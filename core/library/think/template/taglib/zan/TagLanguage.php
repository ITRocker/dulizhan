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

/**
 * 多语言列表
 */
class TagLanguage extends Base
{
    public $currentclass = '';

    //初始化
    protected function _initialize()
    {
        parent::_initialize();
    }

    /**
     * 获取多语言列表
     * @author 小虎哥 by 2018-4-20
     */
    public function getLanguage($type = 'default', $limit = '', $currentclass = '')
    {
        if ('user' == MODULE_NAME) {
            return [];
        }
        $this->currentclass = $currentclass;
        // 默认语言
        $defaultLang = get_default_lang(true);
        $map = ['status'=>1];
        $result = M("language")->where($map)
            ->order('is_home_default desc, sort_order asc, id asc')
            ->limit($limit)
            ->select();

        $pageurl = self::$request->url(true);
        $pageurl = remove_url_param($pageurl, 'clear');
        foreach ($result as $key => $val) {
            if (self::$home_lang == $val['mark']) {
                $val['is_home_default'] = ($defaultLang == $val['mark']) ? 1 : 0;
                //支持绑定二级域名
                if(!empty($val['url'])){
                    $langurl = rtrim(self::$request->subDomain($val['url']), '/');  
                }else{
                    $langurl = rtrim(langurl($val), '/');    
                }
                // $pageurl = str_replace([$langurl, '/index.php?'], [''], $pageurl);
                $pageurl = str_replace([$langurl], [''], $pageurl);
                if ('default' == $type) {
                    unset($result[$key]);
                }
                break;
            }
        }
        // if (stristr($pageurl, '?')) {
        //     $pageurl = self::$request->query();
        // }

        // URL语言标识
        $urlLang = input('param.lang/s', '');
        // 是否去除 index.php
        $seoInlet = config('ey_config.seo_inlet');
        // URL参数
        $urlParams = !empty($_SERVER['REDIRECT_URL']) ? trim($_SERVER['REDIRECT_URL']) : trim($_SERVER['REQUEST_URI']);
        //支持绑定二级域名
        $is_domain = false;
        $is_now_lang = get_current_lang();
        if($is_now_lang){
            $languageinfo = M("language")->field('url')->where(['mark'=>$is_now_lang,'is_home_default'=>0])->find();
            if($languageinfo['url']){
                $is_domain = true;
            }
        }
        static $web_langchange = null;
        null === $web_langchange && $web_langchange = (int)tpCache('web.web_langchange', [], self::$home_lang);

        $result = array_merge($result);
        foreach ($result as $key => $val) {   
            //支持绑定二级域名
            $is_url = $val['url']; 
            if($is_domain==false){
                $val['is_home_default'] = ($defaultLang == $val['mark']) ? 1 : 0;
            }
            $lang_htmlmark = $val['mark'];
            if ('cn' == $lang_htmlmark) {
                $lang_htmlmark = 'zh';
            } else if ('zh' == $lang_htmlmark) {
                $lang_htmlmark = 'zh-Hant';
            }
            $val['htmlmark'] = $lang_htmlmark;
            if(empty($val['is_home_default']) && !empty($val['url'])){
                $host = $_SERVER['HTTP_HOST'];
                $scheme = $_SERVER['REQUEST_SCHEME'];
                if($host){
                    $parts = explode('.', $host);
                    $val['url'] =$scheme.'://'.$val['url'].'.'.$parts[1].'.'.$parts[2];
                }else{
                    $val['url'] = langurl($val);
                }
            }else{
                if($val['mark']==$is_now_lang){
                    $val['url'] = langurl($val);
                }else{
                    $is_default_lang = M("language")->field('url')->where(['is_home_default'=>1])->value('mark');
                    $web_basehost = M('config')->where(['name'=>'web_basehost','lang'=>$is_default_lang])->value('value');
                    $val['url'] = replaceDomain(langurl($val),$web_basehost);
                }
            }
            // 语言切换跳转
            if (empty($web_langchange) || ('home@Index@index' == MODULE_NAME.'@'.CONTROLLER_NAME.'@'.ACTION_NAME)) { // 切换到首页
                $val['pageurl'] = $val['url'];
            } else { // 切换到当前页
                if ('user' == MODULE_NAME) {
                    $get_param = input('get.');
                    if (!empty($get_param) && preg_match('/(\?|&)(m|c|a)=/i', self::$request->url())) {
                        $get_param['lang'] = $val['mark'];
                        if (1 == $val['is_home_default']) {
                            unset($get_param['lang']);
                        }
                        $val['pageurl'] = ROOT_DIR.'/index.php?'.http_build_query($get_param);
                    }
                }
                if (empty($val['pageurl'])) {
                    //支持绑定二级域名
                    if(!empty($is_url)){
                        $val['pageurl'] = rtrim($val['url'], '/');
                    }else{
                        $is_default_lang = M("language")->field('url')->where(['is_home_default'=>1])->value('mark');
                        $web_basehost = M('config')->where(['name'=>'web_basehost','lang'=>$is_default_lang])->value('value');
                        $oldurl = langurl($val);
                        $oldurl = rtrim($oldurl, '/');
                        $val['pageurl'] = replaceDomain($oldurl,$web_basehost);
                        //$val['pageurl'] = rtrim(langurl($val), '/');
                    }
                    $val['pageurl'] .= $pageurl;
                    /*检测URL上 index.php 并处理 - start*/
                    $index_ = 'index.php';
                    $domain_ = self::$request->domain();
                    if (0 < intval(substr_count($val['pageurl'], $index_))) {
                        if (!empty($defaultLang) && trim($defaultLang) === trim($val['mark'])) {
                            $urlParams_ = $urlParams;
                        } else if ('/' === trim($urlParams)) {
                            $urlParams_ = $urlParams . $val['mark'];
                        } else {
                            $urlParams_ = str_replace($index_, $index_ . '/' . $val['mark'], $urlParams);
                        }
                        $val['pageurl'] = $domain_ . $urlParams_;
                        if (!empty($urlLang) && 0 < intval(substr_count($val['pageurl'], '/'. $urlLang))) {
                            $count_ = strrpos($val['pageurl'], '/'. $urlLang);
                            if ($count_ !== false) $val['pageurl'] = substr($val['pageurl'], 0, $count_) . substr($val['pageurl'], $count_ + strlen('/'. $urlLang));
                        }
                        $val['url'] = $val['pageurl'];
                    }
                    if (0 === intval($seoInlet) && 0 === intval(substr_count($val['pageurl'], $index_))) {
                        // $clear = 0 < intval(substr_count($val['pageurl'], '?clear=1')) ? '?clear=1' : '';
                        $clear = '';
                        if (!empty($defaultLang) && trim($defaultLang) === trim($val['mark'])) {
                            $urlParams_ = '/' . $index_ . $clear;
                        } else {
                            $urlParams_ = '/' . $index_ . '/' . $val['mark'] . $clear;
                        }
                        $val['pageurl'] = $domain_ . $urlParams_;
                    }
                    /*检测URL上 index.php 并处理 - end*/
                }
                $val['url'] = $val['pageurl'];
            }

            $val['target'] = ($val['target'] == 1) ? 'target="_blank"' : 'target="_self"';
            $val['logo'] = ROOT_DIR . "/public/static/common/images/language/{$val['mark']}.gif";

            /*标记被选中效果*/
            if ($val['mark'] == self::$home_lang) {
                $val['currentclass'] = $val['currentstyle'] = $this->currentclass;
            } else {
                $val['currentclass'] = $val['currentstyle'] = '';
            }
            /*--end*/
            $result[$key] = $val;
        }
        return $result;
    }
}