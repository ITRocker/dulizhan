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
 * 基类
 */
class Base
{
    /**
     * 子目录
     */
    public $root_dir = '';

    static $request = null;

    /**
     * 当前栏目ID
     */
    public $tid = 0;

    /**
     * 当前文档aid
     */
    public $aid = 0;

    /**
     * 是否开启多语言
     */
    static $lang_switch_on = null;

    /**
     * 前台当前语言
     */
    public $lang = null;

    /**
     * 主体语言（语言列表中最早一条）
     */
    static $main_lang = null;

    /**
     * 前台当前语言
     */
    static $home_lang = null;

    /**
     * 当前语言站点信息
     */
    static $lang_info = null;

    /**
     * 是否开启多城市站点
     */
    static $city_switch_on = null;

    /**
     * 前台当前城市站点
     */
    static $home_site = '';

    /**
     * 当前城市站点ID
     */
    static $siteid = null;

    /**
     * 当前城市站点信息
     */
    static $site_info = null;
    
    public $php_sessid = '';

    /**
     * 多语言分离
     */
    static $language_split = null;

    /**
     * 全部文档的数据
     * @var array
     */
    static $archivesData = null;

    //构造函数
    function __construct()
    {
        // 控制器初始化
        $this->_initialize();
    }

    // 初始化
    protected function _initialize()
    {
        $this->php_sessid = !empty($_COOKIE['PHPSESSID']) ? $_COOKIE['PHPSESSID'] : '';
        if (null == self::$request) {
            self::$request = Request::instance();
        }

        $this->root_dir = ROOT_DIR; // 子目录安装路径
        // 多语言
        if (null === self::$main_lang) {
            self::$main_lang = get_main_lang();
            self::$home_lang = get_home_lang();
        }
        $this->lang = self::$home_lang;
        /*多语言*/
        null === self::$lang_switch_on && self::$lang_switch_on = config('lang_switch_on');
        if (self::$lang_switch_on && null === self::$lang_info) {
            if (!empty(self::$home_lang)) {
                self::$lang_info = Db::name('language')->where('mark', self::$home_lang)->cache(true, EYOUCMS_CACHE_TIME, 'language')->find();
            } else {
                self::$lang_info = get_cookie_langinfo();
            }
        }
        // 多语言分离
        if (null === self::$language_split) self::$language_split = (int)tpCache('language.language_split', [], self::$home_lang);

        $this->tid = input("param.tid/s", '');
        $this->tid = getTrueTypeid($this->tid); // tid为目录名称的情况下

        $this->aid = input("param.aid/s", '');
        $this->aid = getTrueAid($this->aid); // 在aid传值为自定义文件名的情况下

        if (null === self::$archivesData) {
            if ('Buildhtml' == CONTROLLER_NAME) {
                self::$archivesData = $this->get_archivesData($this->aid);
            }
        }
        self::$archivesData = !empty(self::$archivesData) ? self::$archivesData : [];

        // 如果开启游客结账功能则执行
        $this->visitorsID = model('ShopPublicHandle')->getVisitorsID();
    }

    /**
     * 网站默认站点域名
     * @return [type] [description]
     */
    public function getWebsiteHost($full = false)
    {
        $website_host = self::$request->host();
        static $web_basehost = null;
        if (null == $web_basehost) {
            $web_basehost = tpCache('web.web_basehost', [], self::$home_lang);
        }
        $web_basehost = preg_replace('/^(([^\:\.]+):)?(\/\/)?([^\/\:]*)(.*)$/i', '${4}', $web_basehost);
        if (!empty($web_basehost)) {
            $host_port = !stristr(self::$request->host(), ':') ? '' : self::$request->port();
            $website_host = $web_basehost;
            if (!empty($host_port) && !stristr($website_host, ':')) {
                $website_host .= ":{$host_port}";
            }
        }

        if (true === $full) {
            $website_host = self::$request->scheme().'://'.$website_host;
        }

        return $website_host;
    }

