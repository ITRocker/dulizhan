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

class Country extends Base
{
    public function _initialize()
    {
        parent::_initialize();
        // 当前时间戳
        $this->times = getTime();
        // 国家数据表
        $this->countryDb = Db::name('country');
        $functionLogic = new \app\common\logic\FunctionLogic;
        $functionLogic->validate_authorfile(2);
        // 七大洲标记
        $this->sevenContinents = ['AS'=>'亚洲', 'AF'=>'非洲', 'NA'=>'北美洲', 'SA'=>'南美洲', 'EU'=>'欧洲', 'OA'=>'大洋洲', 'AN'=>'南极洲', 'NULL'=>'未知'];
        $this->assign('sevenContinents', $this->sevenContinents);
    }

    public function index()
    {
        $this->assign($this->lists(false));
        return $this->fetch();
    }

    public function add()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            if (empty($post['name'])) $this->error('请填写国家/地区');

            // 新增
            $insert = [
                'name' => trim($post['name']),
                'code' => !empty($post['code']) ? trim($post['code']) : '',
                'status' => !empty($post['status']) ? intval($post['status']) : 0,
                'continent' => !empty($post['continent']) ? trim($post['continent']) : '',
                'sort_order' => !empty($post['sort_order']) ? intval($post['sort_order']) : 100,
                'add_time' => $this->times,
                'update_time' => $this->times,
            ];
            $resultID = $this->countryDb->insert($insert);
            if (!empty($resultID)) {
                $this->success('添加成功');
            }
            $this->error('添加失败');
        }

        return $this->fetch();
    }

    public function edit()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            if (empty($post['id'])) $this->error('ID异常，刷新重试');
            if (empty($post['name'])) $this->error('请填写国家/地区');

            // 编辑
            $where = [
                'id' => intval($post['id'])
            ];
            $update = [
                'name' => trim($post['name']),
                'code' => !empty($post['code']) ? trim($post['code']) : '',
                'status' => !empty($post['status']) ? intval($post['status']) : 0,
                'continent' => !empty($post['continent']) ? trim($post['continent']) : '',
                'sort_order' => !empty($post['sort_order']) ? intval($post['sort_order']) : 100,
                'update_time' => $this->times,
            ];
            $resultID = $this->countryDb->where($where)->update($update);
            if (!empty($resultID)) {
                $this->success('编辑成功');
            }
            $this->error('编辑失败');
        }

        $id = input('id/d', 0);
        if (empty($id)) $this->error('ID异常，刷新重试');
        $where = [
            'id' => intval($id)
        ];
        $field = $this->countryDb->where($where)->find();

        $this->assign('field', $field);
        return $this->fetch();
    }

    public function lists($fetch = false)
    {
        // 查询条件
        $where = [];
        $keywords = input('param.keywords/s', '');
        if (!empty($keywords)) $where['name'] = ['LIKE', "%{$keywords}%"];

        // 分页查询
        $count = $this->countryDb->where($where)->count('id');
        $pageObj = new Page($count, config('paginate.list_rows'));

        // 自定义排序
        $orderby = input('param.orderby/s', '');
        $orderway = input('param.orderway/s', '');
        if (!empty($orderby) && !empty($orderway)) {
            $orderby = "{$orderby} {$orderway}, id desc";
        } else {
            $orderby = "sort_order asc, id desc";
        }

        // 数据查询
        $list = $this->countryDb->where($where)->limit($pageObj->firstRow.','.$pageObj->listRows)->order($orderby)->select();

        // 渲染数据
        $result = [
            'list' => $list,
            'page' => $pageObj->show(),
            'pager' => $pageObj
        ];
        if (empty($fetch)) return $result;

        $this->assign($result);
        return $this->fetch();
    }

    public function del()
    {
        if (IS_AJAX_POST) {
            $del_id = input('del_id/d', 0);
            if (empty($del_id)) $this->error('ID异常，刷新重试');
            $where = [
                'id' => intval($del_id)
            ];
            $resultID = $this->countryDb->where($where)->delete(true);
            if (!empty($resultID)) {
                $this->success('删除成功');
            }
            $this->error('删除失败');
        }
    }
}