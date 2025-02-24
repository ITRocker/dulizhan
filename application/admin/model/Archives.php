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
use think\Page;
use think\Model;

/**
 * 文档主表
 */

load_trait('controller/Jump');
class Archives extends Model
{
    use \traits\controller\Jump;

    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        // 当前时间戳
        $this->times = getTime();
        // 内容数据表前端
        $this->table = 'article';
        // 后台默认语言
        $this->adminLang = get_admin_lang();
        // 后台URL语言(编辑切换时使用)
        $this->showLang = input('showlang/s', $this->adminLang);
        $this->archivesDb = Db::name('archives');
        $this->archivesLangDb = Db::name('archives_' . $this->showLang);
    }

    /**
     * 统计每个栏目文档数
     * @param int $aid 产品id
     */
    public function afterSave($aid, $post)
    {
        if (isset($post['aid']) && intval($post['aid']) > 0) {
            $opt = 'edit';
           Db::name('article_content')->where('aid', $aid)->update($post);
        } else {
            $opt = 'add';
            $post['aid'] = $aid;
           Db::name('article_content')->insert($post);
        }

        // --处理TAG标签
        model('Taglist')->savetags($aid, $post['typeid'], $post['tags'],$post['arcrank']);
    }

    /**
     * 获取单条记录
     * @author wengxianhu by 2017-7-26
     */
    public function getInfo($aid, $field = '', $isshowbody = true)
    {
        $result = array();
        $field = !empty($field) ? $field : 'a.*';
        $result = Db::name('archives')->field($field)
            ->alias('a')
            ->find($aid);
        if ($isshowbody) {
            $tableName = Db::name('channeltype')->where('id','eq',$result['channel'])->getField('table');
            $addonFieldExt = Db::name($tableName.'_content')->where('aid',$aid)->find();
            if (!empty($addonFieldExt)) {
                $result = array_merge($addonFieldExt, $result);
            }
        }

        // 文章TAG标签
        if (!empty($result)) {
            $typeid = isset($result['typeid']) ? $result['typeid'] : 0;
            $tags = model('Taglist')->getListByAid($aid, $typeid);
            $result['tags'] = $tags['tag_arr'];
            $result['tag_id'] = $tags['tid_arr'];
        }

        return $result;
    }

    /**
     * 伪删除栏目下所有文档
     */
    public function pseudo_del($typeidArr)
    {
        // 伪删除文档
       Db::name('archives')->where([
                'typeid'    => ['IN', $typeidArr],
                'is_del'    => 0,
            ])
            ->update([
                'is_del'    => 1,
                'del_method'    => 2,
                'update_time'   => getTime(),
            ]);

        return true;
    }

    /**
     * 删除栏目下所有文档
     */
    public function del($typeidArr)
    {
        /*获取栏目下所有文档，并取得每个模型下含有的文档ID集合*/
        $channelAidList = array(); // 模型下的文档ID列表
        $arcrow =Db::name('archives')->where(array('typeid'=>array('IN', $typeidArr)))
            ->order('channel asc')
            ->select();
        foreach ($arcrow as $key => $val) {
            if (!isset($channelAidList[$val['channel']])) {
                $channelAidList[$val['channel']] = array();
            }
            array_push($channelAidList[$val['channel']], $val['aid']);
        }
        /*--end*/

        /*在相关模型下删除文档残余的关联记录*/
        $sta =Db::name('archives')->where(array('typeid'=>array('IN', $typeidArr)))->delete(); // 删除文档
        if ($sta) {
            foreach ($channelAidList as $key => $val) {
                $aidArr = $val;
                /*删除其余相关联的表记录*/
                switch ($key) {
                    case '1': // 文章模型
                        model('Article')->afterDel($aidArr);
                        break;
                    
                    case '2': // 产品模型
                        model('Product')->afterDel($aidArr);
                        Db::name('product_attribute')->where(array('typeid'=>array('IN', $typeidArr)))->delete();
                        break;
                    
                    case '3': // 图集模型
                        model('Images')->afterDel($aidArr);
                        break;
                    
                    case '4': // 下载模型
                        model('Download')->afterDel($aidArr);
                        break;
                    
                    case '6': // 单页模型
                        model('Single')->afterDel($typeidArr);
                        break;

                    default:
                        # code...
                        break;
                }
                /*--end*/
            }
        }
        /*--end*/

        /*删除留言模型下的关联内容*/
        $guestbookList =Db::name('guestbook')->where(['typeid'=>array('IN', $typeidArr), 'form_type'=>0])->select();
        if (!empty($guestbookList)) {
            $aidArr = get_arr_column($guestbookList, 'aid');
            $typeidArr = get_arr_column($guestbookList, 'typeid');
            if ($aidArr && $typeidArr) {
                $sta =Db::name('guestbook')->where(['typeid'=>array('IN', $typeidArr), 'form_type'=>0])->delete();
                if ($sta) {
                   Db::name('guestbook_attribute')->where(['typeid'=>array('IN', $typeidArr), 'form_type'=>0])->delete();
                    model('Guestbook')->afterDel($aidArr);
                }
            }
        }
        /*--end*/

        return true;
    }

    /**
     * 获取单条记录
     * @author 陈风任 by 2020-06-08
     */
    public function UnifiedGetInfo($aid, $field = '', $isshowbody = true)
    {
        $result = array();
        $field = !empty($field) ? $field : '*';
        $result = Db::name('archives')->field($field)
            ->where([
                'aid'   => $aid,
                'lang'  => get_admin_lang(),
            ])
            ->find();
        if ($isshowbody) {
            $tableName = Db::name('channeltype')->where('id','eq',$result['channel'])->getField('table');
            $result['addonFieldExt'] = Db::name($tableName.'_content')->where('aid',$aid)->find();
        }

        // 产品TAG标签
        if (!empty($result)) {
            $typeid = isset($result['typeid']) ? $result['typeid'] : 0;
            $tags = model('Taglist')->getListByAid($aid, $typeid);
            $result['tags'] = $tags;
        }

        return $result;
    }

    //自动远程图片本地化/自动清除非本站链接 type = 'type' 是栏目 ,否则是内容
    public function editor_auto_210607(&$post = [])
    {
        if (!empty($post['editor_addonFieldExt'])) {
            if (!empty($post['editor_remote_img_local']) || !empty($post['editor_img_clear_link'])) {
                $editor_addonFieldExt_arr = explode(',', $post['editor_addonFieldExt']);
                foreach ($editor_addonFieldExt_arr as $key => $val) {
                    $html = htmlspecialchars_decode($post['addonFieldExt'][$val]);
                    if (!empty($post['editor_remote_img_local'])) {
                        $html = preg_replace('/(\s+)src=("|\')\/\//i', '${1}src=${2}http://', $html);
                        $html = remote_to_local($html);
                    }
                    if (!empty($post['editor_img_clear_link'])) {
                        $html = replace_links($html);
                    }
                    $post['addonFieldExt'][$val] = htmlspecialchars($html);
                }
                // unset($post['editor_remote_img_local']);
                // unset($post['editor_img_clear_link']);
                unset($post['editor_addonFieldExt']);
            }
        }
    }

    // 获取文档列表
    public function getArchivesList($param = [])
    {
        $aidArr = [];
        // 如果存在(搜索关键词 OR 产品模型)则执行
        if (!empty($param['keywords'])) {
            $where = [
                'is_del' => 0,
                'channel' => $param['channel'],
            ];
            // 关键字搜索
            if (!empty($param['keywords'])) $where['title'] = ['LIKE', "%{$param['keywords']}%"];
            // dump($where);
            $aidArr = $this->archivesLangDb->where($where)->order('aid asc')->column('aid');
            // 如果查询不到则返回结束
            if (empty($aidArr)) return false;
        }

        // 查询条件
        $where = [
            'is_del' => 0,
            'channel' => $param['channel']
        ];
        // 上架产品
        if (!empty($param['channel']) && 2 === intval($param['channel']) && (empty($param['status']) || 1 === intval($param['status']))) {
            $where['status'] = 1;
        }
        // 下架产品
        else if (!empty($param['channel']) && 2 === intval($param['channel']) && !empty($param['status']) && 2 === intval($param['status'])) {
            $where['status'] = 0;
        }
        if (!empty($aidArr)) $where['aid'] = ['IN', $aidArr];

        $whereStr = "";
        if (!empty($param['typeid'])) {
            $arctype_list = model("Arctype")->getHasChildren($param['typeid']);
            $typeids = get_arr_column($arctype_list, "id");
            !in_array($param['typeid'], $typeids) && $typeids[] = $typeid;
            $typeid = implode(",", $typeids);
            $typeid_arr = explode(',', $typeid);
            $typeid_arr = array_unique($typeid_arr);
            $stypeid_where = "";
            foreach ($typeid_arr as $_k => $_v) {
                if (!empty($_v)) $stypeid_where .= " OR CONCAT(',', stypeid, ',') LIKE '%,{$_v},%' ";
            }
            $whereArr[] = Db::raw(" (typeid IN ({$typeid}) {$stypeid_where}) ");
            if (0 < count($whereArr)) $whereStr = implode(" AND ", $whereArr);
        }

        // 自定义排序
        $orderby = input('param.orderby/s', '');
        $orderway = input('param.orderway/s', '');
        if (!empty($orderby) && !empty($orderway)) {
            $orderby = "{$orderby} {$orderway}, aid desc";
        } else {
            $orderby = "aid desc";
        }

        // 分页查询
        $count = $this->archivesDb->where($where)->where($whereStr)->count('aid');
        $pageObj = new Page($count, config('paginate.list_rows'));

        // 数据查询
        $list = $this->archivesDb->where($where)->where($whereStr)->limit($pageObj->firstRow.','.$pageObj->listRows)->order($orderby)->select();

        // 查询对应语言数据
        if (!empty($list)) {
            // 分类模型
            $classListArr = [];
            $stypeid = array_filter(array_unique(explode(',', implode(',', get_arr_column($list, 'stypeid')))));
            if (!empty($stypeid)) {
                // $classModel = new ClassModel($param['channel']);
                // $classListArr = $classModel->getClassifyListData($stypeid);
                $where = [
                    'is_del' => 0,
                    'id' => ['IN', $stypeid],
                    'lang' => $this->showLang,
                    'current_channel' => $param['channel'],
                ];
                $classListArr = Db::name('arctype')->where($where)/*->field('id, typename')*/->getAllWithIndex('id');
            }            
            // 对应语言数据
            $archives_real_fields = implode(',', config('global.archives_real_fields'));
            $list_ = $this->archivesLangDb/*->field($archives_real_fields, true)*/->where(['aid' => ['IN', get_arr_column($list, 'aid')]])/*->order($orderby)*/->getAllWithIndex('aid');
            foreach ($list as $key => $value) {
                // 如果对应语言存在数据则使用对应语言数据
                if (!empty($list_[$value['aid']])) {
                    // 分类ID处理
                    $list_[$value['aid']]['typeid'] = intval($value['typeid']);
                    $list_[$value['aid']]['stypeid'] = strval($value['stypeid']);
                    // 图片处理(使用主体公共数据)
                    $list_[$value['aid']]['is_litpic'] = intval($value['is_litpic']);
                    $list_[$value['aid']]['litpic'] = handle_subdir_pic($value['litpic']);
                    // 销量
                    $list_[$value['aid']]['sales_num'] = $value['sales_num'];
                    // 价格
                    $list_[$value['aid']]['users_price'] = $value['users_price'];
                    // 库存
                    $list_[$value['aid']]['stock_count'] = $value['stock_count'];
                    // 文档属性相关处理
                    $list_[$value['aid']]['is_b'] = isset($value['is_b']) ? intval($value['is_b']) : 0;
                    $list_[$value['aid']]['is_top'] = isset($value['is_top']) ? intval($value['is_top']) : 0;
                    $list_[$value['aid']]['is_head'] = isset($value['is_head']) ? intval($value['is_head']) : 0;
                    $list_[$value['aid']]['is_roll'] = isset($value['is_roll']) ? intval($value['is_roll']) : 0;
                    $list_[$value['aid']]['is_jump'] = isset($value['is_jump']) ? intval($value['is_jump']) : 0;
                    $list_[$value['aid']]['is_recom'] = isset($value['is_recom']) ? intval($value['is_recom']) : 0;
                    $list_[$value['aid']]['is_slide'] = isset($value['is_slide']) ? intval($value['is_slide']) : 0;
                    $list_[$value['aid']]['jumplinks'] = isset($value['jumplinks']) ? trim($value['jumplinks']) : '';
                    $list_[$value['aid']]['is_litpic'] = isset($value['is_litpic']) ? intval($value['is_litpic']) : 0;
                    $list_[$value['aid']]['is_special'] = isset($value['is_special']) ? intval($value['is_special']) : 0;
                    $list_[$value['aid']]['is_diyattr'] = isset($value['is_diyattr']) ? intval($value['is_diyattr']) : 0;

                    $value = array_merge($value, $list_[$value['aid']]);
                }
                // 分类名称处理
                $value['stypename'] = [];
                if (!empty($value['stypeid'])) {
                    $stypeid_ = explode(',', $value['stypeid']);
                    foreach ($stypeid_ as $id) {
                        if (!empty($classListArr[$id]['typename'])) array_push($value['stypename'], $classListArr[$id]['typename']);
                    }
                }
                $value['stypename'] = implode(',', $value['stypename']);
                $value['typename'] = !empty($classListArr[$value['typeid']]['typename']) ? $classListArr[$value['typeid']]['typename'] : $value['stypename'];
                // 预览URL
                $value['arcurl'] = urldecode(get_arcurl($value, false));
                $value['typeurl'] = 6 === intval($param['channel']) ? urldecode(typeurl('home/Single/lists', $classListArr[$value['typeid']])) : '';
                // 覆盖原数据
                $list[$key] = $value;
            }
        }

        // 文档属性
        $archives_flags = model('ArchivesFlag')->getList();

        // 允许发布文档列表的栏目
        $arctype_html = allow_release_arctype(!empty($param['typeid']) ? intval($param['typeid']) : 0, [$param['channel']]);

        // 清空链接
        session('openJumpPageUrl', null);

        // 返回数据
        return [
            'list' => $list,
            'page' => $pageObj->show(),
            'pager' => $pageObj,
            'arctype_html' => $arctype_html,
            'archives_flags' => $archives_flags,
        ];
    }

    // 获取文档详情
    public function getArchivesDetails($aid = 0, $field = '')
    {
        // 查询条件
        $where = [
            'is_del' => 0,
            'aid' => intval($aid),
        ];
        // 查询字段
        $field = !empty($field) ? trim($field) : '*';

        // 查询显示语言的对应文档数据是否存在
        $result = $this->getDetailsData($where, $field, $this->showLang);
        // 查询系统文档主表
        $result_ = $this->getDetailsData($where, $field);
        // $result = !empty($result) ? $result : $this->getDetailsData($where, $field);
        $result = !empty($result) ? array_merge($result_, $result) : $result_;
        if (empty($result)) $this->error('未查询到相关文档...');

        // 预览URL处理
        $result['arcurl'] = get_arcurl($result);
        // 状态处理
        $result['status'] = isset($result_['status']) ? intval($result_['status']) : '';
        // 分类ID处理
        $result['typeid'] = isset($result_['typeid']) ? trim($result_['typeid']) : '';
        $result['stypeid'] = isset($result_['stypeid']) ? trim($result_['stypeid']) : '';
        // 商品规格类型
        $result['spec_type'] = isset($result_['spec_type']) ? intval($result_['spec_type']) : 1;
        // 封面图处理
        $result['litpic'] = isset($result_['litpic']) ? handle_subdir_pic($result_['litpic']) : '';
        // 商品价格相关处理        
        $result['stock_show'] = isset($result_['stock_show']) ? intval($result_['stock_show']) : '';
        $result['stock_count'] = isset($result_['stock_count']) ? intval($result_['stock_count']) : '';
        $result['users_price'] = isset($result_['users_price']) ? floatval($result_['users_price']) : '';
        $result['virtual_sales'] = isset($result_['virtual_sales']) ? intval($result_['virtual_sales']) : '';
        $result['crossed_price'] = isset($result_['crossed_price']) ? floatval($result_['crossed_price']) : '';
        $result['logistics_type'] = isset($result_['logistics_type']) ? explode(',', $result_['logistics_type']) : '';
        // 文档属性相关处理
        $result['is_b'] = isset($result_['is_b']) ? intval($result_['is_b']) : 0;
        $result['is_top'] = isset($result_['is_top']) ? intval($result_['is_top']) : 0;
        $result['is_head'] = isset($result_['is_head']) ? intval($result_['is_head']) : 0;
        $result['is_roll'] = isset($result_['is_roll']) ? intval($result_['is_roll']) : 0;
        $result['is_jump'] = isset($result_['is_jump']) ? intval($result_['is_jump']) : 0;
        $result['is_recom'] = isset($result_['is_recom']) ? intval($result_['is_recom']) : 0;
        $result['is_slide'] = isset($result_['is_slide']) ? intval($result_['is_slide']) : 0;
        $result['jumplinks'] = isset($result_['jumplinks']) ? trim($result_['jumplinks']) : '';
        $result['is_litpic'] = isset($result_['is_litpic']) ? intval($result_['is_litpic']) : 0;
        $result['is_special'] = isset($result_['is_special']) ? intval($result_['is_special']) : 0;
        $result['is_diyattr'] = isset($result_['is_diyattr']) ? intval($result_['is_diyattr']) : 0;
        // 文档内容字段处理
        if (!empty($result['content'])) $result['content'] = htmlspecialchars_decode($result['content']);
        if (!empty($result['content_ey_m'])) $result['content_ey_m'] = htmlspecialchars_decode($result['content_ey_m']);

        return $result;
    }

    public function getDetailsData($where = [], $field = '', $showLang = '')
    {
        // 处理数据表名
        $table_0 = empty($showLang) ? 'archives' : 'archives_' . $showLang;
        // 查询数据表内容
        $result = Db::name($table_0)->field($field)->where($where)->find();
        if (!empty($result)) {
            // 获取内容数据表前端
            if (!empty($result['channel'])) $this->getChannelTable($result['channel']);
            // 处理数据表名
            $table_1 = empty($showLang) ? $this->table . '_content' : $this->table . '_content_' . $showLang;
            // 查询显示语言的对应文档内容数据
            unset($where['is_del']);
            $result_ = Db::name($table_1)->field('auto_id, aid, add_time, update_time', true)->where($where)->find();
            $result = !empty($result_) ? array_merge($result, $result_) : $result;
        }

        // 返回数据
        return $result;
    }

    // 更新主表公共字段数据
    public function saveArchivesPublicDetails($post = [])
    {
        if (trim($this->showLang) === trim($this->adminLang)) {
            // 更新条件
            $where = [
                'aid' => intval($post['aid']),
            ];
            // 更新数据
            $update = [
                'update_time' => $this->times,
            ];

            // 处理自定义路由
            if (isset($post['htmlfilename'])) {
                $htmlfilename = !empty($post['htmlfilename']) ? trim($post['htmlfilename']) : trim($post['title']);
                $htmlfilename = implode('', explode(PHP_EOL, $htmlfilename));
                $update['htmlfilename'] = model('Archives')->customRouteHandle($post['aid'], preg_replace("/[^\x{4e00}-\x{9fa5}\w\-]+/u", "-", strtolower($htmlfilename)));
            }

            // 商品状态
            if (isset($post['status'])) $update['status'] = intval($post['status']);

            // 商品第一个分类ID
            $update['typeid'] = isset($post['stypeid'][0]) ? intval($post['stypeid'][0]) : 0;

            // 商品分类ID数组
            $update['stypeid'] = isset($post['stypeid']) ? implode(',', $post['stypeid']) : 0;

            // 内容HTML转码解析
            $content_ey = empty($post['addonFieldExt']['content']) ? '' : htmlspecialchars_decode($post['addonFieldExt']['content']);
            $content_ey_m = empty($post['addonFieldExt']['content_ey_m']) ? '' : htmlspecialchars_decode($post['addonFieldExt']['content_ey_m']);
            $content_ey = empty($content_ey) && !empty($content_ey_m) ? $content_ey_m : $content_ey;

            // 如果存在轮播图则默认使用第一张为封面图
            if (!empty($post['proimg'][0])) $post['litpic'] = trim($post['proimg'][0]);
            if (!empty($post['imgupload'][0])) $post['litpic'] = trim($post['imgupload'][0]);

            // 如果没有上传封面图则自动获取内容第一张图片作为封面图
            $update['litpic'] = !empty($post['litpic']) ? trim($post['litpic']) : get_html_first_imgurl($content_ey);
            // 是否有无封面图
            if (empty($update['litpic'])) {
                $update['is_litpic'] = 0; // 无封面图
            } else {
                $update['is_litpic'] = isset($post['is_litpic']) ? intval($post['is_litpic']) : 0; // 有封面图
            }

            // 自定义HTML文件名
            if (isset($post['tempview'])) {
                $update['tempview'] = !empty($post['tempview']) ? $post['tempview'] : 'lists_single.htm';
            }

            // 执行更新
            $update = array_merge($post, $update);
            if (isset($update['title'])) unset($update['title']);
            if (isset($update['add_time'])) $update['add_time'] = strtotime($update['add_time']);
            // 文档属性相关处理
            $update = $this->archivesAttrFields($update, $post);
            // dump($update);exit;
            Db::name('archives')->where($where)->cache(true, EYOUCMS_CACHE_TIME, 'archives')->update($update);
        }
    }

    // 保存文档详情(默认语言)
    public function saveArchivesDetails($post = [])
    {
        $where = [
            'aid' => $post['aid'],
        ];
        $isCount = Db::name('archives_' . $this->showLang)->where($where)->count();
        if (empty($isCount)) {
            // 获取新增文档数据
            [$insert, $content] = $this->getInsertArchivesArray($post);

            // 保存文档基础数据
            $resultID = Db::name('archives_' . $this->showLang)->insertGetId($insert);
            if (!empty($resultID)) {
                // 保存文档内容数据
                if (!empty($post['channel'])) $this->getChannelTable($post['channel']);
                Db::name($this->table . '_content_' . $this->showLang)->insertGetId($content);
            }
        }
        else {
            // 获取更新文档数据
            [$update, $content] = $this->getUpdateArchivesArray($post);

            // 保存文档基础数据
            $resultID = Db::name('archives_' . $this->showLang)->where($where)->update($update);
            if (!empty($resultID)) {
                // 保存文档内容数据
                if (!empty($post['channel'])) $this->getChannelTable($post['channel']);
                Db::name($this->table . '_content_' . $this->showLang)->where($where)->update($content);
            }
        }
        return !empty($resultID) ? true : false;
    }

    // 获取新增文档数据
    public function getInsertArchivesArray($post = [], $isMainTable = false)
    {
        // 处理编辑器的内容
        $this->editor_auto_210607($post);

        // 后台登录的管理员信息
        $admin_info = session('admin_info');

        // 内容HTML转码解析
        $content_ey = empty($post['addonFieldExt']['content']) ? '' : htmlspecialchars_decode($post['addonFieldExt']['content']);
        $content_ey_m = empty($post['addonFieldExt']['content_ey_m']) ? '' : htmlspecialchars_decode($post['addonFieldExt']['content_ey_m']);
        $content_ey = empty($content_ey) && !empty($content_ey_m) ? $content_ey_m : $content_ey;

        if (!empty($isMainTable)) {
            // 如果存在轮播图则默认使用第一张为封面图
            if (!empty($post['proimg'][0])) $post['litpic'] = trim($post['proimg'][0]);
            if (!empty($post['imgupload'][0])) $post['litpic'] = trim($post['imgupload'][0]);
            // 如果没有上传封面图则自动获取内容第一张图片作为封面图
            $litpic = !empty($post['litpic']) ? trim($post['litpic']) : get_html_first_imgurl($content_ey);
        }

        // SEO描述处理
        $seo_description = empty($post['seo_description']) && !empty($content_ey) ? @msubstr(checkStrHtml($content_ey), 0, get_seo_description_length(), false) : $post['seo_description'];

        // 文档基础数据
        $insert = [
            'aid'                     => !empty($post['aid']) ? intval($post['aid']) : 0,
            'typeid'                  => !empty($post['stypeid'][0]) && !empty($isMainTable) ? intval($post['stypeid'][0]) : 0,
            'stypeid'                 => !empty($post['stypeid']) && !empty($isMainTable) ? implode(',', $post['stypeid']) : '',
            'channel'                 => !empty($post['channel']) ? intval($post['channel']) : 0,
            'title'                   => trim($post['title']),
            'litpic'                  => !empty($litpic) && !empty($isMainTable) ? trim($litpic) : '',
            'is_litpic'               => !empty($litpic) && !empty($isMainTable) ? 1 : 0,
            'click'                   => mt_rand(100, 1000),
            'author'                  => !empty($admin_info['pen_name']) ? trim($admin_info['pen_name']) : '小编',
            'logistics_type'          => isset($post['logistics_type']) ? implode(',', $post['logistics_type']) : 1,
            'sort_order'              => 100,
            'users_price'             => !empty($post['users_price']) ? floatval($post['users_price']) : 0,
            'admin_id'                => !empty($admin_info['admin_id']) ? intval($admin_info['admin_id']) : 0,
            'add_time'                => !empty($post['add_time']) ? strtotime($post['add_time']) : $this->times,
            'update_time'             => $this->times,
            'editor_img_clear_link'   => !empty($post['editor_img_clear_link']) ? intval($post['editor_img_clear_link']) : 0,
            'editor_remote_img_local' => !empty($post['editor_remote_img_local']) ? intval($post['editor_remote_img_local']) : 0,
        ];
        if (6 === intval($insert['channel'])) {
            $insert['tempview'] = !empty($post['tempview']) ? $post['tempview'] : 'lists_single.htm';
        }
        // 检测路由是否重名，重名则在后面加上(-n)标记
        if (!empty($isMainTable)) $insert['htmlfilename'] = model('Archives')->customRouteHandle(0, preg_replace("/[^\x{4e00}-\x{9fa5}\w\-]+/u", "-", strtolower($post['title'])));

        // 文档内容数据
        $content = [
            'aid'             => !empty($post['aid']) ? intval($post['aid']) : 0,
            'content'         => !empty($content_ey) ? htmlspecialchars($content_ey) : '',
            'content_ey_m'    => !empty($content_ey_m) ? htmlspecialchars($content_ey_m) : '',
            'seo_title'       => !empty($post['seo_title']) ? trim($post['seo_title']) : '',
            'seo_keywords'    => !empty($post['seo_keywords']) ? str_replace('，', ',', $post['seo_keywords']) : '',
            'seo_description' => !empty($seo_description) ? trim($seo_description) : '',
            'short_content'   => !empty($post['short_content']) ? trim($post['short_content']) : '',
            'add_time'        => $this->times,
            'update_time'     => $this->times,
        ];
        // 如果是单页模型则追加分类ID字段
        if (!empty($insert['channel']) && 6 === intval($insert['channel']) && !empty($post['stypeid'][0])) $content['typeid'] = intval($post['stypeid'][0]);

        // 如果没有传入aid则删除字段
        if (empty($post['aid'])) {
            unset($insert['aid']);
            unset($content['aid']);
        }

        // 返回数据
        $insert = array_merge($post, $insert);
        // 文档主表共用字段处理，不文档语言表存入
        if (empty($isMainTable)) {
            $insert = $this->archivesRealFields($insert);
        } else {
            // 文档属性相关处理
            $insert = $this->archivesAttrFields($insert, $post);
        }
        return [$insert, $content];
    }

    // 更新对应语言文档数据
    public function getUpdateArchivesArray($post = [])
    {
        // 处理编辑器的内容
        $this->editor_auto_210607($post);

        // 文档基础数据
        $update = [
            'title'                   => !empty($post['title']) ? trim($post['title']) : '',
            'update_time'             => $this->times,
            'editor_img_clear_link'   => !empty($post['editor_img_clear_link']) ? intval($post['editor_img_clear_link']) : 0,
            'editor_remote_img_local' => !empty($post['editor_remote_img_local']) ? intval($post['editor_remote_img_local']) : 0,
        ];
        if (!empty($post['add_time'])) $update['add_time'] = strtotime($post['add_time']);
        if (6 === intval($post['channel'])) $update['tempview'] = !empty($post['tempview']) ? $post['tempview'] : 'lists_single.htm';

        // 内容HTML转码解析
        $content_ey = empty($post['addonFieldExt']['content']) ? '' : htmlspecialchars_decode($post['addonFieldExt']['content']);
        $content_ey_m = empty($post['addonFieldExt']['content_ey_m']) ? '' : htmlspecialchars_decode($post['addonFieldExt']['content_ey_m']);
        $content_ey = empty($content_ey) && !empty($content_ey_m) ? $content_ey_m : $content_ey;

        // SEO描述处理
        $seo_description = empty($post['seo_description']) && !empty($content_ey) ? @msubstr(checkStrHtml($content_ey), 0, get_seo_description_length(), false) : $post['seo_description'];

        // 文档内容数据
        $content = [
            'content'         => !empty($content_ey) ? htmlspecialchars($content_ey) : '',
            'content_ey_m'    => !empty($content_ey_m) ? htmlspecialchars($content_ey_m) : '',
            'seo_title'       => !empty($post['seo_title']) ? trim($post['seo_title']) : '',
            'seo_keywords'    => !empty($post['seo_keywords']) ? str_replace('，', ',', $post['seo_keywords']) : '',
            'seo_description' => !empty($seo_description) ? trim($seo_description) : '',
            'short_content'   => !empty($post['short_content']) ? trim($post['short_content']) : '',
            'update_time'     => $this->times,
        ];

        // 返回数据
        $update = array_merge($post, $update);
        // 文档主表共用字段处理，不文档语言表存入
        $update = $this->archivesRealFields($update);
        return [$update, $content];
    }

    // 获取模型对应的数据表名
    public function getChannelTable($channel = 0)
    {
        $this->table = Db::name('channeltype')->where('id', intval($channel))->getField('table');
        if (empty($this->table)) $this->error('数据模型不存在');
    }

    // 检测路由是否重名，重名则在后面加上(-n)标记
    public function customRouteHandle($aid = 0, $customRoute = '', $customRouteOld = '', $index = 1)
    {
        // 查询条件
        $where = [
            'htmlfilename' => trim($customRoute),
        ];
        if (!empty($aid)) $where['aid'] = ['NEQ', intval($aid)];
        $count = Db::name('archives')->where($where)->count();
        if (!empty($count)) {
            // 存在重名，标记(-n)后再次查询
            $customRouteOld = !empty($customRouteOld) ? trim($customRouteOld) : trim($customRoute);
            return $this->customRouteHandle($aid, $customRouteOld . '-' . $index, $customRouteOld, ++$index);
        }
        return $customRoute;
    }

    // 文档主表共用字段处理，不文档语言表存入
    public function archivesRealFields($result = [])
    {
        $archives_real_fields = config('global.archives_real_fields');
        if (!empty($archives_real_fields)) {
            foreach ($archives_real_fields as $key => $value) {
                if (isset($value)) {
                    $result[$value] = 0;
                    if (in_array($value, ['litpic', 'stypeid', 'jumplinks'])) $result[$value] = '';
                    if (in_array($value, ['status', 'stock_show', 'logistics_type'])) $result[$value] = 1;
                }
            }
        }

        return $result;
    }

    // 文档属性相关处理
    public function archivesAttrFields($result = [], $post = [])
    {
        return array_merge($result, [
            'is_b'       => !empty($post['is_b']) ? intval($post['is_b']) : 0,
            'is_head'    => !empty($post['is_head']) ? intval($post['is_head']) : 0,
            'is_special' => !empty($post['is_special']) ? intval($post['is_special']) : 0,
            'is_top'     => !empty($post['is_top']) ? intval($post['is_top']) : 0,
            'is_recom'   => !empty($post['is_recom']) ? intval($post['is_recom']) : 0,
            'is_roll'    => !empty($post['is_roll']) ? intval($post['is_roll']) : 0,
            'is_slide'   => !empty($post['is_slide']) ? intval($post['is_slide']) : 0,
            'is_diyattr' => !empty($post['is_diyattr']) ? intval($post['is_diyattr']) : 0,
            'is_jump'    => !empty($post['is_jump']) ? intval($post['is_jump']) : 0,
            'jumplinks'  => !empty($post['jumplinks']) ? trim($post['jumplinks']) : '',
        ]);
    }

    // 删除文档及相关内容
    public function delArchives($del_id = [], $table = 'article', $success = true)
    {
        if (empty($del_id)) $this->error('请选择需要删除的文档');

        // 查询需要删除的文档标题
        $where = [
            'aid' => ['IN', $del_id]
        ];
        $titleArr = Db::name('archives')->where($where)->column('title');
        if (empty($titleArr)) $this->error('请选择需要删除的文档');
        // 删除文档主表及相关数据
        Db::name('archives')->where($where)->cache(true, EYOUCMS_CACHE_TIME, 'archives')->delete(true);
        Db::name($table . '_content')->where($where)->delete(true);

        // 仅删除文章时执行
        if ('article' == trim($table)) {
            del_statistics_data(7, $del_id); // 减少统计数
        }
        // 仅删除案例时执行
        else if ('images' == trim($table)) {
            Db::name('images_upload')->where($where)->delete(true);
        }
        // 仅删除产品时执行
        else if ('product' == trim($table)) {
            Db::name('product_img')->where($where)->delete(true);
            Db::name('product_param')->where($where)->delete(true);
            del_statistics_data(6, $del_id); // 减少统计数
            // 清理失效的购物车商品
            model('ShopCart')->handleUsersShopCart($del_id);
        }

        // 查询使用的语言列表
        $markList = Db::name('language')->where(['status' => 1])->column('mark');
        foreach ($markList as $key => $value) {
            // 删除对应语言文档及相关数据
            if (!empty($value)) {
                Db::name('archives_' . $value)->where($where)->delete(true);
                Db::name($table . '_content_' . $value)->where($where)->delete(true);

                // 仅删除产品时执行
                if ('product' == trim($table)) Db::name('product_param_' . $value)->where($where)->delete(true);
            }
        }

        // 同时删除TAG标签
        // model('Taglist')->delByAids($del_id);
        // 写入日志
        adminLog('删除文档：' . implode(',', $titleArr));
        // 删除成功返回
        if (!empty($success)) $this->success('删除成功');
    }

    public function logOpenJumpPageUrl($aid = 0, $callback_url = '', $controller = '')
    {
        // 查询文档信息
        $result = $this->getArchivesDetails($aid);
        // 记录链接
        session('openJumpPageUrl', [
            'add_url' => custom_url($controller . '/add', ['id' => intval($aid), 'callback_url' => $callback_url]),
            'edit_url' => showlang_url($controller . '/edit', ['id' => intval($aid), 'callback_url' => $callback_url, 'showMsg' => 1]),
            'list_url' => custom_url($controller . '/index'),
            'view_url' => get_arcurl($result, true, '', $this->showLang),
        ]);
    }
}