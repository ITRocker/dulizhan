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
namespace app\common\model;

use think\Db;
use think\Model;

/**
 * 商城购物车
 */
load_trait('controller/Jump');
class ShopCart extends Model
{
    use \traits\controller\Jump;

    // 初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        // 时间戳
        $this->times = getTime();
        // 会员ID
        $this->usersID = intval(session('users_id'));
        // 购物车数据表
        $this->shopCartDb = Db::name('shop_cart');
        // 游客ID
        $this->visitorsID = intval(cookie('visitorsID'));
    }

    // 清理失效的购物车商品
    public function handleUsersShopCart($aidArr = [], $where = [])
    {
        if (!empty($aidArr) && empty($where)) {
            $where = [
                'product_id' => ['IN', $aidArr]
            ];
        }
        if (!empty($where)) $this->shopCartDb->where($where)->delete(true);
    }

    // 登录后将游客时的购物车记录更新登录用户记录，再清空游客ID
    public function visitorsSyncUsersCart()
    {
        if (!empty($this->usersID)) {
            // 查询游客时的购物车数据
            $where = [
                'users_id' => intval($this->visitorsID)
            ];
            $visitorsCart = !empty($this->visitorsID) ? $this->shopCartDb->where($where)->select() : [];
            if (!empty($visitorsCart)) {
                // 查询登录会员的购物车数据
                $usersCart = $this->shopCartDb->where(['users_id' => intval($this->usersID)])->order('cart_id asc')->select();
                if (!empty($usersCart)) {
                    // 处理游客购物车商品是否和登录会员购物车商品，相同商品数量累加更新，不同商品加入登录会员购物车
                    foreach ($visitorsCart as $key_0 => $val_0) {
                        unset($val_0['cart_id']);
                        $val_0['users_id'] = intval($this->usersID);
                        $val_0['add_time'] = $this->times;
                        $val_0['update_time'] = $this->times;
                        $visitorsCart[$key_0] = $val_0;
                        foreach ($usersCart as $key_1 => $val_1) {
                            $usersCart[$key_1]['update_time'] = $this->times;
                            if (trim($val_0['product_id']) == trim($val_1['product_id']) && trim($val_0['spec_value_id']) == trim($val_1['spec_value_id'])) {
                                $usersCart[$key_1]['product_num'] = intval($val_0['product_num'] + $val_1['product_num']);
                                unset($visitorsCart[$key_0]);
                            }
                        }
                    }
                    if (!empty($visitorsCart)) $usersCart = array_merge($usersCart, $visitorsCart);
                    // dump($usersCart);exit;
                    $this->saveAll($usersCart);
                }
                // 新增购物车数据
                else {
                    $insertAll = [];
                    foreach ($visitorsCart as $val_2) {
                        unset($val_2['cart_id']);
                        $val_2['users_id'] = intval($this->usersID);
                        $val_2['add_time'] = $this->times;
                        $val_2['update_time'] = $this->times;
                        $insertAll[] = $val_2;
                    }
                    // dump($insertAll);exit;
                    if (!empty($insertAll)) $this->shopCartDb->insertAll($insertAll);
                }
            }
            // 删除游客ID
            cookie('visitorsID', null);
            // 删除游客购物车数据
            // $this->shopCartDb->where($where)->delete(true);
            // 删除游客收货地址数据
            Db::name('shop_address')->where($where)->delete(true);
        }
    }

}