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

namespace app\admin\logic;

use think\Config;
use think\Model;
use think\Db;

/**
 * 逻辑定义
 * Class CatsLogic
 * @package admin\Logic
 */
class AjaxLogic extends Model
{
    private $request = null;
    private $admin_lang = 'cn';
    private $main_lang = 'cn';

    /**
     * 析构函数
     */
    function  __construct() {
        $this->request = request();
        $this->admin_lang = get_admin_lang();
        $this->main_lang = get_main_lang();
    }

    /**
     * 进入登录页面需要异步处理的业务
     */
    public function login_handle()
    {
        $this->saveBaseFile(); // 存储后台入口文件路径，比如：/login.php
        clear_session_file(); // 清理过期的data/session文件
    }

    /**
     * 清理未存在的左侧菜单
     * @return [type] [description]
     */
    public function admin_menu_clear()
    {
        $del_ids = [];
        $codeArr = Db::name('weapp')->column('code');
        $list = Db::name('admin_menu')->where(['controller_name'=>'Weapp','action_name'=>'execute'])->select();
        foreach ($list as $key => $val) {
            $code = preg_replace('/^(.*)\|sm\|([^\|]+)\|sc\|(.*)$/i', '${2}', $val['param']);
            if (!in_array($code, $codeArr)) {
                $del_ids[] = $val['id'];
            }
        }
        if (!empty($del_ids)) {
            Db::name('admin_menu')->where(['id'=>['IN', $del_ids]])->delete();
        }
    }

    /**
     * 进入欢迎页面需要异步处理的业务
     */
    public function welcome_handle()
    {
        $this->addChannelFile(); // 自动补充自定义模型的文件
        $this->saveBaseFile(); // 存储后台入口文件路径，比如：/login.php
        $this->renameInstall(); // 重命名安装目录，提高网站安全性
        $this->renameSqldatapath(); // 重命名数据库备份目录，提高网站安全性
        $this->del_adminlog(); // 只保留最近一个月的操作日志
        model('Member')->batch_update_userslevel(); // 批量更新会员过期等级
        tpversion(); // 统计装载量，请勿删除，谢谢支持！
    }
    
    /**
     * 自动补充自定义模型的文件
     */
    public function addChannelFile()
    {
        try {
            $list = Db::name('channeltype')->where([
                'ifsystem'  => 0,
                ])->select();
            if (!empty($list)) {
                $cmodSrc = "data/model/application/common/model/CustomModel.php";
                $cmodContent = @file_get_contents($cmodSrc);
                $hctlSrc = "data/model/application/home/controller/CustomModel.php";
                $hctlContent = @file_get_contents($hctlSrc);
                $hmodSrc = "data/model/application/home/model/CustomModel.php";
                $hmodContent = @file_get_contents($hmodSrc);
                foreach ($list as $key => $val) {
                    $file = "application/common/model/{$val['ctl_name']}.php";
                    if (!file_exists($file)) {
                        $cmodContent = str_replace('CustomModel', $val['ctl_name'], $cmodContent);
                        $cmodContent = str_replace('custommodel', strtolower($val['nid']), $cmodContent);
                        $cmodContent = str_replace('CUSTOMMODEL', strtoupper($val['nid']), $cmodContent);
                        @file_put_contents($file, $cmodContent);
                    }
                    $file = "application/home/controller/{$val['ctl_name']}.php";
                    if (!file_exists($file)) {
                        $hctlContent = str_replace('CustomModel', $val['ctl_name'], $hctlContent);
                        $hctlContent = str_replace('custommodel', strtolower($val['nid']), $hctlContent);
                        $hctlContent = str_replace('CUSTOMMODEL', strtoupper($val['nid']), $hctlContent);
                        @file_put_contents($file, $hctlContent);
                    }
                    $file = "application/home/model/{$val['ctl_name']}.php";
                    if (!file_exists($file)) {
                        $hmodContent = str_replace('CustomModel', $val['ctl_name'], $hmodContent);
                        $hmodContent = str_replace('custommodel', strtolower($val['nid']), $hmodContent);
                        $hmodContent = str_replace('CUSTOMMODEL', strtoupper($val['nid']), $hmodContent);
                        @file_put_contents($file, $hmodContent);
                    }
                }
            }
        } catch (\Exception $e) {}
    }
    
    /**
     * 只保留最近一个月的操作日志
     */
    public function del_adminlog()
    {
        try {
            $is_system = true;
            if (file_exists(ROOT_PATH.'weapp/Equal/logic/EqualLogic.php')) {
                $equalLogic = new \weapp\Equal\logic\EqualLogic;
                if (method_exists($equalLogic, 'del_adminlog')) {
                    $is_system = false;
                    $equalLogic->del_adminlog();
                }
            }
            else if (file_exists(ROOT_PATH.'weapp/Systemdoctor/logic/SystemdoctorLogic.php')) {
                $systemdoctorLogic = new \weapp\Systemdoctor\logic\SystemdoctorLogic;
                if (method_exists($systemdoctorLogic, 'del_adminlog')) {
                    $is_system = false;
                    $systemdoctorLogic->del_adminlog();
                }
            }
            if ($is_system) {
                $mtime = strtotime("-1 month");
                Db::name('admin_log')->where([
                    'log_time'  => ['lt', $mtime],
                    ])->delete();
            }
        } catch (\Exception $e) {}
    }

    /*
     * 修改备份数据库目录
     */
    private function renameSqldatapath() {
        $default_sqldatapath = config('DATA_BACKUP_PATH');
        if (is_dir('.'.$default_sqldatapath)) { // 还是符合初始默认的规则的链接方式
            $dirname = get_rand_str(20, 0, 1);
            $new_path = '/data/sqldata_'.$dirname;
            if (@rename(ROOT_PATH.ltrim($default_sqldatapath, '/'), ROOT_PATH.ltrim($new_path, '/'))) {
                /*多语言*/
                $langRow = \think\Db::name('language')->order('id asc')->select();
                foreach ($langRow as $key => $val) {
                    tpCache('web', ['web_sqldatapath'=>$new_path], $val['mark']);
                }
                /*--end*/
            }
        }
    }

    /**
     * 重命名安装目录，提高网站安全性
     * 在 Admin@login 和 Index@index 操作下
     */
    private function renameInstall()
    {
        if (stristr($this->request->host(), 'eycms.hk')) {
            return true;
        }
        $install_path = ROOT_PATH.'install';
        if (is_dir($install_path) && file_exists($install_path)) {
            $install_time = get_rand_str(20, 0, 1);
            $new_path = ROOT_PATH.'install_'.$install_time;
            @rename($install_path, $new_path);
        }
        else {
            $dirlist = glob('install_*');
            $install_dirname = current($dirlist);
            if (!empty($install_dirname)) {
                /*---修补v1.1.6版本删除的安装文件 install.lock start----*/
                if (!empty($_SESSION['isset_install_lock'])) {
                    return true;
                }
                $_SESSION['isset_install_lock'] = 1;
                /*---修补v1.1.6版本删除的安装文件 install.lock end----*/

                $install_path = ROOT_PATH.$install_dirname;
                if (preg_match('/^install_[0-9]{10}$/i', $install_dirname)) {
                    $install_time = get_rand_str(20, 0, 1);
                    $install_dirname = 'install_'.$install_time;
                    $new_path = ROOT_PATH.$install_dirname;
                    if (@rename($install_path, $new_path)) {
                        $install_path = $new_path;
                        /*多语言*/
                        $langRow = \think\Db::name('language')->order('id asc')->select();
                        foreach ($langRow as $key => $val) {
                            tpSetting('install', ['install_dirname'=>$install_time], $val['mark']);
                        }
                        /*--end*/
                    }
                }

                $filename = $install_path.DS.'install.lock';
                if (!file_exists($filename)) {
                    @file_put_contents($filename, '');
                }
            }
        }
    }

    /**
     * 存储后台入口文件路径，比如：/login.php
     * 在 Admin@login 和 Index@index 操作下
     */
    private function saveBaseFile()
    {
        $data = [];
        $data['web_adminbasefile'] = $this->request->baseFile();
        $data['web_cmspath'] = ROOT_DIR; // EyouCMS安装目录
        /*多语言*/
        $langRow = \think\Db::name('language')->field('mark')->order('id asc')->select();
        foreach ($langRow as $key => $val) {
            tpCache('web', $data, $val['mark']);
        }
        /*--end*/
    }
    
    // 记录当前是多语言还是单语言到文件里
    public function system_langnum_file()
    {
        model('Language')->setLangNum();
    }

    public function admin_logic_1609900642()
    {
        // 更新自定义的样式表文件
        /*$version = getVersion();
        $syn_admin_logic_1697156935 = zanSetting('syn.syn_admin_logic_1697156935');
        if ($version != $syn_admin_logic_1697156935) {
            $r = $this->admin_update_theme_css();
            if ($r !== false) {
                zanSetting('syn', ['syn_admin_logic_1697156935'=>$version]);
            }
        }*/

        $vars1 = 'cGhwLnBo'.'cF9zZXJ2aW'.'NlaW5mbw==';
        $vars1 = base64_decode($vars1);
        $data = tpCache($vars1);
        $data = mchStrCode($data, 'DECODE');
        $data = json_decode($data, true);
        if (empty($data['pid']) || 2 > $data['pid']) return true;
        $file = "./data/conf/{$data['code']}.txt";
        $vars2 = 'cGhwX3Nl'.'cnZpY2V'.'tZWFs';
        $vars2 = base64_decode($vars2);
        if (!file_exists($file)) {
            $vars2Value = 1;
        } else {
            $vars2Value = $data['pid'];
        }
        /*多语言*/
        $langRow = \think\Db::name('language')->order('id asc')->select();
        foreach ($langRow as $key => $val) {
            tpCache('php', [$vars2=>$vars2Value], $val['mark']);
        }
        /*--end*/
    }

    /**
     * 更新后台自定义的样式表文件
     * @return [type] [description]
     */
    public function admin_update_theme_css()
    {
        $r = false;
        $file = APP_PATH.'admin/template/public/theme_css.htm';
        if (file_exists($file)) {
            $view = \think\View::instance(\think\Config::get('template'), \think\Config::get('view_replace_str'));
            $view->assign('global', tpCache('global'));
            $css = $view->fetch($file);
            $css = str_replace(['<style type="text/css">','</style>'], '', $css);
            @chmod($file, 0755);
            $r = @file_put_contents(ROOT_PATH.'public/static/admin/css/theme_style.css', $css);
        }

        return $r;
    }

    public function admin_logic_1623036205()
    {
        $arr = [
            ROOT_PATH."application/common/model/Recruit.php",
            ROOT_PATH."application/home/controller/Recruit.php",
            ROOT_PATH."application/home/model/Recruit.php",
            ROOT_PATH."data/conf/eyoufilelist.txt",
            ROOT_PATH."weapp/Foreign",
            ROOT_PATH."public/static/template",
            ROOT_PATH."application/admin/model/UsersParameter.php",
            ROOT_PATH."public/static/common/js/lang/foreign_global.js",
        ];
        foreach ($arr as $key => $val) {
            if (is_dir($val)) {
                try {
                    delFile($val, true);
                } catch (\Exception $e) {}
            } else if (file_exists($val)) {
                @unlink($val);
            }
        }
        
        // 自动更新插件里的jquery文件为最新版本，修复jquery漏洞
        $this->copy_jquery();
        // 升级后要处理的语言数据
        $langRow = $langSysRow = Db::name('language')->order('id asc')->getAllWithIndex('mark');
        foreach (['cn','zh','en'] as $key => $val) {
            if (empty($langSysRow[$val])) {
                $langSysRow[$val] = [
                    'mark' => $val,
                    'domain' => $val,
                ];
            }
        }
        // 升级v2.0.1版本要处理的数据
        // $this->eyou_v201_handle_data($langRow, $langSysRow);
        // 升级v2.0.2版本要处理的数据
        // $this->eyou_v202_handle_data($langRow, $langSysRow);
        // 升级v2.0.3版本要处理的数据
        // $this->eyou_v203_handle_data($langRow, $langSysRow);
        // 升级v2.0.4版本要处理的数据
        $this->eyou_v204_handle_data($langRow, $langSysRow);
        // 升级v2.0.5版本要处理的数据
        $this->eyou_v205_handle_data($langRow, $langSysRow);
        // 升级v2.0.6版本要处理的数据
        $this->eyou_v206_handle_data($langRow, $langSysRow);
    }

