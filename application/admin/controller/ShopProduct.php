<?php
/**
 * ZanCms
 * ============================================================================
 * 版权所有 2020-2035 海南赞赞网络科技有限公司，并保留所有权利。
 * 网站地址: http://www.zancms.com
 * ----------------------------------------------------------------------------
 * 如果商业用途务必到官方购买正版授权, 以免引起不必要的法律纠纷.
 * ============================================================================
 * Author: 易而优团队 by 小虎哥 <1105415366@qq.com>
 * Date: 2018-4-3
 */

namespace app\admin\controller;

use think\Db;
use think\Page;
use app\common\logic\ArctypeLogic;
use app\admin\logic\ProductLogic;
use app\admin\logic\ProductSpecLogic; // 用于商品规格逻辑功能处理
use app\admin\logic\ShopLogic;

class ShopProduct extends Base
{
    // 模型标识
    public $nid = 'product';
    // 模型ID
    public $channeltype = '';
    // 表单类型
    public $attrInputTypeArr = array();
    public $shopLogic;

    public function _initialize()
    {
        parent::_initialize();
        // 当前时间戳
        $this->times = getTime();

        $channeltype_list  = config('global.channeltype_list');
        $this->channeltype = $channeltype_list[$this->nid];
        empty($this->channeltype) && $this->channeltype = 2;
        $this->attrInputTypeArr = config('global.attr_input_type_arr');
        $this->assign('nid', $this->nid);
        $this->assign('channeltype', $this->channeltype);

        // 商城业务层
        $this->shopLogic = new ShopLogic;

        // 分类业务层
        $this->arctypeLogic = new ArctypeLogic();

        // 商城产品参数表
        $this->shop_product_attrlist_db = Db::name('shop_product_attrlist');

        // 规格业务层
        $this->productSpecLogic = new ProductSpecLogic;
        
        // 列出营销功能里已使用的模块
        $marketFunc = $this->shopLogic->marketLogic();
        $this->assign('marketFunc', $marketFunc);

        // 返回页面
        $paramTypeid = input('param.typeid/d', 0);
        $this->callback_url = url('ShopProduct/index', ['lang' => $this->admin_lang, 'typeid' => $paramTypeid]);
        $this->assign('callback_url', $this->callback_url);

        // 分类列表URL
        $this->assign('arctype_list_url', url('Arctype/index', ['channeltype' => $this->channeltype]));
    }

    /**
     * 商品列表
     */
    public function index()
    {
        $param = input('param.');
        $param['channel'] = $this->channeltype;
        $result = model('Archives')->getArchivesList($param);
        $this->assign($result);
        return $this->fetch();
    }

    /**
     * 添加
     */
    public function add()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            $post['channel'] = 2;
            if (!empty($post['is_jump']) && empty($post['jumplinks'])) $this->error('请输入跳转网址');

            // 获取新增文档数据
            [$insert, $content] = model('Archives')->getInsertArchivesArray($post, true);

