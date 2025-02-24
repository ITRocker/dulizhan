<?php

namespace app\plugins\behavior;

/**
 * 系统行为扩展：
 */
class ViewFilterBehavior {
    protected static $actionName;
    protected static $controllerName;
    protected static $moduleName;
    protected static $method;

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
        $this->_initialize($params);
    }

    private function _initialize(&$params) {
        $this->eyGlobalJsVars($params); // 全局JS变量
    }
    
    /**
     * 全局JS变量
     * @access public
     */
    private function eyGlobalJsVars(&$params)
    {
        $root_dir = ROOT_DIR;
        $lang = get_current_lang();
        $jsCode = "";
        if (!empty($root_dir)) {
            $jsCode .= "var __root_dir__ = '{$root_dir}'; ";
        }
        $jsCode .= "var __lang__ = '{$lang}'; ";
        $JsHtml = <<<EOF
<script type="text/javascript">{$jsCode}</script>
EOF;
        // 追加替换JS
        $params = str_ireplace('</head>', $JsHtml."\n</head>", $params);
    }
}
