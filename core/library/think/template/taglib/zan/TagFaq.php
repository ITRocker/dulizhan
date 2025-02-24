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

/**
 * 常见问题问答列表
 */
class TagFaq extends Base
{
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
    }

    /**
     * 常见问题问答列表
     */
    public function getFaq($group_id = '', $where = '', $orderby = '')
    {
        if (empty($group_id)) {
            echo '标签faq报错：缺少属性 group_id 。';
            return false;
        }

        /*多语言*/
        if (self::$language_split) {
            $langArr = Db::name('faq_group')->where(['group_id'=>$group_id, 'lang'=>self::$home_lang])->cache(true, EYOUCMS_CACHE_TIME, 'ad')->column('lang');
            if (!in_array(self::$home_lang, $langArr)) {
                $lang_title = Db::name('language_mark')->where(['mark'=>self::$home_lang])->value('cn_title');
                echo "标签faq报错：【{$lang_title}】语言 group_id 值不存在。";
                return false;
            }
        }
        /*--end*/

        $uiset = I('param.uiset/s', 'off');
        $uiset = trim($uiset, '/');

        $args = [$group_id, $where, $orderby, $uiset, self::$home_lang];
        $cacheKey = 'taglib-'.md5(__CLASS__.__FUNCTION__.json_encode($args));
        $result = false;//cache($cacheKey);
        if (empty($result) || 'rand' == $orderby) {
            if (empty($where)) { // 新逻辑
                // 排序
                switch ($orderby) {
                    case 'now':
                    case 'new': // 兼容写法
                        $orderby = 'b.add_time desc';
                        break;
                        
                    case 'id':
                        $orderby = 'b.asklist_id desc';
                        break;

                    case 'sort_order':
                        $orderby = 'b.sort_order asc';
                        break;

                    case 'rand':
                        $orderby = 'rand()';
                        break;
                    
                    default:
                        if (empty($orderby)) {
                            $orderby = 'b.sort_order asc, b.asklist_id desc';
                        }
                        break;
                }
                $where = [
                    'a.group_id' => $group_id,
                    'a.status'  => 1,
                    'a.lang' => self::$home_lang,
                ];
                $result = Db::name("faq_group")->alias('a')
                    ->field("b.*")
                    ->join('__FAQ_ASKLIST__ b', 'a.group_id = b.group_id AND a.lang = b.lang', 'LEFT')
                    ->where($where)
                    ->orderRaw($orderby)
                    ->select();
            } else {
                $faqRow = Db::name("faq_group")->where(['group_id'=>$group_id, 'lang'=>self::$home_lang, 'status'=>1])->count();
                if (empty($faqRow)) {
                    return false;
                }
                // 排序
                switch ($orderby) {
                    case 'now':
                    case 'new': // 兼容写法
                        $orderby = 'add_time desc';
                        break;
                        
                    case 'id':
                        $orderby = 'asklist_id desc';
                        break;

                    case 'sort_order':
                        $orderby = 'sort_order asc';
                        break;

                    case 'rand':
                        $orderby = 'rand()';
                        break;
                    
                    default:
                        if (empty($orderby)) {
                            $orderby = 'sort_order asc, asklist_id desc';
                        }
                        break;
                }
                $result = Db::name("faq_asklist")->where($where)->orderRaw($orderby)->select();
            }

            foreach ($result as $key => $val) {
                $val['asklist_title'] = htmlspecialchars_decode($val['asklist_title']);
                $val['asklist_content'] = htmlspecialchars_decode($val['asklist_content']);
                $result[$key] = $val;
            }

            cache($cacheKey, $result, null, 'faq_asklist');
        }

        return $result;
    }
}