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
class Language extends Model
{
    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
    }

    /**
     * 系统语言，删除语言变量时，不删除这些语言的变量数据
     * @return [type] [description]
     */
    public function system_lang_arr()
    {
        return ['cn','zh','en'];
    }

    /**
     * 创建语言时，需要复制数据的数据表（适用于不分表的数据表）
     * @return [type] [description]
     */
    public function tables_syn_data()
    {
        return ['ad','ad_position','arcrank','download_attr_field','arctype','config','config_attribute','config_type','form','guestbook_attribute','language_pack','links','links_group','nav_list','nav_position','setting','sms_template','smtp_tpl','ui_config','users_config','users_level','users_notice_tpl','users_parameter','users_type_manage','product_param'];
    }

    /**
     * 后置操作方法
     * 自定义的一个函数 用于数据新增之后做的相应处理操作, 使用时手动调用
     * @param int $aid 产品id
     * @param array $post post数据
     * @param string $opt 操作
     */
    public function afterAdd($insertId = '', $post = [])
    {
        $mark = trim($post['mark']);
        $copy_lang = trim($post['copy_lang']);

        // 重新生成全部数据表缓存字段文件
        schemaAllTable();

        /*创建语言的文档archives表*/
        $oldTable = PREFIX."archives_{$copy_lang}";
        $newTable = PREFIX."archives_{$mark}";
        @Db::execute("DROP TABLE IF EXISTS `{$newTable}`");
        try {
            $syn_status = @Db::execute("CREATE TABLE IF NOT EXISTS `{$newTable}` LIKE `{$oldTable}`");
        } catch (\Exception $e) {
            $syn_status = false;
        }
        if (false === $syn_status) {
            return $syn_status;
        } else {
            schemaTable($newTable);
        }
        /*--end*/

        /*创建语言的文档archives内容副表*/
        $syn_status = true;
        foreach (['article','product','images','single'] as $key => $nid) {
            $oldTable = PREFIX."{$nid}_content_{$copy_lang}";
            $newTable = PREFIX."{$nid}_content_{$mark}";
            @Db::execute("DROP TABLE IF EXISTS `{$newTable}`");
            try {
                $syn_status = @Db::execute("CREATE TABLE IF NOT EXISTS `{$newTable}` LIKE `{$oldTable}`");
            } catch (\Exception $e) {
                $syn_status = false;
            }
            if (false === $syn_status) {
                break;
            } else {
                schemaTable($newTable);
                if ('product' == $nid) {
                    $oldTable = PREFIX."product_param";
                    $newTable = PREFIX."product_param_{$mark}";
                    @Db::execute("DROP TABLE IF EXISTS `{$newTable}`");
                    try {
                        $syn_status = @Db::execute("CREATE TABLE IF NOT EXISTS `{$newTable}` LIKE `{$oldTable}`");
                    } catch (\Exception $e) {
                        $syn_status = false;
                    }
                    if (false === $syn_status) {
                        break;
                    } else {
                        schemaTable($newTable);
                    }
                }
            }
        }
        if (false === $syn_status) {
            return $syn_status;
        }
        /*--end*/

        /*复制语言的表数据*/
        $syn_status = true;
        foreach ($this->tables_syn_data() as $key => $table) {
            if (in_array($mark, $this->system_lang_arr())) {
                if (in_array($table, ['language_pack'])) {
                    $count = Db::name($table)->where(['lang'=>$mark])->count();
                    if (!empty($count)) {
                        continue;
                    }
                } else if (in_array($table, ['product_param'])) {
                    $count = Db::name($table."_{$mark}")->count();
                    if (!empty($count)) {
                        continue;
                    }
                }
            }
            if ('setting' == $table) {
                Db::name('setting')->where(['inc_type'=>'adminlogin'])->delete();
            }
            $insertField = $selectField = "";
            $tableFields = Db::name($table)->getTableFields();
            foreach ($tableFields as $_k => $_v) {
                if (0 < $_k) {
                    if (!empty($insertField)) {
                        $insertField .= ",";
                    }
                    $insertField .= "`{$_v}`";

                    if (!empty($selectField)) {
                        $selectField .= ",";
                    }
                    $selectField .= ('lang' == $_v) ? "'{$mark}' as `lang`" : "`{$_v}`";
                }
            }
            if (in_array($table, ['product_param'])) {
                $sql = "INSERT INTO `".PREFIX."{$table}_{$mark}` ({$insertField}) (SELECT {$selectField} FROM `".PREFIX."{$table}`)";
            } else {
                $sql = "INSERT INTO `".PREFIX."{$table}` ({$insertField}) (SELECT {$selectField} FROM `".PREFIX."{$table}` WHERE `lang` = '{$copy_lang}')";
            }
            try {
                $syn_status = @Db::execute($sql);
            } catch (\Exception $e) {
                $syn_status = false;
            }
            if (false === $syn_status) {
                break;
            } else {
                if ('language_pack' == $table) { // 复制后的语言变量值
                    Db::name('language_pack')->where(['lang'=>$mark])->update(['value'=>'']);
                }
            }
        }
        if (false === $syn_status) {
            // model('Language')->where("id",'IN',[$insertId])->delete();
            // $this->afterDel([$insertId], ['pl']);
            // var_dump($table);
            // exit;
            return $syn_status;
        }
        /*--end*/
        
        /*统计多语言数量*/
        $this->setLangNum();
        /*--end*/

        \think\Cache::clear();

        return true;
    }

    /**
     * 统计多语言数量
     */
    public function setLangNum()
    {
        \think\Cache::clear('system_langnum');
        $languageRow = Db::name('language')->field('mark')->select();
        $system_langnum = count($languageRow);
        foreach ($languageRow as $key => $val) {
            tpCache('system', ['system_langnum'=>$system_langnum], $val['mark']);
        }

        // 记录多语言启用数量
        $system_langnum = (int)Db::name('language')->where(['status'=>1])->count();
        $tfile = DATA_PATH.'conf'.DS.'lang_enable_num.txt';
        $fp = @fopen($tfile,'w');
        if(!$fp) {
            @file_put_contents($tfile, $system_langnum);
        }
        else {
            fwrite($fp, $system_langnum);
            fclose($fp);
        }
    }

    /**
     * 后置操作方法
     * 自定义的一个函数 用于数据删除之后做的相应处理操作, 使用时手动调用
     * @param int $aid 产品id
     * @param array $post post数据
     * @param string $opt 操作
     */
    public function afterDel($id_arr = [], $lang_list = [])
    {
        if (!empty($id_arr) && !empty($lang_list)) {
            // 至少保留一个语言是开启且默认
            $row = Db::name('language')->where(['status'=>1])->select();
            if (empty($row)) {
                Db::name('language')->where(['is_home_default'=>1])->update(['status'=>1,'update_time'=>getTime()]);
            }

            /*统计多语言数量*/
            $this->setLangNum();
            // 创建时删除多余的语言数据
            $this->delLangData($lang_list);
            // 重新生成全部数据表缓存字段文件
            schemaAllTable();
        }
    }

    /**
     * 创建时删除多余的语言数据
     * @param  [type] $lang_list [description]
     * @return [type]            [description]
     */
    public function delLangData($lang_list)
    {
        if (!empty($lang_list)) {
            $system_lang_arr = $this->system_lang_arr();
            $diff_langs = array_diff($lang_list, $system_lang_arr);
            // 非系统语言
            if (!empty($diff_langs)) {
                // 同步删除模板语言变量表数据
                Db::name('language_pack')->where("lang",'IN',$diff_langs)->delete();
                // 同步删除文档表
                foreach ($diff_langs as $key => $val) {
                    Db::execute("DROP TABLE IF EXISTS ".PREFIX."archives_{$val}");
                    foreach (['article','product','images','single'] as $_k => $_nid) {
                        Db::execute("DROP TABLE IF EXISTS ".PREFIX."{$_nid}_content_{$val}");
                        if ('product' == $_nid) {
                            Db::execute("DROP TABLE IF EXISTS ".PREFIX."product_param_{$val}");
                        }
                    }
                }
            }
            // 系统语言，不删表，只清数据
            if (!empty($system_lang_arr)) {
                foreach ($lang_list as $key => $val) {
                    if (in_array($val, $system_lang_arr)) {
                        foreach (['article','product','images','single'] as $_k => $_nid) {
                            Db::name("archives_{$val}")->where(['auto_id'=>['gt', 0]])->delete(true);
                            Db::name("{$_nid}_content_{$val}")->where(['auto_id'=>['gt', 0]])->delete(true);
                            if ('product' == $_nid) {
                                Db::name("product_param_{$val}")->where(['param_id'=>['gt', 0]])->delete(true);
                            }
                        }
                    }
                }
            }
            // 同步删除已复制的数据
            foreach ($this->tables_syn_data() as $key => $table) {
                if (!in_array($table, ['language_pack','product_param'])) {
                    Db::name($table)->where("lang",'IN',$lang_list)->delete();
                }
            }
            // 删除语言包
            foreach ($lang_list as $key => $val) {
                if (!in_array($val, $system_lang_arr)) {
                    @unlink(APP_PATH."lang/{$val}.php");
                    @unlink(ROOT_PATH."public/static/common/js/lang/pack/{$val}.js");
                    @unlink(DATA_PATH."schema/ey_archives_{$val}.php");
                    foreach (['article','product','images','single'] as $_k => $_nid) {
                        @unlink(DATA_PATH."schema/ey_{$_nid}_content_{$val}.php");
                        if ('product' == $_nid) {
                            @unlink(DATA_PATH."schema/ey_product_param_{$val}.php");
                        }
                    }
                }
            }
            // 清除缓存
            \think\Cache::clear();
        }
    }

    public function isValidateStatus($field = '', $value = '')
    {
        $return = true;

        $value = trim($value);
        if ($value == 0 && $field == 'status') {
            $count = Db::name('language')->where(['status'=>1])->count();
            if ($count <= 1) {
                $return = [
                    'time'  => 2,
                    'msg'   => '至少要开启一个语言',
                    'refresh' => 0,
                ];
            }
        }
        else if ($value == 0 && $field == 'is_home_default') {
            $count = Db::name('language')->where(['is_home_default'=>1])->count();
            if ($count <= 1) {
                $return = [
                    'time'  => 2,
                    'msg'   => '至少要设置一个默认语言',
                    'refresh' => 0,
                ];
            }
        }

        return $return;
    }

    /**
     * 对保存的数据进行lang字段的赋值
     * @param  array  $data [description]
     * @return [type]       [description]
     */
    public function getMultiLanguageInsertAll($data = [])
    {
        // 定义数组
        $result = [];

        // 处理多语言数据
        if (!empty($data)) {
            // 查询使用的语言列表
            $list = Db::name('language')->where(['status' => 1])->column('mark');
            if (!empty($list)) {
                foreach ($list as $lang) {
                    if (!empty($lang)) {
                        $data['lang'] = $lang;
                        $result[] = $data;
                    }
                }
            }
            // 没有使用多语言
            else {
                $result[] = $data;
            }
        }

        // 返回数组
        return $result;   
    }
}