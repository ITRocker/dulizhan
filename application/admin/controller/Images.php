<?php
/**
 * ZanCms
 * ============================================================================
 * 版权所有 2020-2035 海南赞赞网络科技有限公司，并保留所有权利。
 * 网站地址: http://www.zancms.com
 * ----------------------------------------------------------------------------
 * 如果商业用途务必到官方购买正版授权, 以免引起不必要的法律纠纷.
 * ============================================================================
 * Author: 小虎哥 <1105415366@qq.com>
 * Date: 2018-4-3
 */

namespace app\admin\controller;

use think\Db;
use think\Page;
use app\common\logic\ArctypeLogic;

class Images extends Base
{
    // 模型标识
    public $nid = 'images';
    // 模型ID
    public $channeltype = '';
    
    public function _initialize() {
        parent::_initialize();
        // 当前时间戳
        $this->times = getTime();

        // 分类业务层
        $this->arctypeLogic = new ArctypeLogic();

        $channeltype_list = config('global.channeltype_list');
        $this->channeltype = $channeltype_list[$this->nid];
        empty($this->channeltype) && $this->channeltype = 3;
        $this->assign('nid', $this->nid);
        $this->assign('channeltype', $this->channeltype);

        // 返回页面
        $paramTypeid = input('param.typeid/d', 0);
        $this->callback_url = url('Images/index', ['lang' => $this->admin_lang, 'typeid' => $paramTypeid]);
        $this->assign('callback_url', $this->callback_url);

        // 分类列表URL
        $this->assign('arctype_list_url', url('Arctype/index', ['channeltype' => $this->channeltype]));
    }

    // 列表
    public function index()
    {
        $param = input('param.');
        $param['channel'] = $this->channeltype;
        $result = model('Archives')->getArchivesList($param);
        $this->assign($result);
        return $this->fetch();
    }

    // 添加
    public function add()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            $post['channel'] = 3;
            if (!empty($post['is_jump']) && empty($post['jumplinks'])) $this->error('请输入跳转网址');

            // 获取新增文档数据
            [$insert, $content] = model('Archives')->getInsertArchivesArray($post, true);

