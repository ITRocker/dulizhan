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

namespace weapp\Paypal\logic;

use think\Db;
use think\Config;
use app\user\logic\PayApiLogic;

/**
 * 业务逻辑
 */
load_trait('controller/Jump');
class PaypalLogic
{
    use \traits\controller\Jump;

    // 获取支付参数
    public function UnifyGetPayAction($PayInfo = [], $Order = [], $ReturnUrl = null)
    {
        $resultData = [];

        // 会员充值
        if (1 === intval($Order['transaction_type'])) {
            if (isset($Order['status']) && !in_array($Order['status'], [2, 3])) {
                $resultData = [
                    'code' => 1,
                    'url'  => '',
                    'data' => [
                        'is_paypal' => 1,
                        'item_name' => $Order['unified_number'],
                        'amount' => $Order['unified_amount'],
                        'invoice' => $Order['moneyid'] . '_' . request()->host(true),
                        'eyou_cancel_return' => !empty($ReturnUrl) ? $ReturnUrl : '',
                    ]
                ];
            }
        }
        // 商品购买
        else if (2 === intval($Order['transaction_type'])) {
            if (!empty($Order['order_code']) && !empty($Order['order_amount'])) {
                $resultData = [
                    'code' => 1,
                    'url'  => '',
                    'data' => [
                        'is_paypal' => 1,
                        'item_name' => $Order['unified_number'],
                        'amount' => $Order['unified_amount'],
                        'invoice' => $Order['order_id'] . '_' . request()->host(true),
                        'eyou_cancel_return' => !empty($ReturnUrl) ? $ReturnUrl : '',
                    ]
                ];
            }
        }
        
        return $resultData;
    }

    // 查询订单支付状态
    public function OtherPayProcessing($PayInfo = [], $unified_number = null, $transaction_type = 1)
    {
        // 会员充值
        if (1 === intval($transaction_type)) {
            $orderInfo = Db::name('users_money')->where(['order_number'=>$unified_number])->find();
            if (isset($orderInfo['status']) && in_array($orderInfo['status'], [2, 3])) {
                $this->success('订单已支付处理完成', url('user/Pay/pay_consumer_details'));
            } else {
                $this->success('正在支付中...');
            }
        }
        // 商品购买
        else if (2 === intval($transaction_type)) {
            $orderInfo = Db::name('shop_order')->where(['order_code'=>$unified_number])->find();
            if (file_exists('./data/conf/develop.txt')) return $orderInfo; // 这行代码上线前删除，用于跳过palpay真实支付完成订单
            if (!empty($orderInfo['order_status'])) {
                $url = custom_url('user/Shop/shop_pay_success', ['order_id' => intval($orderInfo['order_id'])]);
                // $url = url('user/Shop/shop_centre');
                // $visitorsID = model('ShopPublicHandle')->getVisitorsID();
                // if (!empty($visitorsID)) {
                //     $langInfo = cookie('lang_info') ? json_decode(cookie('lang_info'), true) : [];
                //     $url = !empty($langInfo['lang_pageurl']) ? trim($langInfo['lang_pageurl']) : $url;
                // }
                $this->success('订单已支付处理完成', $url);
            } else {
                $this->success('正在支付中...');
            }
        }
    }