    // 升级v2.0.6版本要处理的数据
    private function eyou_v206_handle_data($langRow = [], $langSysRow = [])
    {
        // 完善 language_pack 表内置数据
        $syn_admin_logic_1740018283 = zanSetting('syn.syn_admin_logic_1740018283');
        if (empty($syn_admin_logic_1740018283)) {
            try{
                $r = true;
                $row = Db::name('language_pack')->field('auto_id', true)->where(['is_system'=>1])->order('lang asc, pack_id asc')->select();
                if (!empty($row)) {
                    // 添加内置 cn、en、zh 语言数据
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['pack_id']] = $v;
                    }
                    $row =  $new_arr;

                    $time = getTime();
                    $data = [
                        'cn' => [
                            378 => "确定删除选中的商品？",
                            379 => "部分商品库存数量不足，是否确认提交？",
                            380 => "请至少选择一个商品",
                            381 => "评价成功，需管理员审核后显示",
                            382 => "查看报价列表",
                            383 => "继续浏览",
                            384 => "确认执行删除操作?",
                        ],
                        'en' => [
                            378 => "Are you sure you want to delete the selected item?",
                            379 => "The stock quantity of some products is insufficient. Do you want to confirm the submission?",
                            380 => "Please select at least one product",
                            381 => "The evaluation is successful and needs to be displayed after review by the administrator.",
                            382 => "View Quote List",
                            383 => "Continue to Visit",
                            384 => "Confirm the deletion operation?",
                        ],
                        'zh' => [
                            378 => "確定刪除選中的商品？",
                            379 => "部分商品庫存數量不足，是否確認提交？",
                            380 => "請至少選擇一個商品",
                            381 => "評價成功，需管理員審覈後顯示",
                            382 => "查看報價列表",
                            383 => "繼續瀏覽",
                            384 => "確認執行刪除操作?",
                        ],
                    ];
                    $pack_type = 0;
                    $pack_prefix = '';
                    foreach ($data as $mark => $val) {
                        foreach ($val as $_k => $_v) {
                            if (in_array($_k, [382,383,384])) {
                                $pack_type = 1;
                                $pack_prefix = 'sys';
                            } else if (in_array($_k, [])) {
                                $pack_type = 2;
                                $pack_prefix = 'search';
                            } else if (in_array($_k, [])) {
                                $pack_type = 3;
                                $pack_prefix = 'gbook';
                            } else if (in_array($_k, [])) {
                                $pack_type = 4;
                                $pack_prefix = 'crumb';
                            } else if (in_array($_k, [378,379,380,381])) {
                                $pack_type = 5;
                                $pack_prefix = 'users';
                            }
                            $info['pack_id'] = $_k;
                            $info['name'] = $pack_prefix . $info['pack_id'];
                            $info['value'] = $_v;
                            $info['type'] = $pack_type;
                            $info['is_system'] = 1;
                            $info['lang'] = $mark;
                            $info['sort_order'] = 100;
                            $info['add_time'] = $time;
                            $info['update_time'] = $time;
                            $val[$_k] = $info;
                        }
                        $data[$mark] = $val;
                    }
                    $addData = [];
                    foreach ($data as $mark => $sub) {
                        if (in_array($mark, ['cn','en','zh']) && isset($row[$mark])) {
                            foreach ($sub as $_k => $_v) {
                                if (!isset($row[$mark][$_v['pack_id']])) {
                                    $_v['lang'] = $mark;
                                    $addData[] = $_v;
                                }
                            }
                        }
                    }
                    if (!empty($addData)) {
                        $r = Db::name('language_pack')->insertAll($addData);
                    }

                    // 同步默认语言数据到其他语言里
                    if ($r !== false) {
                        $row = Db::name('language_pack')->field('auto_id', true)->where(['is_system'=>1])->order('lang asc, pack_id asc')->select();
                        $new_arr = array();
                        foreach ($row as $k => $v) {
                            $new_arr[$v['lang']][$v['pack_id']] = $v;
                        }
                        $row =  $new_arr;
                        $data = empty($row[$default_lang]) ? current($row) : $row[$default_lang];

                        $synAddData = [];
                        foreach ($langSysRow as $key => $val) {
                            foreach ($data as $_k => $_v) {
                                if (!isset($row[$val['mark']][$_v['pack_id']])) {
                                    $_v['lang'] = $val['mark'];
                                    $synAddData[] = $_v;
                                }
                            }
                        }
                        if (!empty($synAddData)) {
                            $r = Db::name('language_pack')->insertAll($synAddData);
                        }
                    }
                }
                if ($r !== false) {
                    // 更新语言包变量文件
                    model('LanguagePack')->updateLangFile();
                    zanSetting('syn', ['syn_admin_logic_1740018283'=>1]);
                }
            }catch(\Exception $e){}
        }
    }

    // 升级v2.0.5版本要处理的数据
    private function eyou_v205_handle_data($langRow = [], $langSysRow = [])
    {
        // 完善 users_config 表内置数据
        $syn_admin_logic_1733819719 = zanSetting('syn.syn_admin_logic_1733819719');
        if (empty($syn_admin_logic_1733819719)) {
            try{
                // 添加内置语言数据
                $r = true;
                $row = Db::name('users_config')->field('id', true)->order('lang asc')->select();
                if (!empty($row)) {
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['name']] = $v;
                    }
                    $row =  $new_arr;
                } else {
                    $row = [];
                }

                $time = getTime();
                $data = [
                    'shop_visitors_pay' => [
                        'name' => 'shop_visitors_pay',
                        'value' => 1,
                        'desc' => '',
                        'inc_type' => 'shop',
                        'update_time' => $time,
                    ],
                    'shop_open_shipping_type' => [
                        'name' => 'shop_open_shipping_type',
                        'value' => 1,
                        'desc' => '',
                        'inc_type' => 'shop',
                        'update_time' => $time,
                    ],
                    'shop_open_shipping_money' => [
                        'name' => 'shop_open_shipping_money',
                        'value' => 10,
                        'desc' => '',
                        'inc_type' => 'shop',
                        'update_time' => $time,
                    ],
                    'shop_open_comment_audit' => [
                        'name' => 'shop_open_comment_audit',
                        'value' => 0,
                        'desc' => '',
                        'inc_type' => 'shop',
                        'update_time' => $time,
                    ],
                    'order_unpay_close_time' => [
                        'name' => 'order_unpay_close_time',
                        'value' => 0,
                        'desc' => '',
                        'inc_type' => 'order',
                        'update_time' => $time,
                    ],
                    'order_auto_receipt_time' => [
                        'name' => 'order_auto_receipt_time',
                        'value' => 0,
                        'desc' => '',
                        'inc_type' => 'order',
                        'update_time' => $time,
                    ],
                    'users_login_jump_type' => [
                        'name' => 'users_login_jump_type',
                        'value' => 2,
                        'desc' => '',
                        'inc_type' => 'users',
                        'update_time' => $time,
                    ],
                    'users_login_jump_url' => [
                        'name' => 'users_login_jump_url',
                        'value' => '',
                        'desc' => '',
                        'inc_type' => 'users',
                        'update_time' => $time,
                    ],
                ];
                $addData = [];
                foreach ($langRow as $key => $val) {
                    foreach ($data as $_k => $_v) {
                        if (!isset($row[$_v['name']])) {
                            $_v['lang'] = $val['mark'];
                            $addData[] = $_v;
                        }
                    }
                }
                if (!empty($addData)) {
                    $r = Db::name('users_config')->insertAll($addData);
                }
                if ($r !== false) {
                    zanSetting('syn', ['syn_admin_logic_1733819719'=>1]);
                }
            }catch(\Exception $e){}
        }

        // 完善 language_pack 表内置数据(分组5 会员中心)
        $syn_admin_logic_1734594113 = zanSetting('syn.syn_admin_logic_1734594113');
        if (empty($syn_admin_logic_1734594113)) {
            try{
                $r = true;
                $row = Db::name('language_pack')->field('auto_id', true)->where(['is_system'=>1])->order('lang asc, pack_id asc')->select();
                if (!empty($row)) {
                    // 添加内置 cn、en、zh 语言数据
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['pack_id']] = $v;
                    }
                    $row =  $new_arr;

                    $time = getTime();
                    $data = [
                        'cn' => [
                            361 => "信息",
                            362 => "清空购物车",
                            363 => "继续购物",
                            364 => "联系信息",
                            365 => "已经有一个帐户？",
                            366 => "您的订单",
                            367 => "查看购物车",
                            368 => "付款方式",
                            369 => "订单完成",
                            370 => "谢谢你。你的订单已经收到了。",
                            371 => "商家未配置支付信息",
                            372 => "不可连续提交订单！",
                            373 => "条评论",
                            374 => "添加评论",
                            375 => "您的电子邮件地址不会被公开。必填字段已标记",
                            376 => "您的评分",
                            377 => "您的评价",
                        ],
                        'en' => [
                            361 => "information",
                            362 => "CLEAR SHOPPING CART",
                            363 => "CONTINUE SHOPPING",
                            364 => "Contact Information",
                            365 => "Already have an account ?",
                            366 => "Your Order",
                            367 => "View cart",
                            368 => "PAYMENT METHOD",
                            369 => "Order Complete",
                            370 => "Thank you. Your order has been received.",
                            371 => "The merchant has not configured payment information.",
                            372 => "Orders cannot be submitted continuously!",
                            373 => "review",
                            374 => "Add a review",
                            375 => "Your email address will not be published. Required fields are marked",
                            376 => "Your rating",
                            377 => "Your review",
                        ],
                        'zh' => [
                            361 => "信息",
                            362 => "清空購物車",
                            363 => "繼續購物",
                            364 => "聯繫信息",
                            365 => "已經有一個帳戶？",
                            366 => "您的訂單",
                            367 => "查看購物車",
                            368 => "付款方式",
                            369 => "訂單完成",
                            370 => "謝謝你。你的訂單已經收到了。",
                            371 => "商家未配寘支付信息",
                            372 => "不可連續提交訂單！",
                            373 => "條評論",
                            374 => "添加評論",
                            375 => "您的電子郵件地址不會被公開。必填字段已標記",
                            376 => "您的評分",
                            377 => "您的評價",
                        ],
                    ];
                    foreach ($data as $mark => $val) {
                        foreach ($val as $_k => $_v) {
                            $info['pack_id'] = $_k;
                            $info['name'] = 'users' . $info['pack_id'];
                            $info['value'] = $_v;
                            $info['type'] = 5;
                            $info['is_system'] = 1;
                            $info['lang'] = $mark;
                            $info['sort_order'] = 100;
                            $info['add_time'] = $time;
                            $info['update_time'] = $time;
                            $val[$_k] = $info;
                        }
                        $data[$mark] = $val;
                    }
                    $addData = [];
                    foreach ($data as $mark => $sub) {
                        if (in_array($mark, ['cn','en','zh']) && isset($row[$mark])) {
                            foreach ($sub as $_k => $_v) {
                                if (!isset($row[$mark][$_v['pack_id']])) {
                                    $_v['lang'] = $mark;
                                    $addData[] = $_v;
                                }
                            }
                        }
                    }
                    if (!empty($addData)) {
                        $r = Db::name('language_pack')->insertAll($addData);
                    }

                    // 同步默认语言数据到其他语言里
                    if ($r !== false) {
                        $row = Db::name('language_pack')->field('auto_id', true)->where(['is_system'=>1])->order('lang asc, pack_id asc')->select();
                        $new_arr = array();
                        foreach ($row as $k => $v) {
                            $new_arr[$v['lang']][$v['pack_id']] = $v;
                        }
                        $row =  $new_arr;
                        $data = empty($row[$default_lang]) ? current($row) : $row[$default_lang];

                        $synAddData = [];
                        foreach ($langSysRow as $key => $val) {
                            foreach ($data as $_k => $_v) {
                                if (!isset($row[$val['mark']][$_v['pack_id']])) {
                                    $_v['lang'] = $val['mark'];
                                    $synAddData[] = $_v;
                                }
                            }
                        }
                        if (!empty($synAddData)) {
                            $r = Db::name('language_pack')->insertAll($synAddData);
                        }
                    }
                }
                if ($r !== false) {
                    // 更新语言包变量文件
                    model('LanguagePack')->updateLangFile();
                    zanSetting('syn', ['syn_admin_logic_1734594113'=>1]);
                }
            }catch(\Exception $e){}
        }

        // 补充 pay_api_config 表 PayPal支付数据
        $syn_admin_logic_1734921436 = zanSetting('syn.syn_admin_logic_1734921436');
        if (empty($syn_admin_logic_1734921436)) {
            try {
                $where = [
                    'pay_mark' => 'Paypal',
                ];
                $count = Db::name('pay_api_config')->where($where)->count();
                if (empty($count)) {
                    Db::name('pay_api_config')->insert([
                        'pay_name'      => 'Paypal支付',
                        'pay_mark'      => 'Paypal',
                        'pay_info'      => '',
                        'pay_terminal'  => '',
                        'system_built'  => 0,
                        'status'        => 1,
                        'lang'          => 'cn',
                        'add_time'      => getTime(),
                        'update_time'   => getTime()
                    ]);
                }
                zanSetting('syn', ['syn_admin_logic_1734921436'=>1]);
            } catch(\Exception $e) {}
        }
    }

    // 升级v2.0.4版本要处理的数据
    private function eyou_v204_handle_data($langRow = [], $langSysRow = [])
    {
        $Prefix = config('database.prefix');
        // $default_lang = Db::name('language')->where(['is_admin_default' => 1])->getField('mark');
        
        // 处理上个版本升级后，导航数据因为标签底层改动，缓存问题导致不显示
        $syn_admin_logic_1732586784 = zanSetting('syn.syn_admin_logic_1732586784');
        if (empty($syn_admin_logic_1732586784)) {
            try {
                delFile(rtrim(RUNTIME_PATH, '/'));
            } catch (\Exception $e) {
                
            }
            zanSetting('syn', ['syn_admin_logic_1732586784'=>1]);
        }

        // 文档主表新增字段
        $tableInfo = Db::query("SHOW COLUMNS FROM {$Prefix}archives");
        $tableInfo = get_arr_column($tableInfo, 'Field');
        if (!empty($tableInfo)) {
            $r = false;
            if (!in_array('collection', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `collection`  int(10) NULL DEFAULT 0 COMMENT '收藏数' AFTER `users_price`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('appraise', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `appraise`  int(10) NULL DEFAULT 0 COMMENT '评价数' AFTER `users_price`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('logistics_type', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `logistics_type`  varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '商品物流支持类型(1: 物流配送; 2: 到店核销)' AFTER `users_price`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('prom_type', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `prom_type`  tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '产品类型：0=普通产品，1=虚拟(默认手动发货)，2=虚拟(网盘)，3=虚拟(自定义文本) 4-核销' AFTER `users_price`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('stock_show', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `stock_show`  tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '商品库存在产品详情页是否显示，1为显示，0为不显示' AFTER `users_price`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('stock_count', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `stock_count`  int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商品库存量' AFTER `users_price`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('sales_all', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `sales_all`  int(10) NULL DEFAULT 0 COMMENT '虚拟总销量' AFTER `users_price`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('virtual_sales', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `virtual_sales`  int(10) NULL DEFAULT 0 COMMENT '商品虚拟销售量' AFTER `users_price`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('sales_num', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `sales_num`  int(10) NOT NULL DEFAULT 0 COMMENT '总销售量' AFTER `users_price`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('free_shipping', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `free_shipping`  tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '商品是否包邮(1包邮(免运费)  0跟随系统)' AFTER `users_price`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('users_discount_type', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `users_discount_type`  tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '产品会员折扣类型(0:系统默认折扣; 1:指定会员级别; 2:不参与折扣;)' AFTER `users_price`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('crossed_price', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `crossed_price`  decimal(20,2) NOT NULL DEFAULT 0.00 COMMENT '商品划线价' AFTER `users_price`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('jumplinks', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `jumplinks`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '跳转网址' AFTER `is_litpic`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('is_jump', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `is_jump`  tinyint(1) NULL DEFAULT 0 COMMENT '跳转链接（0=否，1=是）' AFTER `is_litpic`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('is_diyattr', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `is_diyattr`  tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '自定义（0=否，1=是）' AFTER `is_litpic`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('is_slide', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `is_slide`  tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '幻灯（0=否，1=是）' AFTER `is_litpic`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('is_roll', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `is_roll`  tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '滚动（0=否，1=是）' AFTER `is_litpic`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('is_recom', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `is_recom`  tinyint(1) NULL DEFAULT 0 COMMENT '推荐（0=否，1=是）' AFTER `is_litpic`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('is_top', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `is_top`  tinyint(1) NULL DEFAULT 0 COMMENT '置顶（0=否，1=是）' AFTER `is_litpic`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('is_special', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `is_special`  tinyint(1) NULL DEFAULT 0 COMMENT '特荐（0=否，1=是）' AFTER `is_litpic`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('is_head', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `is_head`  tinyint(1) NULL DEFAULT 0 COMMENT '头条（0=否，1=是）' AFTER `is_litpic`;";
                @Db::execute($sql);
                $r = true;
            }
            if (!in_array('is_b', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}archives` ADD COLUMN `is_b`  tinyint(1) NULL DEFAULT 0 COMMENT '加粗' AFTER `is_litpic`;";
                @Db::execute($sql);
                $r = true;
            }
            if ($r !== false) {
                schemaTable("archives");
            }
        }
        foreach ($langSysRow as $key => $val) {
            $isTable = Db::query("SHOW TABLES LIKE '{$Prefix}archives_{$val['mark']}'");
            if (!empty($isTable)) {
                $tableInfo = Db::query("SHOW COLUMNS FROM {$Prefix}archives_{$val['mark']}");
                $tableInfo = get_arr_column($tableInfo, 'Field');
                if (!empty($tableInfo)) {
                    $r = false;
                    if (!in_array('jumplinks', $tableInfo)) {
                        $sql = "ALTER TABLE `{$Prefix}archives_{$val['mark']}` ADD COLUMN `jumplinks`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '跳转网址' AFTER `is_litpic`;";
                        @Db::execute($sql);
                        $r = true;
                    }
                    if (!in_array('is_jump', $tableInfo)) {
                        $sql = "ALTER TABLE `{$Prefix}archives_{$val['mark']}` ADD COLUMN `is_jump`  tinyint(1) NULL DEFAULT 0 COMMENT '跳转链接（0=否，1=是）' AFTER `is_litpic`;";
                        @Db::execute($sql);
                        $r = true;
                    }
                    if (!in_array('is_diyattr', $tableInfo)) {
                        $sql = "ALTER TABLE `{$Prefix}archives_{$val['mark']}` ADD COLUMN `is_diyattr`  tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '自定义（0=否，1=是）' AFTER `is_litpic`;";
                        @Db::execute($sql);
                        $r = true;
                    }
                    if (!in_array('is_slide', $tableInfo)) {
                        $sql = "ALTER TABLE `{$Prefix}archives_{$val['mark']}` ADD COLUMN `is_slide`  tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '幻灯（0=否，1=是）' AFTER `is_litpic`;";
                        @Db::execute($sql);
                        $r = true;
                    }
                    if (!in_array('is_roll', $tableInfo)) {
                        $sql = "ALTER TABLE `{$Prefix}archives_{$val['mark']}` ADD COLUMN `is_roll`  tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '滚动（0=否，1=是）' AFTER `is_litpic`;";
                        @Db::execute($sql);
                        $r = true;
                    }
                    if (!in_array('is_recom', $tableInfo)) {
                        $sql = "ALTER TABLE `{$Prefix}archives_{$val['mark']}` ADD COLUMN `is_recom`  tinyint(1) NULL DEFAULT 0 COMMENT '推荐（0=否，1=是）' AFTER `is_litpic`;";
                        @Db::execute($sql);
                        $r = true;
                    }
                    if (!in_array('is_top', $tableInfo)) {
                        $sql = "ALTER TABLE `{$Prefix}archives_{$val['mark']}` ADD COLUMN `is_top`  tinyint(1) NULL DEFAULT 0 COMMENT '置顶（0=否，1=是）' AFTER `is_litpic`;";
                        @Db::execute($sql);
                        $r = true;
                    }
                    if (!in_array('is_special', $tableInfo)) {
                        $sql = "ALTER TABLE `{$Prefix}archives_{$val['mark']}` ADD COLUMN `is_special`  tinyint(1) NULL DEFAULT 0 COMMENT '特荐（0=否，1=是）' AFTER `is_litpic`;";
                        @Db::execute($sql);
                        $r = true;
                    }
                    if (!in_array('is_head', $tableInfo)) {
                        $sql = "ALTER TABLE `{$Prefix}archives_{$val['mark']}` ADD COLUMN `is_head`  tinyint(1) NULL DEFAULT 0 COMMENT '头条（0=否，1=是）' AFTER `is_litpic`;";
                        @Db::execute($sql);
                        $r = true;
                    }
                    if (!in_array('is_b', $tableInfo)) {
                        $sql = "ALTER TABLE `{$Prefix}archives_{$val['mark']}` ADD COLUMN `is_b`  tinyint(1) NULL DEFAULT 0 COMMENT '加粗' AFTER `is_litpic`;";
                        @Db::execute($sql);
                        $r = true;
                    }
                    if ($r !== false) {
                        schemaTable("archives_{$val['mark']}");
                    }
                }
            }
        }

        // 调整文档语言主表的字段长度
        $syn_admin_logic_1733129516 = zanSetting('syn.syn_admin_logic_1733129516');
        if (empty($syn_admin_logic_1733129516)) {
            foreach ($langSysRow as $key => $val) {
                try{
                    $isTable = Db::query("SHOW TABLES LIKE '{$Prefix}archives_{$val['mark']}'");
                    if (!empty($isTable)) {
                        $tableInfo = Db::query("SHOW COLUMNS FROM {$Prefix}archives_{$val['mark']}");
                        $tableInfo = get_arr_column($tableInfo, 'Field');
                        if (!empty($tableInfo) && in_array('users_price', $tableInfo)) {
                            $sql = "ALTER TABLE `{$Prefix}archives_{$val['mark']}` MODIFY COLUMN `users_price`  decimal(20,2) NOT NULL DEFAULT 0.00 COMMENT '会员价' AFTER `sort_order`;";
                            @Db::execute($sql);
                            schemaTable("archives_{$val['mark']}");
                        }
                    }
                }catch(\Exception $e){}
                zanSetting('syn', ['syn_admin_logic_1733129516'=>1]);
            }
        }

        // 完善 language_pack 表内置数据(分组1 公共变量)
        $syn_admin_logic_1733131407 = zanSetting('syn.syn_admin_logic_1733131407');
        if (empty($syn_admin_logic_1733131407)) {
            try{
                $r = true;
                $row = Db::name('language_pack')->field('auto_id', true)->where(['is_system'=>1])->order('lang asc, pack_id asc')->select();
                if (!empty($row)) {
                    // 添加内置 cn、en、zh 语言数据
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['pack_id']] = $v;
                    }
                    $row =  $new_arr;

                    $time = getTime();
                    $data = [
                        'cn' => [
                            313 => "数量",
                            314 => "立即购买",
                            315 => "加入购物车",
                            316 => "库存",
                            317 => "销量",
                            318 => "总销量",
                            319 => "评分",
                            320 => "非常不满",
                            321 => "不满意",
                            322 => "一般",
                            323 => "满意",
                            324 => "非常满意",
                            325 => "评论数",
                            342 => "哎呀！找不到页面了！",
                            343 => "不要伤心，可能是网址错了呢，重新核对一下吧。",
                            344 => "回到上一页",
                            345 => "回到首页",
                        ],
                        'en' => [
                            313 => "Quantity",
                            314 => "Buy Now",
                            315 => "Add To Cart",
                            316 => "Stock",
                            317 => "Sales Volume",
                            318 => "Total Sales",
                            319 => "Score",
                            320 => "Bad",
                            321 => "Dissatisfied",
                            322 => "General",
                            323 => "Satisfied",
                            324 => "Good",
                            325 => "Quantity",
                            342 => "Can't find the page!",
                            343 => "Don't be sad, maybe the website address is wrong, please double check it.",
                            344 => "Return to the previous page",
                            345 => "Return to the homepage",
                        ],
                        'zh' => [
                            313 => "數量",
                            314 => "立即購買",
                            315 => "加入購物車",
                            316 => "庫存",
                            317 => "銷量",
                            318 => "總銷量",
                            319 => "評分",
                            320 => "非常不满",
                            321 => "不滿意",
                            322 => "一般",
                            323 => "满意",
                            324 => "非常滿意",
                            325 => "評論數",
                            342 => "哎呀！找不到頁面了！",
                            343 => "不要傷心，可能是網址錯了呢，重新核對一下吧。",
                            344 => "回到上一頁",
                            345 => "回到首頁",
                        ],
                    ];
                    foreach ($data as $mark => $val) {
                        foreach ($val as $_k => $_v) {
                            $info['pack_id'] = $_k;
                            $info['name'] = 'sys' . $info['pack_id'];
                            $info['value'] = $_v;
                            $info['type'] = 1;
                            $info['is_system'] = 1;
                            $info['lang'] = $mark;
                            $info['sort_order'] = 100;
                            $info['add_time'] = $time;
                            $info['update_time'] = $time;
                            $val[$_k] = $info;
                        }
                        $data[$mark] = $val;
                    }
                    $addData = [];
                    foreach ($data as $mark => $sub) {
                        if (in_array($mark, ['cn','en','zh']) && isset($row[$mark])) {
                            foreach ($sub as $_k => $_v) {
                                if (!isset($row[$mark][$_v['pack_id']])) {
                                    $_v['lang'] = $mark;
                                    $addData[] = $_v;
                                }
                            }
                        }
                    }
                    if (!empty($addData)) {
                        $r = Db::name('language_pack')->insertAll($addData);
                    }

                    // 同步默认语言数据到其他语言里
                    if ($r !== false) {
                        $row = Db::name('language_pack')->field('auto_id', true)->where(['is_system'=>1])->order('lang asc, pack_id asc')->select();
                        $new_arr = array();
                        foreach ($row as $k => $v) {
                            $new_arr[$v['lang']][$v['pack_id']] = $v;
                        }
                        $row =  $new_arr;
                        $data = empty($row[$default_lang]) ? current($row) : $row[$default_lang];

                        $synAddData = [];
                        foreach ($langSysRow as $key => $val) {
                            foreach ($data as $_k => $_v) {
                                if (!isset($row[$val['mark']][$_v['pack_id']])) {
                                    $_v['lang'] = $val['mark'];
                                    $synAddData[] = $_v;
                                }
                            }
                        }
                        if (!empty($synAddData)) {
                            $r = Db::name('language_pack')->insertAll($synAddData);
                        }
                    }
                }
                if ($r !== false) {
                    // 更新语言包变量文件
                    model('LanguagePack')->updateLangFile();
                    zanSetting('syn', ['syn_admin_logic_1733131407'=>1]);
                }
            }catch(\Exception $e){}
        }

        // 完善 language_pack 表内置数据(分组5 会员中心)
        $syn_admin_logic_1733130636 = zanSetting('syn.syn_admin_logic_1733130636');
        if (empty($syn_admin_logic_1733130636)) {
            try{
                $r = true;
                $row = Db::name('language_pack')->field('auto_id', true)->where(['is_system'=>1])->order('lang asc, pack_id asc')->select();
                if (!empty($row)) {
                    // 添加内置 cn、en、zh 语言数据
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['pack_id']] = $v;
                    }
                    $row =  $new_arr;

                    $time = getTime();
                    $data = [
                        'cn' => [
                            58 => "您的购物车还没有商品！",
                            59 => "%s不能为空！",
                            60 => "%s格式不正确！",
                            61 => "邮箱验证码已被使用或超时，请重新发送！",
                            62 => "邮箱验证码不正确，请重新输入！",
                            63 => "短信验证码不正确，请重新输入！",
                            64 => "%s已存在！",
                            65 => "签到成功",
                            66 => "今日已签过到",
                            67 => "是否删除该收藏？",
                            68 => "确认批量删除收藏？",
                            69 => "每日签到",
                            70 => "充值金额不能为空！",
                            71 => "请输入正确的充值金额！",
                            72 => "请选择支付方式！",
                            73 => "用户名不能为空！",
                            74 => "用户名不正确！",
                            75 => "密码不能为空！",
                            76 => "图片验证码不能为空！",
                            77 => "图片验证码错误",
                            78 => "前台禁止管理员登录！",
                            79 => "该会员尚未激活，请联系管理员！",
                            80 => "管理员审核中，请稍等！",
                            81 => "登录成功",
                            82 => "密码不正确！",
                            83 => "该用户名不存在，请注册！",
                            84 => "看不清？点击更换验证码",
                            85 => "手机号码不能为空！",
                            86 => "手机号码格式不正确！",
                            87 => "手机验证码不能为空！",
                            88 => "手机验证码已失效！",
                            89 => "手机号码已经注册！",
                            90 => "用户名为系统禁止注册！",
                            91 => "请输入2-30位的汉字、英文、数字、下划线等组合",
                            92 => "登录密码不能为空！",
                            93 => "重复密码不能为空！",
                            94 => "用户名已存在",
                            95 => "两次密码输入不一致！",
                            96 => "注册成功，正在跳转中……",
                            97 => "注册成功，等管理员激活才能登录！",
                            98 => "注册成功，请登录！",
                            99 => "昵称不可为纯空格",
                            100 => "原密码不能为空！",
                            101 => "新密码不能为空！",
                            102 => "手机号码不存在，不能找回密码！",
                            103 => "手机号码未绑定，不能找回密码！",
                            104 => "手机验证码已被使用或超时，请重新发送！",
                            105 => "晚上好～",
                            106 => "早上好～",
                            107 => "下午好～",
                            108 => "用户名",
                            109 => "邮箱地址",
                            110 => "密码",
                            111 => "确认密码",
                            112 => "邮箱验证码",
                            113 => "点击发送",
                            114 => "邮箱地址不能为空！",
                            115 => "该会员尚未激活，不能找回密码！",
                            116 => "邮箱地址未绑定，不能找回密码！",
                            117 => "邮箱地址不存在！",
                            118 => "邮箱已绑定，无需重新绑定！",
                            119 => "邮箱已经存在，不可以绑定！",
                            120 => "必填",
                            121 => "请正确输入邮箱地址",
                            122 => "发送中…",
                            123 => "图片验证码",
                            124 => "登录",
                            125 => "邮箱验证码不能为空",
                            126 => "邮箱不存在，不能找回密码！",
                            127 => "会员邮箱属性已关闭，请联系网站管理员！",
                            128 => "请传入必填项字段",
                            129 => "请传入验证token名称",
                            130 => "请传入提交验证的数组",
                            131 => "数据不存在！",
                            132 => "令牌数据无效",
                            133 => "表单校验失败，请检查站点权限问题",
                            134 => "发送失败",
                            135 => "发送成功",
                            136 => "新密码",
                            137 => "确认新密码",
                            138 => "确认密码不能为空！",
                            139 => "新客户？",
                            140 => "从这里开始",
                            141 => "忘记密码",
                            142 => "账号登录",
                            143 => "创建账号",
                            144 => "已有账号!",
                            145 => "找回密码",
                            146 => "下一步",
                            147 => "返回登录",
                            148 => "重置密码",
                            149 => "确认提交",
                            150 => "个人中心",
                            151 => "我的信息",
                            152 => "我的收藏",
                            153 => "收货地址",
                            154 => "我的订单",
                            155 => "会员中心",
                            156 => "安全退出",
                            157 => "您可以去看看有哪些想买的",
                            158 => "去逛逛",
                            159 => "购物车",
                            160 => "结账",
                            161 => "付款",
                            162 => "待付款",
                            163 => "未付款",
                            164 => "已付款",
                            165 => "商品",
                            166 => "全选",
                            167 => "数量",
                            168 => "小计",
                            169 => "操作",
                            170 => "删除",
                            171 => "商品总计",
                            172 => "已选",
                            173 => "去结账",
                            174 => "件",
                            175 => "配送地址",
                            176 => "已选择",
                            177 => "编辑",
                            178 => "选择其他地址",
                            179 => "添加新地址",
                            180 => "支付方式",
                            181 => "配送方式",
                            182 => "固定运费",
                            183 => "订单备注",
                            184 => "购物车总数",
                            185 => "运费",
                            186 => "应付总金额",
                            187 => "提交订单",
                            188 => "订单提交成功，请付款",
                            189 => "订单编号",
                            190 => "应付金额",
                            191 => "欢迎",
                            192 => "待付款的订单",
                            193 => "查看待付款订单",
                            194 => "待发货的订单",
                            195 => "查看待发货订单",
                            196 => "待收货的订单",
                            197 => "查看待收货订单",
                            198 => "待评价商品数",
                            199 => "查看待评价商品",
                            200 => "待发货",
                            201 => "待收货",
                            202 => "待评价",
                            203 => "已评价",
                            204 => "地址",
                            205 => "收藏",
                            206 => "足迹",
                            207 => "头像",
                            208 => "昵称",
                            209 => "修改密码",
                            210 => "留空时默认不修改密码",
                            211 => "账号注销",
                            212 => "保存",
                            213 => "更改",
                            214 => "新的邮箱地址",
                            215 => "秒",
                            216 => "绑定邮箱",
                            217 => "标题",
                            218 => "分类",
                            219 => "批量删除",
                            220 => "添加地址",
                            221 => "编辑地址",
                            222 => "确定要删除地址吗？",
                            223 => "确定要设置为默认地址?",
                            224 => "电话号码",
                            225 => "邮编",
                            226 => "城市",
                            227 => "国家/地区",
                            228 => "省份",
                            229 => "详细地址",
                            230 => "详细地址，路名或街道名称，门牌号",
                            231 => "请输入联系人",
                            232 => "请输入联系电话",
                            233 => "请选择完整省市区",
                            234 => "请输入详细地址",
                            235 => "设为默认",
                            236 => "默认地址",
                            237 => "修改成功",
                            238 => "全部订单",
                            239 => "已完成",
                            240 => "输入商品名称、订单号",
                            241 => "马上去购物",
                            242 => "已关闭",
                            243 => "等待付款",
                            244 => "已完成",
                            245 => "订单号",
                            246 => "立即付款",
                            247 => "提醒发货",
                            248 => "物流查询",
                            249 => "确认收货",
                            250 => "订单详情",
                            251 => "评价商品",
                            252 => "取消订单",
                            253 => "下单",
                            254 => "付款",
                            255 => "发货",
                            256 => "完成",
                            257 => "订购商品",
                            258 => "订单过期",
                            259 => "订单关闭",
                            260 => "已发货",
                            261 => "商品总价",
                            262 => "配送地址",
                            263 => "买家留言",
                            264 => "快递配送",
                            265 => "买家留言",
                            266 => "商家回复",
                            267 => "快递信息",
                            268 => "快递公司",
                            269 => "物流单号",
                            270 => "海外商直发",
                            271 => "请填写 %s",
                            272 => "添加成功",
                            273 => "删除成功",
                            274 => "删除失败",
                            275 => "收藏成功",
                            276 => "取消成功",
                            277 => "全名",
                            278 => "商品数量最少为1",
                            279 => "确定删除购物车商品: ",
                            280 => "确定要取消订单?",
                            281 => "提醒管理员发货？",
                            282 => "确认已收到货物？",
                            283 => "评价晒单",
                            284 => "下单时间",
                            285 => "实付金额",
                            286 => "共 ",
                            287 => " 种商品",
                            288 => "输入订单号查询",
                            289 => "立即评价",
                            290 => "评价服务",
                            291 => "订单创建成功",
                            292 => "支付订单完成！",
                            293 => "支付成功，处理订单完成！",
                            294 => "支付成功，处理订单失败！",
                            295 => "已支付",
                            296 => "该订单已过期！",
                            297 => "该订单不存在或已关闭！",
                            298 => "描述相符",
                            299 => "请在此处输入您的评价",
                            300 => "上传图片",
                            301 => "限6张",
                            302 => "请选择全部商品评价分",
                            303 => "请填写全部商品评价内容",
                            304 => "订单已评价过",
                            305 => "评价成功",
                            306 => "评价失败，请重试",
                            307 => "我的评价",
                            308 => "评价时间",
                            309 => "差评",
                            310 => "中评",
                            311 => "好评",
                            312 => "查看评价",
                            326 => "我的足迹",
                            327 => "访问时间",
                            328 => "确认批量删除浏览记录？",
                            329 => "确认删除该浏览记录？",
                            330 => "提醒成功！",
                            331 => "[商品已停售]",
                            332 => "订单不存在",
                            333 => "未支付",
                            334 => "在线支付",
                            335 => "订单已取消",
                            336 => "该商品不存在或已下架！",
                            337 => "订单支付异常，请刷新重新下单~",
                            338 => "商品已售罄",
                            339 => "超出商品库存",
                            340 => "退出登录",
                            341 => "注册账号",
                            346 => "订单已支付，即将跳转",
                            347 => "订单已过期，即将跳转",
                            348 => "订单已关闭，即将跳转",
                            349 => "订单不存在或已变更",
                            350 => "订单处理中",
                            351 => "订单支付中",
                            352 => "价格",
                            353 => "最多允许上传6张图片",
                            354 => "或将文件拖到这里，本次最多可选 %s 个",
                            355 => "点击选择图片",
                            356 => "共%s张（%s），已上传%s张",
                            357 => "继续添加",
                            358 => "确定使用",
                            359 => "邮箱地址为系统禁止注册！",
                            360 => "关于您的订单的说明，例如交货的特殊说明。",
                        ],
                        'en' => [
                            58 => "Your shopping cart doesn&apos;t have any products yet!",
                            59 => "%s cannot be empty!",
                            60 => "%s Incorrect format!",
                            61 => "The email verification code has been used or timed out. Please resend it!",
                            62 => "The email verification code is incorrect, please re-enter!",
                            63 => "The SMS verification code is incorrect, please re-enter!",
                            64 => "%s already exists!",
                            65 => "Successful check-in",
                            66 => "Signed in today",
                            67 => "Do you want to delete this collection?",
                            68 => "Confirm bulk deletion of favorites?",
                            69 => "Daily Attendance",
                            70 => "Recharge amount cannot be empty!",
                            71 => "Please enter the correct recharge amount!",
                            72 => "Please choose a payment method!",
                            73 => "The username cannot be empty!",
                            74 => "The username is incorrect!",
                            75 => "Password cannot be empty!",
                            76 => "The image verification code cannot be empty!",
                            77 => "Image verification code error",
                            78 => "The front desk prohibits administrators from logging in!",
                            79 => "This member has not been activated yet. Please contact the administrator!",
                            80 => "Administrator review in progress, please wait!",
                            81 => "Login succeeded",
                            82 => "The password is incorrect!",
                            83 => "The username does not exist, please register!",
                            84 => "Can&apos;t see clearly? Click to change the verification code",
                            85 => "Mobile phone number cannot be empty!",
                            86 => "The phone number format is incorrect!",
                            87 => "Mobile verification code cannot be empty!",
                            88 => "The mobile verification code has expired!",
                            89 => "The phone number has been registered!",
                            90 => "The username is prohibited from registration by the system!",
                            91 => "Please enter a combination of Chinese characters, English characters, numbers, underscores, etc. that are 2-30 digits long",
                            92 => "Login password cannot be empty!",
                            93 => "The duplicate password cannot be empty!",
                            94 => "The username already exists",
                            95 => "The two password inputs are inconsistent!",
                            96 => "Registration successful, jumping in progress……",
                            97 => "Registration successful, wait for administrator activation before logging in!",
                            98 => "Registration successful, please log in!",
                            99 => "Nicknames cannot be pure spaces",
                            100 => "The original password cannot be empty!",
                            101 => "The new password cannot be empty!",
                            102 => "Mobile phone number does not exist, password cannot be retrieved!",
                            103 => "Mobile phone number is not bound, password cannot be retrieved!",
                            104 => "The mobile verification code has been used or timed out. Please resend it!",
                            105 => "Good evening~",
                            106 => "Good morning~",
                            107 => "Good afternoon~",
                            108 => "User name",
                            109 => "Email",
                            110 => "Password",
                            111 => "Re-enter Password",
                            112 => "Email verification code",
                            113 => "To send",
                            114 => "Email address cannot be empty!",
                            115 => "The member has not been activated yet and cannot retrieve the password!",
                            116 => "Email address not bound, password cannot be retrieved!",
                            117 => "The email address does not exist!",
                            118 => "Email already bound, no need to rebind!",
                            119 => "The email already exists and cannot be bound!",
                            120 => "Required",
                            121 => "Please enter your email address correctly",
                            122 => "Sending…",
                            123 => "Image verification code",
                            124 => "Login",
                            125 => "Email verification code cannot be empty",
                            126 => "Email does not exist, password cannot be retrieved!",
                            127 => "The member email attribute has been disabled. Please contact the website administrator!",
                            128 => "Please enter the required fields",
                            129 => "Please pass in the verification token name",
                            130 => "Please pass in the array for submitting verification",
                            131 => "The data does not exist!",
                            132 => "Token data is invalid",
                            133 => "Form verification failed, please check site permission issues",
                            134 => "Fail in send",
                            135 => "Sent successfully",
                            136 => "New password",
                            137 => "Confirm new password",
                            138 => "Confirm password cannot be empty!",
                            139 => "New Customer ？",
                            140 => "Start here.",
                            141 => "Forgot Password",
                            142 => "Login",
                            143 => "Register",
                            144 => "Already have an account!",
                            145 => "password recovery",
                            146 => "Next step",
                            147 => "Back to login",
                            148 => "Reset password",
                            149 => "Submit",
                            150 => "Account",
                            151 => "Message",
                            152 => "Collection",
                            153 => "Addresses",
                            154 => "Oorder",
                            155 => "Member",
                            156 => "Safe exit",
                            157 => "You can go and see what you want to buy.",
                            158 => "Go for a walk",
                            159 => "Cart",
                            160 => "Checkout",
                            161 => "Payment",
                            162 => "Pending Payment",
                            163 => "Unpaid",
                            164 => "Paid",
                            165 => "Product",
                            166 => "Select All",
                            167 => "Quantity",
                            168 => "Subtotal",
                            169 => "Operation",
                            170 => "Delete",
                            171 => "Total Merchandise",
                            172 => "Selected",
                            173 => "Go to checkout",
                            174 => "Piece",
                            175 => "Address",
                            176 => "Chosen",
                            177 => "Edit",
                            178 => "Choose Another Address",
                            179 => "Add New Address",
                            180 => "Payment Method",
                            181 => "Delivery Method",
                            182 => "Fixed freight",
                            183 => "Order notes (optional)",
                            184 => "Cart Totals",
                            185 => "Shipping Fee",
                            186 => "Total",
                            187 => "Submit Order",
                            188 => "Order placed successfully, please pay",
                            189 => "Order number",
                            190 => "Order Total",
                            191 => "Welcome",
                            192 => "Unpaid Order",
                            193 => "View Unpaid Order",
                            194 => "Order to be shipped",
                            195 => "View Order To Be Shipped",
                            196 => "Waiting For Receipt Order",
                            197 => "View Pending Orders",
                            198 => "To Be Evaluated",
                            199 => "View Products To Be Evaluated",
                            200 => "Waiting For Shipment",
                            201 => "Waiting For Receipt",
                            202 => "Unevaluated",
                            203 => "Evaluated",
                            204 => "Address",
                            205 => "Collection",
                            206 => "Footprint",
                            207 => "Avatar",
                            208 => "Nickname",
                            209 => "Password",
                            210 => "Do not change the password by default when leaving blank",
                            211 => "Account Cancellation",
                            212 => "Save",
                            213 => "Change",
                            214 => "New Email Address",
                            215 => "Second",
                            216 => "Bind Email",
                            217 => "Title",
                            218 => "Category",
                            219 => "Batch Deletion",
                            220 => "Add Address",
                            221 => "Edit Address",
                            222 => "Are you sure you want to delete the address?",
                            223 => "Are you sure you want to set it as the default address?",
                            224 => "Phone",
                            225 => "zip Code",
                            226 => "City",
                            227 => "Country/Region",
                            228 => "Province",
                            229 => "Detailed Address",
                            230 => "Detailed address, road or street name, house number",
                            231 => "Please enter a contact person",
                            232 => "Please enter a contact number",
                            233 => "Please select the complete province or city",
                            234 => "Please enter the detailed address.",
                            235 => "Default",
                            236 => "Default",
                            237 => "Modified Successfully",
                            238 => "All Orders",
                            239 => "Completed",
                            240 => "Product and Order ",
                            241 => "Go Shopping Now",
                            242 => "Closed",
                            243 => "Waiting For Payment",
                            244 => "Completed",
                            245 => "Order Number",
                            246 => "Pay",
                            247 => "Remind To Ship",
                            248 => "Logistics Inquiry",
                            249 => "Confirm Receipt",
                            250 => "Details",
                            251 => "Evaluate The Product",
                            252 => "Cancel",
                            253 => "Place An Order",
                            254 => "Payment",
                            255 => "Delivery",
                            256 => "Complete",
                            257 => "Order Items",
                            258 => "Order Expires",
                            259 => "Order Closed",
                            260 => "Shipped",
                            261 => "Product Total",
                            262 => "Shipping Address",
                            263 => "Buyer&apos;s Message",
                            264 => "Express Delivery",
                            265 => "Buyer&apos;s Message",
                            266 => "Merchant Reply",
                            267 => "Courier Information",
                            268 => "Courier Company",
                            269 => "Logistics Tracking Number",
                            270 => "Overseas business direct hair",
                            271 => "Please fill in %s",
                            272 => "Added successfully",
                            273 => "Deleted successfully",
                            274 => "Delete failed",
                            275 => "Favorite Successfully",
                            276 => "Cancellation Successful",
                            277 => "Full name",
                            278 => "The minimum quantity of goods is 1.",
                            279 => "Delete shopping cart items: ",
                            280 => "Are you sure you want to cancel the order?",
                            281 => "Remind the administrator to ship?",
                            282 => "Confirm receipt of the goods?",
                            283 => "Evaluation and order posting",
                            284 => "Time",
                            285 => "Amount",
                            286 => "A total of ",
                            287 => " Products",
                            288 => "Enter the order number to inquire.",
                            289 => "Evaluation",
                            290 => "Evaluation",
                            291 => "Order created successfully",
                            292 => "The payment order is completed!",
                            293 => "The payment is successful and the order processing is completed!",
                            294 => "The payment was successful, but the order processing failed!",
                            295 => "Paid",
                            296 => "The order has expired!",
                            297 => "The order does not exist or has been closed!",
                            298 => "Description match",
                            299 => "Please enter your review here",
                            300 => "Upload image",
                            301 => "Limited to 6 sheets",
                            302 => "Please select all product evaluation points",
                            303 => "Please fill in all product reviews",
                            304 => "The order has been evaluated.",
                            305 => "Evaluation Success",
                            306 => "Evaluation failed, please try again",
                            307 => "My Evaluation",
                            308 => "Evaluation Time",
                            309 => "Bad Review",
                            310 => "Medium Review",
                            311 => "Praise",
                            312 => "View Reviews",
                            326 => "My Footsteps",
                            327 => "Access Time",
                            328 => "Confirm batch deletion of browsing history?",
                            329 => "Are you sure you want to delete this browsing history?",
                            330 => "Reminder of success!",
                            331 => "[Discontinued]",
                            332 => "The order does not exist.",
                            333 => "Unpaid",
                            334 => "Online payment",
                            335 => "The order has been cancelled.",
                            336 => "The product does not exist or has been removed from the shelves!",
                            337 => "The order payment is abnormal, please refresh and place a new order~",
                            338 => "The item has been sold out.",
                            339 => "Exceeds commodity inventory",
                            340 => "Sign out",
                            341 => "Register",
                            346 => "The order has been paid and will be redirected soon.",
                            347 => "The order has expired and will be redirected soon.",
                            348 => "The order has been closed and will be redirected soon.",
                            349 => "The order does not exist or has been changed",
                            350 => "Order processing is in progress.",
                            351 => "Order payment is in progress.",
                            352 => "Price",
                            353 => "A maximum of 6 images are allowed to be uploaded",
                            354 => "Or drag files here, up to %s can be selected this time",
                            355 => "Click to select picture",
                            356 => "Total %s (%s), %s uploaded",
                            357 => "Keep Adding",
                            358 => "Confirm To Use",
                            359 => "The email address is prohibited from registration by the system!",
                            360 => "Notes about your order, e.g. special notes for delivery.",
                        ],
                        'zh' => [
                            58 => "您的購物車還沒有商品！",
                            59 => "%s不能為空！",
                            60 => "%s格式不正確！",
                            61 => "郵箱驗證碼已被使用或超時，請重新發送！",
                            62 => "郵箱驗證碼不正確，請重新輸入！",
                            63 => "簡訊驗證碼不正確，請重新輸入！",
                            64 => "%s已存在！",
                            65 => "簽到成功",
                            66 => "今日已簽過到",
                            67 => "是否删除該收藏？",
                            68 => "確認批量删除收藏？",
                            69 => "每日簽到",
                            70 => "充值金額不能為空！",
                            71 => "請輸入正確的充值金額！",
                            72 => "請選擇支付方式！",
                            73 => "用戶名不能為空！",
                            74 => "用戶名不正確！",
                            75 => "密碼不能為空！",
                            76 => "圖片驗證碼不能為空！",
                            77 => "圖片驗證碼錯誤",
                            78 => "前臺禁止管理員登錄！",
                            79 => "該會員尚未啟動，請聯系管理員！",
                            80 => "管理員稽核中，請稍等！",
                            81 => "登錄成功",
                            82 => "密碼不正確！",
                            83 => "該用戶名不存在，請註冊！",
                            84 => "看不清？點擊更換驗證碼",
                            85 => "手機號碼不能為空！",
                            86 => "手機號碼格式不正確！",
                            87 => "手機驗證碼不能為空！",
                            88 => "手機驗證碼已失效！",
                            89 => "手機號碼已經注册！",
                            90 => "用戶名為系統禁止注册！",
                            91 => "請輸入2-30位的漢字、英文、數字、下劃線等組合",
                            92 => "登錄密碼不能為空！",
                            93 => "重複密碼不能為空！",
                            94 => "用戶名已存在",
                            95 => "兩次密碼輸入不一致！",
                            96 => "注册成功，正在跳轉中……",
                            97 => "注册成功，等管理員啟動才能登錄！",
                            98 => "注册成功，請登錄！",
                            99 => "昵稱不可為純空格",
                            100 => "原密碼不能為空！",
                            101 => "新密碼不能為空！",
                            102 => "手機號碼不存在，不能找回密碼！",
                            103 => "手機號碼未綁定，不能找回密碼！",
                            104 => "手機驗證碼已被使用或超時，請重新發送！",
                            105 => "晚上好～",
                            106 => "早上好～",
                            107 => "下午好～",
                            108 => "用戶名",
                            109 => "郵箱地址",
                            110 => "密碼",
                            111 => "確認密碼",
                            112 => "郵箱驗證碼",
                            113 => "點擊發送",
                            114 => "郵箱地址不能為空！",
                            115 => "該會員尚未啟動，不能找回密碼！",
                            116 => "郵箱地址未綁定，不能找回密碼！",
                            117 => "郵箱地址不存在！",
                            118 => "郵箱已綁定，無需重新綁定！",
                            119 => "郵箱已經存在，不可以綁定！",
                            120 => "必填",
                            121 => "請正確輸入郵箱地址",
                            122 => "發送中…",
                            123 => "圖片驗證碼",
                            124 => "登錄",
                            125 => "郵箱驗證碼不能為空",
                            126 => "郵箱不存在，不能找回密碼！",
                            127 => "會員郵箱内容已關閉，請聯系網站管理員！",
                            128 => "請傳入必填項欄位",
                            129 => "請傳入驗證token名稱",
                            130 => "請傳入提交驗證的數組",
                            131 => "數據不存在！",
                            132 => "權杖數據無效",
                            133 => "表單校驗失敗，請檢查網站許可權問題",
                            134 => "發送失敗",
                            135 => "發送成功",
                            136 => "新密碼",
                            137 => "確認新密碼",
                            138 => "確認密碼不能為空！",
                            139 => "新客戶？",
                            140 => "從這裏開始",
                            141 => "忘記密碼",
                            142 => "賬號登錄",
                            143 => "創建賬號",
                            144 => "已有賬號!",
                            145 => "找回密碼",
                            146 => "下一步",
                            147 => "返回登錄",
                            148 => "重置密碼",
                            149 => "確認提交",
                            150 => "個人中心",
                            151 => "我的信息",
                            152 => "我的收藏",
                            153 => "收貨地址",
                            154 => "我的訂單",
                            155 => "會員中心",
                            156 => "安全退出",
                            157 => "您可以去看看有哪些想買的",
                            158 => "去逛逛",
                            159 => "購物車",
                            160 => "結賬",
                            161 => "付款",
                            162 => "待付款",
                            163 => "未付款",
                            164 => "已付款",
                            165 => "商品",
                            166 => "全選",
                            167 => "數量",
                            168 => "小計",
                            169 => "操作",
                            170 => "刪除",
                            171 => "商品總計",
                            172 => "已選",
                            173 => "去結賬",
                            174 => "件",
                            175 => "配送地址",
                            176 => "已選擇",
                            177 => "編輯",
                            178 => "選擇其他地址",
                            179 => "添加新地址",
                            180 => "支付方式",
                            181 => "配送方式",
                            182 => "固定運費",
                            183 => "訂單備註",
                            184 => "購物車總數",
                            185 => "運費",
                            186 => "應付總金額",
                            187 => "提交訂單",
                            188 => "訂單提交成功，請付款",
                            189 => "訂單編號",
                            190 => "應付金額",
                            191 => "歡迎",
                            192 => "待付款的訂單",
                            193 => "查看待付款訂單",
                            194 => "待發貨的訂單",
                            195 => "查看待發貨訂單",
                            196 => "待收貨的訂單",
                            197 => "查看待收貨訂單",
                            198 => "待評價商品數",
                            199 => "查看待評價商品",
                            200 => "待發貨",
                            201 => "待收貨",
                            202 => "待評價",
                            203 => "已評價",
                            204 => "地址",
                            205 => "收藏",
                            206 => "足跡",
                            207 => "頭像",
                            208 => "暱稱",
                            209 => "修改密碼",
                            210 => "留空時默認不修改密碼",
                            211 => "賬號註銷",
                            212 => "保存",
                            213 => "更改",
                            214 => "新的邮箱地址",
                            215 => "秒",
                            216 => "綁定郵箱",
                            217 => "標題",
                            218 => "分類",
                            219 => "批量刪除",
                            220 => "添加地址",
                            221 => "編輯地址",
                            222 => "确定要删除地址吗？",
                            223 => "确定要設置爲默認地址?",
                            224 => "電話號碼",
                            225 => "郵編",
                            226 => "城市",
                            227 => "國家/地區",
                            228 => "省份",
                            229 => "詳細地址",
                            230 => "詳細地址，路名或街道名稱，門牌號",
                            231 => "請輸入聯繫人",
                            232 => "請輸入聯繫電話",
                            233 => "請選擇完整省市區",
                            234 => "請輸入詳細地址",
                            235 => "設爲默認",
                            236 => "默認地址",
                            237 => "修改成功",
                            238 => "全部訂單",
                            239 => "已完成",
                            240 => "輸入商品名稱、訂單號",
                            241 => "馬上去購物",
                            242 => "已關閉",
                            243 => "等待付款",
                            244 => "已完成",
                            245 => "訂單號",
                            246 => "立即付款",
                            247 => "提醒發貨",
                            248 => "物流查詢",
                            249 => "確認收貨",
                            250 => "訂單詳情",
                            251 => "評價商品",
                            252 => "取消訂單",
                            253 => "下單",
                            254 => "付款",
                            255 => "發貨",
                            256 => "完成",
                            257 => "訂購商品",
                            258 => "訂單過期",
                            259 => "訂單關閉",
                            260 => "已發貨",
                            261 => "商品總價",
                            262 => "配送地址",
                            263 => "買家留言",
                            264 => "快遞配送",
                            265 => "買家留言",
                            266 => "商家回覆",
                            267 => "快遞信息",
                            268 => "快遞公司",
                            269 => "物流單號",
                            270 => "海外商直髮",
                            271 => "請填寫%s",
                            272 => "添加成功",
                            273 => "刪除成功",
                            274 => "刪除失敗",
                            275 => "收藏成功",
                            276 => "取消成功",
                            277 => "全名",
                            278 => "商品數量最少爲1",
                            279 => "確定刪除購物車商品: ",
                            280 => "確定要取消訂單?",
                            281 => "提醒管理員發貨？",
                            282 => "確認已收到貨物？",
                            283 => "評價曬單",
                            284 => "下單時間",
                            285 => "實付金額",
                            286 => "共 ",
                            287 => " 種商品",
                            288 => "輸入訂單號查詢",
                            289 => "立即評價",
                            290 => "評價服務",
                            291 => "訂單創建成功",
                            292 => "支付訂單完成！",
                            293 => "支付成功，處理訂單完成！",
                            294 => "支付成功，處理訂單失敗！",
                            295 => "已支付",
                            296 => "該訂單已過期！",
                            297 => "該訂單不存在或已關閉！",
                            298 => "描述相符",
                            299 => "請在此處輸入您的評價",
                            300 => "上傳圖片",
                            301 => "限6張",
                            302 => "請選擇全部商品評價分",
                            303 => "請填寫全部商品評價內容",
                            304 => "訂單已評價過",
                            305 => "評價成功",
                            306 => "評價失敗，請重試",
                            307 => "我的评价",
                            308 => "评价时间",
                            309 => "差评",
                            310 => "中评",
                            311 => "好评",
                            312 => "查看評價",
                            326 => "我的足跡",
                            327 => "訪問時間",
                            328 => "確認批量刪除瀏覽記錄？",
                            329 => "確認刪除該瀏覽記錄？",
                            330 => "提醒成功！",
                            331 => "[商品已停售]",
                            332 => "訂單不存在",
                            333 => "未支付",
                            334 => "在線支付",
                            335 => "訂單已取消",
                            336 => "該商品不存在或已下架！",
                            337 => "訂單支付異常，請刷新重新下單~",
                            338 => "商品已售罄",
                            339 => "超出商品庫存",
                            340 => "退出登錄",
                            341 => "註冊賬號",
                            346 => "訂單已支付，即將跳轉",
                            347 => "訂單已過期，即將跳轉",
                            348 => "訂單已關閉，即將跳轉",
                            349 => "訂單不存在或已變更",
                            350 => "訂單處理中",
                            351 => "訂單支付中",
                            352 => "價格",
                            353 => "最多允許上傳6張圖片",
                            354 => "或將文件拖到這裏，本次最多可選%s個",
                            355 => "點擊選擇圖片",
                            356 => "共%s張（%s），已上傳%s張",
                            357 => "繼續添加",
                            358 => "確定使用",
                            359 => "郵箱地址為系統禁止注册！",
                            360 => "關於您的訂單的說明，例如交貨的特殊說明。",
                        ],
                    ];
                    foreach ($data as $mark => $val) {
                        foreach ($val as $_k => $_v) {
                            $info['pack_id'] = $_k;
                            $info['name'] = 'users' . $info['pack_id'];
                            $info['value'] = $_v;
                            $info['type'] = 5;
                            $info['is_system'] = 1;
                            $info['lang'] = $mark;
                            $info['sort_order'] = 100;
                            $info['add_time'] = $time;
                            $info['update_time'] = $time;
                            $val[$_k] = $info;
                        }
                        $data[$mark] = $val;
                    }
                    $addData = [];
                    foreach ($data as $mark => $sub) {
                        if (in_array($mark, ['cn','en','zh']) && isset($row[$mark])) {
                            foreach ($sub as $_k => $_v) {
                                if (!isset($row[$mark][$_v['pack_id']])) {
                                    $_v['lang'] = $mark;
                                    $addData[] = $_v;
                                }
                            }
                        }
                    }
                    if (!empty($addData)) {
                        $r = Db::name('language_pack')->insertAll($addData);
                    }

                    // 同步默认语言数据到其他语言里
                    if ($r !== false) {
                        $row = Db::name('language_pack')->field('auto_id', true)->where(['is_system'=>1])->order('lang asc, pack_id asc')->select();
                        $new_arr = array();
                        foreach ($row as $k => $v) {
                            $new_arr[$v['lang']][$v['pack_id']] = $v;
                        }
                        $row =  $new_arr;
                        $data = empty($row[$default_lang]) ? current($row) : $row[$default_lang];

                        $synAddData = [];
                        foreach ($langSysRow as $key => $val) {
                            foreach ($data as $_k => $_v) {
                                if (!isset($row[$val['mark']][$_v['pack_id']])) {
                                    $_v['lang'] = $val['mark'];
                                    $synAddData[] = $_v;
                                }
                            }
                        }
                        if (!empty($synAddData)) {
                            $r = Db::name('language_pack')->insertAll($synAddData);
                        }
                    }
                }
                if ($r !== false) {
                    // 更新语言包变量文件
                    model('LanguagePack')->updateLangFile();
                    zanSetting('syn', ['syn_admin_logic_1733130636'=>1]);
                }
            }catch(\Exception $e){}
        }
    }

    // 升级v2.0.3版本要处理的数据
    private function eyou_v203_handle_data($langRow = [], $langSysRow = [])
    {
        $Prefix = config('database.prefix');
        $default_lang = Db::name('language')->where(['is_admin_default' => 1])->getField('mark');

        // 完善 users_level 表内置数据
        $syn_admin_logic_1732171330 = zanSetting('syn.syn_admin_logic_1732171330');
        if (empty($syn_admin_logic_1732171330)) {
            try{
                $r = true;
                $row = Db::name('users_level')->field('auto_id', true)->order('lang asc')->select();
                if (!empty($row)) {
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['level_id']] = $v;
                    }
                    $row =  $new_arr;
                } else {
                    $row = [];
                }

                $data = [
                    'cn' => [
                        1 => [
                            'level_id' => 1,
                            'level_name' => '注册会员',
                            'level_value' => 10,
                            'is_system' => 1,
                            'amount' => 0,
                            'down_count' => 100,
                            'discount_type' => 1,
                            'discount' => 100,
                            'posts_count' => 5,
                            'ask_is_release' => 1,
                            'ask_is_review' => 0,
                            'upgrade_type' => 0,
                            'upgrade_order_money' => 0,
                            'status' => 1,
                            'lang' => 'cn',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        2 => [
                            'level_id' => 2,
                            'level_name' => '中级会员',
                            'level_value' => 50,
                            'is_system' => 0,
                            'amount' => 0,
                            'down_count' => 100,
                            'discount_type' => 1,
                            'discount' => 100,
                            'posts_count' => 10,
                            'ask_is_release' => 1,
                            'ask_is_review' => 0,
                            'upgrade_type' => 0,
                            'upgrade_order_money' => 0,
                            'status' => 1,
                            'lang' => 'cn',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        3 => [
                            'level_id' => 3,
                            'level_name' => '高级会员',
                            'level_value' => 100,
                            'is_system' => 0,
                            'amount' => 0,
                            'down_count' => 100,
                            'discount_type' => 1,
                            'discount' => 100,
                            'posts_count' => 20,
                            'ask_is_release' => 1,
                            'ask_is_review' => 0,
                            'upgrade_type' => 0,
                            'upgrade_order_money' => 0,
                            'status' => 1,
                            'lang' => 'cn',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                    ],
                    'en' => [
                        1 => [
                            'level_id' => 1,
                            'level_name' => 'Register Member',
                            'level_value' => 10,
                            'is_system' => 1,
                            'amount' => 0,
                            'down_count' => 100,
                            'discount_type' => 1,
                            'discount' => 100,
                            'posts_count' => 5,
                            'ask_is_release' => 1,
                            'ask_is_review' => 0,
                            'upgrade_type' => 0,
                            'upgrade_order_money' => 0,
                            'status' => 1,
                            'lang' => 'en',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        2 => [
                            'level_id' => 2,
                            'level_name' => 'Intermediate Member ',
                            'level_value' => 50,
                            'is_system' => 0,
                            'amount' => 0,
                            'down_count' => 100,
                            'discount_type' => 1,
                            'discount' => 100,
                            'posts_count' => 10,
                            'ask_is_release' => 1,
                            'ask_is_review' => 0,
                            'upgrade_type' => 0,
                            'upgrade_order_money' => 0,
                            'status' => 1,
                            'lang' => 'en',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        3 => [
                            'level_id' => 3,
                            'level_name' => 'Premium Membership',
                            'level_value' => 100,
                            'is_system' => 0,
                            'amount' => 0,
                            'down_count' => 100,
                            'discount_type' => 1,
                            'discount' => 100,
                            'posts_count' => 20,
                            'ask_is_release' => 1,
                            'ask_is_review' => 0,
                            'upgrade_type' => 0,
                            'upgrade_order_money' => 0,
                            'status' => 1,
                            'lang' => 'en',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                    ],
                    'zh' => [
                        1 => [
                            'level_id' => 1,
                            'level_name' => '註冊會員',
                            'level_value' => 10,
                            'is_system' => 1,
                            'amount' => 0,
                            'down_count' => 100,
                            'discount_type' => 1,
                            'discount' => 100,
                            'posts_count' => 5,
                            'ask_is_release' => 1,
                            'ask_is_review' => 0,
                            'upgrade_type' => 0,
                            'upgrade_order_money' => 0,
                            'status' => 1,
                            'lang' => 'zh',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        2 => [
                            'level_id' => 2,
                            'level_name' => '中級會員',
                            'level_value' => 50,
                            'is_system' => 0,
                            'amount' => 0,
                            'down_count' => 100,
                            'discount_type' => 1,
                            'discount' => 100,
                            'posts_count' => 10,
                            'ask_is_release' => 1,
                            'ask_is_review' => 0,
                            'upgrade_type' => 0,
                            'upgrade_order_money' => 0,
                            'status' => 1,
                            'lang' => 'zh',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        3 => [
                            'level_id' => 3,
                            'level_name' => '高級會員',
                            'level_value' => 100,
                            'is_system' => 0,
                            'amount' => 0,
                            'down_count' => 100,
                            'discount_type' => 1,
                            'discount' => 100,
                            'posts_count' => 20,
                            'ask_is_release' => 1,
                            'ask_is_review' => 0,
                            'upgrade_type' => 0,
                            'upgrade_order_money' => 0,
                            'status' => 1,
                            'lang' => 'zh',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                    ],
                ];
                $addData = [];
                foreach ($langRow as $key => $val) {
                    $synData = [];
                    if (!empty($data[$val['mark']])) {
                        $synData = $data[$val['mark']];
                    } else {
                        $synData = empty($data[$default_lang]) ? $data['en'] : $data[$default_lang];
                    }
                    foreach ($synData as $_k => $_v) {
                        if (!isset($row[$val['mark']][$_v['level_id']])) {
                            $_v['lang'] = $val['mark'];
                            $addData[] = $_v;
                        }
                    }
                }
                if (!empty($addData)) {
                    $r = Db::name('users_level')->insertAll($addData);
                }
                if ($r !== false) {
                    zanSetting('syn', ['syn_admin_logic_1732171330'=>1]);
                }
            }catch(\Exception $e){}
        }

        // 完善 users_parameter 表内置数据
        $syn_admin_logic_1732153126 = zanSetting('syn.syn_admin_logic_1732153126');
        if (empty($syn_admin_logic_1732153126)) {
            try{
                $r = true;
                $row = Db::name('users_parameter')->field('auto_id', true)->order('lang asc')->select();
                if (!empty($row)) {
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['para_id']] = $v;
                    }
                    $row =  $new_arr;
                } else {
                    $row = [];
                }

                $data = [
                    'cn' => [
                        1 => [
                            'para_id' => 1,
                            'title' => '手机号码',
                            'name' => 'mobile_1',
                            'dtype' => 'mobile',
                            'dfvalue' => '',
                            'is_system' => 1,
                            'is_hidden' => 1,
                            'is_required' => 0,
                            'is_reg' => 0,
                            'placeholder' => '',
                            'sort_order' => 1,
                            'lang' => 'cn',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        2 => [
                            'para_id' => 2,
                            'title' => '邮箱地址',
                            'name' => 'email_2',
                            'dtype' => 'email',
                            'dfvalue' => '',
                            'is_system' => 1,
                            'is_hidden' => 0,
                            'is_required' => 1,
                            'is_reg' => 1,
                            'placeholder' => '',
                            'sort_order' => 2,
                            'lang' => 'cn',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                    ],
                    'en' => [
                        1 => [
                            'para_id' => 1,
                            'title' => 'Mobile',
                            'name' => 'mobile_1',
                            'dtype' => 'mobile',
                            'dfvalue' => '',
                            'is_system' => 1,
                            'is_hidden' => 1,
                            'is_required' => 0,
                            'is_reg' => 0,
                            'placeholder' => '',
                            'sort_order' => 1,
                            'lang' => 'en',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        2 => [
                            'para_id' => 2,
                            'title' => 'Email',
                            'name' => 'email_2',
                            'dtype' => 'email',
                            'dfvalue' => '',
                            'is_system' => 1,
                            'is_hidden' => 0,
                            'is_required' => 1,
                            'is_reg' => 1,
                            'placeholder' => '',
                            'sort_order' => 2,
                            'lang' => 'en',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                    ],
                    'zh' => [
                        1 => [
                            'para_id' => 1,
                            'title' => '手機號碼',
                            'name' => 'mobile_1',
                            'dtype' => 'mobile',
                            'dfvalue' => '',
                            'is_system' => 1,
                            'is_hidden' => 1,
                            'is_required' => 0,
                            'is_reg' => 0,
                            'placeholder' => '',
                            'sort_order' => 1,
                            'lang' => 'zh',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        2 => [
                            'para_id' => 2,
                            'title' => '郵箱地址',
                            'name' => 'email_2',
                            'dtype' => 'email',
                            'dfvalue' => '',
                            'is_system' => 1,
                            'is_hidden' => 0,
                            'is_required' => 1,
                            'is_reg' => 1,
                            'placeholder' => '',
                            'sort_order' => 2,
                            'lang' => 'zh',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                    ],
                ];
                $addData = [];
                foreach ($langRow as $key => $val) {
                    $synData = [];
                    if (!empty($data[$val['mark']])) {
                        $synData = $data[$val['mark']];
                    } else {
                        $synData = empty($data[$default_lang]) ? $data['en'] : $data[$default_lang];
                    }
                    foreach ($synData as $_k => $_v) {
                        if (!isset($row[$val['mark']][$_v['para_id']])) {
                            $_v['lang'] = $val['mark'];
                            $addData[] = $_v;
                        }
                    }
                }
                if (!empty($addData)) {
                    $r = Db::name('users_parameter')->insertAll($addData);
                }
                if ($r !== false) {
                    zanSetting('syn', ['syn_admin_logic_1732153126'=>1]);
                }
            }catch(\Exception $e){}
        }

        // 完善 smtp_tpl 表内置数据
        $syn_admin_logic_1732153127 = zanSetting('syn.syn_admin_logic_1732153127');
        if (empty($syn_admin_logic_1732153127)) {
            try{
                $r = true;
                $row = Db::name('smtp_tpl')->field('tpl_id', true)->order('lang asc')->select();
                if (!empty($row)) {
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['send_scene']] = $v;
                    }
                    $row =  $new_arr;
                } else {
                    $row = [];
                }

                $data = [
                    'cn' => [
                        1 => [
                            'tpl_name' => '询盘通知',
                            'tpl_title' => '您有新的询盘消息，请查收！',
                            'tpl_content' => '${content}',
                            'send_scene' => 1,
                            'is_open' => 1,
                            'lang' => 'cn',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        2 => [
                            'tpl_name' => '会员注册',
                            'tpl_title' => '验证码已发送至您的邮箱，请登录邮箱查看验证码！',
                            'tpl_content' => '${content}',
                            'send_scene' => 2,
                            'is_open' => 1,
                            'lang' => 'cn',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        3 => [
                            'tpl_name' => '绑定邮箱',
                            'tpl_title' => '验证码已发送至您的邮箱，请登录邮箱查看验证码！',
                            'tpl_content' => '${content}',
                            'send_scene' => 3,
                            'is_open' => 1,
                            'lang' => 'cn',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        4 => [
                            'tpl_name' => '找回密码',
                            'tpl_title' => '验证码已发送至您的邮箱，请登录邮箱查看验证码！',
                            'tpl_content' => '${content}',
                            'send_scene' => 4,
                            'is_open' => 1,
                            'lang' => 'cn',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        5 => [
                            'tpl_name' => '订单付款',
                            'tpl_title' => '您有新的待发货订单消息，请到商城订单查看！',
                            'tpl_content' => '${content}',
                            'send_scene' => 5,
                            'is_open' => 1,
                            'lang' => 'cn',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        6 => [
                            'tpl_name' => '订单发货',
                            'tpl_title' => '您有新的待收货订单消息，请到会员订单查看！',
                            'tpl_content' => '${content}',
                            'send_scene' => 6,
                            'is_open' => 1,
                            'lang' => 'cn',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                    ],
                    'en' => [
                        1 => [
                            'tpl_name' => 'Inquiry Notice',
                            'tpl_title' => 'You have new inquiry messages, please check them!',
                            'tpl_content' => '${content}',
                            'send_scene' => 1,
                            'is_open' => 1,
                            'lang' => 'en',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        2 => [
                            'tpl_name' => 'Member Registration',
                            'tpl_title' => 'The verification code has been sent to your email. Please log in to your email to check the verification code!',
                            'tpl_content' => '${content}',
                            'send_scene' => 2,
                            'is_open' => 1,
                            'lang' => 'en',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        3 => [
                            'tpl_name' => 'Bind email',
                            'tpl_title' => 'The verification code has been sent to your email. Please log in to your email to check the verification code!',
                            'tpl_content' => '${content}',
                            'send_scene' => 3,
                            'is_open' => 1,
                            'lang' => 'en',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        4 => [
                            'tpl_name' => 'Retrieve password',
                            'tpl_title' => 'The verification code has been sent to your email. Please log in to your email to check the verification code!',
                            'tpl_content' => '${content}',
                            'send_scene' => 4,
                            'is_open' => 1,
                            'lang' => 'en',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        5 => [
                            'tpl_name' => 'Order payment',
                            'tpl_title' => 'You have new pending shipment order messages, please check the orders in the mall!',
                            'tpl_content' => '${content}',
                            'send_scene' => 5,
                            'is_open' => 1,
                            'lang' => 'en',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        6 => [
                            'tpl_name' => 'Order shipment',
                            'tpl_title' => 'You have new pending orders, please check the member orders!',
                            'tpl_content' => '${content}',
                            'send_scene' => 6,
                            'is_open' => 1,
                            'lang' => 'en',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                    ],
                    'zh' => [
                        1 => [
                            'tpl_name' => '詢盤通知',
                            'tpl_title' => '您有新的詢盤消息，請查收！',
                            'tpl_content' => '${content}',
                            'send_scene' => 1,
                            'is_open' => 1,
                            'lang' => 'zh',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        2 => [
                            'tpl_name' => '會員注册',
                            'tpl_title' => '驗證碼已發送至您的郵箱，請登入郵箱查看驗證碼！',
                            'tpl_content' => '${content}',
                            'send_scene' => 2,
                            'is_open' => 1,
                            'lang' => 'zh',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        3 => [
                            'tpl_name' => '綁定郵箱',
                            'tpl_title' => '驗證碼已發送至您的郵箱，請登入郵箱查看驗證碼！',
                            'tpl_content' => '${content}',
                            'send_scene' => 3,
                            'is_open' => 1,
                            'lang' => 'zh',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        4 => [
                            'tpl_name' => '找回密碼',
                            'tpl_title' => '驗證碼已發送至您的郵箱，請登入郵箱查看驗證碼！',
                            'tpl_content' => '${content}',
                            'send_scene' => 4,
                            'is_open' => 1,
                            'lang' => 'zh',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        5 => [
                            'tpl_name' => '訂單付款',
                            'tpl_title' => '您有新的待發貨訂單消息，請到商城訂單查看！',
                            'tpl_content' => '${content}',
                            'send_scene' => 5,
                            'is_open' => 1,
                            'lang' => 'zh',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                        6 => [
                            'tpl_name' => '訂單發貨',
                            'tpl_title' => '您有新的待收貨訂單消息，請到會員訂單查看！',
                            'tpl_content' => '${content}',
                            'send_scene' => 6,
                            'is_open' => 1,
                            'lang' => 'zh',
                            'add_time' => getTime(),
                            'update_time' => getTime(),
                        ],
                    ],
                ];
                $addData = [];
                foreach ($langRow as $key => $val) {
                    $synData = [];
                    if (!empty($data[$val['mark']])) {
                        $synData = $data[$val['mark']];
                    } else {
                        $synData = empty($data[$default_lang]) ? $data['en'] : $data[$default_lang];
                    }
                    foreach ($synData as $_k => $_v) {
                        if (!isset($row[$val['mark']][$_v['send_scene']])) {
                            $_v['lang'] = $val['mark'];
                            // 保持与中文一样的文案 start
                            // $_v['tpl_name'] = $data['cn'][$_v['send_scene']]['tpl_name'];
                            // $_v['tpl_title'] = $data['cn'][$_v['send_scene']]['tpl_title'];
                            // 保持与中文一样的文案 end
                            $addData[] = $_v;
                        }
                    }
                }
                if (!empty($addData)) {
                    $r = Db::name('smtp_tpl')->insertAll($addData);
                }
                if ($r !== false) {
                    zanSetting('syn', ['syn_admin_logic_1732153127'=>1]);
                }
            }catch(\Exception $e){}
        }

        $syn_admin_logic_1732517850 = zanSetting('syn.syn_admin_logic_1732517850');
        if (empty($syn_admin_logic_1732517850)) {
            try{
                $param = [];
                // 编辑器防注入
                $param['web_xss_filter'] = tpCache('web.web_xss_filter');
                $web_xss_words = ['union','delete','outfile','char','concat','truncate','insert','revoke','grant','replace','rename','declare','exec','delimiter','phar','eval','onerror','script'];
                $param['web_xss_words'] = implode(PHP_EOL, $web_xss_words);
                // 网站防止被刷
                $param['web_anti_brushing'] = tpCache('web.web_anti_brushing');
                $param['web_anti_words'] = implode(PHP_EOL, ['wd']);
                /*-------------------后台安全配置 end-------------------*/
                foreach ($langRow as $key => $val) {
                    tpCache('web', $param, $val['mark']);
                }
                zanSetting('syn', ['syn_admin_logic_1732517850'=>1]);
            }catch(\Exception $e){}
        }
    }

    // 升级v2.0.2版本要处理的数据
    private function eyou_v202_handle_data($langRow = [], $langSysRow = [])
    {
        $Prefix = config('database.prefix');

        // 完善 users_config 表内置数据
        $syn_admin_logic_1731317074 = zanSetting('syn.syn_admin_logic_1731317074');
        if (empty($syn_admin_logic_1731317074)) {
            try{
                // 清空表数据
                Db::name('users_config')->where(['id'=>['gt', 0]])->delete(true);
                @Db::execute("ALTER TABLE `{$Prefix}users_config` AUTO_INCREMENT 1");

                // 添加内置语言数据
                $r = true;
                $row = Db::name('users_config')->field('id', true)->order('lang asc')->select();
                if (!empty($row)) {
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['name']] = $v;
                    }
                    $row =  $new_arr;
                } else {
                    $row = [];
                }

                $time = getTime();
                $data = [
                    'users_reg_notallow' => [
                        'name' => 'users_reg_notallow',
                        'value' => 'www,bbs,ftp,mail,user,users,admin,administrator,zancms',
                        'desc' => '不允许注册的会员名',
                        'inc_type' => 'users',
                        'update_time' => $time,
                    ],
                    'users_open_release' => [
                        'name' => 'users_open_release',
                        'value' => 1,
                        'desc' => '',
                        'inc_type' => 'users',
                        'update_time' => $time,
                    ],
                    'users_open_register' => [
                        'name' => 'users_open_register',
                        'value' => 0,
                        'desc' => '',
                        'inc_type' => 'users',
                        'update_time' => $time,
                    ],
                    'users_open_reg' => [
                        'name' => 'users_open_reg',
                        'value' => 0,
                        'desc' => '',
                        'inc_type' => 'users',
                        'update_time' => $time,
                    ],
                    'users_verification' => [
                        'name' => 'users_verification',
                        'value' => 0,
                        'desc' => '',
                        'inc_type' => 'users',
                        'update_time' => $time,
                    ],
                    'users_login_expiretime' => [
                        'name' => 'users_login_expiretime',
                        'value' => 3600,
                        'desc' => '',
                        'inc_type' => 'users',
                        'update_time' => $time,
                    ],
                    'shop_open' => [
                        'name' => 'shop_open',
                        'value' => 0,
                        'desc' => '',
                        'inc_type' => 'shop',
                        'update_time' => $time,
                    ],
                    'shop_open_spec' => [
                        'name' => 'shop_open_spec',
                        'value' => 0,
                        'desc' => '',
                        'inc_type' => 'shop',
                        'update_time' => $time,
                    ],
                    'score_signin_status' => [
                        'name' => 'score_signin_status',
                        'value' => 1,
                        'desc' => '',
                        'inc_type' => 'score',
                        'update_time' => $time,
                    ],
                    'score_signin_score' => [
                        'name' => 'score_signin_score',
                        'value' => 3,
                        'desc' => '',
                        'inc_type' => 'score',
                        'update_time' => $time,
                    ],
                    'score_name' => [
                        'name' => 'score_name',
                        'value' => '积分',
                        'desc' => '',
                        'inc_type' => 'score',
                        'update_time' => $time,
                    ],
                    'score_intro' => [
                        'name' => 'score_intro',
                        'value' => 'a) 积分不可兑现、不可转让,仅可在本平台使用;\r\nb) 您在本平台参加特定活动也可使用积分,详细使用规则以具体活动时的规则为准;\r\nc) 积分的数值精确到个位(小数点后全部舍弃,不进行四舍五入)\r\nd) 买家在完成该笔交易(订单状态为“已签收”)后才能得到此笔交易的相应积分,如购买商品参加店铺其他优惠,则优惠的金额部分不享受积分获取;',
                        'desc' => '',
                        'inc_type' => 'score',
                        'update_time' => $time,
                    ],
                    'pay_open' => [
                        'name' => 'pay_open',
                        'value' => 1,
                        'desc' => '',
                        'inc_type' => 'pay',
                        'update_time' => $time,
                    ],
                    'pay_balance_open' => [
                        'name' => 'pay_balance_open',
                        'value' => 1,
                        'desc' => '',
                        'inc_type' => 'pay',
                        'update_time' => $time,
                    ],
                    'order_right_protect_time' => [
                        'name' => 'order_right_protect_time',
                        'value' => 7,
                        'desc' => '',
                        'inc_type' => 'order',
                        'update_time' => $time,
                    ],
                    'memgift_open' => [
                        'name' => 'memgift_open',
                        'value' => 0,
                        'desc' => '',
                        'inc_type' => 'memgift',
                        'update_time' => $time,
                    ],
                    'level_member_upgrade' => [
                        'name' => 'level_member_upgrade',
                        'value' => 1,
                        'desc' => '',
                        'inc_type' => 'level',
                        'update_time' => $time,
                    ],
                ];
                $addData = [];
                foreach ($langRow as $key => $val) {
                    foreach ($data as $_k => $_v) {
                        if (!isset($row[$_v['name']])) {
                            $_v['lang'] = $val['mark'];
                            $addData[] = $_v;
                        }
                    }
                }
                if (!empty($addData)) {
                    $r = Db::name('users_config')->insertAll($addData);
                }
                if ($r !== false) {
                    zanSetting('syn', ['syn_admin_logic_1731317074'=>1]);
                }
            }catch(\Exception $e){}
        }

        // 完善 language_pack 表内置数据
        $syn_admin_logic_1731319559 = zanSetting('syn.syn_admin_logic_1731319559');
        if (empty($syn_admin_logic_1731319559)) {
            try{
                $r = true;
                $row = Db::name('language_pack')->field('auto_id', true)->where(['is_system'=>1])->order('lang asc, pack_id asc')->select();
                if (!empty($row)) {
                    // 添加内置 cn、en、zh 语言数据
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['pack_id']] = $v;
                    }
                    $row =  $new_arr;

                    $data = [
                        'cn' => [
                            55 => [
                                'pack_id' => 55,
                                'type' => 4,
                                'name' => 'crumb55',
                                'value' => '产品详情',
                                'is_system' => 1,
                                'lang' => 'cn',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                            56 => [
                                'pack_id' => 56,
                                'type' => 3,
                                'name' => 'gbook56',
                                'value' => '提交',
                                'is_system' => 1,
                                'lang' => 'cn',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                            57 => [
                                'pack_id' => 57,
                                'type' => 4,
                                'name' => 'crumb57',
                                'value' => '全部案例',
                                'is_system' => 1,
                                'lang' => 'cn',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                        ],
                        'en' => [
                            55 => [
                                'pack_id' => 55,
                                'type' => 4,
                                'name' => 'crumb55',
                                'value' => 'Product Details',
                                'is_system' => 1,
                                'lang' => 'en',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                            56 => [
                                'pack_id' => 56,
                                'type' => 3,
                                'name' => 'gbook56',
                                'value' => 'Submit',
                                'is_system' => 1,
                                'lang' => 'en',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                            57 => [
                                'pack_id' => 57,
                                'type' => 4,
                                'name' => 'crumb57',
                                'value' => 'All cases',
                                'is_system' => 1,
                                'lang' => 'en',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                        ],
                        'zh' => [
                            55 => [
                                'pack_id' => 55,
                                'type' => 4,
                                'name' => 'crumb55',
                                'value' => '產品詳情',
                                'is_system' => 1,
                                'lang' => 'zh',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                            56 => [
                                'pack_id' => 56,
                                'type' => 3,
                                'name' => 'gbook56',
                                'value' => '提交',
                                'is_system' => 1,
                                'lang' => 'zh',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                            57 => [
                                'pack_id' => 57,
                                'type' => 4,
                                'name' => 'crumb57',
                                'value' => '全部案例',
                                'is_system' => 1,
                                'lang' => 'zh',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                        ],
                    ];
                    $addData = [];
                    foreach ($data as $mark => $sub) {
                        if (in_array($mark, ['cn','en','zh']) && isset($row[$mark])) {
                            foreach ($sub as $_k => $_v) {
                                if (!isset($row[$mark][$_v['pack_id']])) {
                                    $_v['lang'] = $mark;
                                    $addData[] = $_v;
                                }
                            }
                        }
                    }
                    if (!empty($addData)) {
                        $r = Db::name('language_pack')->insertAll($addData);
                    }

                    // 同步默认语言数据到其他语言里
                    if ($r !== false) {
                        $row = Db::name('language_pack')->field('auto_id', true)->where(['is_system'=>1])->order('lang asc, pack_id asc')->select();
                        $new_arr = array();
                        foreach ($row as $k => $v) {
                            $new_arr[$v['lang']][$v['pack_id']] = $v;
                        }
                        $row =  $new_arr;
                        $data = empty($row[$default_lang]) ? current($row) : $row[$default_lang];

                        $synAddData = [];
                        foreach ($langSysRow as $key => $val) {
                            foreach ($data as $_k => $_v) {
                                if (!isset($row[$val['mark']][$_v['pack_id']])) {
                                    $_v['lang'] = $val['mark'];
                                    $synAddData[] = $_v;
                                }
                            }
                        }
                        if (!empty($synAddData)) {
                            $r = Db::name('language_pack')->insertAll($synAddData);
                        }
                    }
                }
                if ($r !== false) {
                    // 更新语言包变量文件
                    model('LanguagePack')->updateLangFile();
                    zanSetting('syn', ['syn_admin_logic_1731319559'=>1]);
                }
            }catch(\Exception $e){}
        }

        // 单页内容副表新增字段
        $isTable = Db::query("SHOW TABLES LIKE '{$Prefix}single_content'");
        if (!empty($isTable)) {
            $tableInfo = Db::query("SHOW COLUMNS FROM {$Prefix}single_content");
            $tableInfo = get_arr_column($tableInfo, 'Field');
            if (!empty($tableInfo) && !in_array('typeid', $tableInfo)) {
                $sql = "ALTER TABLE `{$Prefix}single_content` ADD COLUMN `typeid`  int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '文档栏目ID' AFTER `aid`;";
                @Db::execute($sql);
                schemaTable("single_content");
            }
            else if (!empty($tableInfo) && in_array('typeid', $tableInfo)) {
                $syn_admin_logic_1732092087 = zanSetting('syn.syn_admin_logic_1732092087');
                if (empty($syn_admin_logic_1732092087)) {
                    try{
                        $sql = "ALTER TABLE `{$Prefix}single_content` MODIFY COLUMN `typeid`  int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '文档栏目ID' AFTER `aid`;";
                        @Db::execute($sql);
                        schemaTable("single_content");
                        zanSetting('syn', ['syn_admin_logic_1732092087'=>1]);
                    }catch(\Exception $e){}
                }
            }
        }
        foreach ($langSysRow as $key => $val) {
            $isTable = Db::query("SHOW TABLES LIKE '{$Prefix}single_content_{$val['mark']}'");
            if (!empty($isTable)) {
                $tableInfo = Db::query("SHOW COLUMNS FROM {$Prefix}single_content_{$val['mark']}");
                $tableInfo = get_arr_column($tableInfo, 'Field');
                if (!empty($tableInfo) && !in_array('typeid', $tableInfo)) {
                    $sql = "ALTER TABLE `{$Prefix}single_content_{$val['mark']}` ADD COLUMN `typeid`  int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '文档栏目ID' AFTER `aid`;";
                    @Db::execute($sql);
                    schemaTable("single_content_{$val['mark']}");
                }
            }
        }
        $syn_admin_logic_1732092089 = zanSetting('syn.syn_admin_logic_1732092089');
        if (empty($syn_admin_logic_1732092089)) {
            foreach ($langSysRow as $key => $val) {
                try{
                    $isTable = Db::query("SHOW TABLES LIKE '{$Prefix}single_content_{$val['mark']}'");
                    if (!empty($isTable)) {
                        $tableInfo = Db::query("SHOW COLUMNS FROM {$Prefix}single_content_{$val['mark']}");
                        $tableInfo = get_arr_column($tableInfo, 'Field');
                        if (!empty($tableInfo) && in_array('typeid', $tableInfo)) {
                            $sql = "ALTER TABLE `{$Prefix}single_content_{$val['mark']}` MODIFY COLUMN `typeid`  int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '文档栏目ID' AFTER `aid`;";
                            @Db::execute($sql);
                            schemaTable("single_content_{$val['mark']}");
                        }
                    }
                }catch(\Exception $e){}
                zanSetting('syn', ['syn_admin_logic_1732092089'=>1]);
            }
        }

        // 更改单页副表的字段长度
        $syn_admin_logic_1731574937 = zanSetting('syn.syn_admin_logic_1731574937');
        if (empty($syn_admin_logic_1731574937)) {
            try{
                $isTable = Db::query("SHOW TABLES LIKE '{$Prefix}single_content'");
                if (!empty($isTable)) {
                    $sql = "ALTER TABLE `{$Prefix}single_content` MODIFY COLUMN `auto_id`  int(10) UNSIGNED NOT NULL COMMENT '文档内容自增ID' FIRST ;";
                    @Db::execute($sql);
                    $sql = "ALTER TABLE `{$Prefix}single_content` MODIFY COLUMN `aid`  int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '文档主表自增ID' AFTER `auto_id`;";
                    @Db::execute($sql);
                    $sql = "ALTER TABLE `{$Prefix}single_content` MODIFY COLUMN `auto_id`  int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID' FIRST ;";
                    @Db::execute($sql);
                    schemaTable("single_content");
                }
                zanSetting('syn', ['syn_admin_logic_1731574937'=>1]);
            }catch(\Exception $e){}
        }
        $syn_admin_logic_1731574934 = zanSetting('syn.syn_admin_logic_1731574934');
        if (empty($syn_admin_logic_1731574934)) {
            try{
                foreach ($langSysRow as $key => $val) {
                    $isTable = Db::query("SHOW TABLES LIKE '{$Prefix}single_content_{$val['mark']}'");
                    if (!empty($isTable)) {
                        $sql = "ALTER TABLE `{$Prefix}single_content_{$val['mark']}` MODIFY COLUMN `auto_id`  int(10) UNSIGNED NOT NULL COMMENT '文档内容自增ID' FIRST ;";
                        @Db::execute($sql);
                        $sql = "ALTER TABLE `{$Prefix}single_content_{$val['mark']}` MODIFY COLUMN `aid`  int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '文档主表自增ID' AFTER `auto_id`;";
                        @Db::execute($sql);
                        $sql = "ALTER TABLE `{$Prefix}single_content_{$val['mark']}` MODIFY COLUMN `auto_id`  int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID' FIRST ;";
                        @Db::execute($sql);
                        schemaTable("single_content_{$val['mark']}");
                    }
                }
                zanSetting('syn', ['syn_admin_logic_1731574934'=>1]);
            }catch(\Exception $e){}
        }

        // 纠正单页数据
        $syn_admin_logic_1731382107 = zanSetting('syn.syn_admin_logic_1731382107');
        if (empty($syn_admin_logic_1731382107)) {
            try {
                $where = [
                    'channel' => 6
                ];
                $archives = Db::name('archives')->field('aid, htmlfilename, tempview')->where($where)->getAllWithIndex('aid');
                if (!empty($archives)) {
                    $aidArr = get_arr_column($archives, 'aid');

                    $dataArr = [];
                    foreach ($aidArr as $value) {
                        $where = [
                            'aid' => intval($value),
                        ];
                        $dataArr[$value] = [];
                        $field = 'a.*, b.seo_title, b.seo_keywords, b.seo_description';
                        foreach ($langRow as $value1) {
                            $data = Db::name('archives_' . $value1['mark'])->where($where)->find();
                            $data_ = Db::name('single_content_' . $value1['mark'])->field('seo_title, seo_keywords, seo_description')->where($where)->find();
                            if (!empty($data_)) $data = array_merge($data, $data_);
                            if (empty($data) && $dataArr[$value][0]) $data = $dataArr[$value][0];
                            if (!empty($data)) $data['lang'] = $value1['mark'];
                            array_push($dataArr[$value], $data);
                        }
                    }

                    foreach ($dataArr as $key => $value2) {
                        $nextID = create_next_id('arctype', 'id');
                        $insertAll = [];
                        foreach ($value2 as $value3) {
                            // 自定义路由处理
                            $insertAll[] = [
                                'id'              => intval($nextID),
                                'channeltype'     => 6,
                                'current_channel' => 6,
                                'parent_id'       => 0,
                                'topid'           => 0,
                                'typename'        => $value3['title'],
                                'dirname'         => $archives[$key]['htmlfilename'],
                                'dirpath'         => '/' . $archives[$key]['htmlfilename'],
                                'diy_dirpath'     => '/' . $archives[$key]['htmlfilename'],
                                'grade'           => 0,
                                'litpic'          => '',
                                'templist'        => $archives[$key]['tempview'],
                                'seo_title'       => !empty($value3['seo_title']) ? trim($value3['seo_title']) : '',
                                'seo_keywords'    => !empty($value3['seo_keywords']) ? trim($value3['seo_keywords']) : '',
                                'seo_description' => !empty($value3['seo_description']) ? trim($value3['seo_description']) : '',
                                'sort_order'      => 100,
                                'lang'            => !empty($value3['lang']) ? trim($value3['lang']) : '',
                                'add_time'        => getTime(),
                                'update_time'     => getTime(),
                            ];
                        }
                        if (!empty($insertAll)) {
                            // 批量添加分类信息
                            $a = Db::name('arctype')->insertAll($insertAll);
                            if (!empty($a)) {
                                // 更新单页文档信息
                                $where = [
                                    'aid' => intval($key)
                                ];
                                $update = [
                                    'typeid' => intval($nextID),
                                    'stypeid' => intval($nextID),
                                    'update_time' => getTime(),
                                ];
                                $b = Db::name('archives')->where($where)->update($update);
                                if (!empty($b)) {
                                    // 更新单页内容信息
                                    Db::name('single_content')->where($where)->update($update);
                                    foreach ($insertAll as $value4) {
                                        if (!empty($value4['lang'])) Db::name('single_content_' . $value4['lang'])->where($where)->update($update);
                                    }

                                    // 更新导航信息
                                    $where = [
                                        'host_id' => 3,
                                        'type_id' => intval($key)
                                    ];
                                    $update = [
                                        'host_id' => 2,
                                        'type_id' => intval($nextID)
                                    ];
                                    Db::name('nav_list')->where($where)->update($update);
                                } else {
                                    // 删除新增的分类数据
                                    Db::name('arctype')->where(['id' => intval($nextID)])->delete(true);
                                }
                            }
                        }
                    }
                }
                // 记录已执行
                zanSetting('syn', ['syn_admin_logic_1731382107'=>1]);
            }catch(\Exception $e){}
        }

        // 纠正可视化模板的单页数据
        $syn_admin_logic_1731480386 = zanSetting('syn.syn_admin_logic_1731480386');
        if (empty($syn_admin_logic_1731480386)) {
            try{
                $r = true;
                $row = Db::name('ui_config')->field('id,value')->where(['type'=>'single'])->select();
                if (!empty($row)) {
                    $aids = [];
                    foreach ($row as $key => $val) {
                        $info = json_decode($val['value'], true);
                        if (!empty($info['aid'])) {
                            $aids[] = $info['aid'];
                        }
                    }
                    $archivesRow = [];
                    if (!empty($aids)) {
                        $archivesRow = Db::name('archives')->field('aid,typeid')->where(['aid'=>['IN', $aids]])->getAllWithIndex('aid');
                    }
                    $editData = [];
                    foreach ($row as $key => $val) {
                        $info = json_decode($val['value'], true);
                        $typeid = empty($archivesRow[$info['aid']]) ? 0 : $archivesRow[$info['aid']]['typeid'];
                        $val['value'] = preg_replace('/(\'|\")aid(\'|\")\:(\'|\")([0-9]*)(\'|\")/i', '${1}typeid${2}:${3}'.$typeid.'${5}', $val['value']);
                        $editData[] = $val;
                    }
                    if (!empty($editData)) {
                        $r = model('UiConfig')->saveAll($editData);
                    }
                }
                if ($r !== false) {
                    if (is_dir(RUNTIME_PATH.'ui/')) {
                        delFile(RUNTIME_PATH.'ui/');
                    }
                    zanSetting('syn', ['syn_admin_logic_1731480386'=>1]);
                }
            }catch(\Exception $e){}
        }

        // 纠正导航(单页)数据
        $syn_admin_logic_1732069289 = zanSetting('syn.syn_admin_logic_1732069289');
        if (empty($syn_admin_logic_1732069289)) {
            try {
                // 查询导航数据中的文档类型数据
                $where = [
                    'host_id' => 3,
                ];
                $field = 'auto_id, host_id, type_id';
                $navList = Db::name('nav_list')->where($where)->field($field)->select();
                $aidArr = !empty($navList) ? array_unique(get_arr_column($navList, 'type_id')) : [];

                // 查询导航数据是否为单页模型数据
                $archivesList = [];
                if (!empty($aidArr)) {
                    $where = [
                        'aid' => ['IN', $aidArr],
                        'channel' => 6,
                    ];
                    $field = 'aid, typeid, channel, title';
                    $archivesList = Db::name('archives')->where($where)->field($field)->getAllWithIndex('aid');
                }

                // 处理数据纠正
                foreach ($navList as $key => $value) {
                    $find = !empty($archivesList[$value['type_id']]) ? $archivesList[$value['type_id']] : [];
                    if (!empty($find['typeid'])) {
                        $navList[$key]['host_id'] = 2;
                        $navList[$key]['type_id'] = intval($find['typeid']);
                        $navList[$key]['update_time'] = getTime();
                    }
                }

                // 执行数据纠正
                if (!empty($navList)) model('NavList')->saveAll($navList);

                // 清除缓存
                @delFile(RUNTIME_PATH);

                // 记录已执行
                zanSetting('syn', ['syn_admin_logic_1732069289'=>1]);
            }catch(\Exception $e){}
        }

    }

    // 升级v2.0.1版本要处理的数据
    private function eyou_v201_handle_data($langRow = [], $langSysRow = [])
    {
        $Prefix = config('database.prefix');
        $default_lang = Db::name('language')->where(['is_admin_default' => 1])->getField('mark');

        $isTable = Db::query("SHOW TABLES LIKE '{$Prefix}setting_syn'");
        if (empty($isTable)) {
            $tableSql = <<<EOF
CREATE TABLE IF NOT EXISTS `{$Prefix}setting_syn` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
`name` varchar(50) DEFAULT '' COMMENT '配置的key键名',
`value` text,
`inc_type` varchar(64) DEFAULT '' COMMENT '配置分组',
`update_time` int(11) DEFAULT '0' COMMENT '更新时间',
PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='不分语言的数据处理标记表';
EOF;
            $r = @Db::execute($tableSql);
            if ($r !== false) {
                schemaTable('setting_syn');
            }
        }

        // 完善 arcrank 表内置数据
        $syn_admin_logic_1731034059 = zanSetting('syn.syn_admin_logic_1731034059');
        if (empty($syn_admin_logic_1731034059)) {
            try{
                // 同步默认语言数据到其他语言里
                $r = true;
                $row = Db::name('arcrank')->field('id', true)->order('lang asc')->select();
                if (!empty($row)) {
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['rank']] = $v;
                    }
                    $row =  $new_arr;
                    $data = empty($row[$default_lang]) ? current($row) : $row[$default_lang];

                    $synAddData = [];
                    foreach ($langRow as $key => $val) {
                        foreach ($data as $_k => $_v) {
                            if (!isset($row[$val['mark']][$_v['rank']])) {
                                $_v['lang'] = $val['mark'];
                                $synAddData[] = $_v;
                            }
                        }
                    }
                    if (!empty($synAddData)) {
                        $r = Db::name('arcrank')->insertAll($synAddData);
                    }
                }
                if ($r !== false) {
                    zanSetting('syn', ['syn_admin_logic_1731034059'=>1]);
                }
            }catch(\Exception $e){}
        }

        // 完善 config_type 表内置数据
        $syn_admin_logic_1731034060 = zanSetting('syn.syn_admin_logic_1731034060');
        if (empty($syn_admin_logic_1731034060)) {
            try{
                // 同步默认语言数据到其他语言里
                $r = true;
                $row = Db::name('config_type')->field('auto_id', true)->order('lang asc')->select();
                if (!empty($row)) {
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['id']] = $v;
                    }
                    $row =  $new_arr;
                    $data = empty($row[$default_lang]) ? current($row) : $row[$default_lang];

                    $synAddData = [];
                    foreach ($langRow as $key => $val) {
                        foreach ($data as $_k => $_v) {
                            if (!isset($row[$val['mark']][$_v['id']])) {
                                $_v['lang'] = $val['mark'];
                                $synAddData[] = $_v;
                            }
                        }
                    }
                    if (!empty($synAddData)) {
                        $r = Db::name('config_type')->insertAll($synAddData);
                    }
                }
                if ($r !== false) {
                    zanSetting('syn', ['syn_admin_logic_1731034060'=>1]);
                }
            }catch(\Exception $e){}
        }

        // 完善 sms_template 表内置数据
        $syn_admin_logic_1731034061 = zanSetting('syn.syn_admin_logic_1731034061');
        if (empty($syn_admin_logic_1731034061)) {
            try{
                // 同步默认语言数据到其他语言里
                $r = true;
                $row = Db::name('sms_template')->field('tpl_id', true)->order('lang asc')->select();
                if (!empty($row)) {
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']]["{$v['sms_type']}_{$v['send_scene']}"] = $v;
                    }
                    $row =  $new_arr;
                    $data = empty($row[$default_lang]) ? current($row) : $row[$default_lang];

                    $synAddData = [];
                    foreach ($langRow as $key => $val) {
                        foreach ($data as $_k => $_v) {
                            if (!isset($row[$val['mark']]["{$_v['sms_type']}_{$_v['send_scene']}"])) {
                                $_v['lang'] = $val['mark'];
                                $synAddData[] = $_v;
                            }
                        }
                    }
                    if (!empty($synAddData)) {
                        $r = Db::name('sms_template')->insertAll($synAddData);
                    }
                }
                if ($r !== false) {
                    zanSetting('syn', ['syn_admin_logic_1731034061'=>1]);
                }
            }catch(\Exception $e){}
        }

        // 完善 language_pack 表内置数据
        $syn_admin_logic_1731034062 = zanSetting('syn.syn_admin_logic_1731034062');
        if (empty($syn_admin_logic_1731034062)) {
            try{
                $r = true;
                $row = Db::name('language_pack')->field('auto_id', true)->where(['is_system'=>1])->order('lang asc, pack_id asc')->select();
                if (!empty($row)) {
                    // 添加内置 cn、en、zh 语言数据
                    $new_arr = array();
                    foreach ($row as $k => $v) {
                        $new_arr[$v['lang']][$v['pack_id']] = $v;
                    }
                    $row =  $new_arr;

                    $data = [
                        'cn' => [
                            53 => [
                                'pack_id' => 53,
                                'type' => 4,
                                'name' => 'crumb53',
                                'value' => '热门产品',
                                'is_system' => 1,
                                'lang' => 'cn',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                            54 => [
                                'pack_id' => 54,
                                'type' => 4,
                                'name' => 'crumb54',
                                'value' => '相关新闻',
                                'is_system' => 1,
                                'lang' => 'cn',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                        ],
                        'en' => [
                            53 => [
                                'pack_id' => 53,
                                'type' => 4,
                                'name' => 'crumb53',
                                'value' => 'Hot Products',
                                'is_system' => 1,
                                'lang' => 'en',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                            54 => [
                                'pack_id' => 54,
                                'type' => 4,
                                'name' => 'crumb54',
                                'value' => 'Related News',
                                'is_system' => 1,
                                'lang' => 'en',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                        ],
                        'zh' => [
                            53 => [
                                'pack_id' => 53,
                                'type' => 4,
                                'name' => 'crumb53',
                                'value' => '熱門產品',
                                'is_system' => 1,
                                'lang' => 'zh',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                            54 => [
                                'pack_id' => 54,
                                'type' => 4,
                                'name' => 'crumb54',
                                'value' => '相關新聞',
                                'is_system' => 1,
                                'lang' => 'zh',
                                'sort_order' => 100,
                                'add_time' => getTime(),
                                'update_time' => getTime(),
                            ],
                        ],
                    ];
                    $addData = [];
                    foreach ($data as $mark => $sub) {
                        if (in_array($mark, ['cn','en','zh']) && isset($row[$mark])) {
                            foreach ($sub as $_k => $_v) {
                                if (!isset($row[$mark][$_v['pack_id']])) {
                                    $_v['lang'] = $mark;
                                    $addData[] = $_v;
                                }
                            }
                        }
                    }
                    if (!empty($addData)) {
                        $r = Db::name('language_pack')->insertAll($addData);
                    }

                    // 同步默认语言数据到其他语言里
                    if ($r !== false) {
                        $row = Db::name('language_pack')->field('auto_id', true)->where(['is_system'=>1])->order('lang asc, pack_id asc')->select();
                        $new_arr = array();
                        foreach ($row as $k => $v) {
                            $new_arr[$v['lang']][$v['pack_id']] = $v;
                        }
                        $row =  $new_arr;
                        $data = empty($row[$default_lang]) ? current($row) : $row[$default_lang];

                        $synAddData = [];
                        foreach ($langSysRow as $key => $val) {
                            foreach ($data as $_k => $_v) {
                                if (!isset($row[$val['mark']][$_v['pack_id']])) {
                                    $_v['lang'] = $val['mark'];
                                    $synAddData[] = $_v;
                                }
                            }
                        }
                        if (!empty($synAddData)) {
                            $r = Db::name('language_pack')->insertAll($synAddData);
                        }
                    }
                }
                if ($r !== false) {
                    // 更新语言包变量文件
                    model('LanguagePack')->updateLangFile();
                    zanSetting('syn', ['syn_admin_logic_1731034062'=>1]);
                }
            }catch(\Exception $e){}
        }

        // 完善 setting 表内置数据
        $syn_admin_logic_1731034063 = zanSetting('syn.syn_admin_logic_1731034063');
        if (empty($syn_admin_logic_1731034063)) {
            try{
                // 同步默认语言数据到其他语言里
                $r = true;
                Db::name('setting')->where(['inc_type'=>'adminlogin'])->delete();
                $row = Db::name('setting')->field('count(id) as total, lang')->group('lang')->order('total desc')->getAllWithIndex('lang');
                if (!empty($row)) {
                    $data = current($row);
                    foreach ($langRow as $key => $val) {
                        if ($val['mark'] != $data['lang'] && $data['total'] != $row[$val['mark']]['total']) {
                            Db::name('setting')->where(['lang'=>$val['mark']])->delete(true);
                            @Db::execute("ALTER TABLE `{$Prefix}setting` AUTO_INCREMENT 1");
                            @Db::query("REPAIR TABLE `{$Prefix}setting`");
                            $insertField = "`name`, `value`, `inc_type`, `lang`, `update_time`";
                            $selectField = "`name`, `value`, `inc_type`, '{$val['mark']}' as `lang`, `update_time`";
                            $sql = "INSERT INTO `{$Prefix}setting` ({$insertField}) (SELECT {$selectField} FROM `{$Prefix}setting` WHERE `lang` = '{$data['lang']}');";
                            try {
                                $r = @Db::execute($sql);
                            } catch (\Exception $e) {
                                $r = false;
                            }
                        }
                    }
                }
                if ($r !== false) {
                    zanSetting('syn', ['syn_admin_logic_1731034063'=>1]);
                }
            }catch(\Exception $e){}
        }
    }

    /**
     * 自动更新插件里的jquery文件为最新版本，修复jquery漏洞
     * @return [type] [description]
     */
    private function copy_jquery()
    {
        $list = glob('weapp/*/template/skin/js/jquery.js');
        if (!empty($list)) {
            $list[] = 'public/static/common/diyminipro/js/jquery.min.js';
            $minilist = glob('weapp/*/template/*/js/jquery.min.js');
            if (!empty($minilist)) {
                $list = array_merge($list, $minilist);
            }
            foreach ($list as $key => $val) {
                if (file_exists('./'.$val)) {
                    @copy(realpath('public/static/admin/js/jquery.js'), realpath($val));
                }
            }
        }
    }
    
    /*
    * 初始化原来的菜单栏目
    */
    public function initialize_admin_menu(){
        $total = Db::name("admin_menu")->count();
        if (empty($total)){
            $menuArr = getAllMenu();
            $insert_data = [];
            foreach ($menuArr as $key => $val){
                foreach ($val['child'] as $nk=>$nrr) {
                    $sort_order = 100;
                    $is_switch = 1;
                    if ($nrr['id'] == 2004){
                        $sort_order = 10000;
                        $is_switch = 0;
                    }
                    $insert_data[] = [
                        'menu_id' => $nrr['id'],
                        'title' => $nrr['name'],
                        'controller_name' => $nrr['controller'],
                        'action_name' => $nrr['action'],
                        'param' => !empty($nrr['param']) ? $nrr['param'] : '',
                        'is_menu' => $nrr['is_menu'],
                        'is_switch' => $is_switch,
                        'icon' =>  $nrr['icon'],
                        'sort_order' => $sort_order,
                        'add_time' => getTime(),
                        'update_time' => getTime()
                    ];
                }
            }
            Db::name("admin_menu")->insertAll($insert_data);
        }
    }
}
