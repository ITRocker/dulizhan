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

namespace think\template\taglib\zan;

/**
 * 产品参数
 */
class TagAttr extends Base
{
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
    }

    /**
     * 获取每篇文章的属性值
     * @author wengxianhu by 2018-4-20
     */
    public function getAttr($aid = '', $name = '')
    {
        $aid = !empty($aid) ? $aid : $this->aid;

        if (empty($aid)) {
            echo '标签attr报错：缺少属性 aid 值。';
            return false;
        }

        if (empty($name)) {
            echo '标签attr报错：缺少属性 name 值。';
            return false;
        }
        
        $parseStr = false;

        /*当前文档的属性值*/
        $attr_id = intval($name);
        $row = M('product_attr')->alias('a')
            ->field('a.attr_value')
            ->join('__PRODUCT_ATTRIBUTE__ b', 'a.attr_id = b.attr_id', 'LEFT')
            ->where([
                'a.aid'     => $aid,
                'a.attr_id' => $attr_id,
                'b.lang'    => self::$home_lang,
                'b.is_del'  => 0,
            ])
            ->find();
        /*--end*/
        if (empty($row)) {
            return $parseStr;
        } else {
            $parseStr = $row['attr_value'];
        }

        return $parseStr;
    }
}