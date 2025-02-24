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

use \think\Db;
use \think\Request;
use \think\Config;

/**
 * 全局变量
 */
class TagGlobal extends Base
{
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
    }

    /**
     * 获取全局变量
     * @author wengxianhu by 2018-4-20
     */
    public function getGlobal($name = '')
    {
        if (empty($name)) {
            return '标签global报错：缺少属性 name 。';
        }

        $param = explode('|', $name);
        $name = trim($param[0], '$');
        $value = '';

        $uiset = I('param.uiset/s', 'off');
        $uiset = trim($uiset, '/');

        /*PC端与手机端的变量名自适应，可彼此通用*/
        if (in_array($name, ['web_thirdcode_pc','web_thirdcode_wap'])) { // 第三方代码
            $name = 'web_thirdcode_' . (isMobile() ? 'wap' : 'pc');
        }
        /*--end*/

        $ctl = binaryJoinChar(config('binary.5'), 13);
        $act = binaryJoinChar(config('binary.6'), 5);
        $globalArr = $ctl::$act($name);
        if (!empty($globalArr['data'])) {
            $value = $globalArr['value'];
            $globalData = $globalArr['data'];

            switch ($name) {
                case 'web_basehost':
                case 'web_cmsurl':
                    {
                        /*URL全局参数（比如：可视化uiset、多模板v、多语言lang）*/
                        $parse_url_param = Config::get('global.parse_url_param');
                        $urlParam = self::$request->param();
                        foreach ($urlParam as $key => $val) {
                            if (in_array($key, $parse_url_param)) {
                                $urlParam[$key] = trim($val, '/');
                            } else {
                                unset($urlParam[$key]);
                            }
                        }
                        /*--end*/

                        if ('on' == $uiset) {
                            $value = url('home/Index/index', $urlParam);
                            if (!stristr($value, '?')) {
                                $value .= '?';
                            } else {
                                $value .= '&';
                            }
                            $value .= http_build_query(['tmp'=>'']);
                        } else {
                            if (empty($globalData['web_basehost'])) {
                                $value = !empty($this->root_dir) ? $this->root_dir : '/';
                            } else {
                                $value = self::$request->scheme().'://'.preg_replace('/^(([^\/]*)\/\/)?([^\/]+)(.*)$/i', '${3}', $globalData['web_basehost']).$this->root_dir;
                            }

                            $separate_mobile = config('ey_config.separate_mobile');
                            if (1 == $globalData['seo_pseudo'] || 1 == $separate_mobile) {
                                if (self::$lang_switch_on) { // 多语言站点
                                    if (self::$request->domainPrefix() == self::$home_lang) {
                                        $value = self::$request->domain().$this->root_dir;
                                    }
                                }
                                if (!empty($urlParam)) {
                                    /*是否隐藏小尾巴 index.php*/
                                    $seo_inlet = config('ey_config.seo_inlet');
                                    if (0 == intval($seo_inlet) || 2 == $globalData['seo_pseudo']) {
                                        $value .= '/index.php';
                                    } else {
                                        $value .= '/';
                                    }
                                    /*--end*/
                                    if (!stristr($value, '?')) {
                                        $value .= '?';
                                    } else {
                                        $value .= '&';
                                    }
                                    $value .= http_build_query($urlParam);
                                }
                            } else {
                                if (self::$lang_switch_on) { // 多语言站点
                                    $value = self::$request->domain().$this->root_dir;
                                    if (get_default_lang() != self::$home_lang) {
                                        $value = rtrim(url('home/Index/index'), '/');
                                    }
                                }
                            }
                        }
                        
                        if (stristr(self::$request->host(true), '.yiyocms.com')) {
                            $value = preg_replace('/^(http:|https:)/i', '', $value);
                        }
                    }
                    break;

                case 'web_root_dir':
                    $value = $this->root_dir;
                    break;
                
                case 'web_recordnum':
                    if (!empty($value) && empty($globalData['web_recordnum_mode'])) {
                        $value = '<a href="https://beian.miit.gov.cn/" rel="nofollow" target="_blank">'.$value.'</a>';
                    }
                    break;
                
                case 'web_garecordnum':
                    if (!empty($value) && empty($globalData['web_garecordnum_mode'])) {
                        $recordcode = preg_replace('/([^\d\-]+)/i', '', $value);
                        $value = '<a href="http://www.beian.gov.cn/portal/registerSystemInfo?recordcode='.$recordcode.'" rel="nofollow" target="_blank">'.$value.'</a>';
                    }
                    break;

                case 'web_templets_pc':
                case 'web_templets_m':
                    if (empty($globalData['web_tpl_theme']) && file_exists('./template/default')) {
                        $value = str_replace('/template/', '/template/default/', $value);
                    }
                    $value = $this->root_dir.$value;
                    break;

                case 'web_thirdcode_pc':
                case 'web_thirdcode_wap':
                    $value = '';
                    break;

                case 'ey_common_hidden':
                    $baseFile = self::$request->baseFile();
                    $value = <<<EOF
    <script type="text/javascript">
        var __eyou_basefile__ = '{$baseFile}';
        var __root_dir__ = '{$this->root_dir}';
    </script>
EOF;
                    break;

                case 'web_ico':
                    /*支持子目录*/
                    $value = preg_replace('#^(/[/\w\-]+)?(/)#i', '$2', $value); // 支持子目录
                    $value = $this->root_dir.$value;
                    /*--end*/
                    break;

                default:
                    if (preg_match('/^web_attrname_(\d+)$/i', $name)) {
                        static $config_attribute = null;
                        if (null === $config_attribute) {
                            $row = Db::name('config_attribute')->field('attr_id,attr_name,attr_var_name')->where(['lang'=>self::$home_lang])->select();
                            foreach ($row as $key => $val) {
                                $attr_id = str_replace('web_attr_', '', $val['attr_var_name']);
                                $config_attribute['web_attrname_'.$attr_id] = $val;
                            }
                        }
                        $value = !empty($config_attribute[$name]) ? $config_attribute[$name]['attr_name'] : '';
                    } else {
                        /*支持子目录*/
                        $value = handle_subdir_pic($value, 'html');
                        $value = handle_subdir_pic($value);
                        /*--end*/
                    }
                    break;
            }

            foreach ($param as $key => $val) {
                if ($key == 0) continue;
                $value = $val($value);
            }
            
            $value = htmlspecialchars_decode($value);
        }

        return $value;
    }
}