            // 保存文档基础数据
            $aid = Db::name('archives')->insertGetId($insert);
            if (!empty($aid)) {
                $post['aid'] = intval($aid);

                // 保存文档内容数据
                if (empty($content['aid'])) $content['aid'] = intval($aid);
                Db::name('images_content')->insertGetId($content);

                // 保存文档图集数据
                model('ImagesUpload')->saveImagesUpload($post);

                // 同步保存对应语言文档数据
                $resultID = model('Archives')->saveArchivesDetails($post);
                if (!empty($resultID)) {
                    adminLog('新增图集：' . $insert['title']);
                    // 记录链接
                    model('Archives')->logOpenJumpPageUrl($aid, $this->callback_url, 'Images');
                    // 结束返回
                    $this->success("保存成功");
                }
            }
            $this->error("操作失败");
        }
        
        $id = input('id/d', 0);
        $stypeid = Db::name('archives')->where(['aid' => $id])->getField('stypeid');
        $assign_data['stypeid'] = $stypeid;

        $admin_info = session('admin_info');
        $this->assign('admin_info', $admin_info);
        $auth_role_info = $admin_info['auth_role_info'];
        $this->assign('auth_role_info', $auth_role_info);

        // 允许发布文档列表的栏目，文档所在模型以栏目所在模型为主，兼容切换模型之后的数据编辑
        $arctype_list = allow_release_arctype(0, array($this->channeltype), false);
        $assign_data['arctype_list'] = $arctype_list;

        // 文档属性
        $assign_data['archives_flags'] = model('ArchivesFlag')->getList();

        $this->assign($assign_data);
        return $this->fetch();
    }

    /**
     * 编辑
     */
    public function edit()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            if (empty($post['aid'])) $this->error('图集ID丢失，请刷新重试');
            if (!empty($post['is_jump']) && empty($post['jumplinks'])) $this->error('请输入跳转网址');
            $post['channel'] = 3;
            $post['aid'] = intval($post['aid']);

            // 更新主表公共字段数据
            model('Archives')->saveArchivesPublicDetails($post);
            /*if (!empty($post['htmlfilename'])) {
                // 更新条件
                $where = [
                    'aid' => $post['aid'],
                ];
                // 更新内容
                $update = [
                    // 分类ID
                    'stypeid' => !empty($post['stypeid']) ? implode(',', $post['stypeid']) : '',
                    // 检测路由是否重名，重名则在后面加上(-n)标记
                    'htmlfilename' => model('Archives')->customRouteHandle($post['aid'], preg_replace("/[^\x{4e00}-\x{9fa5}\w\-]+/u", "-", $post['htmlfilename'])),
                    'update_time'  => getTime(),
                ];
                Db::name('archives')->where($where)->update($update);
            }*/

            // 保存文档图集数据
            if (trim($this->show_lang) === trim($this->admin_lang)) model('ImagesUpload')->saveImagesUpload($post);

            // 同步保存对应语言文档数据
            $resultID = model('Archives')->saveArchivesDetails($post);
            if (!empty($resultID)) {
                adminLog('编辑图集：' . $post['title']);
                // 记录链接
                model('Archives')->logOpenJumpPageUrl($post['aid'], $this->callback_url, 'Images');
                // 结束返回
                $this->success("保存成功");
            }
            $this->error("操作失败");
        }
        $admin_info = session('admin_info');
        $auth_role_info = $admin_info['auth_role_info'];
        $this->assign('auth_role_info', $auth_role_info);
        $this->assign('admin_info', $admin_info);

        $assign_data = [];
        $id = input('id/d', 0);
        $showlang = input('showlang/s', '');
        $info = model('Archives')->getArchivesDetails($id);
        if (empty($info)) $this->error('数据不存在，请联系管理员！');

        $modelarr = $this->getModelUrl($info,$this->nid,$showlang);
        $assign_data['diy_dirnamel'] = $modelarr['diy_dirnamel'];
        $assign_data['diy_domain'] = $modelarr['diy_domain'];
        $info['arcurl']=  get_arcurl($info,true,'',$showlang);
        // 文档内容
        $assign_data['field'] = $info;

        // 产品相册
        $assign_data['imgupload_list'] = model('ImagesUpload')->getImagesUpload($id);

        // 允许发布文档列表的栏目，文档所在模型以栏目所在模型为主，兼容切换模型之后的数据编辑
        $arctype_list = allow_release_arctype(0, array($this->channeltype), false);
        $assign_data['arctype_list'] = $arctype_list;

        // 文档属性
        $assign_data['archives_flags'] = model('ArchivesFlag')->getList();

        // 是否显示已添加文案
        $assign_data['showMsg'] = input('showMsg/d', 0);
        $this->assign($assign_data);
        return $this->fetch();
    }
    
    /**
     * 删除
     */
    public function del()
    {
        if (IS_POST) {
            $del_id = input('del_id/a');
            model('Archives')->delArchives(eyIntval($del_id), 'images');
            // $archivesLogic = new \app\admin\logic\ArchivesLogic;
            // $archivesLogic->del([], 0, 'images');
        }
    }

    /**
     * 删除图集相册图
     */
    public function del_imgupload()
    {
        if (IS_POST) {
            $filename= input('filename/s');
            $aid = input('aid/d');
            if (!empty($filename) && !empty($aid)) {
                Db::name('images_upload')->where('image_url','like','%'.$filename)->where('aid',$aid)->delete();

            }
        }
    }
    //帮助
    public function help()
    {
        $system_originlist = tpSetting('system.system_originlist');
        $system_originlist = json_decode($system_originlist, true);
        $system_originlist = !empty($system_originlist) ? $system_originlist : [];
        $assign_data['system_originlist_str'] = implode(PHP_EOL, $system_originlist);
        $this->assign($assign_data);
    
        return $this->fetch();
    }

    // 案例分类列表
    public function arctype_index()
    {
        $arctype_list = array();
        // 目录列表
        $where = [
            'lang' => $this->admin_lang,
            'is_del' => 0,
            'current_channel' => 3,
        ];
        $arctype_list = $this->arctypeLogic->arctype_list(0, 0, false, 0, $where, false);
        $this->assign('arctype_list', $arctype_list);

        // 模型列表
        $channeltype_list = getChanneltypeList();
        $this->assign('channeltype_list', $channeltype_list);

        // 栏目最多级别
        $arctype_max_level = intval(config('global.arctype_max_level'));
        $this->assign('arctype_max_level', $arctype_max_level);

        $parent_ids = Db::name('arctype')->where([
                'parent_id' => ['gt', 0],
                'is_del'    => 0,
            ])->group('parent_id')->cache(true, EYOUCMS_CACHE_TIME, 'arctype')->column('parent_id');
        $cookied_treeclicked =  json_decode(cookie('admin-treeClicked-Arr'));
        empty($cookied_treeclicked) && $cookied_treeclicked = [];
        $all_treeclicked = cookie('admin-treeClicked_All');
        empty($all_treeclicked) && $all_treeclicked = [];
        $tree = [
            'has_children'=>!empty($parent_ids) ? 1 : 0,
            'parent_ids'=>json_encode($parent_ids),
            'all_treeclicked'=>$all_treeclicked,
            'cookied_treeclicked'=>$cookied_treeclicked,
            'cookied_treeclicked_arr'=>json_encode($cookied_treeclicked),
        ];
        $this->assign('tree', $tree);

        return $this->fetch();
    }
    
    // 案例分类添加
    public function arctype_add()
    {
        return $this->fetch();
    }
    
    // 案例分类添加
    public function arctype_edit()
    {
        return $this->fetch();
    }
    
    // 案例分类删除
    public function arctype_del()
    {
        
    }
}