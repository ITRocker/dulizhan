<?php
/**
 * ZanCms
 * ============================================================================
 * 版权所有 2020-2035 海南赞赞网络科技有限公司，并保留所有权利。
 * 网站地址: http://www.zancms.com
 * ----------------------------------------------------------------------------
 * 如果商业用途务必到官方购买正版授权, 以免引起不必要的法律纠纷.
 * ============================================================================
 * Author: 陈风任 <491085389@qq.com>
 * Date: 2019-5-7
 */

namespace think\template\taglib\zan;

use think\Request;

/**
 * 搜索表单
 */
class TagSpsearch extends Base
{
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
    }

    /**
     * 订单获取搜索
     */
    public function getSpsearch()
    {
        $hidden = '';
        $searchurl = request()->url();
        $ey_config = config('ey_config'); // URL模式
        if ('ShopComment' == Request::instance()->controller()) {
            // if (2 == $ey_config['seo_pseudo'] || (1 == $ey_config['seo_pseudo'] && 1 == $ey_config['seo_dynamic_format'])) {
                $action = Request::instance()->action() ? Request::instance()->action() : 'index';
                $hidden .= '<input type="hidden" name="m" value="user" />';
                $hidden .= '<input type="hidden" name="c" value="ShopComment" />';
                $hidden .= '<input type="hidden" name="a" value="' . $action . '" />';
                $hidden .= '<input type="hidden" name="lang" value="'.self::$home_lang.'" />';
            // }

            // 搜索的URL
            $searchurl = dynamic_url('user/ShopComment/' . $action . '');
        }
        else if ('after_service' == Request::instance()->action()) {
            // if (2 == $ey_config['seo_pseudo'] || (1 == $ey_config['seo_pseudo'] && 1 == $ey_config['seo_dynamic_format'])) {
                $hidden .= '<input type="hidden" name="m" value="user" />';
                $hidden .= '<input type="hidden" name="c" value="Shop" />';
                $hidden .= '<input type="hidden" name="a" value="after_service" />';
                $hidden .= '<input type="hidden" name="lang" value="'.self::$home_lang.'" />';
            // }

            // 搜索的URL
            $searchurl = dynamic_url('user/Shop/after_service');
        }
        else if ('shop_centre' == Request::instance()->action()) {
            // if (2 == $ey_config['seo_pseudo'] || (1 == $ey_config['seo_pseudo'] && 1 == $ey_config['seo_dynamic_format'])) {
                $hidden .= '<input type="hidden" name="m" value="user" />';
                $hidden .= '<input type="hidden" name="c" value="Shop" />';
                $hidden .= '<input type="hidden" name="a" value="shop_centre" />';
                $hidden .= '<input type="hidden" name="lang" value="'.self::$home_lang.'" />';
            // }

            // 搜索的URL
            $searchurl = dynamic_url('user/Shop/shop_centre');
        }
        
        $result[0] = array(
            'action'    => $searchurl,
            'hidden'    => $hidden,
        );
        
        return $result;
    }
}