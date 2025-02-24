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

namespace app\common\model;

use think\Db;
use think\Model;

/**
 * 模型
 */
class LanguagePack extends Model
{
    public $lang = '';
    public $pack_type_arr = [
        0 => '全部',
        1 => '公共',
        2 => '搜索',
        3 => '询盘',
        4 => '面包屑',
        5 => '会员中心',
        99 => '自定义',
    ];

    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        $this->lang = get_current_lang();
        if (1 != (int)getUsersConfigData('shop.shop_open', [], $this->lang)) {
            unset($this->pack_type_arr[5]);
        }
    }

    /**
     * 生成语言包文件
     */
    public function updateLangFile($marks = [])
    {
        $result = [];
        $default_lang = get_default_lang(true);
        $where = [];
        if (!empty($mark)) {
            $where['lang'] = ['IN', $marks];
        } else {
            $where['pack_id'] = ['gt', 0];
        }
        $packRow = Db::name('language_pack')->field('name,value,lang')->where($where)->order('lang asc, type asc, pack_id asc')->select();
        foreach ($packRow as $key => $val) {
            $result[$val['lang']][$val['name']] = $val['value'];
        }
        clearstatcache(); // 清除文件夹权限缓存
        foreach ($result as $key => $val) {
            // JS版语言变量包
            $jsContent =<<<EOF
/**
 * JS文件的多语言变量包
 */

function ey_lang(string, ...args) {
    return string.replace(/%([a-zA-Z0-9]{1,1})/g, function() {
        return args.shift();
    });
}

EOF;
            foreach ($val as $_k => $_v) {
                $_v = empty($_v) ? $result[$default_lang][$_k] : $_v;
                // 强制所有语言的会员中心都支持英文版
                /*if (preg_match('/^users(\d+)$/i', $_k)) {
                    $_v = $result['en'][$_k];
                }*/
                // end
                $val[$_k] = $_v;
                $jsContent .= "var ey_langpack_{$_k} = \"{$_v}\";" . PHP_EOL;
            }
            $filepath = ROOT_PATH."public/static/common/js/lang/pack/{$key}.js";
            $fp = @fopen($filepath, "w+");
            if (is_writeable($filepath) && !empty($fp)) {
                if (@fwrite($fp, $jsContent)) {
                    fclose($fp);
                } else {
                    @file_put_contents( $filepath, $jsContent );
                }
            }

            // php版语言变量包
            $filepath = APP_PATH."lang/{$key}.php";
            $fp = @fopen($filepath, "w+");
            if (is_writeable($filepath) && !empty($fp)) {
                $content = "<?php\r\n\r\n"."return ".var_export($val,true).";";
                if (@fwrite($fp, $content)) {
                    fclose($fp);
                } else {
                    @file_put_contents( $filepath, $content );
                }
            }
        }
    }

    public function appendPackGlobalJs(&$params = '')
    {
        $file = "public/static/common/js/lang/pack/".$this->lang.".js";
        // 强制所有语言的会员中心都支持英文版
        /*if (file_exists(ROOT_PATH . $file)) {
            $file = "public/static/common/js/lang/pack/en.js";
        }*/
        if (file_exists(ROOT_PATH . $file)) {
            $root_dir = ROOT_DIR;
            $file_time = getTime();
            try{
                $fileStat = stat(ROOT_PATH . $file);
                $file_time = !empty($fileStat['mtime']) ? $fileStat['mtime'] : $file_time;
            } catch (\Exception $e) {}
            $replacement =<<<EOF
<!-- 引入语言变量包 -->
<script language="javascript" type="text/javascript" src="{$root_dir}/{$file}?v={$file_time}"></script>
EOF;
            $params = preg_replace('/(<script(\s+)([^>]*)src=(\'|\")([^\'\"]*)\/public\/plugins\/layer-v3.1.0\/layer.js([^\'\"]*)(\'|\")(\s*)>(\s*)<\/script>)/i', $replacement.PHP_EOL.'${1}', $params);
        }
    }

    /**
     * 完善语言标识为空的记录
     * @return [type] [description]
     */
    public function update_empty_pack_data($mark = '')
    {
        $opt_source = input('param.opt_source/s');
        if (in_array($opt_source, ['pack_add'])) {
            return true;
        }
        // 标识值为空的所有name集合
        $name_arr = [];
        $where = [];
        $where[] = Db::raw("(`value` = '' OR `value` IS NULL)");
        if (!empty($mark)) {
            $where['lang'] = ['NEQ', $mark];
        }
        $result = Db::name('language_pack')->field('auto_id,name,value,lang')->where($where)->select();
        foreach ($result as $key => $val) {
            $name_arr[] = $val['name'];
        }
        if (!empty($name_arr)) {
            // 默认语言的语言标识值
            $row = Db::name('language_pack')->field('name,value')->where(['name'=>['IN', $name_arr], 'lang'=>get_default_lang(true)])->getAllWithIndex('name');
            // 组装要批量更新的语言标识数据
            $saveData = [];
            foreach ($result as $key => $val) {
                $saveData[] = [
                    'auto_id' => $val['auto_id'],
                    'value' => empty($row[$val['name']]) ? '' : $row[$val['name']]['value'],
                    'update_time' => getTime(),
                ];
            }
            model('LanguagePack')->saveAll($saveData);
        }
    }

    /**
     * 注册表单专属的语言变量ID集合
     * @return [type] [description]
     */
    public function getUsersParameterPackIds()
    {
        return [108,109,110,111];
    }

    /**
     * 注册表单的字段专用语言变量
     * @param  string $lang [description]
     * @return [type]       [description]
     */
    public function getUsersParameterPack($lang = '', $index_key = '')
    {
        $result = Db::name('language_pack')->where([
                'pack_id' => ['IN', $this->getUsersParameterPackIds()],
                'type' => 5,
                'lang' => $lang,
            ])
            ->order('sort_order asc, pack_id asc')
            ->select();
        if (!empty($result) && !empty($index_key)) {
            $rtn = array();
            foreach ($result as $_k => $_v) {
                $rtn[$_v[$index_key]] = $_v;
            }
            $result = $rtn;
        }

        return $result;
    }
}