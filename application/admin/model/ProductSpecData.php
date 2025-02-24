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
use app\admin\logic\ProductSpecLogic; // 用于产品规格逻辑功能处理

/**
 * 产品规格预设模型
 */
load_trait('controller/Jump');
class ProductSpecData extends Model
{
    use \traits\controller\Jump;
    
    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        $this->times = getTime();
        $this->admin_lang = get_admin_lang();
        $this->show_lang = input('showlang/s', $this->admin_lang);
        $this->isSameLang = trim($this->admin_lang) === trim($this->show_lang) ? 1 : 0;
        $this->inputStyle = empty($this->isSameLang) ? 'disabled style="background-color: #f4f6f8;"' : '';
    }

    public function PresetSpecAddData($Data = array())
    {
        if (!empty($Data['aid'])) {
            // 查询规格库规格信息
            $where = [
                'lang' => get_admin_lang(),
                'preset_mark_id' => ['IN', $Data['spec_mark_id']],
            ];
            $PresetData = Db::name('product_spec_preset')->where($where)->order('preset_mark_id desc')->select();

            // 查询商品规格库是否存在选中的规格，不存在则执行添加
            $Where = [
                'aid' => $Data['aid'],
                'lang' => $this->admin_lang,
                'spec_mark_id' => $Data['spec_mark_id'],
            ];
            $count = Db::name('product_spec_data_handle')->where($Where)->count();
            if (empty($count)) {
                $insertAll = [];
                $spec_id = date('is');
                foreach ($PresetData as $key => $value) {
                    $spec_id++;
                    $insertAll[] = [
                        'spec_id'        => $spec_id,
                        'aid'            => $Data['aid'],
                        'spec_mark_id'   => $value['preset_mark_id'],
                        'spec_name'      => $value['preset_name'],
                        'spec_value_id'  => $value['preset_id'],
                        'spec_value'     => $value['preset_value'],
                        'spec_is_select' => 0,
                        'lang'           => $this->admin_lang,
                        'add_time'       => getTime(),
                        'update_time'    => getTime(),
                    ];
                }
            }
            if (!empty($insertAll)) Db::name('product_spec_data_handle')->insertAll($insertAll);
        }
    }

    public function ProducSpecNameEditSave($post = [], $action = 'edit')
    {
        if (!empty($post['aid']) && !empty($post['spec_value_id']) && !empty($post['spec_mark_id'])) {
            // 查询条件
            $where = [
                'aid' => $post['aid'],
            ];

            $handleAID = session('handleAID');
            if ('add' === strval($action) && !empty($handleAID)) $where['aid'] = $handleAID;

            // 查询规格数据
            $handle = Db::name('product_spec_data_handle')->where($where)->order('handle_id asc, auto_id asc')->select();

            // 编辑执行
            if ('edit' === strval($action)) {
                // 查询商品正式规格库数据
                $realSpecArr = Db::name('product_spec_data')->where(['aid' => $post['aid'], 'lang' => $this->show_lang])->getAllWithIndex('auto_id');
                $realAutoID = !empty($realSpecArr) ? get_arr_column($realSpecArr, 'auto_id') : [];

                // 对比提取已被删除的规格，存在已被删除数据则执行删除
                $handleAutoID = array_diff($realAutoID, !empty($handle) ? get_arr_column($handle, 'auto_id') : []);
                if (!empty($handleAutoID)) {
                    $deleteArr = [];
                    foreach ($handleAutoID as $value) {
                        if (!empty($realSpecArr[$value])) array_push($deleteArr, $realSpecArr[$value]);
                    }
                    if (!empty($deleteArr)) {
                        $where = [
                            'aid' => intval($post['aid']),
                            'spec_mark_id' => ['IN', array_unique(get_arr_column($deleteArr, 'spec_mark_id'))],
                            'spec_value_id' => ['IN', array_unique(get_arr_column($deleteArr, 'spec_value_id'))],
                        ];
                        Db::name('product_spec_data')->where($where)->delete(true);
                    }
                }

                // 处理商品规格
                $saveAll = $insertAll = [];
                foreach ($handle as $key => $value) {
                    if (in_array($value['auto_id'], $realAutoID)) {
                        $saveAll[] = [
                            'auto_id'       => $value['auto_id'],
                            'spec_id'       => $value['spec_id'],
                            'aid'           => $value['aid'],
                            'spec_mark_id'  => $value['spec_mark_id'],
                            'spec_name'     => $value['spec_name'],
                            'spec_value_id' => $value['spec_value_id'],
                            'spec_value'    => $value['spec_value'],
                            'open_image'    => $value['open_image'],
                            'spec_image'    => $value['spec_image'],
                            'lang'          => $value['lang'],
                            'update_time'   => $this->times,
                        ];
                    } else {
                        $insertAll[] = $value;
                    }
                }
                // 更新规格数据
                if (!empty($saveAll)) $this->saveAll($saveAll);
                // 新增规格数据
                if (!empty($insertAll)) $insertAll = $this->getProductSpecDataInsertAll($insertAll, $post['aid']);
                if (!empty($insertAll)) Db::name('product_spec_data')->insertAll($insertAll);
            }
            // 添加执行
            else {
                // 添加数组拼装
                $insertAll = $this->getProductSpecDataInsertAll($handle, $post['aid']);
                // 批量添加商品规格
                if (!empty($insertAll)) Db::name('product_spec_data')->insertAll($insertAll);
            }

            // 删除产品规格数据处理表
            Db::name("product_spec_data_handle")->where($where)->delete(true);
        }
    }

    public function getProductSpecDataInsertAll($data = [], $aid = 0)
    {
        if (empty($data)) return [];

        // 添加数组拼装
        $insertAll = [];
        // 查询最大的 spec_id
        $nextID = create_next_id('product_spec_data', 'spec_id');
        // 查询语言列表
        $langList = Db::name('language')->where(['status' => 1])->column('mark');
        foreach ($data as $key => $value) {
            $insert = [
                'spec_id'       => intval($nextID),
                'aid'           => intval($aid),
                'spec_mark_id'  => $value['spec_mark_id'],
                'spec_value_id' => $value['spec_value_id'],
                'spec_name'     => $value['spec_name'],
                'spec_value'    => $value['spec_value'],
                'open_image'    => $value['open_image'],
                'spec_image'    => $value['spec_image'],
                'add_time'      => $this->times,
                'update_time'   => $this->times,
                'spec_is_select'=> $value['spec_is_select'],
            ];
            if (!empty($langList)) {
                foreach ($langList as $lang) {
                    if (!empty($lang)) {
                        $insert['lang'] = $lang;
                        $insertAll[] = $insert;
                    }
                }
            } else {
                $insertAll[] = $insert;
            }
            $nextID++;
        }

        return $insertAll;
    }

    // 编辑产品时，规格原数据处理
    public function GetProductSpecData($id = 0)
    {
        $assign_data = ['spec_mark_id_arr' => 0];
        // 商城配置
        $shopConfig = getUsersConfigData('shop');
        $assign_data['shopConfig'] = $shopConfig;

        // 已选规格处理
        if (!empty($shopConfig['shop_open']) && isset($shopConfig['shop_open_spec']) && 1 === intval($shopConfig['shop_open_spec'])) {
            // 删除商品规格处理表的规格数据
            Db::name('product_spec_data_handle')->where(['aid' => $id])->delete(true);
            Db::name('product_spec_value_handle')->where(['aid' => $id])->delete(true);

            // 查询规格名称、值数据并处理
            $order = 'spec_value_id asc, auto_id asc';
            $product_spec_data = Db::name('product_spec_data')->where(['aid' => $id, 'lang' => $this->show_lang])->order($order)->select();
            if (!empty($product_spec_data)) {
                foreach ($product_spec_data as $key => $value) {
                    $value['add_time'] = $value['update_time'] = getTime();
                    $product_spec_data[$key] = $value;
                }
            }
            // dump($product_spec_data);

            // 查询规格价格数据并处理
            $product_spec_value = Db::name('product_spec_value')->where(['aid' => $id])->order($order)->select();
            if (!empty($product_spec_value)) {
                foreach ($product_spec_value as $key => $value) {
                    $value['add_time'] = $value['update_time'] = getTime();
                    $product_spec_value[$key] = $value;
                }
            }
            // dump($product_spec_value);
            // exit;

            // 参数预定义
            $assign_data['useSpecNum'] = 0;
            $assign_data['SpecSelectName'] = $assign_data['HtmlTable'] = $assign_data['spec_mark_id_arr'] = '';
            if (!empty($product_spec_data)) {
                // 添加商品规格处理表的规格信息
                $resultID1 = Db::name('product_spec_data_handle')->insertAll($product_spec_data);
                $resultID2 = Db::name('product_spec_value_handle')->insertAll($product_spec_value);
                if (empty($resultID1) || empty($resultID2)) $this->error('信息错误，请重新进入');
                // 查询规格库现有规格preset_mark_id
                $preset_mark_ids = Db::name('product_spec_preset')->column('preset_mark_id');
                $preset_mark_ids = array_unique($preset_mark_ids);
                $ProductSpecLogic = new ProductSpecLogic;
                $spec_arr_new = group_same_key($product_spec_data, 'spec_mark_id');
                $spec_mark_id_arr = [];
                $index = 0;
                foreach ($spec_arr_new as $key => $value) {
                    // dump($key);
                    $assign_data['useSpecNum']++;
                    // 规格库规格显示处理
                    if (in_array($key, $preset_mark_ids)) {
                        $spec_mark_id_arr[] = $key;
                        $SpecSelectName[$key]  = '<div class="prset-box" id="spec_'.$key.'">';
                        $SpecSelectName[$key] .= '<div id="div_'.$key.'">';
                        $SpecSelectName[$key] .= '<div><span class="mr10 specNameSpan" style="display: flex;align-items: baseline;"><span class="preset-bt w150 mr10 "><span class="spec_name_span_'.$key.'">'.$value[0]['spec_name'].'</span><em data-name="'.$value[0]['spec_name'].'" data-mark_id="'.$key.'" onclick="clearPresetSpec(this, '.$key.')"><i class="fa fa-times-circle" title="关闭"></i></em></span>';

                        $none0 = /*0 === intval($index) && */!empty($value[0]["open_image"]) ? '' : 'style="display: none;"';
                        $checked = !empty($value[0]['open_image']) ? 'checked' : '';
//                         $SpecSelectName[$key] .= <<<EOF
// <label {$none0}><input type="checkbox" onclick="openGoodsSpecImage(this);" value="{$key}" {$checked}>添加图片</label>
// EOF;
                        $SpecSelectName[$key] .= '</span>';
                        $SpecSelectName[$key] .= '<span class="set-preset-box"></span>';

                        $SpecSelectName[$key] .= '<span class="set-preset-con"> <span class="d-flex" id="SelectEd_'.$key.'">';
                        $openImage = !empty($value[0]['open_image']) ? 'style="display: block;"' : 'style="display: none;"';
                        for ($i = 0; $i < count($value); $i++) {
                            if (!empty($value[$i]['spec_is_select'])) {
                                $spec_arr_new[$key][$i] = $value[$i]['spec_value_id'];
                                $SpecSelectName[$key] .= '<span class="d-flex mr10" id="preset-bt2_'.$value[$i]['spec_id'].'">';

                                $show0 = !empty($value[$i]["spec_image"]) ? '' : 'style="display: none;"';
                                $none1 = !empty($value[$i]["spec_image"]) ? 'style="display: none;"' : '';
                                $SpecSelectName[$key] .= <<<EOF
<div class='spec-dan-pane openGoodsSpecImage_{$key}' {$openImage}>
    <div class='images_upload'>
        <a href="javascript:void(0);" onclick="goodsSpecImageAdd({$value[$i]["spec_mark_id"]}, {$value[$i]["spec_value_id"]});" class="img-upload" title="上传图片" style="width: 30px; height: 30px;">
            <div class="y-line spec_image_y_line_{$value[$i]["spec_value_id"]}" {$none1}></div>
            <div class="x-line spec_image_x_line_{$value[$i]["spec_value_id"]}" {$none1}></div>
            <img src="{$value[$i]["spec_image"]}" class="pic_con spec_image_src_{$value[$i]["spec_value_id"]}" {$show0}>
        </a>
    </div>
</div>
EOF;
                                $SpecSelectName[$key] .= '<span class="preset-bt2"><span class="spec_value_span_'.$value[$i]['spec_value_id'].'">'.$value[$i]['spec_value'].'</span><em data-value="'.$value[$i]['spec_value'].'" data-spec_mark_id="'.$value[$i]['spec_mark_id'].'" data-spec_value_id="'.$value[$i]['spec_value_id'].'" onclick="clearPresetSpecValue(this)"><i class="fa fa-times-circle" title="关闭"></i></em> &nbsp; </span></span>';
                            } else {
                                unset($spec_arr_new[$key][$i]);
                            }
                        }

                        $SpecSelectName[$key] .= '</span>';
                        $SpecSelectName[$key] .= '<select class="preset-select" name="spec_value" id="spec_value_'.$key.'" onchange="addPresetSpecValue(this,'.$key.')">';
                        $SpecSelectName[$key] .= $ProductSpecLogic->GetPresetValueOption('', $key, $id, 1);
                        $SpecSelectName[$key] .= '</select>';
                        $SpecSelectName[$key] .= '<span class="tongbu" title="同步规格数据" data-mark_id="'.$key.'" data-name="'.$value[0]['spec_name'].'" onclick="RefreshSpecValue(this);"><i class="fa fa-refresh"></i></span>';
                        $SpecSelectName[$key] .= ' </span></div></div></div>';

                        $index++;
                    }
                    // 自定义规格显示处理
                    else {
                        $SpecSelectName[$key]  = '<div class="prset-box">';
                        $SpecSelectName[$key] .= '<span class="set-preset-bt mr10 specNameSpan" style="display: block;">';
                        $SpecSelectName[$key] .= '<input type="text" name="set_spec_name" class="zdy-ggname w150" value="' . $value[0]['spec_name'] . '" placeholder="规格名称.." onchange="setSpecName(this, ' . $key . ');">';
                        if (!empty($this->isSameLang)) {
                            $SpecSelectName[$key] .= '<em onclick="setSpecNameClear(this, ' . $key . ');"> <i class="fa fa-times-circle" title="关闭" style="margin-left: -20px; margin-top: 8px;"></i> </em>';

                            $none0 = 0 === intval($index) ? '' : 'style="display: none;"';
                            $checked = !empty($value[0]['open_image']) ? 'checked' : '';
//                             $SpecSelectName[$key] .= <<<EOF
// <label {$none0}><input type="checkbox" onclick="openGoodsSpecImage(this);" value="{$key}" {$checked}>添加图片</label>
// EOF;
                        }
                        $SpecSelectName[$key] .= '</span>';
                        $SpecSelectName[$key] .= '<span class="set-preset-box"></span>';
                        $SpecSelectName[$key] .= '<span class="set-preset-con">';
                        $openImage = !empty($value[0]['open_image']) ? 'style="display: block;"' : 'style="display: none;"';
                        for ($i = 0; $i < count($value); $i++) {
                            $spec_arr_new[$key][$i] = $value[$i]['spec_value_id'];
                            $SpecSelectName[$key] .= '<span class="set-preset-bt mr10 ">';
                            
                            $show0 = !empty($value[$i]["spec_image"]) ? '' : 'style="display: none;"';
                            $none1 = !empty($value[$i]["spec_image"]) ? 'style="display: none;"' : '';
                            $SpecSelectName[$key] .= <<<EOF
<div class='spec-dan-pane openGoodsSpecImage_{$key}' {$openImage}>
    <div class='images_upload'>
        <a href="javascript:void(0);" onclick="goodsSpecImageAdd({$value[$i]["spec_mark_id"]}, {$value[$i]["spec_value_id"]});" class="img-upload" title="上传图片" style="width: 30px; height: 30px;">
            <div class="y-line spec_image_y_line_{$value[$i]["spec_value_id"]}" {$none1}></div>
            <div class="x-line spec_image_x_line_{$value[$i]["spec_value_id"]}" {$none1}></div>
            <img src="{$value[$i]["spec_image"]}" class="pic_con spec_image_src_{$value[$i]["spec_value_id"]}" {$show0}>
        </a>
    </div>
</div>
EOF;
                            $SpecSelectName[$key] .= '<input type="hidden" value="' . $value[$i]['spec_value_id'] . '">';
                            $SpecSelectName[$key] .= '<input type="text" class="zdy-ggshuzi w150" value="' . $value[$i]['spec_value'] . '" placeholder="规格值.." onchange="setSpecValue(this, ' . $value[$i]['spec_mark_id'] . ');">';
                            if (0 !== intval($i) && !empty($this->isSameLang)) {
                                $SpecSelectName[$key] .= '<em data-spec_mark_id="' . $value[$i]['spec_mark_id'] . '" data-spec_value_id="' . $value[$i]['spec_value_id'] . '" onclick="setSpecValueClear(this);"><i class="fa fa-times-circle" title="关闭" style="margin-left: -22px; margin-top: 8px; cursor: pointer;"></i></em>';
                            }
                            $SpecSelectName[$key] .= '</span>';
                        }
                        if (!empty($this->isSameLang)) {
                            $SpecSelectName[$key] .= '<a href="javascript:void(0);" onclick="addCustomSpecValue(this, ' . $key . ');" class="preset-bt-shuzi mr10">+增加规格值</a>';
                        }
                        $SpecSelectName[$key] .= '</span>';
                        $SpecSelectName[$key] .= '</div>';

                        $index++;
                    }
                }

                // session('spec_arr', $spec_arr_new);
                $assign_data['SpecSelectName'] = $SpecSelectName;
                $assign_data['HtmlTable'] = $ProductSpecLogic->SpecAssemblyEdit($spec_arr_new, $id, false, $this->isSameLang, $this->inputStyle);
                $assign_data['spec_mark_id_arr'] = implode(',', $spec_mark_id_arr);
            }

            // 预设值名称
            // $where = ['lang' => $this->admin_lang];
            // if (!empty($spec_mark_id_arr)) $where['preset_mark_id'] = ['NOT IN',$spec_mark_id_arr];
            // $assign_data['preset_value'] = Db::name('product_spec_preset')->where($where)->field('preset_id,preset_mark_id,preset_name')->group('preset_mark_id')->order('preset_mark_id desc')->select();
            $assign_data['maxPresetMarkID'] = 1;//$assign_data['preset_value'][0]['preset_mark_id'];
        }
        return $assign_data;
    }

    /**
     * 2020/12/18 大黄 秒杀 编辑秒杀商品，规格原数据处理
     */
    public function GetSharpProductSpecData($id)
    {
        $assign_data = [];
        // 商城配置
        $shopConfig = getUsersConfigData('shop');
        $assign_data['shopConfig'] = $shopConfig;
        // 已选规格处理
        if (isset($shopConfig['shop_open_spec']) && 1 == $shopConfig['shop_open_spec']) {
            session('spec_arr',null);
            $SpecWhere = [
                'aid' => $id,
                'lang' => $this->admin_lang,
                'spec_is_select' => 1,// 已选中的
            ];
            $order = 'spec_value_id asc, spec_id asc';
            $product_spec_data = Db::name('product_spec_data')->where($SpecWhere)->order($order)->select();
            // 参数预定义
            $assign_data['SpecSelectName'] = $assign_data['HtmlTable'] = $assign_data['spec_mark_id_arr'] = '';
            if (!empty($product_spec_data)) {
                $ProductSpecLogic = new ProductSpecLogic;
                $spec_arr_new = group_same_key($product_spec_data, 'spec_mark_id');
                foreach ($spec_arr_new as $key => $value) {
                    $spec_mark_id_arr[] = $key;
                    $SpecSelectName[$key]  = '<div class="prset-box" id="spec_'.$key.'">';
                    $SpecSelectName[$key] .= '<div id="div_'.$key.'">';
                    $SpecSelectName[$key] .= '<div><span class="preset-bt"><span class="spec_name_span_'.$key.'">'.$value[0]['spec_name'].'</span><em data-name="'.$value[0]['spec_name'].'" data-mark_id="'.$key.'" onclick="DelDiv(this)"><i class="fa fa-times-circle" title="关闭"></i></em></span>';

                    $SpecSelectName[$key] .= '<span class="d-flex" id="SelectEd_'.$key.'">';
                    for ($i=0; $i<count($value); $i++) {
                        $spec_arr_new[$key][$i] = $value[$i]['spec_value_id'];
                        $SpecSelectName[$key] .= '<span class="preset-bt2" id="preset-bt2_'.$value[$i]['spec_id'].'"><span class="spec_value_span_'.$value[$i]['spec_value_id'].'">'.$value[$i]['spec_value'].'</span><em data-value="'.$value[$i]['spec_value'].'" data-mark_id="'.$value[$i]['spec_mark_id'].'" data-preset_id="'.$value[$i]['spec_value_id'].'" onclick="DelValue(this)"><i class="fa fa-times-circle" title="关闭"></i></em> &nbsp; </span>';
                    }

                    $SpecSelectName[$key] .= '</span>';
                    $SpecSelectName[$key] .= '<select class="preset-select" name="spec_value" id="spec_value_'.$key.'" onchange="AppEndPreset(this,'.$key.')">';
                    $SpecSelectName[$key] .= $ProductSpecLogic->GetPresetValueOption('', $key, $id, 1);
                    $SpecSelectName[$key] .= '</select><span class="tongbu" title="同步规格数据" data-mark_id="'.$key.'" data-name="'.$value[0]['spec_name'].'" onclick="RefreshSpecValue(this);"><i class="fa fa-refresh"></i></span>';
                    $SpecSelectName[$key] .= '</div></div></div>';
                }

                session('spec_arr',$spec_arr_new);
                $assign_data['SpecSelectName']   = $SpecSelectName;
                $assign_data['HtmlTable']        = $ProductSpecLogic->SharpSpecAssemblyEdit($spec_arr_new, $id);
                $assign_data['spec_mark_id_arr'] = implode(',', $spec_mark_id_arr);
            }

            // 预设值名称
            $where = ['lang' => $this->admin_lang];
            if (!empty($spec_mark_id_arr)) $where['preset_mark_id'] = ['NOT IN',$spec_mark_id_arr];
            $assign_data['preset_value'] = Db::name('product_spec_preset')->where($where)->field('preset_id,preset_mark_id,preset_name')->group('preset_mark_id')->order('preset_mark_id desc')->select();
        }

        return $assign_data;
    }
    /**
     * 2022/03/08 大黄 限时折扣 编辑限时折扣商品，规格原数据处理
     */
    public function GetDiscountProductSpecData($id)
    {
        $assign_data = [];
        // 商城配置
        $shopConfig = getUsersConfigData('shop');
        $assign_data['shopConfig'] = $shopConfig;
        // 已选规格处理
        if (isset($shopConfig['shop_open_spec']) && 1 == $shopConfig['shop_open_spec']) {
            session('spec_arr',null);
            $SpecWhere = [
                'aid' => $id,
                'lang' => $this->admin_lang,
                'spec_is_select' => 1,// 已选中的
            ];
            $order = 'spec_value_id asc, spec_id asc';
            $product_spec_data = Db::name('product_spec_data')->where($SpecWhere)->order($order)->select();
            // 参数预定义
            $assign_data['SpecSelectName'] = $assign_data['HtmlTable'] = $assign_data['spec_mark_id_arr'] = '';
            if (!empty($product_spec_data)) {
                $ProductSpecLogic = new ProductSpecLogic;
                $spec_arr_new = group_same_key($product_spec_data, 'spec_mark_id');
                foreach ($spec_arr_new as $key => $value) {
                    $spec_mark_id_arr[] = $key;
                    $SpecSelectName[$key]  = '<div class="prset-box" id="spec_'.$key.'">';
                    $SpecSelectName[$key] .= '<div id="div_'.$key.'">';
                    $SpecSelectName[$key] .= '<div><span class="preset-bt"><span class="spec_name_span_'.$key.'">'.$value[0]['spec_name'].'</span><em data-name="'.$value[0]['spec_name'].'" data-mark_id="'.$key.'" onclick="DelDiv(this)"><i class="fa fa-times-circle" title="关闭"></i></em></span>';

                    $SpecSelectName[$key] .= '<span class="d-flex" id="SelectEd_'.$key.'">';
                    for ($i=0; $i<count($value); $i++) {
                        $spec_arr_new[$key][$i] = $value[$i]['spec_value_id'];
                        $SpecSelectName[$key] .= '<span class="preset-bt2" id="preset-bt2_'.$value[$i]['spec_id'].'"><span class="spec_value_span_'.$value[$i]['spec_value_id'].'">'.$value[$i]['spec_value'].'</span><em data-value="'.$value[$i]['spec_value'].'" data-mark_id="'.$value[$i]['spec_mark_id'].'" data-preset_id="'.$value[$i]['spec_value_id'].'" onclick="DelValue(this)"><i class="fa fa-times-circle" title="关闭"></i></em> &nbsp; </span>';
                    }

                    $SpecSelectName[$key] .= '</span>';
                    $SpecSelectName[$key] .= '<select class="preset-select" name="spec_value" id="spec_value_'.$key.'" onchange="AppEndPreset(this,'.$key.')">';
                    $SpecSelectName[$key] .= $ProductSpecLogic->GetPresetValueOption('', $key, $id, 1);
                    $SpecSelectName[$key] .= '</select><span class="tongbu" title="同步规格数据" data-mark_id="'.$key.'" data-name="'.$value[0]['spec_name'].'" onclick="RefreshSpecValue(this);"><i class="fa fa-refresh"></i></span>';
                    $SpecSelectName[$key] .= '</div></div></div>';
                }

                session('spec_arr',$spec_arr_new);
                $assign_data['SpecSelectName']   = $SpecSelectName;
                $assign_data['HtmlTable']        = $ProductSpecLogic->DiscountSpecAssemblyEdit($spec_arr_new, $id);
                $assign_data['spec_mark_id_arr'] = implode(',', $spec_mark_id_arr);
            }

            // 预设值名称
            $where = ['lang' => $this->admin_lang];
            if (!empty($spec_mark_id_arr)) $where['preset_mark_id'] = ['NOT IN',$spec_mark_id_arr];
            $assign_data['preset_value'] = Db::name('product_spec_preset')->where($where)->field('preset_id,preset_mark_id,preset_name')->group('preset_mark_id')->order('preset_mark_id desc')->select();
        }

        return $assign_data;
    }
}