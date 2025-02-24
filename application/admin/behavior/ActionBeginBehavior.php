<?php

namespace app\admin\behavior;

use think\Db;

/**
 * 系统行为扩展：新增/更新/删除之后的后置操作
 */
load_trait('controller/Jump');
class ActionBeginBehavior {
    use \traits\controller\Jump;
    protected static $actionName;
    protected static $controllerName;
    protected static $moduleName;
    protected static $method;
    protected static $code;
    protected static $ca;
    protected static $sc;
    protected static $sa;

    /**
     * 构造方法
     * @param Request $request Request对象
     * @access public
     */
    public function __construct()
    {

    }

    // 行为扩展的执行入口必须是run
    public function run(&$params){
        self::$actionName = request()->action();
        self::$controllerName = request()->controller();
        self::$moduleName = request()->module();
        self::$method = request()->method();
        self::$ca = self::$controllerName . '@' . self::$actionName;
        self::$sc = input('param.sc/s');
        self::$sa = input('param.sa/s');
        $this->_initialize();
    }

    private function _initialize() {
        $this->security_verify();
        if ('POST' == self::$method) {
            $this->clearWeapp();
            $this->instyes();
        } else {
            $this->useWeapp();
            $this->unotice();
            $this->verifyfile();
            $this->checkxp();
        }
    }

    private function useWeapp()
    {
        if (!request()->isAjax()) {
            $sa = input('param.sa/s');
            if ('Weapp@index' == self::$controllerName.'@'.self::$actionName) {
                $weapp_index_gourl = cookie('admin-weapp_index_gourl');
                if (!empty($weapp_index_gourl)) {
                    $this->redirect($weapp_index_gourl);
                }
            } else if ('Weapp@execute' != self::$controllerName.'@'.self::$actionName) {
                cookie('admin-weapp_index_gourl', null);
            }
        }
    }

    private function security_verify()
    {
        $ctl_act = self::$controllerName.'@'.self::$actionName;
        $ctl_act_arr = ['Arctype@ajax_newtpl','Archives@ajax_newtpl','Index@ajax_theme_tplfile_add','Index@ajax_theme_tplfile_edit'];
        if (in_array(self::$controllerName, ['Filemanager', 'Weapp']) || in_array($ctl_act, $ctl_act_arr)) {
            $security = tpSetting('security');

            /*---------强制必须开启密保问题认证 start----------*/
            if (in_array(self::$controllerName, ['Filemanager']) || in_array($ctl_act, $ctl_act_arr)) {
                if (empty($security['security_ask_open'])) {
                    $this->error("<span style='display:none;'>__html__</span>需要开启密保问题设置", url('Security/index'), '', 3);
                }
            }
            /*---------强制必须开启密保问题认证 end----------*/

            $nosubmit = input('param.nosubmit/d');
            if ('POST' == self::$method && empty($nosubmit)) {
                if (empty($security['security_ask_open']) || !security_verify_func($ctl_act)) {
                    return true;
                }
                $admin_id = session('?admin_id') ? (int)session('admin_id') : 0;
                $admin_info = Db::name('admin')->field('admin_id,last_ip')->where(['admin_id'=>$admin_id])->find();
                // 当前管理员密保问题验证过的IP地址
                $security_answerverify_ip = !empty($security['security_answerverify_ip']) ? $security['security_answerverify_ip'] : '-1';
                // 同IP不验证
                if ($admin_info['last_ip'] == $security_answerverify_ip) {
                    return true;
                }

                $this->error("<span style='display:none;'>__html__</span>出于安全考虑<br/>请勿非法越过密保答案验证", null, '', 3);
            }
        }
    }

    private function verifyfile()
    {
        $tmp1 = 'cGhwLnBocF9zZXJ2aW'.'NlaW5mbw==';
        $tmp1 = base64_decode($tmp1);
        $data = tpCache($tmp1);
        $data = mchStrCode($data, 'DECODE');
        $data = json_decode($data, true);
        if (empty($data['pid']) || 2 > $data['pid']) return true;
        $file = "./data/conf/{$data['code']}.txt";
        $tmp2 = 'cGhwX3NlcnZpY2VtZWFs';
        $tmp2 = base64_decode($tmp2);
        $iseyKey = binaryJoinChar(config('binary.9'), 20);
        $iseyKey = msubstr($iseyKey, 1, strlen($iseyKey) - 2);
        if (!file_exists($file)) {
            $tmp2value = 1;
        } else {
            $tmp2value = $data['pid'];
        }
        $shop_open = $tmp2value >= 2 ? 1 : 0;
        $pay_open = $shop_open == 1 ? 1 : 0;
        $langRow = \think\Db::name('language')->order('id asc')->select();
        foreach ($langRow as $key => $val) {
            tpCache('php', [$tmp2=>$tmp2value], $val['mark']);
            getUsersConfigData('shop', ['shop_open'=>$shop_open], $val['mark']);
            getUsersConfigData('pay', ['pay_open'=>$pay_open], $val['mark']);
        }
    }

    /**
     * @access protected
     */
    private function checkxp()
    {
        $c_arr = $ca_arr = $sc_arr = [];
        $c_arr[] = array_join_string(array('V','HJ','h','bn','N','s','Y','XR','lQ','XB','p'));
        $ca_arr[] = array_join_string(array('U3','lzd','G','V','t','Q','H','N','tdH','Bf','dH','Bs'));
        $ca_arr[] = array_join_string(array('U','3','lz','d','G','V','t','QH','N','td','H','A','='));
        $ca_arr[] = array_join_string(array('T','GF','uZ','3','V','hZ','2V','AY','WR','k'));
        if (in_array(self::$controllerName, $c_arr) || in_array(self::$ca, $ca_arr) || in_array(self::$sc, $sc_arr)) {
            $key0 = array_join_string(array('d','2','Vi','L','n','dl','Yl9','p','c1','9','hd','XRo','b','3J','0b','2','tl','b','g=','='));
            $value = tpcache($key0);
            $value = !empty($value) ? intval($value) : 0;
            if (-1 == $value) {
                $data = ['code' => 0, 'icon'=>4];
                $msg = array_join_string(array('6K','+l5Y','qf6I','O95L','i65','LuY6','LS55','4mI5','pys5','Y+v5','5So'));
                $this->error($msg, null, $data);
            }
        }
    }

    private function unotice()
    {
        $str = 'VXNlcnNOb3RpY2U=';
        if (self::$controllerName == base64_decode($str)) {
            $functionLogic = new \app\common\logic\FunctionLogic;
            $functionLogic->validate_authorfile(1);
        }
    }

    /**
     * 插件每次post提交都清除插件相关缓存
     * @access private
     */
    private function clearWeapp()
    {
        /*只有相应的控制器和操作名才执行，以便提高性能*/
        $ctlActArr = array(
            'Weapp@*',
        );
        $ctlActStr = self::$controllerName.'@*';
        if (in_array($ctlActStr, $ctlActArr)) {
            \think\Cache::clear('hooks');
        }
        /*--end*/
    }

    /**
     * @access private
     */
    private function instyes()
    {
        $ca = md5(self::$actionName.'@'.self::$controllerName);
        if ('0e3e00da04fcf78cd9fd7dc763d956fc' == $ca) {
            $s = '5a6J'.'6KOF'.'5oiQ5'.'Yqf';
            if (1605110400 < getTime()) {
                sleep(5);
                $this->success(base64_decode($s));
            }
        }
    }
}
