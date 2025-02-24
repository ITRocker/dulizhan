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
 * Date: 2019-7-9
 */
namespace app\admin\model;

use think\Model;
use think\Config;
use think\Db;

/**
 * 商品规格值ID，价格，库存表
 */
class ProductSpecValue extends Model
{
    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        $this->admin_lang = get_admin_lang();
    }

    public function ProducSpecValueEditSave($post = [], $action = 'edit')
    {
        if (!empty($post['aid']) && !empty($post['spec_price']) && !empty($post['spec_stock'])) {
            // 商品规格价格及规格库存
            $time = getTime();
            $saveAll = [];
            // 查询最大的 spec_id
            $nextID = create_next_id('product_spec_value', 'value_id');
            foreach ($post['spec_price'] as $kkk => $vvv) {
                $saveAll[] = [
                    'value_id'      => intval($nextID),
                    'aid'           => intval($post['aid']),
                    'spec_value_id' => trim($kkk),
                    'spec_price'    => !empty($vvv['users_price']) ? floatval($vvv['users_price']) : 0,
                    'spec_stock'    => !empty($post['spec_stock'][$kkk]['stock_count']) ? intval($post['spec_stock'][$kkk]['stock_count']) : 0,
                    'spec_crossed_price' => !empty($post['spec_crossed_price'][$kkk]['crossed_price']) ? floatval($post['spec_crossed_price'][$kkk]['crossed_price']) : 0,
                    'spec_sales_num'=> !empty($post['spec_sales'][$kkk]['spec_sales_num']) ? intval($post['spec_sales'][$kkk]['spec_sales_num']) : 0,
                    'lang'          => $this->admin_lang,
                    'add_time'      => $time,
                    'update_time'   => $time,
                ];
                $nextID++;
            }
            if (!empty($saveAll)) {
                if ('edit' === strval($action)) {
                    // 删除当前商品下的所有规格价格库存数据
                    $where = [
                        'aid' => $post['aid'],
                    ];
                    $this->where($where)->delete(true);
                }

                // 批量新增商品规格价格数据
                $this->saveAll($saveAll);

                // 删除处理表数据
                Db::name('product_spec_value_handle')->where(['aid' => session('handleAID') ? session('handleAID') : $post['aid']])->delete(true);
            }
        }
    }
}