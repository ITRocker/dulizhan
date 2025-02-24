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
 * 文章
 */
class Article extends Model
{
    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
    }

    /**
     * 后置操作方法
     * 自定义的一个函数 用于数据保存后做的相应处理操作, 使用时手动调用
     * @param int $aid 产品id
     * @param array $post post数据
     * @param string $opt 操作
     */
    public function afterSave($aid, $post, $opt)
    {
        $post['aid'] = $aid;
        $addonFieldExt = !empty($post['addonFieldExt']) ? $post['addonFieldExt'] : array();
        $FieldModel = new \app\admin\model\Field;
        $FieldModel->dealChannelPostData($post['channel'], $post, $addonFieldExt);
        
        // 处理外贸链接
        if (is_dir('./weapp/Waimao/')) {
            $waimaoLogic = new \weapp\Waimao\logic\WaimaoLogic;
            $waimaoLogic->update_htmlfilename($aid, $post, $opt);
        } else {
            $foreignLogic = new \app\admin\logic\ForeignLogic;
            $foreignLogic->update_htmlfilename($aid, $post, $opt);
        }

        // --处理TAG标签
        model('Taglist')->savetags($aid, $post['typeid'], $post['tags'], $post['arcrank'], $opt);

        if ('edit' == $opt) {
            // 清空sql_cache_table数据缓存表 并 添加查询执行语句到mysql缓存表
            Db::execute('TRUNCATE TABLE '.config('database.prefix').'sql_cache_table');
            model('SqlCacheTable')->InsertSqlCacheTable(true);
        } else {
            // 处理mysql缓存表数据
            if (isset($post['arcrank']) && -1 == $post['arcrank'] /*&& -1 == $post['old_arcrank']*/ && !empty($post['users_id'])) {
                // 待审核
                model('SqlCacheTable')->UpdateDraftSqlCacheTable($post, $opt);
            } else if (isset($post['arcrank'])) {
                // 已审核
                $post['old_typeid'] = intval($post['attr']['typeid']);
                model('SqlCacheTable')->UpdateSqlCacheTable($post, $opt, 'article');
            }
        }
    }

    /**
     * 获取单条记录
     * @author wengxianhu by 2017-7-26
     */
    public function getInfo($aid, $field = null, $isshowbody = true)
    {
        $result = array();
        $field = !empty($field) ? $field : '*';
        $result = Db::name('archives')->field($field)
            ->where([
                'aid'   => $aid,
                // 'lang'  => get_admin_lang(),
            ])
            ->find();
        if ($isshowbody) {
            $tableName = Db::name('channeltype')->where('id','eq',$result['channel'])->getField('table');
            $result['addonFieldExt'] = Db::name($tableName.'_content')->where('aid',$aid)->find();
        }

        // 文章TAG标签
        if (!empty($result)) {
            $typeid = isset($result['typeid']) ? $result['typeid'] : 0;
            $tags = model('Taglist')->getListByAid($aid, $typeid);
            $result['tags'] = $tags['tag_arr'];
            $result['tag_id'] = $tags['tid_arr'];
        }

        // 查询栏目名称
        $result['typename'] = !empty($typeid) ? Db::name('arctype')->where('id', $typeid)->getField('typename') : '';

        return $result;
    }

    /**
     * 删除的后置操作方法
     * 自定义的一个函数 用于数据删除后做的相应处理操作, 使用时手动调用
     * @param int $aid
     */
    public function afterDel($aidArr = array())
    {
        if (is_string($aidArr)) {
            $aidArr = explode(',', $aidArr);
        }
        // 同时删除内容
        Db::name('article_content')->where(array('aid'=>array('IN', $aidArr)))->delete();
        // 同时删除TAG标签
        model('Taglist')->delByAids($aidArr);
        // 减少统计数
        del_statistics_data(7, $aidArr);
    }

    /**
     * 同步新增文档ID到多语言的模板文档变量里
     */
    public function syn_add_language_attribute($aid)
    {
        /*单语言 | 语言分离 情况下不执行多语言代码*/
        if (!is_language() || tpCache('language.language_split')) {
            return true;
        }
        /*--end*/

        $attr_group = 'archives';
        $admin_lang = get_admin_lang();
        $main_lang = get_main_lang();
        $languageRow = Db::name('language')->field('mark')->order('id asc')->select();
        if (!empty($languageRow) && $admin_lang == $main_lang) { // 当前语言是主体语言，即语言列表最早新增的语言
            $archivesRow = Db::name('archives')->find($aid);
            $attr_name = 'aid'.$aid;
            $r = Db::name('language_attribute')->save([
                'attr_title'    => $archivesRow['title'],
                'attr_name'     => $attr_name,
                'attr_group'    => $attr_group,
                'add_time'      => getTime(),
                'update_time'   => getTime(),
            ]);
            if (false !== $r) {
                $channeltype_info = Db::name('channeltype')->where(['id'=>$archivesRow['channel']])->find();
                $data = [];
                foreach ($languageRow as $key => $val) {
                    if ($val['mark'] == $admin_lang) {
                        /*当前后台语言绑定在主语言的ID容器里*/
                        $data[] = [
                            'attr_name' => $attr_name,
                            'attr_value'    => $aid,
                            'lang'  => $val['mark'],
                            'attr_group'    => $attr_group,
                            'channel' => $archivesRow['channel'],
                            'add_time'      => getTime(),
                            'update_time'   => getTime(),
                        ];
                        /*--end*/
                        break;
                    }
                }
                foreach ($languageRow as $key => $val) {
                    /*同步新文档到其他语言文档列表*/
                    if ($val['mark'] != $admin_lang) {
                        // 对应的栏目ID start
                        $arctypeAttrList = Db::name('language_attr')->field('attr_name,attr_value')
                            ->where([
                                'attr_group' => 'arctype',
                                'lang' => $val['mark'],
                            ])->getAllWithIndex('attr_name');
                        // 对应的栏目ID end
                        
                        $addsaveData = $archivesRow;
                        $addsaveData['lang'] = $val['mark'];
                        // $addsaveData['title'] = $val['mark'].$addsaveData['title']; // 临时测试
                        $addsaveData['typeid'] = !empty($arctypeAttrList['tid'.$addsaveData['typeid']]) ? $arctypeAttrList['tid'.$addsaveData['typeid']]['attr_value'] : 0;
                        // 副栏目
                        if (!empty($addsaveData['stypeid'])) {
                            $stypeid = trim($addsaveData['stypeid'], ',');
                            $stypeid_arr = explode(',', $stypeid);
                            foreach ($stypeid_arr as $_k => $_v) {
                                if (!empty($arctypeAttrList['tid'.$_v])) {
                                    $_v = $arctypeAttrList['tid'.$_v]['attr_value'];
                                } else {
                                    unset($stypeid_arr[$_k]);
                                }
                                $stypeid_arr[$_k] = $_v;
                            }
                            $addsaveData['stypeid'] = implode(',', $stypeid_arr);
                        }
                        $redata = model('Language')->syn_archives_logic('merge', ['data'=>$addsaveData, 'channeltype_info'=>$channeltype_info, 'copy_lang'=>$archivesRow['lang']]);
                        $addsaveData = $redata['data'];
                        unset($addsaveData['aid']);
                        $aid = Db::name('archives')->insertGetId($addsaveData);
                        if ($aid === false) {
                            return false; // 同步失败
                        }
                        $addsaveData['aid'] = $aid;

                        model('Language')->syn_archives_logic('afterSave', ['data'=>$addsaveData, 'channeltype_info'=>$channeltype_info]);

                        /*所有语言绑定在主语言的ID容器里*/
                        $data[] = [
                            'attr_name' => $attr_name,
                            'attr_value'    => $aid,
                            'lang'  => $val['mark'],
                            'attr_group'    => $attr_group,
                            'channel' => $archivesRow['channel'],
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