    //查询虎皮椒支付有没有配置相应的(微信or支付宝)支付
    public function findHupijiaoIsExis($type = '')
    {
        $hupijiaoInfo = Db::name('weapp')->where(['code'=>'Hupijiaopay','status'=>1])->find();
        $HupijiaoPay = Db::name('pay_api_config')->where(['pay_mark'=>'Hupijiaopay'])->find();
        if (empty($HupijiaoPay) || empty($hupijiaoInfo)) return true;
        if (empty($HupijiaoPay['pay_info'])) return true;
        $PayInfo = unserialize($HupijiaoPay['pay_info']);
        if (empty($PayInfo)) return true;
        if (!isset($PayInfo['is_open_pay']) || $PayInfo['is_open_pay'] == 1) return true;
        $type .= '_appid';
        if (!isset($PayInfo[$type]) || empty($PayInfo[$type])) return true;

        return false;
    }

    public function get_aid_typeid($aid = 0)
    {
        if (!empty(self::$archivesData[$aid])) {
            $typeid = self::$archivesData[$aid];
        } else {
            $cacheKey = 'table-archives-aid-'.$aid;
            $archivesInfo = cache($cacheKey);
            if (empty($archivesInfo)) {
                $archivesInfo = Db::name('archives')->field('typeid')->where('aid', $aid)->find();
                cache($cacheKey, $archivesInfo, null, 'archives');
            }
            $typeid = !empty($archivesInfo['typeid']) ? intval($archivesInfo['typeid']) : 0;
        }

        return $typeid;
    }

    /**
     * 根据aid获取对应所在的缓存文件
     * @return [type] [description]
     */
    private function get_archivesData($aid = 0)
    {
        if (empty($aid)) {
            return [];
        }

        $pagesize = 15000;
        $start = intval($aid / $pagesize) * $pagesize;
        $end = $start + $pagesize;
        $cacheKey = "table_archives_{$start}_{$end}";
        $result = cache($cacheKey);

        return $result;
    }

    // 如果存在分销插件则处理分销商商品URL(携带分销商参数，用于绑定分销商上下级)
    public function handleDealerGoodsURL($result = [], $usersInfo = [], $isFind = false)
    {
        // 是否存在分销插件
        $weappInfo = model('ShopPublicHandle')->getWeappInfo('DealerPlugin');
        // 是否开启分销插件
        if (!empty($weappInfo['status']) && 1 === intval($weappInfo['status'])) {
            // URL模式(仅支持动态、伪静态)
            $seoPseudo = tpCache('seo.seo_pseudo');
            if (in_array($seoPseudo, [1, 3])) {
                // 分销商用户信息
                $usersInfo = !empty($usersInfo) ? $usersInfo : GetUsersLatestData();
                $dealerInfo = !empty($usersInfo['dealer']) ? $usersInfo['dealer'] : [];
                if (!empty($dealerInfo['users_id']) && !empty($dealerInfo['dealer_id']) && !empty($dealerInfo['dealer_status']) && 1 === intval($dealerInfo['dealer_status'])) {
                    if (!empty($isFind)) $result[0] = $result;
                    foreach ($result as $key => $value) {
                        if (!empty($value['arcurl']) && !empty($value['current_channel']) && 2 === intval($value['current_channel'])) {
                            // 分销商参数
                            $dealerParam = base64_encode(json_encode($dealerInfo['users_id'] . '_eyoucms_' . $dealerInfo['dealer_id']));
                            // 动态
                            if (!empty($seoPseudo) && 1 === intval($seoPseudo)) {
                                $result[$key]['arcurl'] = $value['arcurl'] . '&dealerParam=' . $dealerParam;
                            }
                            // 伪静态
                            else if (!empty($seoPseudo) && 3 === intval($seoPseudo)) {
                                $result[$key]['arcurl'] = $value['arcurl'] . '?dealerParam=' . $dealerParam;
                            }
                        }
                    }
                    if (!empty($isFind)) $result = $result[0];
                }
            }
        }
        // 返回参数
        return $result;
    }
}