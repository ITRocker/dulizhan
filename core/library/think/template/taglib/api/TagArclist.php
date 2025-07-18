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

namespace think\template\taglib\api;

use think\Db;
use app\home\logic\FieldLogic;

/**
 * 文章列表(用于任何页面拿到部分文章,不分页)
 */
class TagArclist extends Base
{
    public $fieldLogic;
    
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
        $this->fieldLogic = new FieldLogic;
        if ($this->aid > 0) { // 应用于文档列表
            $this->tid = Db::name('archives')->where('aid', $this->aid)->getField('typeid');
        }
    }

    /**
     * 获取列表
     * @author wengxianhu by 2018-4-20
     */
    public function getArclist($param = array())
    {
        $field = 'a.*,b.typename';
        $param['typeid'] = $typeid = !empty($param['typeid']) ? $param['typeid'] : $this->tid;
        $channelid = input("param.channelid/d", 0);
        !empty($channelid) && $param['channelid'] = $channelid;
        $titlelen = !empty($param['titlelen']) ? intval($param['titlelen']) : 100;
        $infolen = !empty($param['infolen']) ? intval($param['infolen']) : 160;
        $addfields = !empty($param['addfields']) ? str_replace(["'", '"'], '', $param['addfields']) : '';
        $orderby = !empty($param['orderby']) ? trim($param['orderby']) : '';
        $arcrank = empty($param['arcrank']) ? 'off' : $param['arcrank'];

        if (!empty($param['limit'])) {
            $limit = !empty($param['limit']) ? str_replace('，', ',', $param['limit']) : 15;
            $limit = preg_replace('/[^\d\,]/i', '', $limit);
        } else {
            $limit = !empty($param['row']) ? intval($param['row']) : 15;
        }

        if (!empty($param['orderway'])) {
            $ordermode = !empty($param['orderway']) ? trim($param['orderway']) : 'desc';
        } else {
            $ordermode = !empty($param['ordermode']) ? trim($param['ordermode']) : 'desc';
        }
        
        if (!empty($param['channelid'])) {
            if (empty($param['typeid']) && empty($param['channel'])) {
                $param['channel'] = intval($param['channelid']);
            }
        }
        $channeltype = !empty($param['channel']) ? intval($param['channel']) : '';

        /*
        $args = [$param,$field];
        $cacheKey = 'api-'.md5(__CLASS__.__FUNCTION__.json_encode($args));
        $redata = cache($cacheKey);
        if (!empty($redata['data'])) { // 启用缓存
            return $redata;
        }
*/
        
        /*不指定模型ID、栏目ID，默认显示所有可以发布文档的模型ID下的文档*/
        $allow_release_channel = config('global.allow_release_channel');
        if (empty($channeltype) && empty($typeid)) {
            $channeltype = $param['channel'] = implode(',', $allow_release_channel);
        }
        /*--end*/

        // 如果指定了频道ID，则频道下的所有文档都展示
        if (!empty($channeltype)) { // 优先展示模型下的文章
            unset($param['typeid']);
        }
        elseif (!empty($typeid)) { // 其次展示栏目下的文章
            $typeidArr = explode(',', $typeid);
            if (count($typeidArr) == 1) {
                $typeid = intval($typeid);
                $channel_info = Db::name('arctype')->field('id,current_channel')->where(array('id'=>$typeid))->find();
                if (empty($channel_info)) {
                    return false;
                }
                $channeltype = !empty($channel_info) ? $channel_info["current_channel"] : '';  // 当前栏目ID所属模型ID
                /*当前模型ID不属于含有列表模型，直接返回无数据*/
                if (false === array_search($channeltype, $allow_release_channel)) {
                    return false;
                }
                /*end*/
                /*获取当前栏目下的同模型所有子孙栏目*/
                $arctype_list = model("Arctype")->getHasChildren($channel_info['id']);
                foreach ($arctype_list as $key => $val) {
                    if ($channeltype != $val['current_channel']) {
                        unset($arctype_list[$key]);
                    }
                }
                $typeids = get_arr_column($arctype_list, "id");
                !in_array($typeid, $typeids) && $typeids[] = $typeid;
                $typeid = implode(",", $typeids);
                /*--end*/
            } elseif (count($typeidArr) > 1) {
                $firstTypeid = intval($typeidArr[0]);
                $channeltype = Db::name('arctype')->where('id', $firstTypeid)->getField('current_channel');
            }
            $param['channel'] = $channeltype;
        }

        // 查询条件
        $condition = array();
        foreach (array('keywords','keyword','typeid','notypeid','flag','noflag','channel') as $key) {
            if (isset($param[$key]) && $param[$key] !== '') {
                if ($key == 'keywords') {
                    array_push($condition, "a.title LIKE '%{$param[$key]}%'");
                } elseif ($key == 'keyword' && !empty($param[$key])) {
                    $keyword = str_replace('，', ',', $param[$key]);
                    $keywordArr = explode(',', $keyword);
                    $keywordArr = array_unique($keywordArr); // 去重
                    foreach ($keywordArr as $_k => $_v) {
                        $_v = trim($_v);
                        if (empty($_v)) {
                            unset($keywordArr[$_k]);
                            break;
                        } else {
                            $keywordArr[$_k] = addslashes($_v);
                        }
                    }
                    $keyword = implode('|', $keywordArr);
                    $condition[] = Db::raw(" CONCAT(a.title,a.seo_keywords) REGEXP '$keyword' ");
                } elseif ($key == 'channel') {
                    array_push($condition, "a.channel IN ({$channeltype})");
                } elseif ($key == 'typeid') {
                    array_push($condition, "a.typeid IN ({$typeid})");
                } elseif ($key == 'notypeid') {
                    $param[$key] = str_replace('，', ',', $param[$key]);
                    array_push($condition, "a.typeid NOT IN (".$param[$key].")");
                } elseif ($key == 'flag') {
                    $flag_arr = explode(",", $param[$key]);
                    $where_or_flag = array();
                    foreach ($flag_arr as $k2 => $v2) {
                        if ($v2 == "c") {
                            array_push($where_or_flag, "a.is_recom = 1");
                        } elseif ($v2 == "h") {
                            array_push($where_or_flag, "a.is_head = 1");
                        } elseif ($v2 == "a") {
                            array_push($where_or_flag, "a.is_special = 1");
                        } elseif ($v2 == "j") {
                            array_push($where_or_flag, "a.is_jump = 1");
                        } elseif ($v2 == "p") {
                            array_push($where_or_flag, "a.is_litpic = 1");
                        } elseif ($v2 == "b") {
                            array_push($where_or_flag, "a.is_b = 1");
                        } elseif ($v2 == "s") {
                            array_push($where_or_flag, "a.is_slide = 1");
                        } elseif ($v2 == "r") {
                            array_push($where_or_flag, "a.is_roll = 1");
                        } elseif ($v2 == "d") {
                            array_push($where_or_flag, "a.is_diyattr = 1");
                        }
                    }
                    if (!empty($where_or_flag)) {
                        $where_flag_str = " (".implode(" OR ", $where_or_flag).") ";
                        array_push($condition, $where_flag_str);
                    } 
                } elseif ($key == 'noflag') {
                    $flag_arr = explode(",", $param[$key]);
                    $where_or_flag = array();
                    foreach ($flag_arr as $nk2 => $nv2) {
                        if ($nv2 == "c") {
                            array_push($where_or_flag, "a.is_recom <> 1");
                        } elseif ($nv2 == "h") {
                            array_push($where_or_flag, "a.is_head <> 1");
                        } elseif ($nv2 == "a") {
                            array_push($where_or_flag, "a.is_special <> 1");
                        } elseif ($nv2 == "j") {
                            array_push($where_or_flag, "a.is_jump <> 1");
                        } elseif ($nv2 == "p") {
                            array_push($where_or_flag, "a.is_litpic <> 1");
                        } elseif ($nv2 == "b") {
                            array_push($where_or_flag, "a.is_b <> 1");
                        } elseif ($nv2 == "s") {
                            array_push($where_or_flag, "a.is_slide <> 1");
                        } elseif ($nv2 == "r") {
                            array_push($where_or_flag, "a.is_roll <> 1");
                        } elseif ($nv2 == "d") {
                            array_push($where_or_flag, "a.is_diyattr <> 1");
                        }
                    }
                    if (!empty($where_or_flag)) {
                        $where_flag_str = " (".implode(" OR ", $where_or_flag).") ";
                        array_push($condition, $where_flag_str);
                    }
                } else {
                    array_push($condition, "a.{$key} = '".$param[$key]."'");
                }
            }
        }
        // array_push($condition, "a.arcrank > -1");
        array_push($condition, "a.status = 1");
        array_push($condition, "a.is_del = 0"); // 回收站功能
        array_push($condition, "a.lang = '".self::$home_lang."'");
        /*定时文档显示插件*/
        if (is_dir('./weapp/TimingTask/')) {
            $TimingTaskRow = model('Weapp')->getWeappList('TimingTask');
            if (!empty($TimingTaskRow['status']) && 1 == $TimingTaskRow['status']) {
                array_push($condition, "a.add_time <= ".getTime()); // 只显当天或之前的文档
            }
        }
        /*end*/
        
        $where_str = "";
        if (0 < count($condition)) {
            $where_str = implode(" AND ", $condition);
        }

        // 给排序字段加上表别名
        $orderby = getOrderBy($orderby, $ordermode, true);

        // 获取查询的表名
        $channeltype_info = model('Channeltype')->getInfo($channeltype);
        $controller_name = $channeltype_info['ctl_name'];
        $channeltype_table = $channeltype_info['table'];
        $channeltype_nid = $channeltype_info['nid'];

        $result = Db::name('archives')
            ->field($field)
            ->alias('a')
            ->join('__ARCTYPE__ b', 'b.id = a.typeid', 'LEFT')
            ->where($where_str)
            ->orderRaw($orderby)
            ->limit($limit)
            ->select();
        $arctypeInfo = $this->getArctypeInfo($param); //[];

        $users = model('v1.User')->getUser(false);
        $aidArr = $adminArr = $usersArr = [];
        foreach ($result as $key => $val) {
            array_push($aidArr, $val['aid']);   // 收集文档ID
            array_push($adminArr, $val['admin_id']);    // 收集admin_id
            array_push($usersArr, $val['users_id']);    // 收集users_id
            $val['title'] = htmlspecialchars_decode($val['title']);
            $val['title'] = text_msubstr($val['title'], 0, $titlelen, false);
            $val['seo_description'] = text_msubstr($val['seo_description'], 0, $infolen, false);
            $val['seo_title'] = $this->set_arcseotitle($val['typename'], $val['seo_title']);
            $val['litpic'] = $this->get_default_pic($val['litpic']); // 默认封面图
            $val['add_time_format'] = $this->time_format($val['add_time']);
            $val['add_time'] = date('Y-m-d', $val['add_time']);

            $val['old_price'] = unifyPriceHandle($val['users_price']);
            $val['crossed_price'] = model('ShopPublicHandle')->getGoodsSpecCrossedPrice($val['crossed_price'], $val['aid']);
            if (!empty($users)) {
                $resultData = $this->handle_price($val['users_price'], $users, $val['aid'], $val['users_discount_type']);
                $val['users_price'] = $resultData['users_price'];
                $val['level_discount'] = $resultData['level_discount'];
            }
            // $val['users_price_arr'] = explode('.', $val['users_price']);
            $val['users_price_arr'] = explode('.', sprintf("%.2f", $val['users_price']));
            
            $val['real_sales'] = $val['sales_num']; // 真实总销量
            $val['sales_num'] = $val['sales_all']; // 总虚拟销量

            $result[$key] = $val;
            array_push($aidArr, $val['aid']); // 文档ID数组

        }

        //获取文章作者的信息 需要传值arcrank = on
        if ('on' == $arcrank) {
            $field = 'username,nickname,head_pic,users_id,admin_id,sex';
            $userslist = Db::name('users')->field($field)
                ->where('admin_id','in',$adminArr)
                ->whereOr('users_id','in',$usersArr)
                ->select();
            foreach ($userslist as $key => $val) {
                $val['head_pic'] = $this->get_head_pic($val['head_pic'], false, $val['sex']);
                empty($val['nickname']) && $val['nickname'] = $val['username'];
                if (!empty($val['admin_id'])) {
                    $adminLitpicArr[$val['admin_id']] = $val;
                }
                if (!empty($val['users_id'])) {
                    $usersLitpicArr[$val['users_id']] = $val;
                }
            }
            $adminLitpic = Db::name('users')->field($field)->where('admin_id','>',0)->order('users_id asc')->find();
            $adminLitpic['head_pic'] = $this->get_head_pic($adminLitpic['head_pic'], false, $adminLitpic['sex']);
            empty($adminLitpic['nickname']) && $adminLitpic['nickname'] = $adminLitpic['username'];

            foreach ($result as $key => $val) {
                if (!empty($val['users_id'])) {
                    $users = !empty($usersLitpicArr[$val['users_id']]) ? $usersLitpicArr[$val['users_id']] : [];
                } elseif (!empty($val['admin_id'])) {
                    $users = !empty($adminLitpicArr[$val['admin_id']]) ? $adminLitpicArr[$val['admin_id']] : [];
                } else {
                    $users = $adminLitpic;
                }
                !empty($users) && $val['users'] = $users;
                $result[$key] = $val;
            }
        }

        /*附加表*/
        if (5 == $channeltype) {
            $addtableName = $channeltype_table.'_content';
            $addfields .= ',courseware,courseware_free,total_duration,total_video';
            $addfields = str_replace('，', ',', $addfields); // 替换中文逗号
            $addfields = trim($addfields, ',');
            /*过滤不相关的字段*/
            $addfields_arr = explode(',', $addfields);
            $addfields_arr = array_unique($addfields_arr);
            $extFields = Db::name($addtableName)->getTableFields();
            $addfields_arr = array_intersect($addfields_arr, $extFields);
            if (!empty($addfields_arr) && is_array($addfields_arr)) {
                $addfields = implode(',', $addfields_arr);
            } else {
                $addfields = '';
            }
            /*end*/
            !empty($addfields) && $addfields = ','.$addfields;

            if (strstr(",{$addfields},", ',content,')){
                $addfields .= ',content_ey_m';
            }
            $resultExt = M($addtableName)->field("aid {$addfields}")->where('aid','in',$aidArr)->getAllWithIndex('aid');
            /*自定义字段的数据格式处理*/
            $resultExt = $this->fieldLogic->getChannelFieldList($resultExt, $channeltype, true);
            /*--end*/
            foreach ($result as $key => $val) {
                $valExt = !empty($resultExt[$val['aid']]) ? $resultExt[$val['aid']] : array();
                if (strstr(",{$addfields},", ',content,') && !empty($valExt['content_ey_m'])){
                    $valExt['content'] = $valExt['content_ey_m'];
                }
                if (isset($valExt['content_ey_m'])) {unset($valExt['content_ey_m']);}
                if (!empty($valExt['content'])) {
                    $valExt['content_img_list'] = $this->get_content_img($valExt['content']);
                }
                $val = array_merge($valExt, $val);
                $val['total_duration'] = gmSecondFormat($val['total_duration'], ':');
                $result[$key] = $val;
            }
        } else if (!empty($addfields) && !empty($aidArr)) {
            $addtableName = $channeltype_table.'_content';
            $addfields = str_replace('，', ',', $addfields); // 替换中文逗号
            $addfields = trim($addfields, ',');
            /*过滤不相关的字段*/
            $addfields_arr = explode(',', $addfields);
            $extFields = Db::name($addtableName)->getTableFields();
            $addfields_arr = array_intersect($addfields_arr, $extFields);
            if (!empty($addfields_arr) && is_array($addfields_arr)) {
                $addfields = implode(',', $addfields_arr);
            } else {
                $addfields = '';
            }
            /*end*/
            if (!empty($addfields)) {
                $addfields = ','.$addfields;
                if (strstr(",{$addfields},", ',content,')){
                    if (in_array($channeltype, [1,2,3,4,5,6,7])) {
                        $addfields .= ',content_ey_m';
                    } else {
                        if (in_array($extFields, ['content_ey_m'])) {
                            $addfields .= ',content_ey_m';
                        }
                    }
                }
                $resultExt = M($addtableName)->field("aid {$addfields}")->where('aid','in',$aidArr)->getAllWithIndex('aid');
                /*自定义字段的数据格式处理*/
                $resultExt = $this->fieldLogic->getChannelFieldList($resultExt, $channeltype, true);
                /*--end*/
                foreach ($result as $key => $val) {
                    $valExt = !empty($resultExt[$val['aid']]) ? $resultExt[$val['aid']] : array();
                    if (strstr(",{$addfields},", ',content,') && !empty($valExt['content_ey_m'])){
                        $valExt['content'] = $valExt['content_ey_m'];
                    }
                    if (isset($valExt['content_ey_m'])) {unset($valExt['content_ey_m']);}
                    if (!empty($valExt['content'])) {
                        $valExt['content_img_list'] = $this->get_content_img($valExt['content']);
                    }
                    $val = array_merge($valExt, $val);
                    $result[$key] = $val;
                }
            }
        }
        /*--end*/

        /*针对下载列表*/
        // if (!empty($aidArr) && strtolower($controller_name) == 'download') {
        //     $downloadRow = M('download_file')->where(array('aid'=>array('IN', $aidArr)))
        //         ->order('aid asc, sort_order asc')
        //         ->select();
        //     $downloadFileArr = array();
        //     if (!empty($downloadRow)) {
        //         /*获取指定文档ID的下载文件列表*/
        //         foreach ($downloadRow as $key => $val) {
        //             if (!isset($downloadFileArr[$val['aid']]) || empty($downloadFileArr[$val['aid']])) {
        //                 $downloadFileArr[$val['aid']] = array();
        //             }
        //             $val['downurl'] = ROOT_DIR."/index.php?m=home&c=View&a=downfile&id={$val['file_id']}&uhash={$val['uhash']}&lang={self::$home_lang}";
        //             $downloadFileArr[$val['aid']][] = $val;
        //         }
        //         /*--end*/
        //     }
        //     /*将组装好的文件列表与文档相关联*/
        //     foreach ($result as $key => $val) {
        //         $result[$key]['file_list'] = !empty($downloadFileArr[$val['aid']]) ? $downloadFileArr[$val['aid']] : array();
        //     }
        //     /*--end*/
        // }
        /*--end*/

        $redata = [
            'data'=> !empty($result) ? $result : false,
        ];
        !empty($arctypeInfo) && $redata['arctype'] = $arctypeInfo;
        // cache($cacheKey, $redata, null, 'archives');

        return $redata;
    }
    private function getArctypeInfo($param){
        $where = [];
        if (!empty($param['typeid'])){
            $where['id'] = $param['typeid'];
        }
        if (!empty($param['channel'])){
            $where['current_channel'] = $param['channel'];
        }
        $field = 'id,id as typeid,typename,current_channel';
        $result = Db::name('arctype')->field($field)
            ->where($where)
            ->order("id asc")
            ->find();

        return $result;
    }

    private function handle_price($users_price = 0, $users = [], $aid = 0, $users_discount_type = 0)
    {
        $result = [
            'level_discount' => 100,
            'users_price' => $users_price,
        ];
        if (!empty($users['level'])) {
            $level_discount = !empty($users['level_discount']) ? intval($users['level_discount']) : 100;
            $result['level_discount'] = intval($level_discount);
            if (!empty($level_discount) && 100 !== intval($level_discount)) {
                $level_discount = intval($level_discount) / intval(100);
                $users_price = 2 === intval($users_discount_type) ? floatval($users_price) : floatval($users_price) * floatval($level_discount);
            }
        }
        if (1 === intval($users_discount_type)) {
            $users_price = model('ShopPublicHandle')->handleUsersDiscountPrice($aid, $users['level']);
        }
        $result['users_price'] = unifyPriceHandle($users_price);

        return $result;
    }

}