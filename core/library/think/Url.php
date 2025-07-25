<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------

namespace think;

class Url
{
    // 生成URL地址的root
    protected static $root;
    protected static $bindCheck;

    /**
     * URL生成 支持路由反射
     * @param string            $url 路由地址
     * @param string|array      $vars 参数（支持数组和字符串）a=val&b=val2... ['a'=>'val1', 'b'=>'val2']
     * @param string|bool       $suffix 伪静态后缀，默认为true表示获取配置值
     * @param boolean|string    $domain 是否显示域名 或者直接传入域名
     * @param string    $seo_pseudo URL模式
     * @param string    $seo_pseudo_format URL格式
     * @param string    $seo_inlet 隐藏入口文件
     * @return string
     */
    public static function build($url = '', $vars = '', $suffix = true, $domain = false, $seo_pseudo = null, $seo_pseudo_format = null, $seo_inlet = null)
    {
        static $request = null;
        if (null == $request) {
            $request = Request::instance();
        }
        $module = $request->module();

        $mca = !empty($url) ? explode('/', $url) : []; // by 小虎哥

        /*自动识别系统环境隐藏入口文件 by 小虎哥*/
        self::root($request->baseFile().'/');
        null === $seo_inlet && $seo_inlet = config('ey_config.seo_inlet');
        if (1 == $seo_inlet) {
            if ('admin' != $module) { // 排除后台分组模块
                self::root(ROOT_DIR.'/');
            } else if (3 == count($mca) && 'admin' != $mca[0]) { // 排除url中带有admin分组模块
                self::root(ROOT_DIR.'/');
            }
        }
        /*--end*/

        // 解析参数 by 小虎哥
        if (is_string($vars)) {
            parse_str($vars, $vars);
        }

        // 多语言
        static $lang_switch_on = null;
        null === $lang_switch_on && $lang_switch_on = config('lang_switch_on');
        if (!empty($lang_switch_on)) {
            // if ('admin' == $module) {
            //     if ((isset($vars['lang']) && true === $vars['lang'])) {
            //         $vars['lang'] = '';
            //     } else if (empty($vars['lang'])) {
            //         $vars['lang']   = get_home_lang();
            //     }
            // } else {
            //     if ((isset($vars['lang']) && true === $vars['lang']) || get_default_lang() == get_home_lang() || $request->domainPrefix() == get_home_lang() || 'home/Langsite/index' == $url) {
            //         $vars['lang'] = '';
            //     } else if (empty($vars['lang'])) {
            //         $vars['lang']   = get_home_lang();
            //     }

                if (empty($vars['lang'])) {
                    // $lang = $request->param('lang/s', '');
                    $lang = $request->param('showlang/s', $request->param('lang/s', ''));
                    if ('admin' == $module) {
                        $system_home_default_lang = config('ey_config.system_home_default_lang');
                        if (!empty($lang) && $lang != $system_home_default_lang) {
                            $vars['lang']   = $lang;
                        }
                    } else {
                        $lang = get_current_lang();
                        $default_lang = get_default_lang();
                        if ($default_lang != $lang) {
                            $vars['lang']   = $lang;
                        }
                    }
                } else {
                    if (!empty($vars['lang']) && $vars['lang'] == get_default_lang()) {
                        unset($vars['lang']);
                    }
                }

            // }
        } else { // 单语言
            if ('admin' == $module) { // 排除后台分组模块
                if (empty($vars['lang'])) {
                    $vars['lang']   = get_admin_lang();
                }
            }
        }

        if (false === $domain && Route::rules('domain')) {
            $domain = true;
        }
        // 解析URL
        if (0 === strpos($url, '[') && $pos = strpos($url, ']')) {
            // [name] 表示使用路由命名标识生成URL
            $name = substr($url, 1, $pos - 1);
            $url  = 'name' . substr($url, $pos + 1);
        }
        if (false === strpos($url, '://') && 0 !== strpos($url, '/')) {
            $info = parse_url($url);
            $url  = !empty($info['path']) ? $info['path'] : '';
            if (isset($info['fragment'])) {
                // 解析锚点
                $anchor = $info['fragment'];
                if (false !== strpos($anchor, '?')) {
                    // 解析参数
                    list($anchor, $info['query']) = explode('?', $anchor, 2);
                }
                if (false !== strpos($anchor, '@')) {
                    // 解析域名
                    list($anchor, $domain) = explode('@', $anchor, 2);
                }
            } elseif (strpos($url, '@') && false === strpos($url, '\\')) {
                // 解析域名
                list($url, $domain) = explode('@', $url, 2);
            }
        }

        // 解析参数
        if (is_string($vars)) {
            // aaa=1&bbb=2 转换成数组
            parse_str($vars, $vars);
        }

        if ($url) {
            $route_name = isset($name) ? $name : $url . (isset($info['query']) ? '?' . $info['query'] : '');
            $rule = Route::name($route_name);
            if (is_null($rule) && isset($info['query'])) {
                $rule = Route::name($url);
                // 解析地址里面参数 合并到vars
                parse_str($info['query'], $params);
                $vars = array_merge($params, $vars);
                unset($info['query']);
            }
            // 整个会员中心支持路由
            /*if (!empty($lang_switch_on) && empty($rule) && preg_match('/^(user)\//', $url)) {
                $rule_tmp = Route::name('user/Users/route_demo');
                if (!empty($rule_tmp[0][0]) && stristr($rule_tmp[0][0], '<lang>/')) {
                    $rule_tmp[0][0] = preg_replace('/^(user)\//', '<lang>/${1}/', $url);
                    $rule = $rule_tmp;
                }
            }*/
        }
        if (!empty($rule) && $match = self::getRuleUrl($rule, $vars)) {
            // 匹配路由命名标识
            $url = $match[0];
            // 替换可选分隔符
            $url = preg_replace(['/(\W)\?$/', '/(\W)\?/'], ['', '\1'], $url);
            if (!empty($match[1])) {
                $domain = $match[1];
            }
            if (!is_null($match[2])) {
                $suffix = $match[2];
            }
        } elseif (!empty($rule) && isset($name)) {
            throw new \InvalidArgumentException('route name not exists:' . $name);
        } else {
            // 检查别名路由
            $alias      = Route::rules('alias');
            $matchAlias = false;
            if ($alias) {
                // 别名路由解析
                foreach ($alias as $key => $val) {
                    if (is_array($val)) {
                        $val = $val[0];
                    }
                    if (0 === strpos($url, $val)) {
                        $url        = $key . substr($url, strlen($val));
                        $matchAlias = true;
                        break;
                    }
                }
            }
            if (!$matchAlias) {
                // 路由标识不存在 直接解析
                $url = self::parseUrl($url, $domain);
            }
            if (isset($info['query'])) {
                // 解析地址里面参数 合并到vars
                parse_str($info['query'], $params);
                $vars = array_merge($params, $vars);
            }
        }

        // 检测URL绑定
        if (!self::$bindCheck) {
            $type = Route::getBind('type');
            if ($type) {
                $bind = Route::getBind($type);
                if ($bind && 0 === strpos($url, $bind)) {
                    $url = substr($url, strlen($bind) + 1);
                }
            }
        }
        // 还原URL分隔符
        $depr = Config::get('pathinfo_depr');
        $url  = str_replace('/', $depr, $url);

        // URL后缀
        $suffix = in_array($url, ['/', '']) ? '' : self::parseSuffix($suffix);
        // 锚点
        $anchor = !empty($anchor) ? '#' . $anchor : '';
        
        static $uiset = null;
        null === $uiset && $uiset = $request->param('uiset/s', 'off');
        $uiset = trim($uiset, '/');
        if ('on' == $uiset) {
            $seo_pseudo = 1;
            $seo_pseudo_format = 1;
        } else {
            $ey_config = config('ey_config'); // URL模式 by 小虎哥
            $seo_pseudo = !empty($seo_pseudo) ? $seo_pseudo : $ey_config['seo_pseudo'];
            if (empty($seo_pseudo_format)) {
                if (1 == $seo_pseudo) {
                    $seo_pseudo_format = $ey_config['seo_dynamic_format'];
                } else if (3 == $seo_pseudo) {
                    $seo_pseudo_format = $ey_config['seo_rewrite_format'];
                }
            }
        }

        /*默认兼容模式，支持不开启pathinfo模式*/
        $urlinfo = $mca;
        // $urlinfo = explode('/', $url);
        $len = count($urlinfo);
        $m = !empty($urlinfo[$len - 3]) ? $urlinfo[$len - 3] : $request->module();
        $c = !empty($urlinfo[$len - 2]) ? $urlinfo[$len - 2] : $request->controller();
        $a = !empty($urlinfo[$len - 1]) ? $urlinfo[$len - 1] : $request->action();
        if (('user' == $m && empty($rule)) || (1 == $seo_pseudo && 1 == $seo_pseudo_format) || 2 == $seo_pseudo) {
            // 检测域名
            $domain = self::parseDomain($url, $domain);
            // URL组装
            $url = $domain . rtrim(self::$root ?: $request->root(), '/');
            if (1 == $seo_inlet && 'admin' != $m) {
                $url .= "/";
                if ('user' == $m || 2 == $seo_pseudo || stristr($request->url(), '/index.php')) {
                    $url .= "index.php";
                }
            }
            $url .= "?m={$m}&c={$c}&a={$a}";
            /*URL全局参数（比如：可视化uiset、多模板v、多语言lang）*/
            $urlParam = $request->param();
            if (isset($vars['lang']) && empty($vars['lang'])) {
                unset($urlParam['lang']);
            } else {
                !empty($vars['lang']) && !empty($urlParam['lang']) && $urlParam['lang'] = $vars['lang'];
            }
            $parse_url_param = Config::get('global.parse_url_param');
            foreach ($urlParam as $key => $val) {
                if (in_array($key, $parse_url_param)) {
                    $urlParam[$key] = trim($val, '/');
                } else {
                    unset($urlParam[$key]);
                }
            }
            is_array($vars) && $vars = array_merge($vars, $urlParam);
            /*--end*/

            /*当前默认语言下，在后台的非后台模块链接将去掉lang参数，比如：地图sitemap.xml以及栏目、内容浏览*/
            if ('admin' == $module) { // 后台分组模块
                if (!empty($vars['lang']) && $vars['lang'] == get_admin_lang()) {
                    if (3 == count($mca) && 'admin' != $mca[0]) { // 排除带有admin分组模块
                        unset($vars['lang']);
                    }
                } else {
                    if (2 == count($mca) || 'admin' == $mca[0]) { // 排除带有admin分组模块
                        !isset($vars['lang']) && $vars['lang'] = get_current_lang();
                    }
                }
            } else {
                /*URL全局参数（单语言不携带lang参数）*/
                if (empty($lang_switch_on)) {
                    unset($vars['lang']);
                }
            }
            /*--end*/

            // 参数组装
            if (!empty($vars)) {
                /*过滤分组模块、控制器、操作方法，以及没有值的参数*/
                foreach ($vars as $key => $val) {
                    if (in_array($key, ['m','c','a']) || empty($val)) {
                        unset($vars[$key]);
                    }
                }
                /*--end*/
                /*添加参数*/
                $vars = http_build_query($vars);
                if (!empty($vars)) {
                    $url .= "&".$vars.$anchor;
                }
                /*--end*/
            } else {
                $url .= $anchor;
            }
            /*--end*/
        } else {

            /*当前默认语言下，在后台的非后台模块链接将去掉lang参数，比如：地图sitemap.xml以及栏目、内容浏览*/
            if ('admin' == $module) { // 后台分组模块
                if (!empty($vars['lang']) && $vars['lang'] == get_admin_lang()) {
                    if (3 == count($mca) && 'admin' != $mca[0]) { // 排除带有admin分组模块
                        unset($vars['lang']);
                    }
                }
            }
            /*--end*/
            
            // 参数组装

            if (!empty($vars)) {
                // 添加参数
                if (Config::get('url_common_param')) {
                    $vars = http_build_query($vars);
                    $url .= $suffix . '?' . $vars . $anchor;
                } else {
                    $paramType = Config::get('url_param_type');
                    foreach ($vars as $var => $val) {
                        if ('' !== trim($val)) {
                            if ($paramType) {
                                $url .= $depr . urlencode($val);
                            } else {
                                $url .= $depr . $var . $depr . urlencode($val);
                            }
                        }
                    }
                    $url .= $suffix . $anchor;
                }
            } else {
                $url .= $suffix . $anchor;
            }
            // 检测域名
            $domain = self::parseDomain($url, $domain);
            // URL组装
            $url = $domain . rtrim(self::$root ?: $request->root(), '/') . '/' . ltrim($url, '/');
        }

        self::$bindCheck = false;
        return $url;
    }

