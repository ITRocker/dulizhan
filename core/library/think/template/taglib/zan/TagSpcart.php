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
 * Date: 2019-4-13
 */

namespace think\template\taglib\zan;
use think\Db;

/**
 * 购物车列表
 */
class TagSpcart extends Base
{
    /**
     * 会员ID
     */
    public $users_id = 0;
    public $users    = [];
    public $usersTplVersion    = '';

    //初始化
    protected function _initialize()
    {
        parent::_initialize();
        $this->times = getTime();
        // 会员信息
        $this->users    = session('users');
        $this->users_id = session('users_id');
        $this->users_id = !empty($this->users_id) ? $this->users_id : 0;
        $this->usersTplVersion = getUsersTplVersion();
    }

    /**
     * 获取购物车数据
     */
    public function getSpcart($limit = '')
    {
        // 查询条件
        $condition = [
            'b.status' => 1,
            'a.users_id' => $this->users_id,
        ];
        if (!empty($this->visitorsID) && empty($this->users_id)) $condition['a.users_id'] = intval($this->visitorsID);
        /*// 判断是否安装并且启用了多商家插件
        $is_multiMerchant = false;
        if (is_dir('./weapp/MultiMerchant')){
            $TimingTaskRow = model('Weapp')->getWeappList('MultiMerchant');
            if (!empty($TimingTaskRow['status']) && 1 == $TimingTaskRow['status']) {
                $is_multiMerchant = true;
            }
        }*/
        $field = 'a.*, b.aid, b.title, d.title as title_new, b.litpic, b.users_price, b.logistics_type, b.users_discount_type, b.stock_count, b.is_del, c.spec_price, c.spec_stock';
        // $field = 'a.*, b.aid, b.title, d.title as title_new, b.litpic, b.users_price, b.logistics_type, b.users_discount_type, b.stock_count, b.attrlist_id, b.is_del, c.spec_price, c.spec_stock';
        $list = Db::name("shop_cart")
            ->field($field)
            ->alias('a')
            ->join('__ARCHIVES__ b', 'a.product_id = b.aid', 'LEFT')
            ->join('__PRODUCT_SPEC_VALUE__ c', 'a.spec_value_id = c.spec_value_id and a.product_id = c.aid', 'LEFT')
            ->join('archives_'.self::$home_lang.' d', 'b.aid = d.aid', 'left')
            ->where($condition)
            ->limit($limit)
            ->order('a.selected desc, a.add_time desc')
            ->select();
        if (empty($list)) return ['list'=>[]];

        $cart_ids = get_arr_column($list, 'cart_id');
        if (!empty($cart_ids)) {
            $where = [
                'cart_id' => ['NOT IN', $cart_ids],
                'users_id' => $this->users_id,
            ];
            if (!empty($this->visitorsID) && empty($this->users_id)) $where['users_id'] = intval($this->visitorsID);
            model('ShopCart')->handleUsersShopCart([], $where);
        }

        // clearID 需要清零的ID， restoreID 需要恢复数据的ID， upMaxNumID 需要更新最大数量的ID
        $clearID = $restoreID = $upMaxNumID = [];
        // 规格商品价格及库存处理
        foreach ($list as $key => $value) {
            $list[$key]['statusMark'] = '';
            if (!empty($value['spec_value_id'])) {
                // 购物车商品存在规格并且价格不为空，则覆盖商品原来的价格
                if (!empty($value['spec_price'])) $list[$key]['users_price'] = unifyPriceHandle($value['spec_price']);

                // 购物车商品存在规格库存
                if (!empty($value['spec_stock']) && 0 < intval($value['spec_stock'])) {
                    // 覆盖商品原来的库存
                    $list[$key]['stock_count'] = $value['stock_count'] = $value['spec_stock'];
                    // 若商品有库存并且购物车数量小于等于0则执行
                    if (intval($value['product_num']) <= 0 && 0 === intval($value['is_del'])) {
                        $list[$key]['product_num'] = $list[$key]['selected'] = 1;
                        array_push($restoreID, $value['cart_id']);
                    }
                }
                // 商品已售罄则执行
                else {
                    $list[$key]['IsSoldOut']   = 1;
                    $list[$key]['statusMark']  = '[商品已售罄]';
                    $list[$key]['stock_count'] = $list[$key]['selected'] = 0;
                    array_push($clearID, $value['cart_id']);
                }
            } else {
                // 商品已售罄则执行
                if (empty($value['stock_count']) || 0 > intval($value['stock_count'])) {
                    $list[$key]['IsSoldOut']   = 1;
                    $list[$key]['statusMark']  = '[商品已售罄]';
                    $list[$key]['stock_count'] = $list[$key]['selected'] = 0;
                    array_push($clearID, $value['cart_id']);
                }
                // 若商品有库存并且购物车数量小于等于0则执行
                else if (!empty($value['stock_count'])) {
                    if (intval($value['product_num']) <= 0 && 0 === intval($value['is_del'])) {
                        $list[$key]['product_num'] = $list[$key]['selected'] = 1;
                        array_push($restoreID, $value['cart_id']);
                    }
                }
            }
                    
            // 商品 被伪删除 或 规格被删除 则执行
            if (1 === intval($value['is_del']) || (empty($value['spec_price']) && !empty($value['spec_value_id']))) {
                $list[$key]['statusMark']  = '[商品已停售]';
                $list[$key]['stock_count'] = $list[$key]['selected'] = 0;
                array_push($clearID, $value['cart_id']);
            }

            // 购买数量超过库存则执行
            if (intval($value['product_num']) > intval($value['stock_count'])) {
                $upMaxNumID[] = [
                    'cart_id'     => $value['cart_id'],
                    'product_num' => $value['stock_count'],
                    'update_time' => getTime(),
                    'key'         => $key
                ];
            }

            /*$list[$key]['merchant_type'] = '平台';
            $list[$key]['merchant_name'] = '自营商户';*/
        }

        // 更新购物车库存为0并清除选中效果的商品
        if (!empty($clearID)) {
            Db::name("shop_cart")->where(['cart_id' => ['IN', $clearID]])->update(['selected' => 0, 'product_num' => 0, 'update_time' => $this->times]);
        }

        // 更新购物车库存为1并恢复选中效果的商品
        if (!empty($restoreID)) {
            Db::name("shop_cart")->where(['cart_id' => ['IN', $restoreID]])->update(['selected' => 1, 'product_num' => 1, 'update_time' => $this->times]);
        }

        // 当购物车库存超过商品库存则执行购物车库存为商品最大库存
        if (!empty($upMaxNumID)) {
            foreach ($upMaxNumID as $value) {
                Db::name("shop_cart")->where('cart_id', $value['cart_id'])->update($value);
                $list[$value['key']]['product_num'] = $value['product_num'];
            }
        }

        // 订单数据处理
        $result = [
            'TotalAmount' => 0,
            'TotalNumber' => 0,
            'AllSelected' => 0,
            'TotalCartNumber' => 0,
        ];
        $selected = 0;

        $logisticsTypeArr = [];
        $controller_name = 'Product';
        $array_new = get_archives_data($list, 'product_id');
        $level_discount = $this->users['level_discount'];
        foreach ($list as $key => $value) {
            // 标题处理
            $list[$key]['title'] = $value['title'] = !empty($value['title_new']) ? trim($value['title_new']) : trim($value['title']);

            // 仅物流配送 或 仅到店核销 则存入数组
            if (('1' === $value['logistics_type'] || '2' === $value['logistics_type']) && !empty($value['selected'])) {
                array_push($logisticsTypeArr, $value['logistics_type']);
            }
            // 购物车商品存在规格并且价格不为空，则覆盖商品原来的价格
            if (!empty($level_discount)) {
                // 折扣率百分比
                $discount_price = $level_discount / 100;
                $value['users_price'] = 2 === intval($value['users_discount_type']) ? $value['users_price'] : $value['users_price'] * $discount_price;
                $value['users_price'] = floatval(sprintf("%.2f", $value['users_price']));
            }
            // 查询会员折扣价
            if (empty($value['spec_value_id']) && !empty($this->users['level_id']) && 1 === intval($value['users_discount_type'])) {
                $value['users_price'] = model('ShopPublicHandle')->handleUsersDiscountPrice($value['aid'], $this->users['level_id']);
            }
            // 覆盖原数据
            $list[$key]['users_price'] = $value['users_price'];
            // 产品价格处理
            $list[$key]['subtotal'] = 0;
            if (!empty($value['users_price'])) {
                // 计算小计
                $list[$key]['subtotal'] = $value['users_price'] * $value['product_num'];
                $list[$key]['subtotal'] = floatval(sprintf("%.2f", $list[$key]['subtotal']));
                //计算购车商品总件数
                $result['TotalCartNumber'] += $value['product_num'];
                // 计算购物车中已勾选的产品总数和总额
                if (!empty($value['selected'])) {
                    // 合计金额
                    $result['TotalAmount'] += $list[$key]['subtotal'];
                    $result['TotalAmount'] = floatval(sprintf("%.2f", $result['TotalAmount']));
                    // 合计数量
                    $result['TotalNumber'] += $value['product_num'];
                    // 选中的产品个数
                    $selected++;
                }
            }

            // 产品内页地址            
            $list[$key]['arcurl'] = get_arcurl($array_new[$value['product_id']],false);            
            //$list[$key]['arcurl'] = urldecode(arcurl('home/'.$controller_name.'/view', $array_new[$value['product_id']]));
            // 图片处理
            $list[$key]['litpic'] = handle_subdir_pic(get_default_pic($value['litpic']));

            // 产品旧参数属性处理
            $list[$key]['attr_value'] = '';
            if (!empty($value['product_id'])) {
                $attrData = Db::name("product_attr")->where('aid', $value['product_id'])->field('attr_value, attr_id')->select();
                foreach ($attrData as $val) {
                    $attr_name = Db::name("product_attribute")->where('attr_id', $val['attr_id'])->field('attr_name')->find();
                    $list[$key]['attr_value'] .= $attr_name['attr_name'].'：'.$val['attr_value'].'<br/>';
                }
            }

            // 商品规格处理
            $list[$key]['product_spec'] = '';
            $product_spec_list = [];
            if (!empty($value['spec_value_id'])) {
                $spec_value_id = explode('_', $value['spec_value_id']);
                if (!empty($spec_value_id)) {
                    $SpecWhere = [
                        'aid' => $value['product_id'],
                        'lang' => self::$home_lang,
                        'spec_value_id' => ['IN', $spec_value_id]
                    ];
                    $ProductSpecData = M("product_spec_data")->where($SpecWhere)->field('spec_name,spec_value')->select();
                    foreach ($ProductSpecData as $spec_value) {
                        $list[$key]['product_spec'] .= $spec_value['spec_name'].'：'.$spec_value['spec_value'].'<br/>';
                        $product_spec_list[] = [
                            'name' => $spec_value['spec_name'],
                            'value' => $spec_value['spec_value'],
                        ];
                    }
                }
            }
            $list[$key]['product_spec_list'] = $product_spec_list;

            if (isset($value['IsSoldOut']) && !empty($value['IsSoldOut'])) {
                $list[$key]['CartChecked'] = " disabled='true' title='商品已售罄' ";
                $list[$key]['ReduceQuantity'] = " onclick=\"CartUnifiedAlgorithm('IsSoldOut');\" ";
                $list[$key]['UpdateQuantity'] = " onchange=\"CartUnifiedAlgorithm('IsSoldOut');\" value=\"0\" ";
                $list[$key]['IncreaseQuantity'] = " onclick=\"CartUnifiedAlgorithm('IsSoldOut');\" ";
            } else if (isset($value['is_del']) && !empty($value['is_del'])) {
                $list[$key]['CartChecked'] = " disabled='true' title='商品已停售' ";
                $list[$key]['ReduceQuantity'] = " onclick=\"CartUnifiedAlgorithm('IsDel');\" ";
                $list[$key]['UpdateQuantity'] = " onchange=\"CartUnifiedAlgorithm('IsDel');\" value=\"0\" ";
                $list[$key]['IncreaseQuantity'] = " onclick=\"CartUnifiedAlgorithm('IsDel');\" ";
            } else {
                // 单个是否选中
                $isSelected = !empty($value['selected']) ? 'checked' : '';
                $list[$key]['CartChecked'] = " name=\"ey_buynum\" id=\"{$value['cart_id']}_checked\" cart-id=\"{$value['cart_id']}\" product-id=\"{$value['product_id']}\" onclick=\"Checked({$value['cart_id']}, {$value['selected']});\" {$isSelected} ";
                $list[$key]['ReduceQuantity'] = " onclick=\"CartUnifiedAlgorithm({$value['stock_count']}, {$value['product_id']}, '-', {$value['selected']}, '{$value['spec_value_id']}', {$value['cart_id']});\" ";
                $list[$key]['UpdateQuantity'] = " onkeyup=\"this.value=this.value.replace(/[^\d]/g, '');\" onafterpaste=\"this.value=this.value.replace(/[^\d]/g, '');\" value=\"{$value['product_num']}\" data-pre_value=\"{$value['product_num']}\" id=\"{$value['cart_id']}_num\" onchange=\"CartUnifiedAlgorithm({$value['stock_count']}, {$value['product_id']}, 'change', {$value['selected']}, '{$value['spec_value_id']}', {$value['cart_id']});\" ";
                $list[$key]['IncreaseQuantity'] = " onclick=\"CartUnifiedAlgorithm({$value['stock_count']}, {$value['product_id']}, '+', {$value['selected']}, '{$value['spec_value_id']}', {$value['cart_id']});\" ";
            }

            $list[$key]['ProductId']     = " id=\"{$value['cart_id']}_product\" ";
            $list[$key]['ProductSpecId'] = " id=\"{$value['cart_id']}_product_spec\" ";
            $list[$key]['SubTotalId']    = " id=\"{$value['cart_id']}_subtotal\" ";
            $list[$key]['UsersPriceId']  = " id=\"{$value['cart_id']}_price\" ";
            $list[$key]['CartDel']       = " href=\"javascript:void(0);\" onclick=\"CartDel({$value['cart_id']}, '{$value['title']}', 0);\" ";
            $list[$key]['directDeletion'] = " href=\"javascript:void(0);\" onclick=\"directDeletion({$value['cart_id']});\" ";
            $list[$key]['MoveToCollection'] = " href=\"javascript:void(0);\" onclick=\"MoveToCollection('{$value['cart_id']}','{$value['title']}');\" ";
            $list[$key]['hidden']   = <<<EOF
<input type="hidden" id="{$value['cart_id']}_Selected" value="{$value['selected']}">
<input type="hidden" id="SpecStockCount" value="{$value['spec_stock']}">
EOF;
        }

        $result['list'] = $list;

        // dump($list);exit;
        // 是否购物车的产品全部选中
        if (count($list) == $selected) $result['AllSelected'] = 1;

        // 下单地址
        $result['ShopOrderUrl'] = urldecode(dynamic_url('user/Shop/shop_under_order'));
        if (!empty($this->visitorsID) && empty($this->users_id) && !empty($result['list'])) {
            $cartidArr = get_arr_column($result['list'], 'cart_id');
            $cartidStr = md5(json_encode($cartidArr));
            cookie($cartidStr, $cartidArr);
            $result['ShopOrderUrl'] = urldecode(dynamic_url('user/Shop/shop_under_order', ['cartidStr' => $cartidStr]));
        }
        $result['SubmitOrder'] = " id='SubmitOrder_v455820' onclick=\"SubmitOrder('{$result['ShopOrderUrl']}');\" ";
        $result['SubmitOrder_0'] = " id='SubmitOrder_0_v455820'  onclick=\"SubmitOrder_0();\" ";
        $isAllSelected = !empty($result['AllSelected']) ? 'checked' : '';
        $result['InputChecked'] = " id=\"AllChecked\" onclick=\"Checked('*', {$result['AllSelected']});\" {$isAllSelected} ";
        $result['InputHidden'] = " <input type=\"hidden\" id=\"AllSelected\" value='{$result['AllSelected']}'> ";
        $result['TotalCartNumberId'] = " id=\"TotalCartNumber\" ";
        $result['TotalNumberId'] = " id=\"TotalNumber\" ";
        $result['TotalAmountId'] = " id=\"TotalAmount\" ";
        $result['BatchCartDel'] = " href=\"javascript:void(0);\" onclick=\"BatchCartDel();\" ";
        $result['selectCartDel'] = " href=\"javascript:void(0);\" onclick=\"selectCartDel();\" ";
        $result['deteleCartAll'] = " href=\"javascript:void(0);\" onclick=\"CartDel(0, '所有商品', 1);\" ";
        if ('v2' == $this->usersTplVersion) {
            $result['SubmitOrder'] = " onclick=\"toSplitGoods('{$result['ShopOrderUrl']}');\" ";
        }
        // 购物车同时存在 仅物流配送 和 仅到店核销 则执行
        // if (in_array(1, $logisticsTypeArr) && in_array(2, $logisticsTypeArr)) {
        //     $result['SubmitOrder'] = " onclick='toSplitGoods();' ";
        // }

        // 传入JS文件的参数
        $data['is_wap']                     = isWeixin() || isMobile() ? 1 : 0;
        $data['isCheck']                    = 'shop_cart_list' == request()->action() ? 1 : 0;
        $data['cart_del_url']               = dynamic_url('user/Shop/cart_del', ['_ajax' => 1]);
        $data['cart_checked_url']           = dynamic_url('user/Shop/cart_checked', ['_ajax' => 1]);
        $data['toSplitGoods']               = dynamic_url('user/Shop/to_split_goods');
        $data['select_cart_del_url']        = dynamic_url('user/Shop/select_cart_del', ['_ajax' => 1]);
        $data['move_to_collection_url']     = dynamic_url('user/Shop/move_to_collection', ['_ajax' => 1]);
        $data['cart_stock_detection']       = dynamic_url('user/Shop/cart_stock_detection', ['_ajax' => 1]);
        $data['cart_unified_algorithm_url'] = dynamic_url('user/Shop/cart_unified_algorithm', ['_ajax' => 1]);
        $data_json = json_encode($data);
        $version = getCmsVersion();
        // 会员模板版本号
        if (empty($this->usersTplVersion) || 'v1' == $this->usersTplVersion) {
            $jsfile = "tag_spcart.js";
        } else {
            $jsfile = "tag_spcart_{$this->usersTplVersion}.js";
        }
        $srcurl = get_absolute_url("{$this->root_dir}/public/static/common/js/{$jsfile}?v={$version}");
        $result['hidden'] = <<<EOF
<script type="text/javascript">
    var b82ac06cf24687eba9bc5a7ba92be4c8 = {$data_json};
</script>
<script language="javascript" type="text/javascript" src="{$srcurl}"></script>
EOF;
        return $result;
    }
}