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

namespace app\admin\model;

use think\Db;
use think\Model;

/**
 * 产品参数
 */
class ProductParam extends Model
{
    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        // 当前时间戳
        $this->times = getTime();
        // 后台默认语言
        $this->adminLang = get_admin_lang();
        // 后台URL语言(编辑切换时使用)
        $this->showLang = input('showlang/s', $this->adminLang);
    }

    /**
     * 获取单条产品的所有参数
     * @author 小虎哥 by 2018-4-3
     */
    public function getProductParam($aid = 0, $field = '*')
    {
        /*// 查询产品图集主表
        $where = [
            'aid' => intval($aid),
        ];
        $result = Db::name('product_param')->field($field)->where($where)->order('sort_order asc')->select();
        // 查询对应语言数据
        if (!empty($result)) {
            $result_ = Db::name('product_param_' . $this->showLang)->field($field)->where($where)->order('sort_order asc')->getAllWithIndex('param_id');
            foreach ($result as $key => $value) {
                // 如果对应语言存在数据则使用对应语言数据
                if (!empty($result_[$value['param_id']])) $value = array_merge($value, $result_[$value['param_id']]);
                // 覆盖原数据
                $result[$key] = $value;
            }
        }
        return $result;*/

        // 查询对应语言数据
        $where = [
            'aid' => intval($aid),
        ];
        $result = Db::name('product_param_' . $this->showLang)->field($field)->where($where)->order('sort_order asc')->getAllWithIndex('param_id');

        // 如果为空则查询初始默认数据返回
        return empty($result) ? Db::name('product_param')->field($field)->where($where)->order('sort_order asc')->select() : $result;
    }

    /**
     * 删除单条产品的所有参数
     * @author 小虎哥 by 2018-4-3
     */
    public function delProductParam($aid = [], $delLang = '')
    {
        if (!is_array($aid)) $aid = array($aid);
        $where = [
            'aid' => ['IN', $aid],
        ];
        if (empty($delLang)) {
            return Db::name('product_param')->where($where)->delete(true);
        } else {
            return Db::name('product_param_' . $delLang)->where($where)->delete(true);
        }
    }

    // 如果有被删除的参数则同步删除所有语言产品参数
    public function delProductParamAll($aid = [], $del_param_id = [])
    {
        if (!is_array($aid)) $aid = array($aid);
        $where = [
            'aid' => ['IN', $aid],
            'param_id' => ['IN', explode(',', $del_param_id)]
        ];
        $isCount = Db::name('product_param')->where($where)->count();
        if (!empty($isCount)) {
            // 产品主参数
            Db::name('product_param')->where($where)->delete(true);

            // 查询使用的语言列表
            $markList = Db::name('language')->where(['status' => 1])->column('mark');
            foreach ($markList as $key => $value) {
                if (!empty($value)) Db::name('product_param_' . $value)->where($where)->delete(true);
            }
        }
    }

    /**
     * 保存产品参数
     * @author 小虎哥 by 2018-4-3
     */
    public function saveProductParam($post = [], $action = 'add')
    {
        // 设置传入的参数
        $this->setPostParam($post);

        // 获取处理需要新增保存的产品参数
        [$insertAll, $insertAll_] = $this->getInsertParamArr();

        // 新增商品参数
        if (!empty($this->paramName) && count($this->paramName) >= 1 && 'add' === trim($action)) {
            // 执行新增商品参数
            if (!empty($insertAll)) {
                $resultArr = $this->saveAll($insertAll);
                foreach ($resultArr as $key => $value) {
                    $param_id = $value->getData('param_id');
                    if (!empty($param_id)) $insertAll[$key] = array_merge(['param_id' => intval($param_id)], $insertAll[$key]);
                }

                // 查询使用的语言列表
                $markList = Db::name('language')->where(['status' => 1])->column('mark');
                foreach ($markList as $value) {
                    if (!empty($value)) Db::name('product_param_' . $value)->insertAll($insertAll);
                }
            }
        }
        // 编辑商品参数
        else if ('edit' === trim($action)) {
            // 在默认语言下编辑时，如果有新增的语言则添加到产品主参数表
            if (trim($this->showLang) === trim($this->adminLang) && !empty($insertAll)) {
                $resultArr = $this->saveAll($insertAll);
                foreach ($resultArr as $key => $value) {
                    $param_id = $value->getData('param_id');
                    if (!empty($param_id)) $insertAll[$key] = array_merge(['param_id' => intval($param_id)], $insertAll[$key]);
                }

                // 查询使用的语言列表
                $markList = Db::name('language')->where(['status' => 1])->column('mark');
                foreach ($markList as $value) {
                    if (!empty($value)) Db::name('product_param_' . $value)->insertAll($insertAll);
                }
            }

            // 保存对应语言的参数
            if (!empty($insertAll_)) {
                // $this->delProductParam($this->aid, $this->showLang);
                foreach ($insertAll_ as $update) {
                    Db::name('product_param_' . $this->showLang)->update($update);
                }
            }
            // 如果有被删除的参数则同步删除所有语言产品参数
            if (!empty($post['del_param_id'])) $this->delProductParamAll($this->aid, $post['del_param_id']);
        }
    }

    // 设置传入的参数
    private function setPostParam($post = [])
    {            
        $this->aid = !empty($post['aid']) ? intval($post['aid']) : 0;
        $this->paramID = !empty($post['param_id']) ? $post['param_id'] : [];
        $this->paramName = !empty($post['param_name']) ? $post['param_name'] : [];
        $this->sortOrder = !empty($post['sort_order']) ? $post['sort_order'] : 100;
        $this->paramValue = !empty($post['param_value']) ? $post['param_value'] : [];
    }

    // 获取新增的参数
    private function getInsertParamArr()
    {
        $insertAll = $insertAll_ = [];
        foreach ($this->paramName as $key => $value) {            
            if (!empty($value)) {
                $array = [
                    'aid'         => intval($this->aid),
                    'param_name'  => trim($value),
                    'param_value' => !empty($this->paramValue[$key]) ? trim($this->paramValue[$key]) : '',
                    'sort_order'  => !empty($this->sortOrder[$key]) ? intval($this->sortOrder[$key]) : 100,
                    'add_time'    => $this->times,
                    'update_time' => $this->times,
                ];
                if (empty($this->paramID[$key])) {
                    $insertAll[] = $array;
                } else if (!empty($this->paramID[$key])) {
                    $insertAll_[] = array_merge(['param_id' => intval($this->paramID[$key])], $array);
                }
            }
        }
        return [$insertAll, $insertAll_];
    }
}