            // 保存文档基础数据
            $aid = Db::name('archives')->insertGetId($insert);
            if (!empty($aid)) {
                $post['aid'] = intval($aid);

                // 保存文档内容数据
                if (empty($content['aid'])) $content['aid'] = intval($aid);
                Db::name('product_content')->insertGetId($content);

                // 若选择单规格则清理多规格数据
                if (!empty($post['spec_type']) && 1 === intval($post['spec_type']) && session('handleAID')) {
                    $where = [
                        'aid' => session('handleAID')
                    ];
                    Db::name("product_spec_data_handle")->where($where)->delete(true);
                    Db::name("product_spec_value_handle")->where($where)->delete(true);
                }
                // 若选择多规格选项，则添加产品规格
                else if (!empty($post['spec_type']) && 2 === intval($post['spec_type'])) {
                    // 更新规格名称数据
                    model('ProductSpecData')->ProducSpecNameEditSave($post, 'add');
                    // 更新规格值及金额数据
                    model('ProductSpecValue')->ProducSpecValueEditSave($post, 'add');
                }

                // 保存文档图集数据
                model('ProductImg')->saveProductImg($post);

                // 保存文档参数数据
                model('ProductParam')->saveProductParam($post);

                // 同步保存对应语言文档数据
                $resultID = model('Archives')->saveArchivesDetails($post);
                if (!empty($resultID)) {
                    adminLog('新增产品：' . $insert['title']);
                    // 记录链接
                    model('Archives')->logOpenJumpPageUrl($aid, $this->callback_url, 'ShopProduct');
                    // 结束返回
                    $this->success("新增成功");
                }
            }
            $this->error("操作失败");
        }

        $id = input('id/d', 0);
        $stypeid = Db::name('archives')->where(['aid' => $id])->getField('stypeid');
        $assign_data['stypeid'] = $stypeid;

        $admin_info = session('admin_info');
        $this->assign('admin_info', $admin_info);
        $auth_role_info = $admin_info['auth_role_info'];
        $this->assign('auth_role_info', $auth_role_info);

        // 允许发布文档列表的栏目，文档所在模型以栏目所在模型为主，兼容切换模型之后的数据编辑
        $arctype_list = allow_release_arctype(0, array($this->channeltype), false);
        $assign_data['arctype_list'] = $arctype_list;

        // 最大参数ID
        $maxParamID = Db::name('product_param')->max('param_id');
        $assign_data['maxParamID'] = ++$maxParamID;

        // 商城配置
        $shopConfig = getUsersConfigData('shop');
        $assign_data['shopConfig'] = $shopConfig;

        // 商品规格
        if (isset($shopConfig['shop_open_spec']) && 1 === intval($shopConfig['shop_open_spec'])) {
            // 删除商品添加时产生的废弃规格
            $del_spec = session('del_spec') ? session('del_spec') : [];
            if (!empty($del_spec)) {
                $del_spec = array_unique($del_spec);
                $where = [
                    'spec_mark_id' => ['IN', $del_spec]
                ];
                Db::name('product_spec_data_handle')->where($where)->delete(true);
                $where = [
                    'aid' => session('handleAID')
                ];
                Db::name('product_spec_value_handle')->where($where)->delete(true);
                // 清除 session
                session('del_spec', null);
            }
            // 清除处理表的aid
            session('handleAID', 0);
            // 预设值名称
            // $assign_data['preset_value'] = Db::name('product_spec_preset')->where('lang', $this->admin_lang)->field('preset_id, preset_mark_id, preset_name')->group('preset_mark_id')->order('preset_mark_id desc')->select();
            // 读取规格预设库最大参数标记ID
            // $maxPresetMarkID = $assign_data['preset_value'][0]['preset_mark_id'];
            $assign_data['maxPresetMarkID'] = 1;//$maxPresetMarkID + 1;
        }

        // 文档属性
        $assign_data['archives_flags'] = model('ArchivesFlag')->getList();

        $this->assign($assign_data);
        return $this->fetch();
    }

    /**
     * 编辑
     */
    public function edit()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            if (empty($post['aid'])) $this->error('产品ID丢失，请刷新重试');
            if (!empty($post['is_jump']) && empty($post['jumplinks'])) $this->error('请输入跳转网址');

            $post['channel'] = 2;
            $post['aid'] = intval($post['aid']);

            // 更新主表公共字段数据
            model('Archives')->saveArchivesPublicDetails($post);

            if (trim($this->show_lang) === trim($this->admin_lang)) {
                // 保存文档图集数据
                model('ProductImg')->saveProductImg($post);

                // 若选择单规格则清理多规格数据
                if (!empty($post['spec_type']) && 1 === intval($post['spec_type'])) {
                    $where = [
                        'aid' => intval($post['aid'])
                    ];
                    Db::name("product_spec_data")->where($where)->delete(true);
                    Db::name("product_spec_value")->where($where)->delete(true);
                    Db::name("product_spec_data_handle")->where($where)->delete(true);
                    Db::name("product_spec_value_handle")->where($where)->delete(true);
                }
                // 若选择多规格选项，则添加产品规格
                else if (!empty($post['spec_type']) && 2 === intval($post['spec_type'])) {
                    // 更新规格名称数据
                    model('ProductSpecData')->ProducSpecNameEditSave($post);
                    // 更新规格值及金额数据
                    model('ProductSpecValue')->ProducSpecValueEditSave($post);
                }
            } else {
                if (!empty($post['spec_type']) && 2 === intval($post['spec_type'])) {
                    // 更新规格名称数据
                    model('ProductSpecData')->ProducSpecNameEditSave($post);
                    // 删除规格价处理表数据
                    Db::name("product_spec_value_handle")->where(['aid' => intval($post['aid'])])->delete(true);
                }
            }

            // 保存文档参数数据
            model('ProductParam')->saveProductParam($post, 'edit');

            // 同步保存对应语言文档数据
            $resultID = model('Archives')->saveArchivesDetails($post);
            if (!empty($resultID)) {
                adminLog('编辑产品：' . $post['title']);
                // 记录链接
                model('Archives')->logOpenJumpPageUrl($post['aid'], $this->callback_url, 'ShopProduct');
                // 清理失效的购物车商品
                if (empty($post['status'])) model('ShopCart')->handleUsersShopCart($post['aid']);
                // 结束返回
                $this->success("保存成功");
            }
            $this->error("操作失败");
        }

        $admin_info = session('admin_info');
        $auth_role_info = $admin_info['auth_role_info'];
        $this->assign('auth_role_info', $auth_role_info);
        $this->assign('admin_info', $admin_info);

        $assign_data = [];
        $id = input('id/d', 0);
        $showlang = input('showlang/s', '');
        $info = model('Archives')->getArchivesDetails($id);
        if (empty($info)) $this->error('数据不存在，请联系管理员！');
        // 获取规格数据信息
        // 包含：SpecSelectName、HtmlTable、spec_mark_id_arr、preset_value
        $assign_data = model('ProductSpecData')->GetProductSpecData($id);
            
        $modelarr = $this->getModelUrl($info, $this->nid, $showlang);
        $assign_data['diy_dirnamel'] = $modelarr['diy_dirnamel'];
        $assign_data['diy_domain'] = $modelarr['diy_domain'];

        $info['arcurl']=  get_arcurl($info, true, '', $showlang);
        $assign_data['seo_rewrite_format'] = $seo_rewrite_format;
        $assign_data['field'] = $info;
        // 产品相册
        $proimg_list = model('ProductImg')->getProductImg($id);
        $assign_data['proimg_list'] = $proimg_list;

        // 最大参数ID
        $maxParamID = Db::name('product_param')->max('param_id');
        $assign_data['maxParamID'] = ++$maxParamID;

        // 产品参数
        $param_list = model('ProductParam')->getProductParam($id);
        $assign_data['param_list'] = $param_list;

        // 允许发布文档列表的栏目，文档所在模型以栏目所在模型为主，兼容切换模型之后的数据编辑
        $arctype_list = allow_release_arctype(0, array($this->channeltype), false);
        $assign_data['arctype_list'] = $arctype_list;

        // 商城配置
        $shopConfig = getUsersConfigData('shop');
        $assign_data['shopConfig'] = $shopConfig;

        // 文档属性
        $assign_data['archives_flags'] = model('ArchivesFlag')->getList();

        // 豆包翻译API配置
        $doubao = tpSetting('doubao', [], $this->show_lang);
        $this->assign('doubao', $doubao);

        
        // 是否显示已添加文案
        $assign_data['showMsg'] = input('showMsg/d', 0);
        $this->assign($assign_data);
        return $this->fetch();
    }
    /**
     * 删除
     */
    public function del()
    {
        if (IS_POST) {
            $del_id = input('del_id/a');
            model('Archives')->delArchives(eyIntval($del_id), 'product');
            // $archivesLogic = new \app\admin\logic\ArchivesLogic;
            // $archivesLogic->del([], 0, 'product');
        }
    }

    /**
     * 删除商品相册图
     */
    public function del_proimg()
    {
        if (IS_POST) {
            $filename= input('filename/s');
            $aid = input('aid/d');
            if (!empty($filename) && !empty($aid)) {
                Db::name('product_img')->where('image_url','like','%'.$filename)->where('aid',$aid)->delete();
            }

        }
    }

    public function goods_spec_detection()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            // 验证规格名
            $result = 0;
            foreach ($post['spec_mark_id'] as $key => $value) {
                if (empty($value['spec_name'])) $result = 1;
            }
            !empty($result) && $this->error('请完善规格名');

            // 验证规格值
            $result = 0;
            foreach ($post['spec_value_id'] as $key => $value) {
                if (empty($value['spec_value'])) $result = 1;
            }
            !empty($result) && $this->error('请完善规格值');

            // 验证规格价
            $result = 0;
            foreach ($post['spec_price'] as $key => $value) {
                if (empty($value['users_price']) || 0 >= floatval($value['users_price'])) $result = 1;
            }
            !empty($result) && $this->error('请完善规格价');
            $this->success('验证成功');
        }
    }

    public function goods_quick_edit()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            if (empty($post['aid']) || !isset($post['openSpec'])) $this->error('数据异常，刷新重试');
            if (1 == $post['openSpec']){
                $post['sales_all'] = 0;
                foreach ($post['spec_sales'] as $k => $v){
                    $post['sales_all'] += intval($v['spec_sales_num']);
                }
            }else{
                $post['sales_all'] = $post['virtual_sales'];
            }
            // 更新商品表数据
            $where = [
                'aid' => intval($post['aid']),
                'lang' => $this->admin_lang,
            ];
            $update = [
                'stock_show'  => empty($post['stock_show']) ? 0 : intval($post['stock_show']),
                'stock_count' => empty($post['stock_count']) ? 0 : intval($post['stock_count']),
                'users_price' => empty($post['users_price']) ? 0 : floatval($post['users_price']),
                'users_discount_type'  => empty($post['users_discount_type']) ? 0 : intval($post['users_discount_type']),
                'update_time' => getTime(),
            ];
            $update = array_merge($post, $update);
            $result = Db::name('archives')->where($where)->update($update);
            // 后续处理
            if (!empty($result)) {
                // 已开启规格的商品处理
                if (1 === intval($update['openSpec'])) {
                    // 更新规格值及金额数据
                    model('ProductSpecValue')->ProducSpecValueEditSave($update, 'edit');
                }
                // 未开启规格的商品处理
                else if (0 === intval($update['openSpec']) && 1 === intval($update['users_discount_type'])) {
                    // 选择指定会员级别执行
                    model('ShopPublicHandle')->saveUsersDiscountPriceList($update['users_discount'], $update['aid']);
                }
                // 系统商品操作时，积分商品的被动处理
                model('ShopPublicHandle')->pointsGoodsPassiveHandle([$update['aid']]);
                // 成功返回结束
                $this->success("操作成功");
            }
            // 失败返回结束
            $this->error("操作失败");
        }

        // 查询商品信息
        $aid = input('param.aid/d', 0);
        $where = [
            'aid' => intval($aid),
        ];
        $field = 'aid, title, users_price, stock_count, stock_show, virtual_sales, users_discount_type';
        $goods = Db::name('archives')->field($field)->where($where)->find();
        $this->assign('goods', $goods);

        // 查询商品的规格信息
        $where = [
            'aid' => intval($aid),
            'spec_is_select' => 1,
        ];
        $field = 'spec_mark_id, spec_value_id';
        // $order = 'spec_mark_id asc, spec_value_id asc, spec_id asc';
        $order = 'spec_value_id asc, spec_id asc';
        $spec = Db::name('product_spec_data')->where($where)->field($field)->order($order)->select();
        $openSpec = 0;
        $htmlTable = '';
        if (!empty($spec)) {
            $openSpec = 1;
            // 处理规格数组
            $specArray = [];
            foreach ($spec as $key => $value) {
                $specArray[$value['spec_mark_id']][] = $value['spec_value_id'];
            }
            $htmlTable = $this->productSpecLogic->SpecAssemblyEdit($specArray, $aid, true);
        }
        $this->assign('openSpec', $openSpec);
        $this->assign('htmlTable', $htmlTable);

        // 商城配置
        $this->assign('shopConfig', getUsersConfigData('shop'));

        return $this->fetch();
    }

    public function goodsSpecImage()
    {
        if (IS_AJAX_POST) {
            // 规格图片路径
            $aid = input('param.aid/d', 0);
            if (empty($aid)) $aid = session('handleAID');
            $action = input('param.action/s', '');
            $checked = input('param.checked/d', 0);
            $spec_image = input('param.spec_image/s', '');
            $spec_mark_id = input('param.spec_mark_id/d', 0);
            $spec_value_id = input('param.spec_value_id/d', 0);
            if ('open' == $action) {
                // 更新同一类所有规格值为开启规格图片
                $where = [
                    // 'spec_is_select' => 1,
                    'aid' => intval($aid),
                    'spec_mark_id' => intval($spec_mark_id),
                ];
                $update = [
                    'open_image' => intval($checked),
                    'update_time' => getTime(),
                ];
                $result = Db::name('product_spec_data_handle')->where($where)->update($update);
                if (!empty($result)) $this->success("操作成功");
            } else {
                $where = [
                    // 'spec_is_select' => 1,
                    'aid' => intval($aid),
                    'spec_mark_id' => intval($spec_mark_id),
                    'spec_value_id' => intval($spec_value_id),
                ];
                $update = [
                    'spec_image' => $spec_image,
                    'update_time' => getTime(),
                ];
                $result = Db::name('product_spec_data_handle')->where($where)->update($update);
                if (!empty($result)) $this->success("操作成功");
            }
        }
        $this->error("操作失败");
    }

    // 初始化规格信息
    public function initialization_spec()
    {
        if (IS_AJAX_POST) {
            $initialization = input('post.initialization');

            // 刷新或重新进入产品添加页则清除关于产品session
            if (!empty($initialization)) {
                // session('handleAID', 0);
                session('del_spec', null);
                session('spec_arr', null);
                $this->success('初始化完成');
            }
        }
    }

    // 添加商品自定义规格并返回规格表格
    public function add_product_custom_spec()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');

            // 添加自定义规格
            $resultArray = $this->productSpecLogic->addProductCustomSpec($post);
            if (!empty($resultArray['errorMsg'])) $this->error($resultArray['errorMsg']);

            // 获取已选规格进行HTML代码拼装
            $postAid = !empty($post['aid']) ? intval($post['aid']) : 0;
            $htmlTable = $this->productSpecLogic->SpecAssemblyEdit($resultArray['spec_array'], $postAid);

            // 返回数据
            if (in_array($post['action'], ['specName', 'specValue'])) {
                $specData = $this->productSpecLogic->getProductSpecValueOption($resultArray['spec_mark_id'], $post);
            }
            $returnData = [
                'htmlTable' => !empty($htmlTable) ? $htmlTable : ' ',
                'spec_name' => !empty($specData['spec_name']) ? $specData['spec_name'] : '',
                'spec_value' => !empty($specData['spec_value']) ? $specData['spec_value'] : '',
                'spec_mark_id' => !empty($resultArray['spec_mark_id']) ? $resultArray['spec_mark_id'] : 0,
                'spec_value_id' => !empty($resultArray['spec_value_id']) ? $resultArray['spec_value_id'] : 0,
                'spec_value_option' => !empty($specData['spec_value_option']) ? $specData['spec_value_option'] : '',
                'spec_mark_id_arr' => !empty($resultArray['spec_mark_id_arr']) ? $resultArray['spec_mark_id_arr'] : 0,
                'preset_name_option' => !empty($specData['preset_name_option']) ? $specData['preset_name_option'] : '',
            ];
            
            $this->success('加载成功！', null, $returnData);
        }
    }

    // 添加自定义规格名称并返回规格表
    public function add_product_custom_spec_name()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');

            // 添加自定义规格名称
            $resultArray = $this->productSpecLogic->addProductCustomSpecName($post);
            if (!empty($resultArray['errorMsg'])) $this->error($resultArray['errorMsg']);

            // 获取已选规格进行HTML代码拼装
            if (!empty($post['aid'])) {
                $htmlTable = $this->productSpecLogic->SpecAssemblyEdit($resultArray, $post['aid']);
            } else {
                $htmlTable = $this->productSpecLogic->SpecAssemblyEdit($resultArray);
            }
            // 返回数据
            $returnData = [
                'htmlTable' => !empty($htmlTable) ? $htmlTable : ' ',
            ];
            $this->success('加载成功！', null, $returnData);
        }
    }

    // 添加自定义规格值并返回规格表
    public function add_product_custom_spec_value()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');

            // 添加自定义规格值
            $resultArray = $this->productSpecLogic->addProductCustomSpecValue($post);
            if (!empty($resultArray['errorMsg'])) $this->error($resultArray['errorMsg']);

            // 获取已选规格进行HTML代码拼装
            if (!empty($post['aid'])) {
                $htmlTable = $this->productSpecLogic->SpecAssemblyEdit($resultArray, $post['aid']);
            } else {
                $htmlTable = $this->productSpecLogic->SpecAssemblyEdit($resultArray);
            }
            // 返回数据
            $returnData = [
                'htmlTable' => !empty($htmlTable) ? $htmlTable : ' ',
            ];
            $this->success('加载成功！', null, $returnData);
        }
    }

    // 删除商品自定义规格并返回规格表格
    public function del_product_custom_spec()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');

            // 删除自定义规格
            $resultArray = $this->productSpecLogic->delProductCustomSpec($post);
            // 获取已选规格进行HTML代码拼装
            if (!empty($post['aid'])) {
                $htmlTable = $this->productSpecLogic->SpecAssemblyEdit($resultArray, $post['aid']);
            } else {
                $htmlTable = $this->productSpecLogic->SpecAssemblyEdit($resultArray);
            }
            if (in_array($post['del'], ['specName', 'specValue'])) {
                $specData = $this->productSpecLogic->getProductSpecValueOption(0, $post);
            }
            // 返回数据
            $returnData = [
                'htmlTable' => !empty($htmlTable) ? $htmlTable : ' ',
                'spec_value_option' => !empty($specData['spec_value_option']) ? $specData['spec_value_option'] : '',
                'preset_name_option' => !empty($specData['preset_name_option']) ? $specData['preset_name_option'] : '',
            ];
            $this->success('加载成功！', null, $returnData);
        }
    }

    public function edit_product_spec_price()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            $result = model('ProductSpecValueHandle')->editProductSpecPrice($post);
            if (!empty($result)) {
                $htmlTable = $this->productSpecLogic->SpecAssemblyEdit($result['resultArray'], $result['aid']);
                $this->success('操作成功', null, $htmlTable);
            } else {
                $this->error('数据异常，刷新重试');
            }
        }
    }

    // 获取会员折扣价格模板
    public function get_users_discount_price_tpl()
    {
        if (IS_AJAX_POST) {
            // 产品ID
            $aid = input('post.aid/d', 0);
            // 产品单价
            $users_price = input('post.users_price/f', 0);
            // 获取会员折扣价格模板
            $result = model('ShopPublicHandle')->getUsersDiscountPriceTpl($aid, $users_price);
            // 如果存在错误则返回提示
            if (isset($result['code']) && 0 === intval($result['code'])) $this->error($result['data']);
            // 返回数据
            $this->success('加载成功！', null, $result['data']);
        }
    }

    // 选中规格名称值，追加html到页面展示
    public function spec_value_select()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            // Post 数据
            $aid = !empty($post['aid']) ? $post['aid'] : 0;
            $spec_mark_id = !empty($post['spec_mark_id']) ? $post['spec_mark_id'] : 0;
            $spec_value_id = !empty($post['spec_value_id']) ? $post['spec_value_id'] : 0;
            if (empty($aid) || empty($spec_mark_id) || empty($spec_value_id)) $this->error('操作异常，请刷新重试...');

            $spec_array = [];
            // 执行更新
            $where = [
                'aid' => $aid,
                'spec_mark_id' => $spec_mark_id,
                'spec_value_id' => $spec_value_id,
            ];
            $update = [
                'spec_is_select' => 1,
                'update_time' => getTime()
            ];
            $Value = Db::name('product_spec_data_handle')->where($where)->getField('spec_value');
            $isResult = Db::name('product_spec_data_handle')->where($where)->update($update);
            if (!empty($isResult)) {
                // 仅ID信息，二维数组形式
                $where = [
                    'aid' => $aid,
                    'spec_is_select' => 1,
                ];
                $order = 'spec_value_id asc, spec_id asc, spec_mark_id asc';
                $data = Db::name('product_spec_data_handle')->field('spec_mark_id, spec_value_id')->where($where)->order($order)->select();
                if (!empty($data)) {
                    foreach ($data as $key => $value) {
                        $spec_array[$value['spec_mark_id']][] = $value['spec_value_id'];
                    }
                }
            }

            // 剔除已选择的规格值查询未选择的规格值组装成下拉返回
            $notInPresetID = !empty($spec_array[$specMarkID]) ? $spec_array[$specMarkID] : [];
            $where = [
                'aid' => $aid,
                'spec_is_select' => 0,
                'spec_mark_id' => ['IN', $spec_mark_id],
            ];
            if (!empty($notInPresetID)) $where['spec_value_id'] = ['NOT IN', $notInPresetID];
            $specData = Db::name('product_spec_data_handle')->where($where)->order('spec_value_id asc')->select();

            // 拼装下拉选项
            $Option = '<option value="0">选择规格值</option>';
            if (!empty($specData)) {
                foreach ($specData as $value) {
                    $Option .= "<option value='{$value['spec_value_id']}'>{$value['spec_value']}</option>";
                }
            }

            $htmlTable = $this->productSpecLogic->SpecAssemblyEdit($spec_array, $aid);

            // 返回数据
            $returnHtml = [
                'Value' => $Value,
                'Option' => $Option,
                'htmlTable' => $htmlTable
            ];
            $this->success('加载成功！', null, $returnHtml);
        }
    }

    // 商品属性列表
    public function attrlist_index()
    {
        // 查询条件
        $Where = [];
        $keywords        = input('keywords/s');
        if (!empty($keywords)) $Where['list_name'] = ['LIKE', "%{$keywords}%"];
        $Where['lang'] = $this->admin_lang;
        $Where['is_del'] = 0;

        // 分页
        $count   = $this->shop_product_attrlist_db->where($Where)->count('list_id');
        $pageObj = new Page($count, config('paginate.list_rows'));
        $pageStr = $pageObj->show();
        $this->assign('pager', $pageObj);
        $this->assign('page', $pageStr);

        // 数据
        $list = $this->shop_product_attrlist_db
            ->where($Where)
            ->order('sort_order asc, list_id asc')
            ->limit($pageObj->firstRow . ',' . $pageObj->listRows)
            ->select();
        $this->assign('list', $list);

        // 内容管理的产品发布/编辑里入口进来
        $oldinlet = input('param.oldinlet/d');
        $this->assign('oldinlet', $oldinlet);

        return $this->fetch();
    }

    // 保存全部参数
    public function attrlist_save()
    {
        function_exists('set_time_limit') && set_time_limit(0);

        if (IS_AJAX_POST) {
            $post = input('post.');
            // 参数名称不可重复
            $ListName = array_unique($post['list_name']);
            if (count($ListName) != count($post['list_name'])) $this->error('参数名称不可重复！');

            // 数据拼装
            $SaveData = [];
            foreach ($ListName as $key => $value) {
                if (!empty($value)) {
                    $list_id   = $post['list_id'][$key];
                    $list_name = trim($value);

                    $SaveData[$key] = [
                        'list_id'     => !empty($list_id) ? $list_id : 0,
                        'list_name'   => $list_name,
                        'desc'        => !empty($post['desc'][$key]) ? $post['desc'][$key] : '',
                        'sort_order'  => !empty($post['sort_order'][$key]) ? $post['sort_order'][$key] : 100,
                        'update_time' => getTime()
                    ];

                    if (empty($list_id)) {
                        $SaveData[$key]['add_time'] = getTime();
                        unset($SaveData[$key]['list_id']);
                    }
                }
            }

            $ReturnId = model('ShopProductAttrlist')->saveAll($SaveData);
            if ($ReturnId) {
                adminLog('新增商品参数：' . implode(',', $post['list_name']));
                $this->success('操作成功', url('Product/attrlist_index'));
            } else {
                $this->error('操作失败');
            }
        }
    }

    /**
     * 新增参数
     * @return [type] [description]
     */
    public function attrlist_add()
    {
        if (IS_AJAX_POST) {
            $post              = input('post.');
            $post['list_name'] = trim($post['list_name']);
            if (empty($post['list_name'])) {
                $this->error('参数名称不能为空！');
            }

            $SaveData = [
                'list_name'   => $post['list_name'],
                'desc'        => trim($post['desc']),
                'sort_order'  => 100,
                'lang'        => $this->admin_lang,
                'add_time'    => getTime(),
                'update_time' => getTime(),
            ];

            $ReturnId = Db::name('shop_product_attrlist')->insertGetId($SaveData);
            if ($ReturnId) {
                adminLog('新增商品参数：' . $post['list_name']);
                // 同步新产品参数分组ID到多语言的模板变量里，添加多语言新产品参数分组
                $this->syn_add_language_attrlist($ReturnId);

                if (!empty($post['attr_name'])) {
                    //数据拼接
                    $saveAttrData = [];
                    foreach ($post['attr_name'] as $k => $v) {
                        $attr_values           = str_replace('_', '', $v); // 替换特殊字符
                        $attr_values           = str_replace('@', '', $attr_values); // 替换特殊字符
                        $attr_values           = trim($attr_values);
                        if (empty($attr_values)) {
                            unset($post['attr_name'][$k]);
                            continue;
                        }
                        $post['attr_name'][$k] = $attr_values;

                        $saveAttrData[] = array(
                            'attr_name'       => !empty($post['attr_name'][$k]) ? $post['attr_name'][$k] : '',
                            'list_id'         => $ReturnId,
                            'attr_input_type' => !empty($post['attr_input_type'][$k]) ? intval($post['attr_input_type'][$k]) : 0,
                            'attr_values'     => !empty($post['attr_values'][$k]) ? trim($post['attr_values'][$k]) : '',
                            'sort_order'      => isset($post['attr_sort_order'][$k]) ? intval($post['attr_sort_order'][$k]) : 100,
                            'status'          => 1,
                            'lang'            => $this->admin_lang,
                            'add_time'        => getTime(),
                            'update_time'     => getTime(),
                        );
                    }

                    if (!empty($saveAttrData)) {
                        $rdata = model('ShopProductAttribute')->saveAll($saveAttrData);
                        if ($rdata !== false) {
                            // 参数值合计增加
                            Db::name('shop_product_attrlist')->where('list_id', $ReturnId)->setInc('attr_count', count($post['attr_name']));
                            /*多语言*/
                            if (is_language()) {
                                foreach ($rdata as $k1 => $v1) {
                                    $attr_data = $v1->getData();
                                    // 同步多语言
                                    $this->syn_add_language_attribute($attr_data['attr_id']);
                                }
                            }
                            /*end*/
                        }
                    }
                }
                $this->success('操作成功', url('ShopProduct/attrlist_index'));
            }
            $this->error('操作失败');
        }
        return $this->fetch();
    }

    /**
     * 编辑参数
     * @return [type] [description]
     */
    public function attrlist_edit()
    {
        if (IS_AJAX_POST) {
            $post              = input('post.');
            $post['list_id'] = intval($post['list_id']);
            $post['list_name'] = trim($post['list_name']);
            if (empty($post['list_name'])) {
                $this->error('参数名称不能为空！');
            }

            $SaveData = [
                'list_name'   => $post['list_name'],
                'desc'        => trim($post['desc']),
                'update_time' => getTime(),
            ];

            $res = Db::name('shop_product_attrlist')->where('list_id', $post['list_id'])->update($SaveData);
            if ($res) {
                adminLog('编辑商品参数：' . $post['list_name']);
                if (!empty($post['attr_name'])) {
                    //数据拼接
                    $saveAttrData = [];
                    $attr_ids     = [];
                    $time = getTime();

                    foreach ($post['attr_name'] as $k => $v) {
                        $attr_values           = str_replace('_', '', $v); // 替换特殊字符
                        $attr_values           = str_replace('@', '', $attr_values); // 替换特殊字符
                        $post['attr_name'][$k] = trim($attr_values);

                        $attrData = array(
                            'attr_name'       => !empty($post['attr_name'][$k]) ? $post['attr_name'][$k] : '',
                            'list_id'         => !empty($post['list_id']) ? intval($post['list_id']) : 0,
                            'attr_input_type' => !empty($post['attr_input_type'][$k]) ? intval($post['attr_input_type'][$k]) : 0,
                            'attr_values'     => !empty($post['attr_values'][$k]) ? trim($post['attr_values'][$k]) : '',
                            'sort_order'      => isset($post['attr_sort_order'][$k]) ? intval($post['attr_sort_order'][$k]) : 100,
                            'update_time'     => $time,
                        );
                        if (!empty($post['attr_id'][$k])) {
                            $attrData['attr_id'] = $post['attr_id'][$k];
                            $attrData['add_time'] = $time;
                            $attr_ids[]          = $post['attr_id'][$k];
                        }
                        $saveAttrData[] = $attrData;
                    }

                    if (!empty($saveAttrData)) {
                        $RId = model('ShopProductAttribute')->saveAll($saveAttrData);
                        if ($RId !== false) {
                            //删除多余的参数
                            Db::name('shop_product_attribute')
                                ->where([
                                    'list_id'   => $post['list_id'],
                                    'attr_id'   => ['NOTIN', $attr_ids],
                                    'update_time'=> ['NEQ', $time],
                                ])
                                ->delete();
                            // 参数值合计增加
                            Db::name('shop_product_attrlist')->where('list_id', $post['list_id'])->update(['attr_count' => count($saveAttrData), 'update_time' => getTime()]);
                        } else {
                            $this->error('操作失败');
                        }
                    }
                }else{
                    //删除多余的参数
                    Db::name('shop_product_attribute')
                        ->where('list_id', $post['list_id'])
                        ->delete();
                    // 参数值合计增加
                    Db::name('shop_product_attrlist')->where('list_id', $post['list_id'])->update(['attr_count' => 0, 'update_time' => getTime()]);
                }
                $this->success('操作成功', url('ShopProduct/attrlist_index'));
            }
            $this->error('操作失败');
        }
        
        $list_id = input('param.list_id');
        $list    = Db::name('shop_product_attrlist')->where('list_id', $list_id)->find();
        if (empty($list)) $this->error('数据不存在，请联系管理员！');
        $list['attr'] = Db::name('shop_product_attribute')->where('list_id', $list_id)->order('sort_order asc, attr_id asc')->select();

        $this->assign('list', $list);
        return $this->fetch();
    }

    // 参数删除
    public function attrlist_del()
    {
        $id_arr = input('del_id/a');
        $id_arr = eyIntval($id_arr);
        if (!empty($id_arr)) {
            $Result = $this->shop_product_attrlist_db->where('list_id', 'IN', $id_arr)->delete();
            if ($Result) {
                Db::name('shop_product_attribute')->where('list_id', 'IN', $id_arr)->delete();
                adminLog('删除商品参数-id：' . implode(',', $id_arr));
                $this->success('删除成功');
            } else {
                $this->error('删除失败');
            }
        } else {
            $this->error('参数有误');
        }
    }

    /**
     * 商品参数值列表
     */
    public function attribute_index()
    {
        $condition = array();
        // 获取到所有GET参数
        $get     = input('get.');
        $list_id = input('list_id/d', 0);

        // 应用搜索条件
        foreach (['keywords', 'list_id'] as $key) {
            if (isset($get[$key]) && $get[$key] !== '') {
                if ($key == 'keywords') {
                    $condition['a.attr_name'] = ['LIKE', "%{$get[$key]}%"];
                } else if ($key == 'list_id') {
                    $condition['a.list_id'] = $list_id;
                } else {
                    $condition['a.' . $key] = ['eq', $get[$key]];
                }
            }
        }
        $condition['a.lang'] = $this->admin_lang;
        $condition['a.is_del'] = 0;

        // 分页
        $count   = Db::name('shop_product_attribute')->alias('a')->where($condition)->count();
        $pageObj = new Page($count, config('paginate.list_rows'));
        $pageStr = $pageObj->show();
        $this->assign('pager', $pageObj);
        $this->assign('page', $pageStr);

        // 数据
        $list = Db::name('shop_product_attribute')
            ->alias('a')
            ->where($condition)
            ->order('a.sort_order asc, a.attr_id asc')
            ->limit($pageObj->firstRow . ',' . $pageObj->listRows)
            ->select();

        $attrInputTypeArr = [
            0 => '手工录入',
            1 => '选取默认值'
        ];
        $this->assign('attrInputTypeArr', $attrInputTypeArr);
        $this->assign('list', $list);
        return $this->fetch();
    }


    /**
     * 新增商品参数
     */
    public function attribute_add()
    {
        //防止php超时
        function_exists('set_time_limit') && set_time_limit(0);

        if (IS_AJAX_POST) {
            $attr_values              = str_replace('_', '', input('attr_values')); // 替换特殊字符
            $attr_values              = str_replace('@', '', $attr_values); // 替换特殊字符
            $attr_values              = trim($attr_values);
            $post_data                = input('post.');
            $post_data['list_id'] = intval($post_data['list_id']);
            $post_data['attr_values'] = $attr_values;

            $SaveData = array(
                'attr_name'       => $post_data['attr_name'],
                'list_id'         => $post_data['list_id'],
                'attr_input_type' => isset($post_data['attr_input_type']) ? $post_data['attr_input_type'] : '',
                'attr_values'     => isset($post_data['attr_values']) ? $post_data['attr_values'] : '',
                'sort_order'      => $post_data['sort_order'],
                'status'          => 1,
                'lang'            => $this->admin_lang,
                'add_time'        => getTime(),
                'update_time'     => getTime(),
            );

            $ReturnId = Db::name('shop_product_attribute')->add($SaveData);
            if ($ReturnId) {
                // 参数值合计增加
                Db::name('shop_product_attrlist')->where('list_id', $post_data['list_id'])->setInc('attr_count');
                adminLog('新增商品参数：' . $SaveData['attr_name']);
                $this->success('操作成功');
            } else {
                $this->error('操作失败');
            }
        }

        $list_id = input('param.list_id/d', 0);
        $list    = $this->shop_product_attrlist_db->where('list_id', $list_id)->find();
        $this->assign('list', $list);
        return $this->fetch();
    }

    /**
     * 编辑商品参数
     */
    public function attribute_edit()
    {
        //防止php超时
        function_exists('set_time_limit') && set_time_limit(0);

        if (IS_AJAX_POST) {
            $attr_values              = str_replace('_', '', input('attr_values')); // 替换特殊字符
            $attr_values              = str_replace('@', '', $attr_values); // 替换特殊字符
            $attr_values              = trim($attr_values);
            $post_data                = input('post.');
            $post_data['list_id'] = intval($post_data['list_id']);
            $post_data['attr_values'] = $attr_values;

            $SaveData = array(
                'attr_name'       => $post_data['attr_name'],
                'list_id'         => $post_data['list_id'],
                'attr_input_type' => isset($post_data['attr_input_type']) ? $post_data['attr_input_type'] : '',
                'attr_values'     => isset($post_data['attr_values']) ? $post_data['attr_values'] : '',
                'sort_order'      => $post_data['sort_order'],
                'update_time'     => getTime(),
            );

            $ReturnId = Db::name('shop_product_attribute')->where(['attr_id'=>$post_data['attr_id'], 'lang'=>$this->admin_lang])->update($SaveData);
            if ($ReturnId) {
                adminLog('编辑商品参数：' . $SaveData['attr_name']);
                $this->success('操作成功');
            } else {
                $this->error('操作失败');
            }
        }

        $id = input('param.id/d');
        $info = Db::name('shop_product_attribute')->where(['attr_id'=>$id, 'lang'=>$this->admin_lang])->find();
        if (empty($info)) $this->error('数据不存在，请联系管理员！');
        $this->assign('field', $info);

        $list = $this->shop_product_attrlist_db->where('list_id', $info['list_id'])->find();
        $this->assign('list', $list);
        return $this->fetch();
    }

    /**
     * 删除商品参数
     */
    public function attribute_del()
    {
        $id_arr = input('del_id/a');
        $id_arr = eyIntval($id_arr);
        if (!empty($id_arr)) {
            $r = Db::name('shop_product_attribute')->where(['attr_id' => ['IN', $id_arr], 'lang'=>$this->admin_lang])->delete();
            if ($r) {
                $IDCount = count($id_arr);
                Db::name('shop_product_attrlist')->where('list_id', input('list_id/d'))->setDec('attr_count', $IDCount);
                adminLog('删除商品参数-id：' . implode(',', $id_arr));
                $this->success('删除成功');
            } else {
                $this->error('删除失败');
            }
        } else {
            $this->error('参数有误');
        }
    }

    /**
     * 动态获取商品参数输入框 根据不同的数据返回不同的输入框类型
     */
    public function ajax_get_shop_attr_input($typeid = '', $aid = '', $list_id = '')
    {
        $typeid       = intval($typeid);
        $aid          = intval($aid);
        $list_id      = intval($list_id);
        $productLogic = new ProductLogic();
        $str          = $productLogic->getShopAttrInput($aid, $typeid, $list_id);
        if (empty($str)) {
            $str = '<div style="font-size: 12px;text-align: center;">提示：该参数还没有参数值，若有需要请点击【<a href="' . url('Product/attribute_index', array('list_id' => $list_id)) . '">商品参数</a>】进行更多操作。</div>';
        }
        if (IS_AJAX) {
            exit($str);
        } else {
            return $str;
        }
    }

    /**
     * 动态获取商品参数输入框 根据不同的数据返回不同的输入框类型
     */
    public function ajax_get_attr_input($typeid = '', $aid = '', $list_id = '')
    {
        $typeid       = intval($typeid);
        $aid          = intval($aid);
        $list_id      = intval($list_id);
        $productLogic = new ProductLogic();
        $str          = $productLogic->getAttrInput($aid, $typeid, $list_id);
        if (empty($str)) {
            $str = '<div style="font-size: 12px;text-align: center;">提示：该参数还没有参数值，若有需要请点击【<a href="' . url('Product/attribute_index', array('list_id' => $list_id)) . '">商品参数</a>】进行更多操作。</div>';
        }
        if (IS_AJAX) {
            exit($str);
        } else {
            return $str;
        }
    }

    /**
     * 发布商品
     */
    public function release()
    {
        $typeid = input('param.typeid/d', 0);
        if (0 < $typeid) {
            $param = input('param.');
            $row   = Db::name('arctype')->field('current_channel')->find($typeid);
            /*针对不支持发布文档的模型*/
            if ($row['current_channel'] != 2) {
                $this->error('该栏目不支持发布商品！', url('ShopProduct/release'));
            }
            /*-----end*/

            $data = [
                'typeid' => $typeid,
                'callback_url' => $this->callback_url,
            ];
            $jumpUrl = url("ShopProduct/add", $data, true, true);
            header('Location: ' . $jumpUrl);
            exit;
        }

        /*允许发布文档列表的栏目*/
        $select_html = allow_release_arctype(0, [2]);
        $this->assign('select_html', $select_html);
        /*--end*/

        return $this->fetch();
    }
    //帮助
    public function help()
    {
        $system_originlist = tpSetting('system.system_originlist');
        $system_originlist = json_decode($system_originlist, true);
        $system_originlist = !empty($system_originlist) ? $system_originlist : [];
        $assign_data['system_originlist_str'] = implode(PHP_EOL, $system_originlist);
        $this->assign($assign_data);
    
        return $this->fetch();
    }
    
    // 商品服务
    public function goods_label()
    {
        // 商品服务标签列表
        $goodsLabel = Db::name('shop_goods_label')->select();
        foreach ($goodsLabel as $key => $value) {
            $value['label_pic'] = handle_subdir_pic($value['label_pic']);
            $goodsLabel[$key] = $value;
        }
        $this->assign('goodsLabel', $goodsLabel);

        // 最大商品服务标签ID
        $this->assign('maxGoodsLabelID', Db::name('shop_goods_label')->max('label_id'));

        // 商品aid
        $this->assign('aid', input('param.aid/d', 0));

        return $this->fetch();
    }

    // 商品服务删除
    public function goods_label_del()
    {
        if (IS_AJAX_POST) {
            $this->error('删除功能暂停使用');
            // $labelID = input('post.labelID/d', 0);
            // $result = Db::name('shop_goods_label')->where('label_id', $labelID)->delete(true);
            // if (!empty($result)) $this->success('删除成功');
            // $this->error('删除失败');
        }
    }

    // 商品服务保存更新
    public function goods_label_save()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            $saveAll = [];
            $labelIds = [];
            foreach ($post['label_id'] as $key => $value) {
                $labelPic = !empty($post['label_pic'][$key]) ? $post['label_pic'][$key] : '';
                $labelMark = !empty($post['label_mark'][$key]) ? $post['label_mark'][$key] : 0;
                $labelTitle = !empty($post['label_title'][$key]) ? $post['label_title'][$key] : '';
                $labelIntro = !empty($post['label_intro'][$key]) ? $post['label_intro'][$key] : '';
                // 检测数据是否填写完整
                if (!empty($labelTitle)) {
                    if (empty($labelPic)) $this->error('请上传商品服务的图片', null, ['id' => '#labelClick_' . $labelMark]);
                    if (empty($labelIntro)) $this->error('请填写商品服务的描述', null, ['id' => '#labelIntro_' . $labelMark]);
                }
                else if (!empty($labelPic)) {
                    if (empty($labelTitle)) $this->error('请填写商品服务的标题', null, ['id' => '#labelTitle_' . $labelMark]);
                    if (empty($labelIntro)) $this->error('请填写商品服务的描述', null, ['id' => '#labelIntro_' . $labelMark]);
                }
                else if (!empty($labelIntro)) {
                    if (empty($labelTitle)) $this->error('请填写商品服务的标题', null, ['id' => '#labelTitle_' . $labelMark]);
                    if (empty($labelPic)) $this->error('请上传商品服务的图片', null, ['id' => '#labelClick_' . $labelMark]);
                }
                if (!empty($labelPic) || !empty($labelTitle) || !empty($labelIntro)) {
                    $saveAll[$key] = [
                        'label_title' => trim($labelTitle),
                        'label_pic' => trim($labelPic),
                        'label_intro' => trim($labelIntro),
                        'add_time' => getTime(),
                        'update_time' => getTime(),
                    ];
                }
                if (!empty($value)) {
                    array_push($labelIds, $value);
                    unset($saveAll[$key]['add_time']);
                    $saveAll[$key] = array_merge(['label_id' => intval($value)], $saveAll[$key]);
                }
            }

            // 商品标签删除处理
            if (!empty($labelIds)) {
                // 删除需要删除的ID
                $labelIds = Db::name('shop_goods_label')->where(['label_id' => ['NOT IN', $labelIds]])->column('label_id');
                if (!empty($labelIds)) {
                    // 删除指定ID的商品标签
                    $where = [
                        'label_id' => ['IN', $labelIds]
                    ];
                    $result = Db::name('shop_goods_label')->where($where)->delete(true);
                    // 删除指定ID的商品标签绑定信息
                    if (!empty($result)) Db::name('shop_goods_label_bind')->where($where)->delete(true);
                }
            }

            // 商品服务保存更新
            if (!empty($saveAll)) {
                // 商品服务保存更新
                model('ShopGoodsLabel')->saveAll($saveAll);
                // 查询商品服务列表
                $data['goodsLabel'] = !empty($post['aid']) ? model('ShopGoodsLabel')->getGoodsLabelList($post['aid']) : [];
                $this->success('更新成功', null, $data);
            } else {
                $this->error('更新失败');
            }
        }
    }

    /**
     * 同步新增新产品参数分组ID到多语言的模板变量里
     */
    private function syn_add_language_attrlist($list_id)
    {
        /*单语言情况下不执行多语言代码*/
        if (!is_language() || tpCache('language.language_split')) {
            return true;
        }
        /*--end*/

        $attr_group = 'shop_product_attrlist';
        $admin_lang = $this->admin_lang;
        $main_lang = $this->main_lang;
        $languageRow = Db::name('language')->field('mark')->order('id asc')->select();
        if (!empty($languageRow) && $admin_lang == $main_lang) { // 当前语言是主体语言，即语言列表最早新增的语言
            $attrlist_db = Db::name('shop_product_attrlist');
            $result = $attrlist_db->find($list_id);
            $attr_name = 'attrlist_'.$list_id;
            $r = Db::name('language_attribute')->save([
                'attr_title'    => $result['list_name'],
                'attr_name'     => $attr_name,
                'attr_group'    => $attr_group,
                'add_time'      => getTime(),
                'update_time'   => getTime(),
            ]);
            if (false !== $r) {
                $data = [];
                foreach ($languageRow as $key => $val) {
                    /*同步新产品参数分组到其他语言新产品参数分组列表*/
                    if ($val['mark'] != $admin_lang) {
                        $addsaveData = $result;
                        $addsaveData['lang']  = $val['mark'];
                        // $addsaveData['list_name'] = $val['mark'].$addsaveData['list_name']; // 临时测试
                        unset($addsaveData['list_id']);
                        $list_id = $attrlist_db->insertGetId($addsaveData);
                    }
                    /*--end*/
                    
                    /*所有语言绑定在主语言的ID容器里*/
                    $data[] = [
                        'attr_name' => $attr_name,
                        'attr_value'    => $list_id,
                        'lang'  => $val['mark'],
                        'attr_group'    => $attr_group,
                        'add_time'      => getTime(),
                        'update_time'   => getTime(),
                    ];
                    /*--end*/
                }
                if (!empty($data)) {
                    model('LanguageAttr')->saveAll($data);
                }
            }
        }
    }

    /**
     * 同步新增产品参数值ID到多语言的模板变量里
     */
    private function syn_add_language_attribute($attr_id)
    {
        /*单语言情况下不执行多语言代码*/
        if (!is_language() || tpCache('language.language_split')) {
            return true;
        }
        /*--end*/

        $attr_group = 'shop_product_attribute';
        $admin_lang = $this->admin_lang;
        $main_lang = $this->main_lang;
        $languageRow = Db::name('language')->field('mark')->order('id asc')->select();
        if (!empty($languageRow) && $admin_lang == $main_lang) { // 当前语言是主体语言，即语言列表最早新增的语言
            $attribute_db = Db::name('shop_product_attribute');
            $result = $attribute_db->find($attr_id);
            $attr_name = 'attribute_'.$attr_id;
            $r = Db::name('language_attribute')->save([
                'attr_title'    => $result['attr_name'],
                'attr_name'     => $attr_name,
                'attr_group'    => $attr_group,
                'add_time'      => getTime(),
                'update_time'   => getTime(),
            ]);
            if (false !== $r) {
                $data = [];
                foreach ($languageRow as $key => $val) {
                    /*同步新产品参数值到其他语言产品参数值列表*/
                    if ($val['mark'] != $admin_lang) {
                        $addsaveData = $result;
                        $addsaveData['lang'] = $val['mark'];
                        $new_list_id = Db::name('language_attr')->where([
                                'attr_name' => 'attrlist_'.$result['list_id'],
                                'attr_group'    => 'shop_product_attrlist',
                                'lang'  => $val['mark'],
                            ])->getField('attr_value');
                        $addsaveData['list_id']   = $new_list_id;
                        // $addsaveData['attr_name'] = $val['mark'].$addsaveData['attr_name']; // 临时测试
                        unset($addsaveData['attr_id']);
                        $attr_id = $attribute_db->insertGetId($addsaveData);
                    }
                    /*--end*/
                    
                    /*所有语言绑定在主语言的ID容器里*/
                    $data[] = [
                        'attr_name'   => $attr_name,
                        'attr_value'  => $attr_id,
                        'lang'        => $val['mark'],
                        'attr_group'  => $attr_group,
                        'add_time'    => getTime(),
                        'update_time' => getTime(),
                    ];
                    /*--end*/
                }
                if (!empty($data)) {
                    model('LanguageAttr')->saveAll($data);
                }
            }
        }
    }
    
    // 商品分类列表
    public function arctype_index()
    {
        $arctype_list = array();
        // 目录列表
        $where = [
            'lang' => $this->admin_lang,
            'is_del' => 0,
            'current_channel' => 2,
        ];
        $arctype_list = $this->arctypeLogic->arctype_list(0, 0, false, 0, $where, false);
        $this->assign('arctype_list', $arctype_list);

        // 模型列表
        $channeltype_list = getChanneltypeList();
        $this->assign('channeltype_list', $channeltype_list);

        // 栏目最多级别
        $arctype_max_level = intval(config('global.arctype_max_level'));
        $this->assign('arctype_max_level', $arctype_max_level);

        $parent_ids = Db::name('arctype')->where([
                'parent_id' => ['gt', 0],
                'is_del'    => 0,
            ])->group('parent_id')->cache(true, EYOUCMS_CACHE_TIME, 'arctype')->column('parent_id');
        $cookied_treeclicked =  json_decode(cookie('admin-treeClicked-Arr'));
        empty($cookied_treeclicked) && $cookied_treeclicked = [];
        $all_treeclicked = cookie('admin-treeClicked_All');
        empty($all_treeclicked) && $all_treeclicked = [];
        $tree = [
            'has_children'=>!empty($parent_ids) ? 1 : 0,
            'parent_ids'=>json_encode($parent_ids),
            'all_treeclicked'=>$all_treeclicked,
            'cookied_treeclicked'=>$cookied_treeclicked,
            'cookied_treeclicked_arr'=>json_encode($cookied_treeclicked),
        ];
        $this->assign('tree', $tree);

        return $this->fetch();
    }
}