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
 * 单页基本信息
 */
class TagSingle extends Base
{
    public $fieldLogic;
    
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
        $this->fieldLogic = new FieldLogic();
        /*应用于文档列表*/
        if ($this->aid > 0) {
            $this->tid = $this->get_aid_typeid($this->aid);
        }
        /*--end*/
    }

    /**
     * 获取单页基本信息
     * @author wengxianhu by 2018-4-20
     */
    public function getSingle($typeid = '', $aid = '', $type = 'self', $addfields = '', $empty = '')
    {
        if (empty($typeid) && !empty($aid)) {
            $typeid = $this->get_aid_typeid($aid);
        }
        $typeid = !empty($typeid) ? $typeid : $this->tid;

        if (empty($typeid)) {
            if (empty($empty)) {
                echo '标签single报错：缺少属性 typeid 值，或单页ID不存在。';
            }
            return false;
        }

        if (self::$language_split) {
            $langArr = Db::name('arctype')->where(['id'=>$typeid])->cache(true, EYOUCMS_CACHE_TIME, 'arctype')->column('lang');
            if (!in_array(self::$home_lang, $langArr)) {
                $lang_title = Db::name('language_mark')->where(['mark'=>self::$home_lang])->value('cn_title');
                echo "标签single报错：【{$lang_title}】语言 typeid 值不存在。";
                return false;
            }
        }

        $result = array();

        switch ($type) {
            case 'top':
                $result = $this->getTop($typeid);
                break;
            
            default:
                $result = $this->getSelf($typeid);
                break;
        }
        $result = $this->fieldLogic->getTableFieldList($result, config('global.arctype_channel_id'));
        
        /*当前单页单页的内容信息*/
        if (!empty($addfields) && isset($result['nid']) && $result['nid'] == 'single') {
            $addfields = str_replace('single_content', 'content', $addfields); // 兼容1.0.9之前的版本
            $addfields = str_replace('，', ',', $addfields); // 替换中文逗号
            $addfields = trim($addfields, ',');
            $row = Db::name('single_content_'.self::$home_lang)->field($addfields)->where('typeid',$result['id'])->find();
            $row = $this->fieldLogic->getChannelFieldList($row, $result['current_channel']);
            $result = array_merge($row, $result);
        }
        /*--end*/

        return $result;
    }

    /**
     * 获取当前单页基本信息
     * @author wengxianhu by 2018-4-20
     */
    public function getSelf($typeid)
    {
        $result = model("Arctype")->getInfo($typeid); // 当前单页信息

        return $result;
    }

    /**
     * 获取当前单页的第一级单页基本信息
     * @author wengxianhu by 2018-4-20
     */
    public function getTop($typeid)
    {
        $parent_list = model('Arctype')->getAllPid($typeid); // 获取当前单页的所有父级单页
        $result = current($parent_list); // 第一级单页

        return $result;
    }

}