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

use think\Page;
use think\Db;
use think\Config;
use app\admin\model\ClassModel;

class Single extends Base
{
    // 模型标识
    public $nid = 'single';
    // 模型ID
    public $channeltype = '';

    public function _initialize()
    {
        parent::_initialize();
        // 当前时间戳
        $this->times = getTime();
        
        $channeltype_list  = config('global.channeltype_list');
        $this->channeltype = $channeltype_list[$this->nid];
        empty($this->channeltype) && $this->channeltype = 6;
        $this->assign('nid', $this->nid);
        $this->assign('channeltype', $this->channeltype);

        // 分类模型
        $this->classModel = new ClassModel($this->channeltype);

        // 返回页面
        $this->callback_url = url('Single/index', ['lang' => $this->admin_lang]);
        $this->assign('callback_url', $this->callback_url);
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
            $post['channel'] = 6;

            // 添加到分类表
            $post_ = $post;
            $post_['topid'] = 0;
            $post_['typename'] = !empty($post['title']) ? trim($post['title']) : '';
            $post['stypeid'] = $this->classModel->goodsClassifyAction('insert', $post_);
            if (!empty($post['stypeid'])) {
                // 获取新增文档数据
                [$insert, $content] = model('Archives')->getInsertArchivesArray($post, true);

                // 保存文档基础数据
                $aid = Db::name('archives')->insertGetId($insert);
                if (!empty($aid)) {
                    $post['aid'] = intval($aid);

                    // 保存文档内容数据
                    if (empty($content['aid'])) $content['aid'] = intval($aid);
                    Db::name('single_content')->insertGetId($content);

                    // 同步保存对应语言文档数据
                    $resultID = model('Archives')->saveArchivesDetails($post);
                    if (!empty($resultID)) {
                        adminLog('新增单页：' . $insert['title']);
                        $this->success("新增成功", url('Single/edit', ['id' => intval($aid), 'callback_url' => $this->callback_url, 'showMsg' => 1]));
                    }
                }
            }
            
            $this->error("操作失败");
        }

        // 模板列表
        $archivesLogic = new \app\admin\logic\ArchivesLogic;
        $templateList = $archivesLogic->getTemplateList($this->nid);
        $assign_data['templateList'] = $templateList;

        // 默认模板文件
        $tempview = 'lists_'.$this->nid.'.'.config('template.view_suffix');
        $assign_data['tempview'] = $tempview;
        // dump($assign_data);exit;
        $this->assign($assign_data);

        $admin_info = session('admin_info');
        $this->assign('admin_info', $admin_info);
        $auth_role_info = $admin_info['auth_role_info'];
        $this->assign('auth_role_info', $auth_role_info);

        return $this->fetch();
    }

    // 编辑
    public function edit()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            if (empty($post['aid'])) $this->error('单页ID丢失，请刷新重试');
            $post['channel'] = 6;
            $post['aid'] = intval($post['aid']);

            // 编辑分类表
            $post_ = $post;
            if (!empty($post['typeid'])) {
                $where = [
                    'id' => intval($post['typeid']),
                    'lang' => trim($this->show_lang),
                ];
                $arctype = Db::name('arctype')->field('auto_id, id, topid, dirname')->where($where)->find();
                if (!empty($arctype)) {
                    $arctype['dirpath'] = '';
                    $arctype['typename'] = !empty($post['title']) ? trim($post['title']) : '';
                    $arctype['dirname_old'] = !empty($arctype['dirname']) ? trim($arctype['dirname']) : '';
                    $arctype['dirname'] = !empty($post['htmlfilename']) ? trim($post['htmlfilename']) : '';
                    $arctype['templist'] = !empty($post['tempview']) ? trim($post['tempview']) : '';
                    $arctype['seo_title'] = !empty($post['seo_title']) ? trim($post['seo_title']) : '';
                    $arctype['seo_keywords'] = !empty($post['seo_keywords']) ? trim($post['seo_keywords']) : '';
                    $arctype['seo_description'] = !empty($post['seo_description']) ? trim($post['seo_description']) : '';
                    $post_ = array_merge($post_, $arctype);
                }
            }
            $result = $this->classModel->goodsClassifyAction('update', $post_);
            if (!empty($result)) {
                // 更新主表公共字段数据
                model('Archives')->saveArchivesPublicDetails($post);

                // 同步保存对应语言文档数据
                $resultID = model('Archives')->saveArchivesDetails($post);
                if (!empty($resultID)) {
                    adminLog('编辑单页：' . $post['title']);
                    $this->success("保存成功");
                }
            }
            $this->error("操作失败");
        }

        $assign_data = [];
        $id = input('id/d', 0);
        $info = model('Archives')->getArchivesDetails($id);
        if (empty($info)) $this->error('数据不存在，请联系管理员！');
        if (6 === intval($info['channel']) && !empty($info['typeid'])) {
            $where = [
                'id' => $info['typeid'],
                'lang' => $this->show_lang,
            ];
            $arctype = Db::name('arctype')->field('auto_id, tempview', true)->where($where)->find();
            if (!empty($arctype)) {
                if (isset($arctype['typename'])) $info['title'] = trim($arctype['typename']);
                if (isset($arctype['dirname'])) $info['htmlfilename'] = trim($arctype['dirname']);
                $info['typeurl'] = urldecode(typeurl('home/Single/lists', $arctype));
                $info = array_merge($info, $arctype);
            }
        }
        // dump($info);exit;
        $assign_data['field'] = $info;

        $admin_info = session('admin_info');
        $this->assign('admin_info', $admin_info);
        $auth_role_info = $admin_info['auth_role_info'];
        $this->assign('auth_role_info', $auth_role_info);

        // 模板列表
        $archivesLogic = new \app\admin\logic\ArchivesLogic;
        $templateList = $archivesLogic->getTemplateList($this->nid);
        $assign_data['templateList'] = $templateList;

        // 默认模板文件
        $assign_data['tempview'] = $info['tempview'];

        // 豆包翻译API配置
        $doubao = tpSetting('doubao', [], $this->show_lang);
        $this->assign('doubao', $doubao);

        // 是否显示已添加文案
        $assign_data['showMsg'] = input('showMsg/d', 0);
        $this->assign($assign_data);
        return $this->fetch();
    }
    
    // 删除
    public function del()
    {
        if (IS_POST) {
            $param = input('param.');
            $del_id = input('del_id/a');

            // 删除单页分类
            $where = [
                'aid' => ['IN', eyIntval($del_id)]
            ];
            $typeidArr = Db::name('archives')->where($where)->column('typeid');
            if (!empty($typeidArr)) {
                // 查询删除分类ID
                $where = [
                    'current_channel' => $this->channeltype,
                    'id|topid|parent_id' => ['IN', array_filter($typeidArr)],
                ];
                $columnID = Db::name('arctype')->where($where)->column('auto_id');
                if (!empty($columnID)) {
                    // 执行删除指定分类
                    $where = [
                        'auto_id' => ['IN', $columnID],
                        'current_channel' => $this->channeltype
                    ];
                    $deleteID = Db::name('arctype')->where($where)->cache(true, null, "arctype")->delete(true);
                    // 删除分类后续操作
                    if (!empty($deleteID)) \think\Cache::clear("arctype");
                }
            }

            // 删除单页内容
            model('Archives')->delArchives(eyIntval($del_id), 'single');
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
}