    // 直接解析URL地址
    protected static function parseUrl($url, &$domain)
    {
        $request = Request::instance();
        if (0 === strpos($url, '/')) {
            // 直接作为路由地址解析
            $url = substr($url, 1);
        } elseif (false !== strpos($url, '\\')) {
            // 解析到类
            $url = ltrim(str_replace('\\', '/', $url), '/');
        } elseif (0 === strpos($url, '@')) {
            // 解析到控制器
            $url = substr($url, 1);
        } else {
            // 解析到 模块/控制器/操作
            $module  = $request->module();
            $domains = Route::rules('domain');
            if (true === $domain && 2 == substr_count($url, '/')) {
                $current = $request->host();
                $match   = [];
                $pos     = [];
                foreach ($domains as $key => $item) {
                    if (isset($item['[bind]']) && 0 === strpos($url, $item['[bind]'][0])) {
                        $pos[$key] = strlen($item['[bind]'][0]) + 1;
                        $match[]   = $key;
                        $module    = '';
                    }
                }
                if ($match) {
                    $domain = current($match);
                    foreach ($match as $item) {
                        if (0 === strpos($current, $item)) {
                            $domain = $item;
                        }
                    }
                    self::$bindCheck = true;
                    $url             = substr($url, $pos[$domain]);
                }
            } elseif ($domain) {
                if (isset($domains[$domain]['[bind]'][0])) {
                    $bindModule = $domains[$domain]['[bind]'][0];
                    if ($bindModule && !in_array($bindModule[0], ['\\', '@'])) {
                        $module = '';
                    }
                }
            }
            $module = $module ? $module . '/' : '';

            $controller = $request->controller();
            if ('' == $url) {
                // 空字符串输出当前的 模块/控制器/操作
                $action = $request->action();
            } else {
                $path       = explode('/', $url);
                $action     = array_pop($path);
                $controller = empty($path) ? $controller : array_pop($path);
                $module     = empty($path) ? $module : array_pop($path) . '/';
            }
            if (Config::get('url_convert')) {
                $action     = strtolower($action);
                $controller = Loader::parseName($controller);
            }
            $url = $module . $controller . '/' . $action;
        }
        return $url;
    }

