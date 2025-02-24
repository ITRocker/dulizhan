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

namespace app\admin\model;

use think\Db;
use think\Model;

/**
 * 标签索引
 */
class Tagindex extends Model
{
    public $main_lang = 'cn';
    public $admin_lang = 'cn';

    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        $this->main_lang = get_main_lang();
        $this->admin_lang = get_admin_lang();
    }

    /**
     * 同步新增文档tag的ID到多语言的模板变量里
     */
    public function syn_add_language_attribute($tagids = [])
    {
        /*单语言情况下不执行多语言代码*/
        if (!is_language() || tpCache('language.language_split')) {
            return true;
        }
        /*--end*/

        $attr_group = 'tagindex';
        $admin_lang = $this->admin_lang;
        $main_lang = $this->main_lang;
        $languageRow = Db::name('language')->field('mark')->order('id asc')->select();
        if (!empty($languageRow) && $admin_lang == $main_lang) { // 当前语言是主体语言，即语言列表最早新增的语言
            $tagindex_db = Db::name('tagindex');
            $result = $tagindex_db->where(['id'=>['IN', $tagids]])->select();
            if (empty($result)) {
                return true;
            }
            $tagindexInsert = [];
            foreach ($result as $key => $val) {
                $tagindexInsert[] = [
                    'attr_title'    => $val['tag'],
                    'attr_name'     => 'tagindex'.$val['id'],
                    'attr_group'    => $attr_group,
                    'add_time'      => getTime(),
                    'update_time'   => getTime(),
                ];
            }
            $rdata = model('LanguageAttr')->saveAll($tagindexInsert);
            if (false !== $rdata) {
                $data = [];
                foreach ($languageRow as $key => $val) {
                    /*同步新tag到其他语言tag列表*/
                    if ($val['mark'] != $admin_lang) {
                        // 对应的栏目ID start
                        $arctypeAttrList = Db::name('language_attr')->field('attr_name,attr_value')
                            ->where([
                                'attr_group' => 'arctype',
                                'lang' => $val['mark'],
                            ])->getAllWithIndex('attr_name');
                        // 对应的栏目ID end
                        $tagindexInsert = [];
                        foreach ($result as $_k => $_v) {
                            $addsaveData = $_v;
                            $tagid_old = $_v['id'];
                            $addsaveData['tagid_old']  = $tagid_old;
                            unset($addsaveData['id']);
                            $addsaveData['lang']  = $val['mark'];
                            // $addsaveData['tag'] = $val['mark'].$addsaveData['tag']; // 临时测试
                            $addsaveData['typeid'] = !empty($arctypeAttrList['tid'.$addsaveData['typeid']]) ? $arctypeAttrList['tid'.$addsaveData['typeid']]['attr_value'] : 0;
                            $tagindexInsert[] = $addsaveData;
                        }
                        $rdata = model('Tagindex')->saveAll($tagindexInsert);
                        if (empty($rdata)) {
                            return false;
                        }
                        
                        foreach ($rdata as $_k => $_v) {
                            $tagid_new = (int)$_v->getData('id');
                            $tagid_old = (int)$_v->getData('tagid_old');
                            $typeid = (int)$_v->getData('typeid');
                        }
                        $addsaveData = $result;
                        $addsaveData['lang']  = $val['mark'];
                        // $addsaveData['tag'] = $val['mark'].$addsaveData['tag']; // 临时测试
                        unset($addsaveData['id']);
                        $adp_id = $tagindex_db->insertGetId($addsaveData);
                        /*所有语言绑定在主语言的ID容器里*/
                        $data[] = [
                            'attr_name' => $attr_name,
                            'attr_value'    => $adp_id,
                            'lang'  => $val['mark'],
                            'attr_group'    => $attr_group,
                            'add_time'      => getTime(),
                            'update_time'   => getTime(),
                        ];
                        /*--end*/
                    }
                    /*--end*/
                }
                if (!empty($data)) {
                    model('LanguageAttr')->saveAll($data);
                }
            }
        }
    }
}