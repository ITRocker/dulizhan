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
 * Date: 2018-06-28
 */

namespace app\admin\controller;

use think\Db;
use think\Page;
use think\Cache;
use app\admin\model\NavPosition;
use app\common\logic\NavigationLogic;

/**
 * 导航管理
 */
class Navigation extends Base
{
    private $position_model;
    private $list_db;
    private $position_db;
    private $navigationlogic;

    /**
     * 构造方法
     */
    public function __construct()
    {
        parent::__construct();
        $this->position_model = new NavPosition;
        $this->list_db = Db::name('nav_list');
        $this->position_db = Db::name('nav_position');
        $this->navigationlogic = new NavigationLogic;
    }

    // 菜单管理页面
    public function index()
    {
        // 导航菜单位置ID
        $position_id = input('position_id/d', 0);
        $position_id = !empty($position_id) ? intval($position_id) : $this->position_db->order('position_id asc')->limit(1)->value('position_id');
        $this->assign('position_id', $position_id);

        // 导航菜单信息
        $nav_list = [];
        foreach ($this->showLangList as $key => $value) {
            $where = [
                'c.lang' => $value['mark'],
                'c.position_id' => intval($position_id),
            ];
            $nav_list[$value['mark']] = $this->navigationlogic->nav_list(0, 0, false, 0, $where, false);
        }
        $this->assign('list', $nav_list);

        // 最大层级数
        $this->assign('arctype_max_level', intval(config('global.arctype_max_level')));

        /*获取所有有子栏目的栏目id*/
        $parent_ids = Db::name('nav_list')->where(['parent_id' => ['gt', 0], 'is_del' => 0])->group('parent_id')->column('parent_id');
        $cookied_treeclicked =  json_decode(cookie('navigation-treeClicked-Arr'));
        empty($cookied_treeclicked) && $cookied_treeclicked = [];
        $all_treeclicked = cookie('navigation-treeClicked_All');
        empty($all_treeclicked) && $all_treeclicked = [];
        $tree = [
            'has_children'=>!empty($parent_ids) ? 1 : 0,
            'parent_ids'=>json_encode($parent_ids),
            'all_treeclicked'=>$all_treeclicked,
            'cookied_treeclicked'=>$cookied_treeclicked,
            'cookied_treeclicked_arr'=>json_encode($cookied_treeclicked),
        ];
        $this->assign('tree', $tree);
        /* end */

        // 豆包翻译API配置
        $doubao = tpSetting('doubao', [], $this->show_lang);
        $this->assign('doubao', $doubao);

        return $this->fetch('index');
    }

    /**
     * 插件后台管理 - 列表
     */
    public function navigation_index()
    {
        $map = array();
        $list = array();
        $count = $this->position_db->where($map)->count('position_id');
        $pageObj = new Page($count, config('paginate.list_rows'));
        $list = $this->position_db->where($map)->order('sort_order asc,position_id desc')->limit($pageObj->firstRow.','.$pageObj->listRows)->select();
        $pageStr = $pageObj->show();
        $this->assign('list', $list);
        $this->assign('pageStr', $pageStr);
        $this->assign('pager', $pageObj);

        return $this->fetch('navigation_index');
    }

    public function add_position()
    {
        if (IS_POST) {
            $post = input('post.');
            // 导航不可重复
            $PostLevelName = array_unique($post['position_name']);
            if (count($PostLevelName) != count($post['position_name'])) {
                $this->error('导航名称不可重复！');
            }
            // 数据拼装
            $AddUsersLevelData = $where = [];
            foreach ($post['position_name'] as $key => $value) {
                $position_id    = $post['position_id'][$key];
                $sort_order    = !empty($post['sort_order'][$key]) ? $post['sort_order'][$key]:100;
                $position_name  = trim($value);
                if (empty($position_name)) {
                    if (empty($position_id)) {
                        unset($AddUsersLevelData[$key]);
                        continue;
                    }else{
                        $this->error('导航名称不可为空！');
                    }
                }

                $AddUsersLevelData[$key] = [
                    'position_id'    => $position_id,
                    'position_name'  => $position_name,
                    'sort_order'  => $sort_order,
                    'update_time' => getTime(),
                ];

                if (empty($position_id)) {
                    $AddUsersLevelData[$key]['lang']     = $this->admin_lang;
                    $AddUsersLevelData[$key]['add_time'] = getTime();
                    unset($AddUsersLevelData[$key]['position_id']);
                }
            }

            $ReturnId = $this->position_model->saveAll($AddUsersLevelData);
            if ($ReturnId) {
                $position_name = implode(",",$post['position_name']);
                adminLog('新增/编辑导航管理：'.$position_name); // 写入操作日志
                $this->success("操作成功", url('Navigation/index'));
            } else {
                $this->error('操作失败');
            }
        }
    }
    
