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
use app\home\logic\FieldLogic;

/**
 * 文档基本信息
 */
class TagArcview extends Base
{
    public $fieldLogic;
    
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
        $this->fieldLogic = new FieldLogic();
    }

    /**
     * 获取栏目基本信息
     * @author wengxianhu by 2018-4-20
     */
    public function getArcview($aid = '', $addfields = '', $joinaid = '')
    {
        $aid = !empty($aid) ? $aid : $this->aid;
        $joinaid !== '' && $aid = $joinaid;

        if (empty($aid)) {
            return false;
        }

        /*文档信息*/
        $result = M("archives")->field('b.*, a.*')
            ->alias('a')
            ->join('__ARCTYPE__ b', 'b.id = a.typeid', 'LEFT')
            ->where('a.aid', $aid)
            ->find();
        if (empty($result)) {
            echo '标签arcview报错：该文档ID('.$aid.')不存在。';
            return false;
        }
        $archives_real_fields = implode(',', config('global.archives_real_fields'));
        $result_new = M("archives_".self::$home_lang)->field($archives_real_fields, true)
            ->where('aid', $aid)
            ->find();
        !empty($result_new) && $result = array_merge($result, $result_new);
        if (self::$language_split) {
            if ($result['lang'] != self::$home_lang) {
                $lang_title = Db::name('language_mark')->where(['mark'=>self::$home_lang])->value('cn_title');
                echo "标签arcview报错：【{$lang_title}】语言 aid 值不存在。";
                return false;
            }
        }
        /*--end*/
        $result['litpic'] = get_default_pic($result['litpic']); // 默认封面图

        // 获取查询的控制器名
        $channelInfo = model('Channeltype')->getInfo($result['channel']);
        $controller_name = $channelInfo['ctl_name'];
        $channeltype_table = $channelInfo['table'];

        /*栏目链接*/
        if (!empty($val['is_part']) && $result['is_part'] == 1) {
            $result['typeurl'] = $result['typelink'];
        } else {
            $result['typeurl'] = typeurl('home/'.$controller_name."/lists", $result);
        }
        /*--end*/

        /*文档链接*/
        if (!empty($val['is_jump']) && $result['is_jump'] == 1) {
            $result['arcurl'] = $result['jumplinks'];
        } else {
            $result['arcurl'] = arcurl('home/'.$controller_name.'/view', $result);
        }
        /*--end*/

        $result['users_price'] = floatval($result['users_price']); // 价格

        /*附加表*/
        $addtableName = $channeltype_table.'_content_'.self::$home_lang;
        if (!empty($addfields)) {
            $addfields = str_replace('，', ',', $addfields); // 替换中文逗号
            $addfields = trim($addfields, ',');
            /*过滤不相关的字段*/
            $addfields_arr = explode(',', $addfields);
            $extFields = M($addtableName)->getTableFields();
            $addfields_arr = array_intersect($addfields_arr, $extFields);
            if (!empty($addfields_arr) && is_array($addfields_arr)) {
                $addfields = implode(',', $addfields_arr);
                if (strstr(",{$addfields},", ',content,')){
                    $addfields .= ',content_ey_m';
                }
            } else {
                $addfields = '*';
            }
            /*end*/
        } else {
            $addfields = '*';
        }
        $row = M($addtableName)->field($addfields)->where('aid',$aid)->find();
        if (is_array($row)) {
            $result = array_merge($result, $row);
            isset($result['total_duration']) && $result['total_duration'] = gmSecondFormat($result['total_duration'], ':');
        } else {
            $saveData = [
                'aid'           => $aid,
                'add_time'      => getTime(),
                'update_time'   => getTime(),
            ];
            M($addtableName)->save($saveData);
        }
        $result = $this->fieldLogic->getChannelFieldList($result, $result['channel']); // 自定义字段的数据格式处理
        /*--end*/

        $result = view_logic($aid, $result['channel'], $result, true);
        // 手机端详情内容
        if (isset($result['content_ey_m'])) {
            if (isMobile() && !empty($result['content_ey_m'])) {
                $result['content'] = $result['content_ey_m'];
            }
            unset($result['content_ey_m']);
        }

        // 如果存在分销插件则处理分销商商品URL(携带分销商参数，用于绑定分销商上下级)
        $result = $this->handleDealerGoodsURL($result, [], true);

        return $result;
    }
}