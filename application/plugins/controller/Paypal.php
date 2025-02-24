<?php
/**
 * 易优CMS
 * ============================================================================
 * 版权所有 2016-2028 海南赞赞网络科技有限公司，并保留所有权利。
 * 网站地址: http://www.eyoucms.com
 * ----------------------------------------------------------------------------
 * 如果商业用途务必到官方购买正版授权, 以免引起不必要的法律纠纷.
 * ============================================================================
 * Author: 陈风任 <491085389@qq.com>
 * Date: 2020-05-22
 */

namespace app\plugins\controller;

use think\Cookie;
use weapp\Paypal\logic\PaypalLogic;

class Paypal
{
    /**
     * PayPal支付--前台通知地址--订单处理
     */
    public function paypalNotifyHandlePay()
    {
        $getParam = cookie('eyouGetPaypalParams');
        $postParam = cookie('eyouPostPaypalParams');
        if (!empty($getParam) && !empty($postParam)) {
            // 清理
            cookie('eyouGetPaypalParams', []);
            cookie('eyouPostPaypalParams', []);
            // 处理订单支付处理
            $paypalLogic = new PaypalLogic;
            $paypalLogic->orderPaypalHandle($getParam, $postParam);
        } else {
            // 接收参数
            $getParam = $_GET;
            $postParam = $_POST;
            if (!empty($getParam) && !empty($postParam)) {
                cookie('eyouGetPaypalParams', $getParam);
                cookie('eyouPostPaypalParams', $postParam);
                $url = url('plugins/Paypal/paypalNotifyHandlePay', [], true, true);
                header('Location: ' . $url);
                exit;
            }
        }
    }
}