    // 检测域名
    protected static function parseDomain(&$url, $domain)
    {
        if (!$domain) {
            return '';
        }
        $request    = Request::instance();
        $rootDomain = Config::get('url_domain_root');
        if (true === $domain) {
            // 自动判断域名
            $domain = Config::get('app_host') ?: $request->host();

            $domains = Route::rules('domain');
            if ($domains) {
                $route_domain = array_keys($domains);
                foreach ($route_domain as $domain_prefix) {
                    if (0 === strpos($domain_prefix, '*.') && strpos($domain, ltrim($domain_prefix, '*.')) !== false) {
                        foreach ($domains as $key => $rule) {
                            $rule = is_array($rule) ? $rule[0] : $rule;
                            if (is_string($rule) && false === strpos($key, '*') && 0 === strpos($url, $rule)) {
                                $url    = ltrim($url, $rule);
                                $domain = $key;
                                // 生成对应子域名
                                if (!empty($rootDomain)) {
                                    $domain .= $rootDomain;
                                }
                                break;
                            } elseif (false !== strpos($key, '*')) {
                                if (!empty($rootDomain)) {
                                    $domain .= $rootDomain;
                                }
                                break;
                            }
                        }
                    }
                }
            }

        } else {
            $lang_switch_on = Config::get('lang_switch_on');
            if (empty($rootDomain)) {
                $host       = Config::get('app_host') ?: $request->host();
                // if (!empty($lang_switch_on) && stristr($host, '.')) { // 多语言站点
                //     $rootDomain = $request->rootDomain($host);
                // } else {
                    $rootDomain = substr_count($host, '.') > 1 ? substr(strstr($host, '.'), 1) : $host;
                // }
            }
            // if (!empty($lang_switch_on) && $domain == $rootDomain) { // 多语言站点
            //     $domain = $rootDomain;
            // } else {
                if ($domain != $rootDomain) {
                    if (substr_count($domain, '.') < 2 && !strpos($domain, $rootDomain)) {
                        $domain .= '.' . $rootDomain;
                    }
                }
            // }
        }
        if (false !== strpos($domain, '://')) {
            $scheme = '';
        } else {
            $scheme = $request->isSsl() || Config::get('is_https') ? 'https://' : 'http://';
        }
        return $scheme . $domain;
    }

