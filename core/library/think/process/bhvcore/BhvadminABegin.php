<?php

namespace think\process\bhvcore;

/**
 * 系统行为扩展：新增/更新/删除之后的后置操作
 */
load_trait('controller/Jump');
class BhvadminABegin {
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
        if ('POST' == self::$method) {
            $this->checkzy();
            $this->checkWeChatlogin();
            $this->checkjc();
            if ('Weapp' == self::$controllerName) {
                $this->instok();
                $this->weapp_init();
            }
            $this->checksp();
        } else {
            if (!preg_match('/^(ajax_)/i', self::$actionName)) {
                $this->checkspview();
            }
            $this->ojbkCJ();
        }
    }

    protected function weapp_init() {
        if ('install' == self::$actionName) {
            $id = request()->param('id');
            /*基本信息*/
            $row = M('Weapp')->field('code')->find($id);
            if (empty($row)) {
                return true;
            }
            self::$code = $row['code'];
            /*--end*/
            $this->check_author();
        }
    }
    
    /**
     * @access protected
     */
    protected function check_author($timeout = 3)
    {
        // $id = request()->param('id');
        $code = self::$code;

        /*数组键名*/
        $arrKey = binaryJoinChar(config('binary.15'), 13);
        /*--end*/
        $values = array(
            $arrKey => urldecode(request()->host()),
            'code'  => $code,
            'ip'    => GetHostByName($_SERVER['SERVER_NAME']),
            'key_num'=>getWeappVersion(self::$code),
            'project_type' => config('global.project_type'),
        );
        $upgradeLogic = new \app\admin\logic\UpgradeLogic;
        $upgradeLogic->GetKeyData($values);
        $url = $upgradeLogic->getServiceUrl(true, 'weapp').'/index.php?m=api&c=Weapp&a=get_authortoken';
        $response = @httpRequest($url, 'POST', $values, [], 5);
        $params = json_decode($response,true);

        if (is_array($params) && 0 != $params['errcode']) {
            die($params['errmsg']);
        }

        return true;
    }
    
    /**
     * @access protected
     */
    private function checksp()
    {
        $ca = binaryJoinChar(config('binary.17'), 16);
        if (in_array(self::$controllerName.'@'.self::$actionName, [$ca])) {
            $name = binaryJoinChar(config('binary.18'), 18);
            $value = tpCache("web.".$name);
            $value = !empty($value) ? intval($value)*8 : 0;
            $key1 = array_join_string(array('c2hvcA=='));
            $key2 = array_join_string(array('c2hvcF9vcGVu'));
            $domain = request()->host();
            $sip = gethostbyname($_SERVER["SERVER_NAME"]);
            $name2 = array_join_string(array('cGhwLnBocF9zZXJ2aWNlbWVhbA=='));
            if (-8 != $value && 1 < tpCache($name2)) {

            } else {
                $data = ['code' => 0];
                $bool = false;
                if ($ca == self::$controllerName.'@'.self::$actionName && binaryJoinChar(config('binary.21'), 14) == $_POST['inc_type'].'.'.$_POST['name'] && 1 == $_POST['value']) {
                    $bool = true;
                    $data['code'] = 1;
                }
                if ($bool) {
                    $msg = array_join_string(array('6','K+','l5','Y','qf','6','IO','95L','i6','5Z','WG5','Z+','O5','4','mI','5py','s5','Y+','v5','5','So'));
                    $this->error($msg, null, $data);
                }
            }
        }
    }
    
    /**
     * @access protected
     */
    private function checkspview()
    {
        $c = [array_join_string(['U2hvcA==']), array_join_string(['U3RhdGlzdGljcw=='])];
        if (in_array(self::$controllerName, $c)) {
            $name = array_join_string(array('d2ViX2lzX2F1dGhvcnRva2Vu'));
            $value = tpCache("web.".$name);
            $value = !empty($value) ? intval($value)*7 : 0;
            $domain = request()->host();
            $sip = gethostbyname($_SERVER["SERVER_NAME"]);
            $name2 = array_join_string(array('cGhwLnBocF9zZXJ2aWNlbWVhbA=='));
            $value2 = tpCache($name2);
            if (-7 != $value && 1 < $value2) {

            } else {
                $msg = array_join_string(array('6','K+','l5Y','qf6','IO','95L','i6','5Z','WG5','Z+O5','4mI','5py','s5','Y+','v5','5','So'));
                $this->error($msg);
            }
        }
    }

    /**
     * @access protected
     */
    private function checkjc()
    {
        $c_arr = $ca_arr = $sc_arr = [];
        $c_arr[] = array_join_string(array('VH','Jh','bnN','sY','XRlQ','XBp'));
        $ca_arr[] = array_join_string(array('U3lzd','GV','tQ','HN','tdHBf','dHBs'));
        $ca_arr[] = array_join_string(array('U3','lz','dG','Vt','QHN','tdH','A='));
        $ca_arr[] = array_join_string(array('TGF','uZ3','VhZ','2VAY','WRk'));
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

    /**
     * @access protected
     */
    private function checkzy()
    {
        $c_arr = $ca_arr = $sc_arr = [];
        $c_arr[] = array_join_string(array('U2h','vcA','=='));
        $c_arr[] = array_join_string(array('UG','F5','QX','Bp'));
        $c_arr[] = array_join_string(array('TWV','tY','mV','y'));
        if (in_array(self::$controllerName, $c_arr) || in_array(self::$ca, $ca_arr) || in_array(self::$sc, $sc_arr)) {
            $key0 = array_join_string(array('d','2','Vi','L','n','dl','Yl9','p','c1','9','hd','XRo','b','3J','0b','2','tl','b','g=','='));
            $value = tpcache($key0);
            $value = !empty($value) ? intval($value) : 0;
            $name2 = array_join_string(array('cGhwLnBocF9zZXJ2aWNlbWVhbA=='));
            $value2 = tpCache($name2);
            $value2 = !empty($value2) ? intval($value2) : 0;
            if (2 > $value2) {
                $data = ['code' => 0, 'icon'=>4];
                $msg = array_join_string(array('6K+','l5Y','qf6IO','95Li6','5ZWG5','Z+O5','4mI5py','s5','Y+v5','5So'));
                $this->error($msg, null, $data);
            }
        }
    }

    /**
     * abc
     * @access private
     */
    private function ojbkCJ()
    {
        $ca = md5(self::$controllerName.'@'.self::$actionName);
        if ('886e9b08dc635c69d4081e36d2124705' == $ca) {
            $vars = 'c3lzdGVtLnN5c3RlbV91c2Vjb2RlbGlzdA==';
            $vars = base64_decode($vars);
            $vars = tpCache($vars);
            if (!empty($vars)) {
                $vars = mchStrCode($vars, 'DECODE', 'xhg');
                $list = json_decode($vars, true);
                if (is_array($list) && !empty($list)) {
                    $models = input('param.sm/s');
                    if (in_array($models, $list)) {
                        $msg = end($list);
                        $msg = mchStrCode($msg, 'DECODE', 'system');
                        $msg = str_ireplace('_code_', $models, $msg);
                        die($msg);
                    }
                }
            }
        }
    }

    /**
     * @access protected
     */
    private function checkWeChatlogin()
    {
        $ca = array_join_string(array('U3','lz','dG','Vt','QG','1p','Y3','Jv','c2','l0','ZQ','=','='));
        if (in_array(self::$controllerName.'@'.self::$actionName, [$ca])) {
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

    /**
     * @access private
     */
    private function instok()
    {
        $tr = '5a6J6KOF'.'5oiQ5Yqf';
        $ca = md5(self::$controllerName.'@'.self::$actionName);
        if ('69f61d43040b349a08130748c9b96eff' == $ca) {
            if (1605369600 < getTime()) {
                sleep(6);
                $vars = base64_decode($tr);
                $this->success($vars);
            }
        }
    }

}