    /**
     * 插件后台管理 - 新增
     */
    public function add()
    {
        if (IS_AJAX_POST) {
            // 保存导航菜单内容列表数据
            $resultID = model('NavList')->saveNavListContentList();
            if (!empty($resultID)) {
                Cache::clear('nav_list');
                $this->success("操作成功", url('Navigation/index', ['position_id' => input('position_id/d', 1)]));
            } else {
                $this->error("操作失败");
            }
        }

        $nav_id = input('nav_id/d', 0);
        $position_id = input('position_id/d', 0);
        // 全部栏目下拉框
        $assignData['arctypeHtml'] = $this->navigationlogic->getAllArctypeList();
        // 最大层级数
        $assignData['arctype_max_level'] = intval(config('global.arctype_max_level'));
        // 全部导航菜单列表
        $assignData['navListHtml'] = $this->navigationlogic->getAllNavList($position_id, $nav_id, $assignData['arctype_max_level'] - 1);
        $assignData['nav_id'] = $assignData['topid'] = 0;
        if (!empty($nav_id)) {
            $assignData['nav_id'] = intval($nav_id);
            $assignData['topid'] = Db::name('nav_list')->where('nav_id', $nav_id)->getField('topid');
        }
        $this->assign($assignData);

        $position_name = $this->position_db->where('position_id',$position_id)->value('position_name');
        $this->assign('position_name', $position_name);
        return $this->fetch('add');
    }
    
    /**
     * 插件后台管理 - 编辑
     */
    public function edit()
    {
        if (IS_AJAX_POST) {
            // 保存导航菜单内容列表数据
            $resultID = model('NavList')->saveNavListContentList();
            if (!empty($resultID)) {
                Cache::clear('nav_list');
                $this->success("操作成功", url('Navigation/index', ['position_id' => input('position_id/d', 1)]));
            } else {
                $this->error("操作失败");
            }
        }

        $ReturnData = array();
        $nav_id = input('nav_id/d', 0);
        if (empty($nav_id)) $this->error("请选择导航");
        $where = [
            'a.lang' => $this->show_lang,
            'a.nav_id' => intval($nav_id),
        ];
        $field = 'a.*, b.position_name, c.id, c.current_channel, c.typename, c.dirname, d.aid, d.channel, d.title, d.htmlfilename';
        $navigList = $this->list_db
            ->field($field)
            ->alias('a')
            ->join('nav_position b', 'a.position_id = b.position_id', 'LEFT')
            ->join('arctype c', 'a.type_id = c.id', 'LEFT')
            ->join('archives d', 'a.type_id = d.aid', 'LEFT')
            ->where($where)
            ->find();
        if (empty($navigList)) $this->error("请选择导航");
        if (!empty($navigList['arctype_sync']) && 2 === intval($navigList['host_id'])) {
            $navigList['nav_url'] = urldecode(get_typeurl($navigList));
            // $navigList['nav_name'] = $navigList['typename'];
        }
        else if (!empty($navigList['arctype_sync']) && 3 === intval($navigList['host_id'])) {
            $navigList['nav_url'] = urldecode(get_arcurl($navigList, false));
            // $navigList['nav_name'] = $navigList['title'];
        }
        // dump($navigList);
        // exit;
        $assignData['navigList'] = $navigList;

        $this->assign($assignData);
        return $this->fetch();
    }
    
