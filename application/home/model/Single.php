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

namespace app\home\model;

use think\Model;
use think\Db;

/**
 * 单页
 */
class Single extends Model
{
    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
    }

    /**
     * 获取单条记录
     * @author wengxianhu by 2017-7-26
     */
    public function getInfoByTypeid($typeid)
    {
        $lang = get_home_lang();
        $cacheKey = md5("home_model_Single_getInfoByTypeid_{$typeid}_{$lang}");
        $result = cache($cacheKey);
        if (empty($result)) {
            $where = [
                'a.id' => $typeid,
                'a.lang' => $lang,
                'b.channel' => 6,
            ];
            $result = M('arctype')->field('c.*, b.*, a.*, b.aid, a.id as typeid')
                ->alias('a')
                ->join('__ARCHIVES__ b', 'b.typeid = a.id', 'LEFT')
                ->join('single_content_' . $lang . ' c', 'c.aid = b.aid', 'LEFT')
                ->where($where)
                ->find();

            cache($cacheKey, $result, null, "arctype");
        }

        return $result;
    }
}