    // 解析URL后缀
    protected static function parseSuffix($suffix)
    {
        if ($suffix) {
            $suffix = true === $suffix ? Config::get('url_html_suffix') : $suffix;
            if ($pos = strpos($suffix, '|')) {
                $suffix = substr($suffix, 0, $pos);
            }
        }
        return (empty($suffix) || 0 === strpos($suffix, '.') || '/' == $suffix) ? $suffix : '.' . $suffix;
    }

    // 匹配路由地址
    public static function getRuleUrl($rule, &$vars = [])
    {
        foreach ($rule as $item) {
            list($url, $pattern, $domain, $suffix) = $item;
            if (empty($pattern)) {
                return [rtrim($url, '$'), $domain, $suffix];
            }

            /*同个模块、控制器、操作名对应多个路由规则，进行优先级别匹配 by 许宇资*/
            $unequal = 0;
            foreach ($pattern as $key => $val){
                if (!isset($vars[$key])){
                    $unequal = 1;
                    break;
                }
            }
            if ($unequal){
                continue;
            }
            /*end*/
            
            $type = Config::get('url_common_param');
            foreach ($pattern as $key => $val) {
                if (isset($vars[$key])) {
                    $url = str_replace(['[:' . $key . ']', '<' . $key . '?>', ':' . $key . '', '<' . $key . '>'], $type ? $vars[$key] : urlencode($vars[$key]), $url);
                    unset($vars[$key]);
                    $result = [$url, $domain, $suffix];
                } elseif (2 == $val) {
                    $url    = str_replace(['/[:' . $key . ']', '[:' . $key . ']', '<' . $key . '?>'], '', $url);
                    $result = [$url, $domain, $suffix];
                } else {
                    break;
                }
            }
            if (isset($result)) {
                return $result;
            }
        }
        return false;
    }

    // 指定当前生成URL地址的root
    public static function root($root)
    {
        self::$root = $root;
        Request::instance()->root($root);
    }
}