    /**
     * 删除文档
     */
    public function del()
    {
        $id_arr = input('del_id/a');
        $id_arr = eyIntval($id_arr);
        if(!empty($id_arr) && IS_POST){
            $result = $this->position_db->where("position_id",'IN',$id_arr)->select();
            $title_list = get_arr_column($result, '导航名称');

            $r = $this->position_db->where("position_id",'IN',$id_arr)->delete();
            if($r !== false){
                $this->list_db->where("position_id",'IN',$id_arr)->cache(true, null, "nav_list")->delete();
                adminLog('删除导航管理：'.implode(',', $title_list));
                $this->success("操作成功!");
            }
        }
        $this->error("操作失败!");
    }

    /**
     * 删除菜单
     */
    public function list_del()
    {
        $id_arr = input('del_id/a');
        $id_arr = eyIntval($id_arr);
        if (!empty($id_arr) && IS_POST) {
            $where = [
                'nav_id|parent_id|topid' => ['IN', $id_arr]
            ];
            $result = $this->list_db->where($where)->select();
            $title_list = get_arr_column($result, '导航名称');
            $id_list = array_unique(get_arr_column($result, 'nav_id'));
            $r = $this->list_db->where("nav_id", 'IN', $id_list)->cache(true, null, "nav_list")->delete();
            if($r !== false){
                adminLog('删除导航管理菜单：'.implode(',', $title_list));
                $this->success("操作成功!");
            }
        }
        $this->error("操作失败!");
    }

    /**
     * 开启/关闭导航模块功能
     * @return [type] [description]
     */
    public function ajax_open_close()
    {
        if (IS_AJAX_POST) {
            $value = input('param.value/d');
            if (1 == $value) {
                $web_navigation_switch = 0;
            } else {
                $web_navigation_switch = 1;
            }
            /*多语言*/
            $langRow = \think\Db::name('language')->order('id asc')->select();
            foreach ($langRow as $key => $val) {
                tpCache('web', ['web_navigation_switch'=>$web_navigation_switch], $val['mark']);
            }
            /*--end*/
            $this->success("操作成功");
        }
        $this->error("操作失败");
    }
    
    /**
     * 添加链接页面
     */
    public function link()
    {
        $channel = input('channel/d', 0);
        $this->assign('channel', $channel);

        // 基础链接
        $basicArr = model('NavList')->getNavListBasicArr();
        $this->assign('basicArr', $basicArr);

        // 目录列表
        $where = [
           'is_del' => 0,
           'lang' => $this->show_lang,
           'current_channel' => intval($channel),
        ];
        $arctypeLogic = new \app\common\logic\ArctypeLogic;
        $arctype_list = $arctypeLogic->arctype_list(0, 0, false, 0, $where, false);
        foreach ($arctype_list as $key => $value) {
            $arctype_list[$key]['typeurl'] = urldecode(get_typeurl($value));
        }
        $assign_data['arctype_list'] = $arctype_list;

        // 获取所有有子栏目的栏目id
        $where = [
           'is_del' => 0,
           'parent_id' => ['gt', 0],
        ];
        $parent_ids = Db::name('arctype')->where($where)->group('parent_id')->cache(true, EYOUCMS_CACHE_TIME, 'arctype')->column('parent_id');
        $cookied_treeclicked =  json_decode(cookie('admin-treeLinkClicked-Arr'));
        empty($cookied_treeclicked) && $cookied_treeclicked = [];
        $all_treeclicked = cookie('admin-treeLinkClicked_All');
        empty($all_treeclicked) && $all_treeclicked = [];
        $tree = [
           'has_children'=>!empty($parent_ids) ? 1 : 0,
           'parent_ids'=>json_encode($parent_ids),
           'all_treeclicked'=>$all_treeclicked,
           'cookied_treeclicked'=>$cookied_treeclicked,
           'cookied_treeclicked_arr'=>json_encode($cookied_treeclicked),
        ];
        $assign_data['tree'] = $tree;

        $param = input('param.');
        $param['channel'] = $channel;
        $assign_data['single_list'] = model('Archives')->getArchivesList($param);

        $this->assign($assign_data);
        return $this->fetch();
    }

    /**
     * ai翻译
     */
    public function help()
    {
        $position_id = input('position_id/d', 1);
        $this->assign('position_id', $position_id);

        return $this->fetch();
    }
}