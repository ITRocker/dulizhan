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
use think\Cache;

class Links extends Base
{
    public function _initialize()
    {
        parent::_initialize();
        $this->linksModel = model('Links');
    }

    public function index()
    {
        $result = $this->linksModel->getLinksList();
        $this->assign($result);

        return $this->fetch();
    }

    /**
     * 添加友情链接
     */
    public function add()
    {
        if (IS_AJAX_POST) {
            // 保存导航菜单内容列表数据
            $resultID = $this->linksModel->saveLinksContentList();
            if (!empty($resultID)) {
                Cache::clear('links');
                $this->success("操作成功");
            } else {
                $this->error("操作失败");
            }
        }

        return $this->fetch();
    }
    
    /**
     * 编辑友情链接
     */
    public function edit()
    {
        if (IS_AJAX_POST) {
            // 保存导航菜单内容列表数据
            $resultID = $this->linksModel->saveLinksContentList();
            if (!empty($resultID)) {
                Cache::clear('links');
                $this->success("操作成功");
            } else {
                $this->error("操作失败");
            }
        }

        $id = input('id/d', 0);
        $where = [
            'id'   => intval($id),
            'lang' => $this->admin_lang,
        ];
        $info = Db::name('links')->where($where)->find();
        if (empty($info)) $this->error('数据不存在，请联系管理员！');

        $this->assign('info', $info);
        return $this->fetch();
    }
    
    /**
     * 删除友情链接
     */
    public function del()
    {
        if (IS_POST) {
            $id_arr = input('del_id/a');
            $id_arr = eyIntval($id_arr);
            if(!empty($id_arr)){
                $result = Db::name('links')->field('title')->where(['id' => ['IN', $id_arr]])->select();
                $title_list = get_arr_column($result, 'title');
                $result = Db::name('links')->where(['id' => ['IN', $id_arr]])->cache(true, null, "links")->delete(true);
                if (!empty($result)) {
                    adminLog('删除友情链接：'.implode(',', $title_list));
                    $this->success('删除成功');
                } else {
                    $this->error('删除失败');
                }
            } else {
                $this->error('参数有误');
            }
        }
        $this->error('非法访问');
    }
}