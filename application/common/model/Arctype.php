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
 * 栏目
 */
class Arctype extends Model
{
    public $lang = 'cn';
    public $language_split = 0;

    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        $this->lang = get_current_lang();
        $this->language_split = tpCache('language.language_split');
    }

    /**
     * 获取单条记录
     * @author wengxianhu by 2017-7-26
     */
    public function getInfo($id, $field = '', $get_parent = false)
    {
        if (empty($field)) {
            $field = 'c.*, a.*';
        }
        $field .= ', a.id as typeid';

        /*当前栏目信息*/
        $result = Db::name('Arctype')->field($field)
            ->alias('a')
            ->where(['a.id'=>$id, 'a.lang'=>$this->lang])
            ->join('__CHANNELTYPE__ c', 'c.id = a.current_channel', 'LEFT')
            ->cache(true,EYOUCMS_CACHE_TIME,"arctype")
            ->find();
        /*--end*/
        if (!empty($result)) {
            if ($get_parent) {
                $result['typeurl'] = $this->getTypeUrl($result); // 当前栏目的URL
                /*获取当前栏目父级栏目信息*/
                if ($result['parent_id'] > 0) {
                    $parent_row = Db::name('Arctype')->field($field)
                        ->alias('a')
                        ->where(['a.id'=>$result['parent_id'], 'a.lang'=>$this->lang])
                        ->join('__CHANNELTYPE__ c', 'c.id = a.current_channel', 'LEFT')
                        ->cache(true,EYOUCMS_CACHE_TIME,"arctype")
                        ->find();
                    $ptypeurl = $this->getTypeUrl($parent_row);
                    $parent_row['typeurl'] = $ptypeurl;
                } else {
                    $parent_row = $result;
                }
                /*--end*/

                /*给每个父类字段开头加上p*/
                foreach ($parent_row as $key => $val) {
                    $newK = 'p'.$key;
                    $parent_row[$newK] = $val;
                }
                /*--end*/
                $result = array_merge($result, $parent_row);
            } else {
                $result = $this->parentAndTopInfo($id, $result);
            }
        }

        return $result;
    }

    /**
     * 获取指定栏目的父级和顶级栏目信息（用于前台与静态生成）
     * @author wengxianhu by 2017-7-26
     */
    public function parentAndTopInfo($id, $result = [])
    {
        $result['typeurl'] = $this->getTypeUrl($result); // 当前栏目的URL
        if (!empty($result['parent_id'])) {
            // 当前栏目的父级栏目信息
            $parent_row = Db::name('arctype')->where(['id'=>$result['parent_id'],'lang'=>$this->lang])
                ->cache(true,EYOUCMS_CACHE_TIME,"arctype")
                ->find();
            $ptypeid = $parent_row['id'];
            $ptypeurl = $this->getTypeUrl($parent_row);
            $ptypename = $parent_row['typename'];
            $pdirname = $parent_row['dirname'];
            // 当前栏目的顶级栏目信息
            if (!isset($result['toptypeurl'])) {
                $allPid = $this->getAllPid($id);
                $toptypeinfo = current($allPid);
                $toptypeid = $toptypeinfo['id'];
                $toptypeurl = $this->getTypeUrl($toptypeinfo);
                $toptypename = $toptypeinfo['typename'];
                $topdirname = $toptypeinfo['dirname'];
            }
            // end
        } else {
            // 当前栏目的父级栏目信息 或 顶级栏目的信息
            $toptypeid = $ptypeid = $result['id'];
            $toptypeurl = $ptypeurl = $result['typeurl'];
            $toptypename = $ptypename = $result['typename'];
            $topdirname = $pdirname = $result['dirname'];
        }
        // 当前栏目的父级栏目信息
        $result['ptypeid'] = $ptypeid;
        $result['ptypeurl'] = $ptypeurl;
        $result['ptypename'] = $ptypename;
        $result['pdirname'] = $pdirname;
        // 当前栏目的顶级栏目信息
        !isset($result['toptypeid']) && $result['toptypeid'] = $toptypeid;
        !isset($result['toptypeurl']) && $result['toptypeurl'] = $toptypeurl;
        !isset($result['toptypename']) && $result['toptypename'] = $toptypename;
        !isset($result['topdirname']) && $result['topdirname'] = $topdirname;
        // end

        return $result;
    }

    /**
     * 根据目录名称获取单条记录
     * @author wengxianhu by 2018-4-20
     */
    public function getInfoByDirname($dirname)
    {
        $cacheKey = 'arctype-'.md5(__CLASS__.__FUNCTION__.$dirname.$this->lang);
        $result = cache($cacheKey);
        if (empty($result)) {
            $field = 'c.*, a.*, a.id as typeid';

            $result = Db::name('Arctype')->field($field)
                ->alias('a')
                ->where(['a.dirname'=>$dirname, 'a.lang'=>$this->lang])
                ->join('__CHANNELTYPE__ c', 'c.id = a.current_channel', 'LEFT')
                // ->cache(true,EYOUCMS_CACHE_TIME,"arctype")
                ->find();
            if (!empty($result)) {
                $result['typeurl'] = $this->getTypeUrl($result);

                $result_tmp = Db::name('arctype')->where(['id'=>$result['parent_id'],'lang'=>$this->lang])->find();
                $result['ptypeurl'] = $this->getTypeUrl($result_tmp);
            }

            cache($cacheKey, $result, null, 'arctype');
        }

        return $result;
    }

    /**
     * 检测是否有子栏目
     * @author wengxianhu by 2017-7-26
     */
    public function hasChildren($id)
    {
        if (is_array($id)) {
            $ids = array_unique($id);
            $row = Db::name('Arctype')->field('parent_id, count(id) AS total')->where([
                    'parent_id'=>['IN', $ids],
                    'lang'=>$this->lang,
                    'current_channel'=>['neq', 51], // 过滤问答模型
                    'is_del'    => 0,
                ])->group('parent_id')->getAllWithIndex('parent_id');
            return $row;
        } else {
            $count = Db::name('Arctype')->where([
                    'parent_id' => $id,
                    'lang' => $this->lang,
                    'current_channel'=>['neq', 51], // 过滤问答模型
                    'is_del'    => 0,
                ])->count('id');
            return ($count > 0 ? 1 : 0);
        }
    }

    /**
     * 获取栏目的URL
     */
    public function getTypeUrl($res)
    {
        if ($res['is_part'] == 1) {
            $typeurl = get_absolute_url($res['typelink']);
        } else {
            $ctl_name = get_controller_byct($res['current_channel']);
            $typeurl = typeurl("home/{$ctl_name}/lists", $res);
        }

        return $typeurl;
    }


    /**
     * 获取指定级别的栏目列表
     * @param string type son表示下一级栏目,self表示同级栏目,top顶级栏目
     * @param boolean $self 包括自己本身
     * @author wengxianhu by 2018-4-26
     */
    public function getChannelList($id = '', $type = 'son')
    {
        $result = array();
        switch ($type) {
            case 'son':
                $result = $this->getSon($id, false);
                break;

            case 'self':
                $result = $this->getSelf($id);
                break;

            case 'top':
                $result = $this->getTop();
                break;

            case 'sonself':
                $result = $this->getSon($id, true);
                break;
        }

        return $result;
    }

    /**
     * 获取下一级栏目
     * @param string $self true表示没有子栏目时，获取同级栏目
     * @author wengxianhu by 2017-7-26
     */
    public function getSon($id, $self = false)
    {
        $result = array();
        if (empty($id)) {
            return $result;
        }

        $arctypeLogic = new \app\common\logic\ArctypeLogic();
        $arctype_max_level = intval(config('global.arctype_max_level'));
        $map = array(
            'is_hidden'   => 0,
            'status'  => 1,
            'is_del'  => 0, // 回收站功能
        );
        $res = $arctypeLogic->arctype_list($id, 0, false, $arctype_max_level, $map);

        if (!empty($res)) {
            $arr = group_same_key($res, 'parent_id');
            for ($i=0; $i < $arctype_max_level; $i++) {
                foreach ($arr as $key => $val) {
                    foreach ($arr[$key] as $key2 => $val2) {
                        if (!isset($arr[$val2['id']])) continue;
                        $val2['children'] = $arr[$val2['id']];
                        $arr[$key][$key2] = $val2;
                    }
                }
            }
            if (isset($arr[$id])) {
                $result = $arr[$id];
            }
        }

        if (empty($result) && $self == true) {
            $result = $this->getSelf($id);
        }

        return $result;
    }

    /**
     * 获取同级栏目
     * @author wengxianhu by 2017-7-26
     */
    public function getSelf($id)
    {
        $result = array();
        if (empty($id)) {
            return $result;
        }

        $map = array(
            'id'   => $id,
            'lang' => $this->lang,
            'is_hidden'   => 0,
            'status'  => 1,
            'is_del'  => 0, // 回收站功能
        );
        $res = Db::name('arctype')->field('parent_id')->where($map)->find();

        if ($res) {
            $newId = $res['parent_id'];
            $arctypeLogic = new \app\common\logic\ArctypeLogic();
            $arctype_max_level = intval(config('global.arctype_max_level'));
            $map = array(
                'is_hidden'   => 0,
                'status'  => 1,
            );
            $res = $arctypeLogic->arctype_list($newId, 0, false, $arctype_max_level, $map);

            if (!empty($res)) {
                $arr = group_same_key($res, 'parent_id');
                for ($i=0; $i < $arctype_max_level; $i++) {
                    foreach ($arr as $key => $val) {
                        foreach ($arr[$key] as $key2 => $val2) {
                            if (!isset($arr[$val2['id']])) continue;
                            $val2['children'] = $arr[$val2['id']];
                            $arr[$key][$key2] = $val2;
                        }
                    }
                }
                $result = $arr[$newId];
            }
        }

        return $result;
    }

    /**
     * 获取顶级栏目
     * @author wengxianhu by 2017-7-26
     */
    public function getTop()
    {
        $arctypeLogic = new \app\common\logic\ArctypeLogic();
        $arctype_max_level = intval(config('global.arctype_max_level'));
        $map = array(
            'is_hidden'   => 0,
            'status'  => 1,
            'is_del'  => 0, // 回收站功能
        );
        $res = $arctypeLogic->arctype_list(0, 0, false, $arctype_max_level, $map);

        $result = array();
        if (!empty($res)) {
            $arr = group_same_key($res, 'parent_id');
            for ($i=0; $i < $arctype_max_level; $i++) {
                foreach ($arr as $key => $val) {
                    foreach ($arr[$key] as $key2 => $val2) {
                        if (!isset($arr[$val2['id']])) continue;
                        $val2['children'] = $arr[$val2['id']];
                        $arr[$key][$key2] = $val2;
                    }
                }
            }
            reset($arr);
            $firstResult = current($arr);
            $result = $firstResult;
        }

        return $result;
    }

    /**
     * 获取当前栏目及所有子栏目
     * @param boolean $self 包括自己本身
     * @author wengxianhu by 2017-7-26
     */
    public function getHasChildren($id, $self = true)
    {
        $args = [$id, $self, $this->lang];
        $cacheKey = 'arctype-'.md5(__CLASS__.__FUNCTION__.json_encode($args));
        $result = cache($cacheKey);
        if (empty($result)) {
            static $res = null;
            if (null === $res) {
                $childrenRow = Db::name('arctype')->field('parent_id, count(id) as has_children')
                    ->where([
                        'lang'    => $this->lang,
                        'status'  => 1,
                        'is_del'  => 0,
                    ])->group('parent_id')
                    ->getAllWithIndex('parent_id');

                $where = [
                    'lang'    => $this->lang,
                    'status'  => 1,
                    'is_del'  => 0,
                ];
                $res = Db::name('arctype')->where($where)->order('parent_id asc, sort_order asc, id asc')->select();
                foreach ($res as $key => $val) {
                    $val['has_children'] = !empty($childrenRow[$val['id']]) ? $childrenRow[$val['id']]['has_children'] : 0;
                    $res[$key] = $val;
                }
            }

            $result = arctype_options($id, $res, 'id', 'parent_id');

            if (!$self) {
                array_shift($result);
            }

            cache($cacheKey, $result, null, "arctype");
        }

        return $result;
    }

    /**
     * 获取当前栏目及所有子栏目【已优化为 getHasChildren 函数】
     * @param boolean $self 包括自己本身
     * @author wengxianhu by 2017-7-26
     */
    public function getHasChildren_old($id, $self = true)
    {
        $args = [$id, $self, $this->lang];
        $cacheKey = 'arctype-'.md5(__CLASS__.__FUNCTION__.json_encode($args));
        $result = cache($cacheKey);
        if (empty($result)) {

            static $res = null;
            if (null === $res) {
                $where = array(
                    'c.lang'    => $this->lang,
                    'c.status'  => 1,
                    'c.is_del'  => 0,
                );
                $fields = "c.*, count(s.id) as has_children";
                $res = Db::name('arctype')
                    ->field($fields)
                    ->alias('c')
                    ->join('__ARCTYPE__ s','s.parent_id = c.id','LEFT')
                    ->where($where)
                    ->group('c.id')
                    ->order('c.parent_id asc, c.sort_order asc, c.id')
                    ->select();
            }

            $result = arctype_options($id, $res, 'id', 'parent_id');

            if (!$self) {
                array_shift($result);
            }

            cache($cacheKey, $result, null, "arctype");
        }

        return $result;
    }

    /**
     * 获取所有栏目
     * @param   int     $id     栏目的ID
     * @param   int     $selected   当前选中栏目的ID
     * @param   int     $channeltype      查询条件
     * @author wengxianhu by 2017-7-26
     */
    public function getList($id = 0, $select = 0, $re_type = true, $map = array())
    {
        $id = $id ? intval($id) : 0;
        $select = $select ? intval($select) : 0;

        $arctypeLogic = new \app\common\logic\ArctypeLogic;
        $arctype_max_level = intval(config('global.arctype_max_level'));
        $options = $arctypeLogic->arctype_list($id, $select, $re_type, $arctype_max_level, $map);

        return $options;
    }


    /**
     * 默认获取全部
     * @author 小虎哥 by 2018-4-16
     */
    public function getAll($field = '*', $map = array(), $index_key = '')
    {
        if (!isset($map['lang'])) $map['lang'] = $this->lang;

        $args = [$field, $map, $index_key];
        $cacheKey = 'arctype-'.md5(__CLASS__.__FUNCTION__.json_encode($args));
        $result = cache($cacheKey);
        if (empty($result)) {
            $result = Db::name('arctype')->field($field)
                ->where($map)
                ->order('sort_order asc')
                ->select();

            if (!empty($index_key)) {
                $result = convert_arr_key($result, $index_key);
            }

            cache($cacheKey, $result, null, "arctype");
        }

        return $result;
    }

    /**
     * 获取当前栏目的所有父级
     * @author wengxianhu by 2018-4-26
     */
    public function getAllPid($id, $is_RecycleBin = false)
    {
        static $seo_pseudo = null;
        null === $seo_pseudo && $seo_pseudo = tpCache('seo.seo_pseudo', [], $this->lang);
        $args = [THEME_STYLE, $id, $is_RecycleBin, $seo_pseudo, request()->baseFile(), $this->lang];
        $cacheKey = 'arctype-'.md5(__CLASS__.__FUNCTION__.json_encode($args));
        $data = cache($cacheKey);
        if (empty($data)) {
            $data = array();
            $typeid = $id;
            $map = [
                'lang' => $this->lang,
                'status'    => 1,
            ];
            if (false === $is_RecycleBin) $map['is_del'] = 0;
            $arctype_list = Db::name('Arctype')->field('*, id as typeid')
                ->where($map)
                ->getAllWithIndex('id');
            if (isset($arctype_list[$typeid])) {
                // 第一个先装起来
                $arctype_list[$typeid]['typeurl'] = $this->getTypeUrl($arctype_list[$typeid]);
                $data[$typeid] = $arctype_list[$typeid];
            } else {
                return $data;
            }

            while (true)
            {
                $typeid = $arctype_list[$typeid]['parent_id'];
                if($typeid > 0 && $id != $typeid){
                    if (isset($arctype_list[$typeid])) {
                        $arctype_list[$typeid]['typeurl'] = $this->getTypeUrl($arctype_list[$typeid]);
                        $data[$typeid] = $arctype_list[$typeid];
                    }
                } else {
                    break;
                }
            }
            $data = array_reverse($data, true);

            cache($cacheKey, $data, null, "arctype");
        }

        return $data;
    }

    /**
     * 获取多个栏目的所有父级
     * @author wengxianhu by 2018-4-26
     */
    public function getAllPidByids($ids = [])
    {
        $data = array();
        $arctype_list = $this->getAll('id,parent_id', [], 'id');
        foreach ($ids as $key => $typeid) {
            if (isset($arctype_list[$typeid])) {
                // 第一个先装起来
                $data[$typeid] = $arctype_list[$typeid];
            }

            while (true)
            {
                $typeid = $arctype_list[$typeid]['parent_id'];
                if($typeid > 0){
                    if (isset($arctype_list[$typeid])) {
                        $data[$typeid] = $arctype_list[$typeid];
                    }
                } else {
                    break;
                }
            }
        }

        !empty($data) && $data = array_reverse($data, true);

        return $data;
    }

    /**
     * 伪删除指定栏目（包括子栏目、所有相关文档）
     */
    public function pseudo_del($typeid)
    {
        $childrenList = $this->getHasChildren($typeid); // 获取当前栏目以及所有子栏目
        $typeidArr = get_arr_column($childrenList, 'id'); // 获取栏目数组里的所有栏目ID作为新的数组
        $typeidArr2 = $typeidArr;

        /*标记当前栏目以及子栏目为被动伪删除*/
        $sta1 = Db::name('arctype')
            ->where([
                'id'    => ['IN', $typeidArr],
                'lang' => $this->lang,
                'is_del'    => 0,
                'del_method' => 0,
            ])
            ->cache(true,null,"arctype")
            ->update([
                'is_del'    => 1,
                'del_method'    => 2, // 1为主动删除，2为跟随上级栏目被动删除
                'update_time'   => getTime(),
            ]); // 伪删除栏目
        /*--end*/

        /*标记当前栏目为主动伪删除*/
        $sta2 = Db::name('arctype')
            ->where([
                'id'    => ['IN', $typeidArr2],
                'lang' => $this->lang,
            ])
            ->cache(true,null,"arctype")
            ->update([
                'is_del'    => 1,
                'del_method'    => 1, // 1为主动删除，2为跟随上级栏目被动删除
                'update_time'   => getTime(),
            ]); // 伪删除栏目
        /*--end*/

        if ($sta1 && $sta2) {
            model('Archives')->pseudo_del($typeidArr); // 删除文档
            return true;
        }

        return false;
    }

    /**
     * 删除指定栏目（包括子栏目、所有相关文档）
     */
    public function del($typeid)
    {
        $childrenList = $this->getHasChildren($typeid); // 获取当前栏目以及所有子栏目
        $typeidArr = get_arr_column($childrenList, 'id'); // 获取栏目数组里的所有栏目ID作为新的数组

        $sta = Db::name('arctype')
            ->where([
                'id'    => ['IN', $typeidArr],
                'lang' => $this->lang,
            ])
            ->cache(true,null,"arctype")
            ->delete(); // 删除栏目
        if ($sta !== false) {
            model('Archives')->del($typeidArr); // 删除文档
            \think\Cache::clear('taglist');
            \think\Cache::clear('archives');
            \think\Cache::clear('arctype');

            return true;
        }

        return false;
    }

    /**
     * 每个栏目的顶级栏目的目录名称
     */
    public function getEveryTopDirnameList()
    {
        $args = [$this->lang];
        $cacheKey = 'arctype-'.md5(__CLASS__.__FUNCTION__.json_encode($args));
        $result = cache($cacheKey);
        if (empty($result)) {
            $fields = "c.id, c.parent_id, c.dirname, c.grade, count(s.id) as has_children";
            $row = Db::name('arctype')
                ->field($fields)
                ->alias('c')
                ->join('__ARCTYPE__ s','s.parent_id = c.id','LEFT')
                ->where('c.lang',$this->lang)
                ->group('c.id')
                ->order('c.parent_id asc, c.sort_order asc, c.id')
                // ->cache(true,EYOUCMS_CACHE_TIME,"arctype")
                ->select();
            $row = arctype_options(0, $row, 'id', 'parent_id');

            $result = array();
            foreach ($row as $key => $val) {
                if (empty($val['parent_id'])) {
                    $val['tdirname'] = $val['dirname'];
                } else {
                    $val['tdirname'] = isset($row[$val['parent_id']]['tdirname']) ? $row[$val['parent_id']]['tdirname'] : $val['dirname'];
                }
                $row[$key] = $val;
                $result[md5($val['dirname'])] = $val;
            }

            cache($cacheKey, $result, null, "arctype");
        }

        return $result;
    }

    /**
     * 新增栏目数据
     *
     * @param array $data
     * @return intval|boolean
     */
    public function addData($data = [])
    {
        $insertId = false;
        if (!empty($data)) {
            // 获取栏目空闲ID作为本次添加ID
            $idleID = $this->getArcTypeIdleID();
            if (!empty($idleID)) $data = array_merge(['id'=>$idleID], $data);
            // 添加栏目
            $insertId = Db::name('arctype')->insertGetId($data);
            if (!empty($insertId)) {
                // 删除多余数据
                $this->del_redundant_data($insertId);
                // --存储单页模型
                if ($data['current_channel'] == 6) {
                    $editor = tpSetting('editor');
                    Db::name('archives')->where(['typeid'=>$insertId])->delete();
                    $archivesData = array(
                        'title' => $data['typename'],
                        'typeid'=> $insertId,
                        'channel'   => $data['current_channel'],
                        'seo_description' => '',
                        'reason' => '',
                        'sort_order'    => 100,
                        'editor_remote_img_local'=> !isset($editor['editor_remote_img_local']) ? 1 : $editor['editor_remote_img_local'],
                        'editor_img_clear_link'  => !isset($editor['editor_img_clear_link']) ? 1 : $editor['editor_img_clear_link'],
                        'lang'  => $data['lang'],
                        'add_time'  => getTime(),
                    );
                    // $archivesData = array_merge($archivesData, $data);
                    $aid = Db::name('archives')->insertGetId($archivesData);
                    if ($aid) {
                        Db::name('single_content')->where(['typeid'=>$insertId])->delete();
                        // ---------后置操作
                        if (!isset($data['addonFieldExt'])) {
                            $data['addonFieldExt'] = array(
                                'typeid'    => $archivesData['typeid'],
                            );
                        } else {
                            $data['addonFieldExt']['typeid'] = $archivesData['typeid'];
                        }
                        $data['addonFieldExt']['content'] = !empty($data['addonFieldExt']['content']) ? $data['addonFieldExt']['content'] : '';
                        $addData = array(
                            'addonFieldExt' => $data['addonFieldExt'],
                        );
                        $addData = array_merge($addData, $archivesData);
                        model('Single')->afterSave($aid, $addData, 'add');
                        // ---------end
                    }
                }

                /*同步栏目ID到权限组，默认是赋予该栏目的权限*/
                model('AuthRole')->syn_auth_role($insertId);
                /*--end*/

                /*清除页面缓存*/
                // $htmlCacheLogic = new \app\common\logic\HtmlCacheLogic;
                // $htmlCacheLogic->clear_arctype();
                /*--end*/

                \think\Cache::clear("arctype");
                // extra_cache('admin_all_menu', NULL);
            }
        }
        return $insertId;
    }

    /**
     * 新增分类时删除多余数据，用于分类ID占位
     * @return [type] [description]
     */
    public function del_redundant_data($typeid = 0)
    {
        Db::name('channelfield_bind')->where(['typeid'=>$typeid])->delete();
    }

    /**
     * 批量增加顶级分类数据
     *
     * @param array $data
     * @return intval|boolean
     */
    public function batchAddTopData($addData = [], $post = [])
    {
        $arctypeLogic = new \app\common\logic\ArctypeLogic;
        $v_lang = get_current_lang();
        $result = [];
        if (!empty($addData)) {
            // 获取分类空闲ID作为本次添加ID
            $idleID = $this->getArcTypeIdleID(true);
            if (!empty($idleID)) {
                $insertAll = [];
                foreach ($idleID as $key => $value) {
                    if (!empty($addData[$key])) {
                        $addData[$key] = $insertAll[$key] = array_merge(['id'=>$value], $addData[$key]);
                        $addData[$key]['update_time'] = getTime() + 1;
                    }
                }
                if (!empty($insertAll)) Db::name('arctype')->insertAll($insertAll);
            }
            // 添加分类
            $rdata = $this->saveAll($addData);
            if ($rdata) {
                if($post['current_channel']==6){
                    //Archives
                    $v_archivesData = self::_syncOther(1,$rdata);                                                 
                    //sing_content                
                    $v_singleData = self::_syncOther(2,$v_archivesData);                                                             
                }                           
                /*同步分类ID到权限组，默认是赋予该分类的权限*/                
                $result = self::_syncOther(3,$rdata);  
                /*新增顶级分类的下级分类*/
                $saveData = [];
                $dirnameArr = [];
                foreach ($result as $key => $val) {
                    //同步到各个表              
                    if($val['lang']==$v_lang && $post['current_channel']==6){                                            
                        $updata = ['aid'=>$v_singleData[$key]['aid'],'title'=> $val['typename'],'current_channel'=>$val['current_channel'],'channel'=>$val['channeltype'],'stypeid'=>$val['id']];
                        $v_other[] = self::_syncOther(4,$updata);                       
                    }
                    if (!empty($post['sontype'][$key])) {
                        $sontype = $post['sontype'][$key];
                        foreach ($sontype as $son_k => $son_v) {
                            $typename = trim($son_v);
                            if (empty($typename)) continue;
                            // 目录名称
                            $dirname = $arctypeLogic->get_dirname($typename, '', 0, $dirnameArr, false);
                            array_push($dirnameArr, $dirname);

                            $dirpath = $val['dirpath'].'/'.$dirname;
                            $data = [
                                'id'=>'',// 子类型ID
                                'typename'  => $typename,
                                'channeltype'   => $val['channeltype'],
                                'current_channel'   => $val['current_channel'],
                                'parent_id' => intval($val['id']),
                                'dirname'   => $dirname,
                                'dirpath'   => $dirpath,
                                'diy_dirpath'   => $dirpath,
                                'grade' => intval($val['grade']) + 1,
                                'templist'  => !empty($val['templist']) ? $val['templist'] : '',
                                'tempview'  => !empty($val['tempview']) ? $val['tempview'] : '',
                                'is_hidden'  => $val['is_hidden'],
                                'seo_description'   => '',
                                'admin_id'  => $val['admin_id'],
                                'lang'  => $val['lang'],
                                'sort_order'    => $val['sort_order'],
                                'add_time'  => $val['add_time'],
                                'update_time'  => $val['update_time'],
                            ];
                            $saveData[] = $data;
                        }
                    }
                }
                $arctype_maxid = create_next_id('arctype', 'id', []); 
                foreach ($saveData as $key => $value) {
                    $value['id'] = $arctype_maxid;                    
                    $arctype_maxid +=1;  
                    $saveData2[]=$value;                    
                }
                $langlist = Db::name('language')->field('mark')->select();
                foreach ($langlist as $lgval) {
                    foreach ($saveData2 as $key2 => $_v) {
                        $_v['lang']=$lgval['mark'];                        
                        $saveData3[] = $_v;
                    }
                }    
                if (!empty($saveData3)) {
                    $result2 = $this->batchAddSubData($saveData3,$post);
                    $result = array_merge($result, $result2);
                }
                /*end*/
            }
        }

        return $result;
    }

    //======同步到各分表===============     
    public function _syncOther($frtype='',$updata=[]){
        $v_lang = get_current_lang();
        switch ($frtype) {
            case 1:
                // 同步到Archives表                
                $editor = tpSetting('editor');
                $archivesData = [];
                foreach ($updata as $k1 => $v1) {                   
                    $info = $v1->getData();    
                    // 删除多余数据
                    $this->del_redundant_data($info['id']);                                        
                    if ($info['lang'] == $v_lang) {                        
                        $archivesData[] = [
                            'title' => $info['typename'],
                            'typeid'=> $info['id'],
                            'stypeid'=> $info['id'],
                            'channel'   => $info['current_channel'],
                            'sort_order'    => 100,
                            'lang'  => $info['lang'],
                            'tempview'  => 'lists_single.htm',
                            'htmlfilename'  => $info['typename'],
                            'add_time'  => getTime(),
                            'editor_remote_img_local'=> !isset($editor['editor_remote_img_local']) ? 1 : $editor['editor_remote_img_local'],
                            'editor_img_clear_link'  => !isset($editor['editor_img_clear_link']) ? 1 : $editor['editor_img_clear_link'],
                        ];                        
                    }
                }       
                return $archivesData;
                break;
            case 2:
                // --存储单页模型的附表
                if (!empty($updata)) {
                    $arcdata = model('Archives')->saveAll($updata);
                    if ($arcdata) {
                        $singleData = [];
                        foreach ($arcdata as $k1 => $v1) {                            
                            $info = $v1->getData();                                                   
                            $singleData[] = [
                                'aid' => $info['aid'],
                                'typeid'=> $info['typeid'],
                                'content'   => '',
                                'seo_title'   => $info['title'],
                                'add_time'  => getTime(),
                                'update_time'  => getTime(),
                            ];
                        }                        
                        !empty($singleData) && Db::name('single_content')->insertAll($singleData);
                    }
                }                  
                return $singleData;                
                break;
            case 3:
                foreach ($updata as $k1 => $v1) {
                    $info = $v1->getData();
                    $result[] = $info;
                    /*同步分类ID到权限组，默认是赋予该分类的权限*/
                    model('AuthRole')->syn_auth_role($info['id']);
                    /*--end*/
                }              
                return $result;
                break;
            case 4:                
                // 同步其他表
                $otherSingleData=[
                    'aid'=>$updata['aid'],
                    'title'=> $updata['title'],
                    'typename'=> $updata['title'],
                    'seo_title'=> $updata['title'],
                    'current_channel'=>$updata['channel'],
                    'topid'=> 0,
                    'dirpath'=> '',
                    'parent_id'=> 0,                        
                    'channel'=> $updata['channel'],
                    'stypeid'=>[$updata['stypeid']],
                ];        
                $resultID = model('Archives')->saveArchivesDetails($otherSingleData);                
                return $otherSingleData;
                break;
            case 5:
                # 多子类
                if(!empty($updata)){
                    foreach ($updata as $key => $o_val) {                            
                        //======同步到各分表===============                    
                        $otherSingleData=[
                            'aid'=>$o_val['aid'],
                            'title'=> $o_val['seo_title'],
                            'typename'=> $o_val['seo_title'],
                            'seo_title'=> $o_val['seo_title'],
                            'current_channel'=>  6,
                            'topid'=> 0,
                            'dirpath'=> '',
                            'parent_id'=> 0,
                            'channel'=> 6,
                            'stypeid'=>[$o_val['typeid']],
                        ];
                        // 同步保存对应语言文档数据
                        $resultID = model('Archives')->saveArchivesDetails($otherSingleData);
                    }
                }        
                return '';
                break;       
        }        
    }
    
    /**
     * 批量增加下级分类数据
     *
     * @param array $data
     * @return intval|boolean
     */
    public function batchAddSubData($addData = [],$post=[])
    {
        $result = [];
        if (!empty($addData)) {
            // 获取分类空闲ID作为本次添加ID
            $idleID = $this->getArcTypeIdleID(true);
            if (!empty($idleID)) {
                $insertAll = [];
                foreach ($idleID as $key => $value) {
                    if (!empty($addData[$key])) {
                        $addData[$key] = $insertAll[$key] = array_merge(['id'=>$value], $addData[$key]);
                        $addData[$key]['update_time'] = getTime() + 1;
                    }
                }
                if (!empty($insertAll)) Db::name('arctype')->insertAll($insertAll);
            }
            // 添加分类
            $rdata = $this->saveAll($addData);
            if ($rdata) {
                if($addData[0]['current_channel']==6){
                    $v_archivesData = self::_syncOther(1,$rdata);                       
                    $v_singleData = self::_syncOther(2,$v_archivesData);               
                    $v_other = self::_syncOther(5,$v_singleData);  
                }                 
                $result = self::_syncOther(3,$rdata);                         
            }
        }

        return $result;
    }

    /**
     * 编辑栏目数据
     *
     * @param array $data
     * @return intval|boolean
     */
    public function updateData($data = [])
    {
        $bool = false;
        if (!empty($data)) {
            $admin_lang = get_admin_lang();
            $old_arctype_info = Db::name('arctype')->where(['id'=>$data['id'],'lang'=>$admin_lang])->find();
            $bool = Db::name('arctype')->where([
                    'id'    => $data['id'],
                    'lang'  => $admin_lang,
                ])
                ->cache(true,null,"arctype")
                ->update($data);
            if($bool){
                /*批量更新所有子孙栏目的最顶级模型ID / 顶级栏目ID*/
                $allSonTypeidArr = $this->getHasChildren($data['id'], false); // 获取当前栏目的所有子孙栏目（不包含当前栏目）
                if (!empty($allSonTypeidArr)) {
                    /*记录每一上级的指定数据*/
                    $arctypeArr = [];
                    $arctypeArr[$data['id']] = [
                        'dirpath'   => $data['dirpath'],
                    ];
                    /*end*/

                    $i = 1;
                    $minuendGrade = 0;
                    $update_data_all = [];
                    foreach ($allSonTypeidArr as $key => $val) {
                        if ($i == 1) {
                            $firstGrade = intval($data['oldgrade']);
                            $minuendGrade = intval($data['grade']) - $firstGrade;
                        }

                        /*记录每一上级的指定数据*/
                        $arctypeArr[$val['id']] = [
                            'dirpath'   => $arctypeArr[$val['parent_id']]['dirpath'].'/'.$val['dirname'],
                        ];
                        /*end*/

                        $update_data = [
                            'id'                => $val['id'],
                            'channeltype'       => $data['channeltype'],
                            'topid'             => !empty($data['topid']) ? $data['topid'] : $data['id'],
                            'dirpath'           => $arctypeArr[$val['id']]['dirpath'],
                            'update_time'       => getTime(),
                        ];
                        !empty($minuendGrade) && $update_data['grade'] = Db::raw('grade+'.$minuendGrade);

                        /*继承父级阅读权限、模板风格、命名规则*/
                        if (!empty($data['inherit_status'])) {
                            $update_data['typearcrank'] = $data['typearcrank'];
                            $update_data['page_limit'] = $data['page_limit'];
                            if ($val['current_channel'] == $old_arctype_info['current_channel']) {
                                $update_data['templist'] = $data['templist'];
                                $update_data['tempview'] = $data['tempview'];
                                $update_data['rulelist'] = $data['rulelist'];
                                $update_data['ruleview'] = $data['ruleview'];
                                if ($val['current_channel'] == 6) {
                                    $update_data['empty_logic'] = $old_arctype_info['empty_logic'];
                                }
                            }
                        }
                        /*end*/

                        $update_data_all[] = $update_data;

                        ++$i;
                    }

                    if (!empty($update_data_all)) {
                        model('Arctype')->saveAll($update_data_all);
                    }
                }
                /*--end*/

                // --存储单页模型
                if ($data['current_channel'] == 6) {
                    $archivesData = array(
                        'title' => $data['typename'],
                        'typeid'=> $data['id'],
                        'channel'   => $data['current_channel'],
                        'sort_order'    => 100,
                        'update_time'     => getTime(),
                    );
                    $aid = Db::name('single_content')->where(array('typeid'=>$data['id']))->getField('aid');
                    if (empty($aid)) {
                        $editor = tpSetting('editor');
                        $opt = 'add';
                        $archivesData['lang'] = get_admin_lang();
                        $archivesData['add_time'] = getTime();
                        $archivesData['editor_remote_img_local'] = !isset($editor['editor_remote_img_local']) ? 1 : $editor['editor_remote_img_local'];
                        $archivesData['editor_img_clear_link'] = !isset($editor['editor_img_clear_link']) ? 1 : $editor['editor_img_clear_link'];
                        $up = $aid = Db::name('archives')->insertGetId($archivesData);
                    } else {
                        $opt = 'edit';
                        $up = Db::name('archives')->where([
                                'aid'   => $aid,
                                'lang'  => get_admin_lang(),
                            ])->update($archivesData);
                    }
                    if ($up) {
                        // ---------后置操作
                        if (!isset($data['addonFieldExt'])) {
                            $data['addonFieldExt'] = array(
                                'typeid'    => $data['id'],
                            );
                        } else {
                            $data['addonFieldExt']['typeid'] = $data['id'];
                        }
                        $updateData = array(
                            'addonFieldExt' => $data['addonFieldExt'],
                        );
                        $updateData = array_merge($updateData, $archivesData);
                        model('Single')->afterSave($aid, $updateData, $opt);
                        // ---------end
                    }
                }

                \think\Cache::clear("arctype");
            }
        }
        return $bool;
    }

    /**
     * 获取当前栏目下有几层，包括自身这一层
     * @author wengxianhu by 2017-7-26
     */
    public function getHierarchy($id = '')
    {
        $hierarchy = 1;
        $ids = [$id];
        while (true)
        {
            $ids = Db::name('arctype')->where([
                    'parent_id'    => ['IN', $ids],
                    'lang' => $this->lang,
                ])->column('id');
            if (empty($ids)) {
                break;
            } else {
                $hierarchy++;
            }
        }

        return $hierarchy;
    }

    public function getArcTypeIdleID($returnArr = false)
    {
        return false;
        
        $arctypeArr = Db::name('arctype')->field('id')->where(['lang'=>$this->lang])->order('id asc')->getAllWithIndex('id');
        if (!empty($arctypeArr)) {
            $endArr = end($arctypeArr);
            $maxID = $endArr['id'];
            $result = [];
            for ($i = 1; $i <= $maxID; $i++) {
                if (!isset($arctypeArr[$i])) {
                    array_push($result, $i);
                    if (empty($returnArr)) break;
                }
            }
            if (empty($returnArr)) {
                return $result[0];
            } else {
                return $result;
            }
        } else {
            return false;
        }
    }
}