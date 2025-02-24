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
use think\Request;

/**
 * 多语言模板变量
 */
class TagLang extends Base
{
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
    }

    /**
     * 获取多语言模板变量
     * @author wengxianhu by 2018-4-20
     */
    public function getLang($param = '')
    {
        $is_empty = true;
        $param = unserialize($param);
        foreach ($param as $key => $val) {
            if (!empty($val)) {
                $$key = strtolower($val);
                $is_empty = false;
                break;
            }
        }
        if ($is_empty) {
            return '标签lang报错：至少指定任意一个属性 。';
        }

        $value = '';
        if (!empty($name)) { // 多语言模板变量
            $value = lang($name);
        } else if (!empty($const)) { // 多语言常量，不存储到数据表
            $value = $this->getConst($const);
        }
        
        return $value;
    }

    /**
     * 获取常量值
     * @param string $const 变量名
     * @return string
     */
    private function getConst($const = '')
    {
        static $data = [];
        $param_lang = self::$request->param('lang/s');
        !isset($constArr[self::$home_lang]) && $constArr[self::$home_lang] = [];

        if (empty($data[self::$home_lang])) {
            $arr = [];
            // 当前语言信息
            $langInfo = Db::name('language')->where(['mark'=>self::$home_lang])
                ->cache(true, 0, 'language')
                ->find();
            $lang_htmlmark = $langInfo['mark'];
            if ('cn' == $lang_htmlmark) {
                $lang_htmlmark = 'zh';
            } else if ('zh' == $lang_htmlmark) {
                $lang_htmlmark = 'zh-Hant';
            }
            $arr['htmlmark'] = $lang_htmlmark;
            $arr['mark']   = $langInfo['mark'];
            $arr['url']   = langurl($langInfo);
            $arr['pageurl'] = self::$request->url(true);
            $arr['title']   = $langInfo['title'];
            $arr['logo']   = ROOT_DIR . "/public/static/common/images/language/{$langInfo['mark']}.gif";
            $data[self::$home_lang] = $arr;
        }
        if (preg_match('/^([^a-z0-9]*)mark$/i', $const, $match)) {
            $constArr[self::$home_lang][$const]   = !empty($param_lang) ? end($match).$param_lang : ''; // _mark #mark
        }
        if (!empty($data[self::$home_lang])) {
            $constArr[self::$home_lang] = array_merge($constArr[self::$home_lang], $data[self::$home_lang]);
        }

        $value = !empty($constArr[self::$home_lang][$const]) ? $constArr[self::$home_lang][$const] : '';
        return $value;
    }
}