    // 处理订单支付处理
    public function orderPaypalHandle($getParam = [], $postParam = [])
    {
        if (!empty($getParam['transaction_type'])) {
            // 查询 Paypal 支付信息
            $where = [
                'status' => 1,
                'pay_mark' => 'Paypal',
            ];
            $payInfo = Db::name('pay_api_config')->where($where)->getField('pay_info');
            $payInfo = !empty($payInfo) ? unserialize($payInfo) : [];

            // 异步处理订单
            if (!empty($getParam['is_notify']) && 1 === intval($getParam['is_notify'])) {
                if (empty($payInfo['business']) || empty($postParam['receiver_id']) || $payInfo['business'] != $postParam['receiver_id']) {
                   echo 'fail'; exit;
                }
                if (empty($postParam['payer_status']) || !in_array($postParam['payer_status'], ['verified', 'VERIFIED'])) {
                   echo 'fail'; exit;
                }
                if (empty($postParam['payment_status']) || !in_array($postParam['payment_status'], ['Completed'])) {
                   echo 'fail'; exit;
                }
                if (empty($postParam['item_name']) || empty($postParam['invoice'])) {
                   echo 'fail'; exit;
                }
                // 查询订单信息
                $invoice = explode('_', $postParam['invoice']);
                // 会员充值
                if (1 === intval($getParam['transaction_type'])) {
                    $where = [
                        'moneyid' => $invoice[0],
                        'order_number' => $postParam['item_name'],
                    ];
                    $usersMoney = Db::name('users_money')->where($where)->find();
                    if (!empty($usersMoney) && 1 === intval($usersMoney['status'])) {
                        $payApiLogic = new PayApiLogic();
                        $payApiLogic->OrderProcessing($getParam, $usersMoney, $postParam, [], false);
                    } else {
                        echo 'success'; exit;
                    }
                }
                // 商品购买
                else if (2 === intval($getParam['transaction_type'])) {
                    $where = [
                        'order_id' => $invoice[0],
                        'order_code' => $postParam['item_name'],
                    ];
                    $shopOrder = Db::name('shop_order')->where($where)->find();
                    if (!empty($shopOrder) && 0 === intval($shopOrder['order_status'])) {
                        $payApiLogic = new PayApiLogic();
                        $payApiLogic->OrderProcessing($getParam, $shopOrder, $postParam, [], false);
                    } else {
                        echo 'success'; exit;
                    }
                }
            }
            // 同步处理订单
            else if (!empty($getParam['is_notify']) && 2 === intval($getParam['is_notify'])) {
                if (empty($payInfo['business']) || empty($postParam['receiver_id']) || $payInfo['business'] != $postParam['receiver_id']) {
                    $this->error('101-请勿非法访问');
                }
                if (empty($postParam['payer_status']) || !in_array($postParam['payer_status'], ['verified', 'VERIFIED'])) {
                    $this->error('102-订单验证失败');
                }
                if (empty($postParam['payment_status']) || !in_array($postParam['payment_status'], ['Completed'])) {
                    $this->error('103-订单尚未付款');
                }
                if (empty($postParam['item_name']) || empty($postParam['invoice'])) {
                    $this->error('104-订单不存在');
                }
                // 查询订单信息
                $invoice = explode('_', $postParam['invoice']);
                // 会员充值
                if (1 === intval($getParam['transaction_type'])) {
                    $where = [
                        'moneyid' => $invoice[0],
                        'order_number' => $postParam['item_name'],
                    ];
                    $usersMoney = Db::name('users_money')->where($where)->find();
                    if (!empty($usersMoney) && 1 === intval($usersMoney['status'])) {
                        $payApiLogic = new PayApiLogic();
                        $payApiLogic->OrderProcessing($getParam, $usersMoney, $postParam, [], false);
                    } else {
                        $this->success('订单已支付处理完成', url('user/Pay/pay_consumer_details'));
                    }
                }
                // 商品购买
                else if (2 === intval($getParam['transaction_type'])) {
                    $where = [
                        'order_id' => $invoice[0],
                        'order_code' => $postParam['item_name'],
                    ];
                    $shopOrder = Db::name('shop_order')->where($where)->find();
                    if (!empty($shopOrder) && 0 == intval($shopOrder['order_status'])) {
                        $payApiLogic = new PayApiLogic();
                        $payApiLogic->OrderProcessing($getParam, $shopOrder, $postParam, [], false);
                    } else {
                        $url = custom_url('user/Shop/shop_pay_success', ['order_id' => intval($shopOrder['order_id'])]);
                        // $url = url('user/Shop/shop_centre');
                        // $visitorsID = model('ShopPublicHandle')->getVisitorsID();
                        // if (!empty($visitorsID)) {
                        //     $langInfo = cookie('lang_info') ? json_decode(cookie('lang_info'), true) : [];
                        //     $url = !empty($langInfo['lang_pageurl']) ? trim($langInfo['lang_pageurl']) : $url;
                        // }
                        $this->success('订单已支付处理完成', $url);
                    }
                }
            }
        }
    }

}
