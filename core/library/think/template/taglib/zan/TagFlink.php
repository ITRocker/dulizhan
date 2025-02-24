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

use think\Db;

/**
 * 友情链接
 */
class TagFlink extends Base
{
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
    }

    /**
     * 获取友情链接
     * @author wengxianhu by 2018-4-20
     */
    public function getFlink($type = 'text', $limit = '', $groupid = '')
    {
        if ($type == 'text' || $type == 'textall') {
            $typeid = 1;
        } elseif ($type == 'image') {
            $typeid = 2;
        }

        $condition = array();
        if (!empty($typeid)) {
            $condition['a.typeid'] = array('eq', $typeid);
        }
        if (!is_numeric($groupid) && $groupid === '') {
            $groupid = Db::name('links_group')->where(['lang'=>self::$home_lang])->order('id asc')->cache(true, EYOUCMS_CACHE_TIME, 'links_group')->value('id');
        }
        if (!empty($groupid) && $groupid != 'all') {
            /*多语言*/
            if (self::$language_split) {
                $langArr = Db::name('links_group')->where(['id'=>$groupid])->cache(true, EYOUCMS_CACHE_TIME, 'links_group')->column('lang');
                if (!in_array(self::$home_lang, $langArr)) {
                    $lang_title = Db::name('language_mark')->where(['mark'=>self::$home_lang])->value('cn_title');
                    echo "标签flink报错：【{$lang_title}】语言 groupid 值不存在。";
                    return false;
                }
            }
            /*--end*/
            $condition['a.groupid'] = array('eq', $groupid);
        }
        $condition['a.lang'] = self::$home_lang;
        $condition['a.status'] = 1;
        $result = M("links")->alias('a')->where($condition)
            ->order('a.sort_order asc')
            ->limit($limit)
            ->cache(true,EYOUCMS_CACHE_TIME,"links")
            ->select();
        foreach ($result as $key => $val) {
            $val['logo'] = get_default_pic($val['logo']);
            $val['target'] = ($val['target'] == 1) ? ' target="_blank" ' : ' target="_self" ';
            $val['nofollow'] = ($val['nofollow'] == 1) ? ' rel="nofollow" ' : '';
            $result[$key] = $val;
        }

        return $result;
    }
}