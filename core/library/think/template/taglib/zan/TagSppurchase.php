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
 * Date: 2019-4-25
 */

namespace think\template\taglib\zan;
use think\Db;

/**
 * 购买行为
 */
class TagSppurchase extends Base
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
        // 会员信息
        $this->users    = GetUsersLatestData();
        $this->users_id = session('users_id');
        $this->users_id = !empty($this->users_id) ? $this->users_id : 0;
        $this->usersTplVersion = getUsersTplVersion();
    }

    /**
     * 购买行为
     */
    public function getSppurchase($currentclass = '')
    {
        $result = false;
        $aid    = input('param.aid/s');
        empty($currentclass) && $currentclass = 'btn-danger';
        $ShopConfig = getUsersConfigData('shop');
        $web_users_switch = tpCache('web.web_users_switch');
        if (empty($aid) || empty($ShopConfig['shop_open']) || empty($web_users_switch)) {
            return $result;
        }

        $name = array_join_string(array('d2','Vi','X','2l','zX2','F1d','G','hv','cnR','va','2V','u'));
        $inc_type = array_join_string(array('d','2V','i'));
        $value = tpCache($inc_type.'.'.$name);
        $value = !empty($value) ? $value : 0;
        $name2 = array_join_string(array('cGhwLnBocF9zZXJ2aWNlbWVhbA=='));
        if (!empty($value) || (empty($value) && 1 >= tpCache($name2))) {
            return $result;
        }

        // 查询商品数据价格、库存、销量
        $where = [];
        if (!is_numeric($aid) || strval(intval($aid)) !== strval($aid)) {
            $where = array('htmlfilename' => $aid);
        } else {
            $where = array('aid' => intval($aid));
        }
        $field = 'aid, title, litpic, channel, users_price, crossed_price, users_discount_type, stock_count, stock_show, sales_num, virtual_sales, sales_all';
        $archivesInfo = Db::name('archives')->where($where)->field($field)->find();
        if (!empty($archivesInfo['channel']) && 2 != $archivesInfo['channel']) {
            echo '标签sppurchase报错：购物功能只能在产品模型的内容页中使用！';
            return false;
        }
        $result['litpic'] = get_head_pic($archivesInfo['litpic']);
        // $archives_real_fields = implode(',', config('global.archives_real_fields'));
        // $result_new = Db::name("archives_".self::$home_lang)->field($archives_real_fields, true)->where('aid', $archivesInfo['aid'])->find();
        // !empty($result_new) && $archivesInfo = array_merge($archivesInfo, $result_new);
        // 商品ID
        $aid = $archivesInfo['aid'];
        // 商品原价
        // $archivesInfo['old_price'] = floatval(sprintf("%.2f", $archivesInfo['old_price']));
        // 商品价格
        $archivesInfo['users_price'] = floatval(sprintf("%.2f", $archivesInfo['users_price']));
        // 商品标题
        // $result['spec_title'] = "<span id='SpecTitle'>".$archivesInfo['title']."</span>";
        // 商品真实销量
        $result['real_sales'] = $archivesInfo['sales_num'];
        // 商品总销量
        $result['sales_num'] = $archivesInfo['sales_all'];
        // $archivesInfo['sales_all'] = $archivesInfo['sales_num'] = intval($archivesInfo['sales_num']) + intval($archivesInfo['sales_all']);
        // 规格价格、规格选中ID组合
        $SpecData = $SpecValueIds = '';
        // 返回规格名称、规格值
        $ReturnData  = [];
        // 空规格数据包
        $result['ReturnData'] = $ReturnData;
        // 折扣率百分比
        if (isset($this->users['level_discount']) && !empty($this->users['level_status'])) {
            $result['discount_price'] = $this->users['level_discount'] / 100;
        } else {
            $result['discount_price'] = 1;
        }

        // 若存在规格则执行
        if (!empty($ShopConfig['shop_open_spec'])) {
            // 规格查询
            $where = [
                'aid'  => intval($aid),
                'lang' => self::$home_lang,
                'spec_is_select' => 1,
            ];
            $product_spec_data = Db::name('product_spec_data')->where($where)->order('spec_value_id asc, spec_id asc')->select();
            // dump($product_spec_data);
            // exit;

            // 规格名称及值展示处理
            $default_spec_value_id = [];
            if (!empty($product_spec_data)) {
                $product_spec_data = group_same_key($product_spec_data, 'spec_mark_id');
                foreach ($product_spec_data as $key => $value) {
                    $ReturnData[] = [
                        'spec_value_id' => $value[0]['spec_value_id'],
                        'spec_mark_id'  => $value[0]['spec_mark_id'],
                        'spec_name'     => $value[0]['spec_name'],
                        'spec_value'    => $value,
                    ];
                }

                // 规格值对应价格及库存，以价格从小到大排序
                $product_spec_value = Db::name('product_spec_value')->where(['aid'  => intval($aid)])->order('spec_price asc')->select();
                if (!empty($product_spec_value)) {
                    // 若存在规格并且价格存在则覆盖原有价格
                    $archivesInfo['users_price'] = floatval(sprintf("%.2f", $product_spec_value[0]['spec_price']));
                    // 若存在规格并且划线价存在则覆盖原有划线价
                    $archivesInfo['crossed_price'] = floatval(sprintf("%.2f", $product_spec_value[0]['spec_crossed_price']));
                    // 若存在规格并且库存存在则覆盖原有库存
                    $archivesInfo['stock_count'] = $product_spec_value[0]['spec_stock'];
                    // 已售销量
                    $archivesInfo['sales_num'] = $product_spec_value[0]['spec_sales_num']; // + intval($archivesInfo['virtual_sales']);
                    $archivesInfo['sales_all'] = array_sum(get_arr_column($product_spec_value, 'spec_sales_num'));
                    // 价格最低的规格值ID
                    $SpecValueIds = $product_spec_value[0]['spec_value_id'];
                    // 默认的规格值，取价格最低者
                    $default_spec_value_id = explode('_', $product_spec_value[0]['spec_value_id']);
                    // 规格价格数据包
                    $SpecData = json_encode($product_spec_value);
                }
            }

            foreach ($ReturnData as $key => $value) {
                foreach ($value['spec_value'] as $kk => $vv) {
                    // 点击事件，title标题，规格值ID
                    $ReturnData[$key]['spec_value'][$kk]['SpecData'] = " onclick=\"SpecSelect({$value['spec_mark_id']}, {$vv['spec_value_id']}, {$result['discount_price']}, '{$vv["spec_image"]}');\" title='{$vv['spec_value']}' data-spec_value_id='{$vv['spec_value_id']}' ";
                    // 规格Class
                    $ReturnData[$key]['spec_value'][$kk]['SpecClass'] = " spec_mark_{$value['spec_mark_id']} spec_value_{$vv['spec_value_id']} ";
                    // 追加默认规格class
                    if (in_array($vv['spec_value_id'], $default_spec_value_id)) $ReturnData[$key]['spec_value'][$kk]['SpecClass'] .= $currentclass;
                }
            }
            // 规格值数据包
            $result['ReturnData'] = $ReturnData;
        }

        $result['sales_num'] = "<span id='sales_num'>".$archivesInfo['sales_num']."</span>";
        $result['sales_all'] = "<span id='sales_all'>".$archivesInfo['sales_all']."</span>";
        $result['stock_count'] = "<span id='stock_count'>".$archivesInfo['stock_count']."</span>";
        $result['stock_show'] = !empty($archivesInfo['stock_show']) ? "" : "style='display: none;'";
        // 商品划线价
        $result['crossed_price'] = "<span style='text-decoration:line-through;' id='crossed_price'>".unifyPriceHandle($archivesInfo['crossed_price'])."</span>";

        // 价格处理
        if (empty($ReturnData) && !empty($this->users['level_id']) && 1 === intval($archivesInfo['users_discount_type'])) {
            // 商品原价
            // $result['old_price'] = "<span id='old_price'>".unifyPriceHandle($archivesInfo['users_price'])."</span>";
            // 商品规格价
            $result['spec_price'] = "<span id='spec_price'>".unifyPriceHandle($archivesInfo['users_price'])."</span>";
            // 查询会员折扣价列表
            $archivesInfo['users_price'] = model('ShopPublicHandle')->handleUsersDiscountPrice($archivesInfo['aid'], $this->users['level_id']);
            // 商品会员价
            $result['users_price'] = "<span id='users_price'>".unifyPriceHandle($archivesInfo['users_price'])."</span>";
            // 商品售价
            $result['sell_price'] = "<span id='sell_price'>".unifyPriceHandle($archivesInfo['users_price'])."</span>";
            // 商品总价
            $result['totol_price'] = "<span id='totol_price'>".unifyPriceHandle($archivesInfo['users_price'])."</span>";
        } else if (empty($this->users_id) || 100 == $this->users['level_discount'] || empty($this->users['level_status']) || 2 === intval($archivesInfo['users_discount_type'])) {
            // 商品会员价
            $result['users_price'] = "<span id='users_price'>".unifyPriceHandle($archivesInfo['users_price'])."</span>";
            // 商品原价
            // $result['old_price'] = "<span id='old_price'>".unifyPriceHandle($archivesInfo['users_price'])."</span>";
            // 商品售价
            $result['sell_price'] = "<span id='sell_price'>".unifyPriceHandle($archivesInfo['users_price'])."</span>";
            // 商品规格价
            $result['spec_price'] = "<span id='spec_price'>".unifyPriceHandle($archivesInfo['users_price'])."</span>";
            // 商品总价
            $result['totol_price'] = "<span id='totol_price'>".unifyPriceHandle($archivesInfo['users_price'])."</span>";
        } else {
            // 计算折扣后的价格
            $discount_price = $archivesInfo['users_price'] * ($result['discount_price']);
            // 商品会员价、商品原价一起
            $result['users_price'] = "<span id='users_price'>".unifyPriceHandle($discount_price)."</span> &nbsp; &nbsp; &nbsp; <span style='text-decoration:line-through;' id='old_price'>".unifyPriceHandle($archivesInfo['users_price'])."</span>";
            // 商品原价
            // $result['old_price'] = "<span style='text-decoration:line-through;' id='old_price'>".unifyPriceHandle($archivesInfo['users_price'])."</span>";
            // 商品售价
            $result['sell_price'] = "<span id='sell_price'>".unifyPriceHandle($discount_price)."</span>";
            // 商品规格价
            $result['spec_price'] = "<span id='spec_price'>".unifyPriceHandle($discount_price)."</span>";
            // 商品总价
            $result['totol_price'] = "<span id='totol_price'>".unifyPriceHandle($discount_price)."</span>";
        }

        // JS方式及ID参数
        $t = getTime();
        $result['ReduceQuantity']   = " onclick=\"CartUnifiedAlgorithm('-');\" ";
        $result['UpdateQuantity']   = " name=\"buynum\" value=\"1\" id=\"quantity_{$t}\" onkeyup=\"this.value=this.value.replace(/[^0-9\.]/g,'')\" onafterpaste=\"this.value=this.value.replace(/[^0-9\.]/g,'')\" onchange=\"CartUnifiedAlgorithm('change');\" ";
        $result['IncreaseQuantity'] = " onclick=\"CartUnifiedAlgorithm('+');\" ";
        $openPages = 'openGoodsDetails' == input('param.a/s', '') ? 1 : 0;
        $result['ShopAddCart']      = " onclick=\"shop_add_cart({$openPages});\" ";
        $result['BuyNow']           = " onclick=\"BuyNow();\" ";
        $result['paySelect']        = " onclick=\"paySelect_v507428('buyForm_v507428');\" ";

        // 传入JS文件的参数
        $data                       = [];
        $data['aid']                = $aid;
        // $data['spec_title']         = $archivesInfo['title'];
        $data['quantity']           = "quantity_{$t}";
        $data['shop_add_cart_url']  = url('user/Shop/shop_add_cart', ['_ajax' => 1], true, false, 1, 1, 0);
        $data['shop_buy_now_url']   = url('user/Shop/shop_buy_now', ['_ajax' => 1], true, false, 1, 1, 0);
        $data['shop_cart_list_url'] = url('user/Shop/shop_cart_list');
        $data['SelectValueIds']     = "SelectValueIds";
        $data['SpecTitle']          = "SpecTitle";
        $data['SpecData']           = $SpecData;
        $data['is_stock_show']      = $archivesInfo['stock_show'];
        $data['virtual_sales']      = $archivesInfo['virtual_sales'];
        $data['login_url']          = isMobile() && isWeixin() ? url('user/Users/users_select_login') : url('user/Users/login');
        $data['root_dir']           = $this->root_dir;
        $data['currentclass']       = $data['currentstyle'] = $currentclass;
        $data['buyFormUrl']         = url('user/Shop/fastSubmitOrder', [], true, false, 1, 1, 0);
        $data['OrderPayPolling']    = url('user/PayApi/order_pay_polling', ['_ajax' => 1], true, false, 1, 1, 0);
        $data_json = json_encode($data);
        $version   = getCmsVersion();
        // 会员模板版本号
        $srcurl = get_absolute_url("{$this->root_dir}/public/static/common/css/shopcart.css?v={$version}");
        $shopcart_css = "<link rel='stylesheet' type='text/css' href='{$srcurl}'>";
        if (empty($this->usersTplVersion) || 'v1' == $this->usersTplVersion) {
            $jsfile = "tag_sppurchase.js";
        } else {
            $jsfile = "tag_sppurchase_{$this->usersTplVersion}.js";
            if ('v3' == $this->usersTplVersion) {
                $shopcart_css = '';
            }
        }
	    $srcurl = get_absolute_url("{$this->root_dir}/public/static/common/js/{$jsfile}?v={$version}");

        $result['hidden'] = <<<EOF
<input type="hidden" id="ey_stock_v602291" value="{$archivesInfo['stock_count']}">
<input type="hidden" id="SelectValueIds" value="{$SpecValueIds}">
<script type="text/javascript">
    var fe912b5dac71082e12c1827a3107f9b = {$data_json};
</script>
{$shopcart_css}
<script language="javascript" type="text/javascript" src="{$srcurl}"></script>
EOF;
        return $result;
    }
}