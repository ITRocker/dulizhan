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

namespace app\common\controller;
use think\Controller;
use think\Session;
use think\Db;
class Common extends Controller {

    public $session_id;
    public $theme_style = '';
    public $theme_style_path = '';
    public $view_suffix = 'html';
    public $zan = array();

    public $users_id = 0;
    public $users = array();
    public $usersConfig = [];
    public $usersTplVersion = '';

    public $visitorsID = 0;

    /**
     * 析构函数
     */
    function __construct() 
    {
        /*是否隐藏或显示应用入口index.php*/
        if (tpCache('seo.seo_inlet', [], $this->show_lang) == 0) {
            \think\Url::root('/index.php');
        } else {
            // \think\Url::root('/');
        }
        /*--end*/
        parent::__construct();
    }    
    
    /*
     * 初始化操作
     */
    public function _initialize() 
    {
        $assignData = [];
        
        // 解决PHP套用Iframe访问导致cookie跨域session失效
        if (in_array($this->request->rootDomain(), ['kuaituiyun.cn'])) {
            // IE浏览器cookie跨域
            header("P3P:CP=CAO DSP COR CUR ADM DEV TAI PSA PSD IVAi IVDi CONi TELo OTPi OUR DELi SAMi OTRi UNRi PUBi IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE GOV");
            // Chrome等浏览器cookie跨域（一定要加上secure，否则SameSite无效）
            @ini_set('session.cookie_samesite', "None;secure");
        }

        session('admin_info'); // 传后台信息到前台，此处可视化用到
        if (!session_id()) {
            Session::start();
        }
        header("Cache-control: private");  // history.back返回后输入框值丢失问题 
        $this->session_id = session_id(); // 当前的 session_id
        !defined('SESSION_ID') && define('SESSION_ID', $this->session_id); //将当前的session_id保存为常量，供其它方法调用
        // 全局配置
        $global = tpCache('global');
        $global['lang_switch_on'] = config('lang_switch_on');

        /*站点状态关闭时，所关闭的终端口(pc、mobile)*/
        // $webClosePort = !empty($global['web_close_port']) ? unserialize($global['web_close_port']) : [];
        // $close = 0;
        // if (!empty($webClosePort)) {
        //     if (0 === intval($this->is_mobile) && in_array('pc', $webClosePort)) {
        //         $close = 1;
        //     } else if (1 === intval($this->is_mobile) && in_array('mobile', $webClosePort)) {
        //         $close = 1;
        //     }
        // }
        // if (in_array(MODULE_NAME, ['home']) && !empty($global['web_status']) && $global['web_status'] == 1 && !empty($close)) {}
        /*end*/

        /*关闭网站*/
        if (in_array(MODULE_NAME, ['home']) && !empty($global['web_status']) && $global['web_status'] == 1) {
            if ($global['web_status_mode'] == 1) {
                if (!empty($global['web_status_url'])) {
                    $this->redirect($global['web_status_url']);
                    exit;
                } else {
                    die("<div style='text-align:center; font-size:20px; font-weight:bold; margin:50px 0px;'>网站暂时关闭，没有找到跳转的URL</div>");
                }
            } else if ($global['web_status_mode'] == 2) {
                $web_status_tpl = !empty($global['web_status_tpl']) ? $global['web_status_tpl'] : 'public/close.html';
                if (is_http_url($web_status_tpl)) {
                    $web_status_tpl = preg_replace('/^(([^\:\.]+):)?(\/\/)?([^\/\:]*)(\:\d+)?(.*)$/i', '${6}', $web_status_tpl);
                }
                if (!empty($this->root_dir)) {
                    $web_status_tpl = preg_replace('/^'.str_replace('/', '\/', $this->root_dir).'\//i', '', $web_status_tpl);
                }
                $web_status_tpl = ltrim($web_status_tpl, '/');
                $filesize = @filesize($web_status_tpl);
                if (file_exists($web_status_tpl) && !empty($filesize)) {
                    $fp      = fopen($web_status_tpl, 'r');
                    $html = fread($fp, $filesize);
                    fclose($fp);
                    exit($html);
                }
            }
            $web_status_text = isset($global['web_status_text']) ? $global['web_status_text'] : '网站暂时关闭，维护中……';
            die("<div style='text-align:center; font-size:20px; font-weight:bold; margin:50px 0px;'>{$web_status_text}</div>");
        }
        /*--end*/

        // 会员中心相关逻辑
        if (!empty($global['web_users_switch'])) {
            $this->usersConfig = getUsersConfigData('all');
            $this->usersTplVersion = getUsersTplVersion();

            $times = getTime();
            /*会员登录有效期逻辑*/
            $users_login_expire = 0;
            if (session('?users_id')) {
                $users_login_expiretime = !empty($this->usersConfig['users_login_expiretime']) ? intval($this->usersConfig['users_login_expiretime']) : 3600;
                $users_login_expire = (int)session('users_login_expire'); //最后登录时间
                if (empty($users_login_expire)) {
                    $users_login_expire = $times;
                    session('users_login_expire', $users_login_expire);
                }
                // 招聘插件会员中心导航内置代码 start 
                if (file_exists('./weapp/Recruits/model/RecruitsModel.php')) {
                    $recruitsModel = new \weapp\Recruits\model\RecruitsModel;
                    $recruitsModel->common_initialize($assignData, $this->usersConfig);
                }
                // 招聘插件会员中心导航内置代码 end
            }
            /*end*/
            if ( !session('?users_id') || (!empty($users_login_expire) && ($times - $users_login_expire) >= $users_login_expiretime) ) {
                session('users_id', null);
                session('users', null);
                cookie('users_id', null);
            } else if ( session('?users_id') && ($times - $users_login_expire) < $users_login_expiretime ) {
                session('users_login_expire', getTime()); // 登录有效期
            }
        }
        $this->assign('usersConfig', $this->usersConfig);
        $this->assign('usersTplVersion',$this->usersTplVersion);

        /*强制微信模式，仅允许微信端访问*/
        $shop_force_use_wechat = getUsersConfigData('shop.shop_force_use_wechat');
        if (!empty($shop_force_use_wechat) && 1 == $shop_force_use_wechat  && !isWeixin() && in_array(MODULE_NAME, ['home'])) {
            $html = "<div style='text-align:center; font-size:20px; font-weight:bold; margin:50px 0px;'>网站仅微信端可访问</div>";
            $WeChatLoginConfig = getUsersConfigData('wechat.wechat_login_config') ? unserialize(getUsersConfigData('wechat.wechat_login_config')) : [];
            if (!empty($WeChatLoginConfig['wechat_name'])) $html .= "<div style='text-align:center; font-size:20px; font-weight:bold; margin:50px 0px;'>关注微信公众号：".$WeChatLoginConfig['wechat_name']."</div>";
            if (!empty($WeChatLoginConfig['wechat_pic'])) $html .= "<div style='text-align:center; font-size:20px; font-weight:bold; margin:50px 0px;'><img style='width: 400px; height: 400px;' src='".$WeChatLoginConfig['wechat_pic']."'></div>";
            die($html);
        }
        /*END*/

        $this->global_assign($global); // 获取网站全局变量值
        $this->view_suffix = config('template.view_suffix'); // 模板后缀htm
        $this->theme_style = THEME_STYLE; // 模板标识
        $this->theme_style_path = THEME_STYLE_PATH; // 模板目录
        //全局变量
        $global['lang_switch_show'] = ('user' == MODULE_NAME) ? 0 : 1;
        $this->zan['global'] = $global;

        // 引入语言包变量
        try {
            $langArr = include_once APP_PATH."lang/{$this->home_lang}.php";
        } catch (\Exception $e) {
            $this->home_lang = get_home_lang(true);
            $langCookieVar = \think\Config::get('global.home_lang');
            \think\Cookie::set($langCookieVar, $this->home_lang);
            $langArr = include_once APP_PATH."lang/{$this->home_lang}.php";
        }
        $this->zan['lang'] = !empty($langArr) ? $langArr : [];
        // 语言站点信息
        $lang_info = Db::name('language')->where(['mark'=>$this->home_lang])->find();
        if (empty($lang_info['status'])) {
            abort(404,'页面不存在');
        }
        $lang_info['url'] = langurl($lang_info);
        $lang_info['pageurl'] = $this->request->url(true);
        // 语言切换跳转
        if (empty($global['web_langchange']) || 'user' == MODULE_NAME) { // 切换到首页
            $lang_info['pageurl'] = $lang_info['url'];
        } else { // 切换到当前页
            $lang_info['url'] = $lang_info['pageurl'];
        }
        $lang_info['logo'] = ROOT_DIR . "/public/static/common/images/language/{$lang_info['mark']}.gif";
        $htmlmark = $lang_info['mark'];
        if ('cn' == $htmlmark) {
            $htmlmark = 'zh';
        } else if ('zh' == $htmlmark) {
            $htmlmark = 'zh-Hant';
        }
        $lang_info['htmlmark'] = $htmlmark;
        foreach ($lang_info as $key => $val) {
            $lang_info['lang_'.$key] = $val;
            unset($lang_info[$key]);
        }
        cookie('lang_info', json_encode($lang_info));
        $this->zan['global'] = array_merge($this->zan['global'], $lang_info);

        /*电脑版与手机版的切换*/
        $v = I('param.v/s', 'pc');
        $v = trim($v, '/');
        $this->assign('v', $v);
        /*--end*/
        
        $assignName2 = $this->arrJoinStr(['cGhwX3Nlcn','ZpY2VtZWFs']);
        $assignValue2 = tpCache('php.'.$assignName2);
        $this->assign($assignName2, $assignValue2);

        // 判断是否开启注册入口
        $users_open_register = getUsersConfigData('users.users_open_register');
        $this->assign('users_open_register', $users_open_register);
        
        // 默认主题颜色
        if (!empty($this->usersConfig['theme_color'])) {
            $theme_color = $this->usersConfig['theme_color'];
        } else {
            if ($this->usersTplVersion == 'v1') {
                $theme_color = '#ff6565';
            } else {
                $theme_color = '#fd8a27';
            }
        }
        $this->usersConfig['theme_color'] = $theme_color;
        $this->assign('theme_color', $theme_color);

        // 存在游客免登录查询则执行
        if (is_dir('./weapp/FreeLogin/')) {
            // 未登录 且 存在指定访问的控制器和方法 则执行
            $freeLoginRow = model('Weapp')->getWeappList('FreeLogin');
            if (!empty($freeLoginRow['status']) && 1 == $freeLoginRow['status']) {
                $unifyController = new \weapp\FreeLogin\controller\FreeLogin;
                $unifyController->freeLoginHandle($this->usersConfig);
            }
        }

        // 如果开启游客结账功能则执行
        $this->visitorsID = model('ShopPublicHandle')->getVisitorsID();
        $this->assign('visitorsID', $this->visitorsID);

        $this->assign($assignData);
    }

    /**
     * 获取系统内置变量 
     */
    public function global_assign($globalParams = [])
    {
        if (empty($globalParams)) {
            $globalParams = tpCache('global');
        }
        $this->assign('global', $globalParams);
    }
}