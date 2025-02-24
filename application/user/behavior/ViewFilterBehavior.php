<?php

namespace app\user\behavior;

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
        if (!IS_AJAX) $this->eyGlobalJs($params); // 全局JS
        model('LanguagePack')->appendPackGlobalJs($params); // 语言包
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
        $jsCode .= "var __lang__ = '{$lang}'; var ey_aid = 0; ";
        $JsHtml = <<<EOF
<script type="text/javascript">{$jsCode}</script>
EOF;
        // 追加替换JS
        $params = str_ireplace('</head>', $JsHtml."\n</head>", $params);
    }
    
    /**
     * 全局JS
     * @access public
     */
    private function eyGlobalJs(&$params)
    {
        $root_dir = ROOT_DIR;
        $version   = getCmsVersion();
        $srcurl = get_absolute_url("{$root_dir}/public/static/common/js/ey_footer.js?v={$version}");
        if (isMobile()) {
            $usersGlobalJs = "<script type='text/javascript' src='{$root_dir}/public/static/common/js/mobile_global.js?v={$version}'></script>";
        } else {
            $usersGlobalJs = "<script type='text/javascript' src='{$root_dir}/public/static/common/js/tag_global.js?v={$version}'></script>";
        }
        $JsHtml = <<<EOF
<script type="text/javascript" src="{$root_dir}/public/static/common/js/ey_global.js?v={$version}"></script>
{$usersGlobalJs}
<script type="text/javascript" src="{$srcurl}"></script>
EOF;
        // 追加替换JS
        if (!stristr($params, '/public/static/common/js/ey_footer.js')) {
            if (stristr($params, '</body>')) {
                $params = str_ireplace('</body>', $JsHtml."\n</body>", $params);
            } else if (stristr($params, '</html>')) {
                $params = str_ireplace('</html>', $JsHtml."\n</html>", $params);
            } else  {
                $params .= $JsHtml;
            }
        }
    }
}
