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
use think\Request;

/**
 * 内容页上下篇
 */
class TagPrenext extends Base
{
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
    }

    /**
     * 获取内容页上下篇
     * @author wengxianhu by 2018-4-20
     */
    public function getPrenext($get = 'pre')
    {
        $aid = $this->aid;
        if (empty($aid)) {
            echo '标签prenext报错：只能用在内容页。';
            return false;
        }

        $channelRes = model('Channeltype')->getInfoByAid($aid);
        $channel = $channelRes['channel'];
        $typeid = $channelRes['typeid'];
        $controller_name = $channelRes['ctl_name'];

        $condition = [];

        if ($get == 'next') {
            /* 下一篇 */
            $condition['a.typeid'] = $typeid;
            $condition['a.aid'] = ['GT', $aid];
            $condition['a.channel'] = $channel;
            $condition['a.status'] = 1;
            $condition['a.is_del'] = 0;
            // $condition['a.arcrank'] = ['EGT', 0];
            $result = M('archives')->field('b.*, a.*')
                ->alias('a')
                ->join('__ARCTYPE__ b', 'b.id = a.typeid', 'LEFT')
                ->where($condition)
                ->order('a.aid asc')
                ->find();
            if (!empty($result)) {
                $archives_real_fields = implode(',', config('global.archives_real_fields'));
                $result_new = M("archives_".self::$home_lang)->field($archives_real_fields, true)
                    ->where('aid', $result['aid'])
                    ->find();
                if (!empty($result_new)) {
                    $result = array_merge($result, $result_new);
                }
                if (!empty($result['is_jump']) && 1 == $result['is_jump']) {
                    $result['arcurl'] = $result['jumplinks'];
                } else {
                    $seo_rewrite_format = config('ey_config.seo_rewrite_format');
                    if($seo_rewrite_format==3){
                        $result['arcurl'] = $result['typeid']?arcurl('home/'.$controller_name.'/view', $result):'/product-details/'.$result['htmlfilename'].'.html';
                    }else{
                        $result['arcurl'] = arcurl('home/'.$controller_name.'/view', $result);
                    }
                    //$result['arcurl'] = arcurl('home/'.$controller_name.'/view', $result);
                }
                /*封面图*/
                if (empty($result['litpic'])) {
                    $result['is_litpic'] = 0; // 无封面图
                } else {
                    $result['is_litpic'] = 1; // 有封面图
                }
                $result['litpic'] = get_default_pic($result['litpic']); // 默认封面图
                /*--end*/
            }
        } else {
            /* 上一篇 */ 
            $condition['a.typeid'] = $typeid;
            $condition['a.aid'] = ['LT', $aid];
            $condition['a.channel'] = $channel;
            $condition['a.status'] = 1;
            $condition['a.is_del'] = 0;
            // $condition['a.arcrank'] = ['EGT', 0];
            $result = M('archives')->field('b.*, a.*')
                ->alias('a')
                ->join('__ARCTYPE__ b', 'b.id = a.typeid', 'LEFT')
                ->where($condition)
                ->order('a.aid desc')
                ->find();
            if (!empty($result)) {
                $archives_real_fields = implode(',', config('global.archives_real_fields'));
                $result_new = M("archives_".self::$home_lang)->field($archives_real_fields, true)
                    ->where('aid', $result['aid'])
                    ->find();
                if (!empty($result_new)) {
                    $result = array_merge($result, $result_new);
                }
                if (!empty($result['is_jump']) && 1 == $result['is_jump']) {
                    $result['arcurl'] = $result['jumplinks'];
                } else {
                    $seo_rewrite_format = config('ey_config.seo_rewrite_format');
                    if($seo_rewrite_format==3){
                        $result['arcurl'] = $result['typeid']?arcurl('home/'.$controller_name.'/view', $result):'/product-details/'.$result['htmlfilename'].'.html';
                    }else{
                        $result['arcurl'] = arcurl('home/'.$controller_name.'/view', $result);
                    }
                    //$result['arcurl'] = arcurl('home/'.$controller_name.'/view', $result);
                }
                /*封面图*/
                if (empty($result['litpic'])) {
                    $result['is_litpic'] = 0; // 无封面图
                } else {
                    $result['is_litpic'] = 1; // 有封面图
                }
                $result['litpic'] = get_default_pic($result['litpic']); // 默认封面图
                /*--end*/
            }
        }

        return $result;
    }
}