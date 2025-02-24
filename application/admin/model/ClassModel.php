<?php
/**
 * ZanCms
 * ============================================================================
 * 版权所有 2020-2035 海南赞赞网络科技有限公司，并保留所有权利。
 * 网站地址: http://www.zancms.com
 * ----------------------------------------------------------------------------
 * 如果商业用途务必到官方购买正版授权, 以免引起不必要的法律纠纷.
 * ============================================================================
 * Author: 易而优团队 by 陈风任 <491085389@qq.com>
 * Date: 2021-01-14
 */

namespace app\admin\model;

use think\Db;
use think\Page;
use app\common\logic\ArctypeLogic;

/**
 * 分类模型
 */
load_trait('controller/Jump');
class ClassModel
{
    use \traits\controller\Jump;

    public $action;
    public $paramArr;

    // 构造函数
    public function __construct($channeltype = 0)
    {
        // 时间戳
        $this->times = getTime();
        // 执行方法
        $this->action = 'insert';
        // 接收参数
        $this->paramArr = input('param.');
        // 模型ID，默认2(商城模型)
        $this->channeltype = intval($channeltype);
        // 数据表
        $this->arctype_db = Db::name('arctype');
        // 全局分类业务层
        $this->arctypeLogic = new ArctypeLogic();
        // 后台默认语言
        $this->adminLang = get_admin_lang();
        // 后台URL语言(编辑切换时使用)
        $this->showLang = input('showlang/s', $this->adminLang);
    }

    // 商品分类操作
    public function goodsClassifyAction($action = '', $post = [])
    {
        // 定义执行方法
        $this->action = $action;
        $this->paramArr = !empty($post) ? $post : $this->paramArr;
        if (!empty($this->paramArr['current_channel'])) $this->channeltype = intval($this->paramArr['current_channel']);

        // 删除分类
        if ('delete' == $this->action) {
            $this->deleteClassifyListData();
        }
        // 新增 or 编辑
        else {
            // 保存分类列表数据
            $result = $this->saveClassifyListData();
            if (6 === intval($this->channeltype)) return $result;
        }
        $this->error('操作失败');
    }

    // 获取分类列表
    public function getClassifyListData($stypeid = [], $showLangList = [], $auto_id = 0)
    {
        // 分类列表
        $where = [
            'is_del' => 0,
            'lang' => $this->showLang,
        ];
        if (!empty($stypeid)) $where['id'] = ['IN', $stypeid];
        if (!empty($auto_id)) $where['auto_id'] = intval($auto_id);
        if (!empty($this->channeltype)) $where['current_channel'] = $this->channeltype;
        $arctype_list = [];
        if (!empty($showLangList)) {
            foreach ($showLangList as $key => $value) {
                $where['lang'] = $value['mark'];
                $arctype_list[$value['mark']] = $this->arctypeLogic->arctype_list(0, 0, false, 0, $where, false, false);
            }
        } else {
            $arctype_list = $this->arctypeLogic->arctype_list(0, 0, false, 0, $where, false);
        }
        if (!empty($stypeid) || !empty($auto_id)) return $arctype_list;

        // 获取所有有子栏目的栏目id
        $where = [
            'is_del' => 0,
            'parent_id' => ['gt', 0]
        ];
        $parent_ids = $this->arctype_db->where($where)->group('parent_id')->cache(true, EYOUCMS_CACHE_TIME, 'arctype')->column('parent_id');
        $cookied_treeclicked =  json_decode(cookie('admin-treeClicked-Arr'));
        empty($cookied_treeclicked) && $cookied_treeclicked = [];
        $all_treeclicked = cookie('admin-treeClicked_All');
        empty($all_treeclicked) && $all_treeclicked = [];
        $tree = [
            'has_children'=>!empty($parent_ids) ? 1 : 0,
            'parent_ids'=>json_encode($parent_ids),
            'all_treeclicked'=>$all_treeclicked,
            'cookied_treeclicked'=>$cookied_treeclicked,
            'cookied_treeclicked_arr'=>json_encode($cookied_treeclicked),
        ];
        // --- end

        // 生成静态所需参数
        $typeurl = '';
        $seo_pseudo = tpCache('global.seo_pseudo');//URL模式
        $sitemap_zzbaidutoken = config('tpcache.sitemap_zzbaidutoken');//实时推送Url的token
        $bdminipro = Db::name('weapp')->where(['code'=>'BdDiyminipro','status'=>1])->find();
        if (!empty($this->paramArr['typeid'])){
            $typeData = $this->arctype_db->where('id', $this->paramArr['typeid'])->find();
            if (!empty($typeData)) $typeurl = get_typeurl($typeData);
        }
        $eyou = [
            'handle' => !empty($this->paramArr['handle']) ? $this->paramArr['handle'] : '',
            'typeurl' => $typeurl,
            'bdminipro' => !empty($bdminipro) ? $bdminipro : [],
            'seo_pseudo' => $seo_pseudo,
            'zzbaidutoken' => $sitemap_zzbaidutoken,
        ];
        // --- end

        // 返回数据
        return [
            // 栏目cookie
            'tree' => $tree,
            // 生成静态所需参数
            'eyou' => $eyou,
            // 分类列表
            'arctype_list' => !empty($arctype_list) ? $arctype_list : [],
            // 回收站开关
            'recycle_switch' => tpSetting('recycle.recycle_switch'),
            // 模型列表
            'channeltype_list' => getChanneltypeList(),
            // 分类最多级别
            'arctype_max_level' => intval(config('global.arctype_max_level')),
            // 栏目ID
            'typeid' => !empty($this->paramArr['typeid']) ? intval($this->paramArr['typeid']) : 0,
            // 是否伪删除(回收站)
            'is_del' => !empty($this->paramArr['is_del']) ? intval($this->paramArr['is_del']) : 0,
        ];
    }

    // 获取页面所需数据
    public function getGoodsClassifyPublic($action = 'insert')
    {
        $arctype = [];
        $topCount = $parentCount = 0;
        if ('update' == $action) {
            // 分类ID
            if (empty($this->paramArr['id'])) $this->error('请选择分类');
            $where = [
                'id' => intval($this->paramArr['id']),
                'status' => 1,
                'is_del' => 0,
                'lang' => $this->showLang,
            ];
            $arctype = $this->arctype_db->where($where)->find();
            if (!empty($arctype['current_channel'])) {
                $channelList = getChanneltypeList();
                $arctype['nid'] = !empty($channelList[$arctype['current_channel']]['nid']) ? trim($channelList[$arctype['current_channel']]['nid']) : '';
                // 赋值模型ID
                $this->channeltype = intval($arctype['current_channel']);
            }
            // 查询当前分类下是否有子级分类
            $subList = model('Arctype')->getHasChildren($this->paramArr['id'], false);
            if (!empty($subList)) {
                foreach ($subList as $key => $value) {
                    if (isset($value['grade']) && 1 === intval($value['grade'])) {
                        $parentCount = 1;
                    } else if (isset($value['grade']) && 2 === intval($value['grade'])) {
                        $topCount = 1;
                    }
                }
            }
        }

        // 父级分类ID
        $parent_id = !empty($arctype['parent_id']) ? intval($arctype['parent_id']) : intval($this->paramArr['parent_id']);

        // 目录存放HTML路径
        $predirpath = $this->arctype_db->where(['id' => intval($parent_id)])->getField('dirpath');

        // 一级分类
        $where = [
            'is_del' => 0,
            'parent_id' => 0,
            'lang' => $this->showLang,
            'current_channel' => $this->channeltype
        ];
        $arctype_list = model('Arctype')->getAll('id, typename, dirpath', $where, 'id');

        // 新增栏目在指定的上一级栏目下
        $topid = !empty($arctype['topid']) ? intval($arctype['topid']) : 0;
        $grade = !empty($arctype['grade']) ? intval($arctype['grade']++) : 0;
        $parent_show = 0;
        $arctype_list2 = [];
        if (0 < intval($parent_id)) {
            $where = [
                'is_del' => 0,
                'lang' => $this->showLang,
                'id' => intval($parent_id),
                'current_channel' => $this->channeltype
            ];
            $info = $this->arctype_db->where($where)->field('id, parent_id, grade, topid')->find();
            if (!empty($info)) {
                $grade = $info['grade'] + 1;
                $topid = !empty($info['topid']) ? $info['topid'] : $parent_id;
            }

            // 二级分类
            if (2 <= intval($grade)) {
                $where = [
                    'is_del' => 0,
                    'lang' => $this->showLang,
                    'parent_id' => $info['parent_id'],
                    'current_channel' => $this->channeltype
                ];
                $parent_show = 1;
                $arctype_list2 = model('Arctype')->getAll('id, typename, dirpath', $where, 'id');
            }
        }

        // 返回数据
        return [
            'topid' => !empty($topid) ? intval($topid) : 0,
            'grade' => !empty($grade) ? intval($grade) : 0,
            'arctype' => !empty($arctype) ? $arctype : [],
            'parent_id' => !empty($parent_id) ? intval($parent_id) : 0,
            'predirpath' => !empty($predirpath) ? trim($predirpath) : '',
            'parent_show' => !empty($parent_show) ? $parent_show : 0,
            'arctype_list' => !empty($arctype_list) ? $arctype_list : [],
            'arctype_list2' => !empty($arctype_list2) ? $arctype_list2 : [],
            'topCount' => !empty($topCount) ? intval($topCount) : 0,
            'parentCount' => !empty($parentCount) ? intval($parentCount) : 0,
        ];

    }

    // 获取商品分类数据
    private function saveClassifyListData()
    {
        if(strtolower($this->paramArr['typename']) == 'all-product' || strtolower($this->paramArr['typename']) == 'all-image' || strtolower($this->paramArr['typename']) == 'all-article'){
            $this->error('与系统内置参数冲突，请更换！');
        }   
        if(strtolower($this->paramArr['dirname']) == 'all-product' || strtolower($this->paramArr['dirname']) == 'all-image' || strtolower($this->paramArr['dirname']) == 'all-article'){
            $this->error('自定义地址已存在，请更换！');
        }        
        // 目录存放HTML路径
        $dirpath = !empty($this->paramArr['dirpath']) ? rtrim($this->paramArr['dirpath'], '/') : '';
        // 分类名称处理
        $typename = str_replace('\\', '/', $this->paramArr['typename']);
        $typename = addslashes(htmlspecialchars(strip_tags(strip_sql($typename))));
        $typename = str_replace(["\'","&amp;"], ["'","&"], $typename);
        // 编辑分类
        if (!empty($this->paramArr['auto_id'])) {
            // 编辑数据
            $update = [
                'topid'           => !empty($this->paramArr['topid']) ? intval($this->paramArr['topid']) : 0,
                'parent_id'       => !empty($this->paramArr['parent_id']) ? intval($this->paramArr['parent_id']) : intval($this->paramArr['topid']),
                'typename'        => trim($typename),
                'grade'           => 0,
                'litpic'          => !empty($this->paramArr['litpic']) ? get_default_pic($this->paramArr['litpic']) : '',
                'templist'        => !empty($this->paramArr['templist']) ? trim($this->paramArr['templist']) : '',
                'tempview'        => !empty($this->paramArr['tempview']) ? trim($this->paramArr['tempview']) : '',
                'seo_title'       => !empty($this->paramArr['seo_title']) ? trim($this->paramArr['seo_title']) : '',
                'seo_keywords'    => !empty($this->paramArr['seo_keywords']) ? trim($this->paramArr['seo_keywords']) : '',
                'seo_description' => !empty($this->paramArr['seo_description']) ? trim($this->paramArr['seo_description']) : '',
                'update_time'     => $this->times
            ];
            if (!empty($this->paramArr['topid'])) $update['grade'] = 1;
            if (!empty($this->paramArr['parent_id']) && $this->paramArr['topid'] != $this->paramArr['parent_id']) $update['grade'] = 2;

            // 执行更新
            $resultID = $this->arctype_db->where(['auto_id' => $this->paramArr['auto_id']])->cache(true, null, "arctype")->update($update);
            if (!empty($resultID)) {
                $update_ = [];
                // 如果是默认语言改动路由则执行更新
                if (trim($this->showLang) === trim($this->adminLang) && $this->paramArr['dirname'] != $this->paramArr['dirname_old']) {
                    $this->paramArr['dirname'] = !empty($this->paramArr['dirname']) ? $this->paramArr['dirname'] : $typename;
                    // 自定义路由处理
                    $customRoute = $this->arctypeCustomRouteHandle($this->paramArr['id'], preg_replace("/[^\x{4e00}-\x{9fa5}\w\-]+/u", "-", strtolower($this->paramArr['dirname'])));
                    // 默认语言才可以编辑其他信息
                    $update_ = array_merge($update_, [
                        'dirname'     => $customRoute,
                        'dirpath'     => $dirpath . '/' . $customRoute,
                        'diy_dirpath' => $dirpath . '/' . $customRoute,
                        'update_time' => $this->times
                    ]);
                }
                else if (trim($this->showLang) === trim($this->adminLang) && trim($this->paramArr['dirpath']) != trim($this->paramArr['dirpath_old'])) {
                    $update_ = array_merge($update_, [
                        'grade'       => $update['grade'],
                        'topid'       => !empty($this->paramArr['topid']) ? intval($this->paramArr['topid']) : 0,
                        'parent_id'   => !empty($this->paramArr['parent_id']) ? intval($this->paramArr['parent_id']) : intval($this->paramArr['topid']),
                        'dirname'     => $this->paramArr['dirname'],
                        'dirpath'     => $dirpath . '/' . $this->paramArr['dirname'],
                        'diy_dirpath' => $dirpath . '/' . $this->paramArr['dirname'],
                        'update_time' => $this->times
                    ]);

                    $allSubArctype = [];
                    // 查询下级所有分类
                    if (in_array($update_['grade'], [0, 1])) {
                        $field = 'auto_id, parent_id, topid, grade, dirname, dirpath, diy_dirpath, update_time';
                        $allSubArr = $this->arctype_db->field($field)->where(['parent_id' => $this->paramArr['id']])->select();
                        foreach ($allSubArr as $key => $value) {
                            if (!empty($value)) {
                                $value['update_time'] = $this->times;
                                $value['topid'] = !empty($update_['topid']) ? intval($update_['topid']) : intval($this->paramArr['id']);
                                if (!empty($value['topid'])) $value['grade'] = 1;
                                if (!empty($value['parent_id']) && $value['topid'] != $value['parent_id']) $value['grade'] = 2;
                                $value['dirpath'] = $update_['dirpath'] . '/' . $value['dirname'];
                                $value['diy_dirpath'] = $update_['diy_dirpath'] . '/' . $value['dirname'];
                                $allSubArr[$key] = $value;
                            }
                        }
                    }
                }
                if (!empty($this->paramArr['templist']) || !empty($this->paramArr['tempview'])) {
                    $update_ = array_merge($update_, [
                        'templist'    => !empty($this->paramArr['templist']) ? trim($this->paramArr['templist']) : '',
                        'tempview'    => !empty($this->paramArr['tempview']) ? trim($this->paramArr['tempview']) : '',
                        'update_time' => $this->times
                    ]);
                }

                if (!empty($update_)) {
                    $resultID = $this->arctype_db->where(['id' => $this->paramArr['id']])->cache(true, null, "arctype")->update($update_);
                    if (false !== $resultID && !empty($allSubArr)) model('Arctype')->saveAll($allSubArr);
                }
                if (6 === intval($this->channeltype)) {
                    return false !== $resultID ? true : false;
                } else {
                    // 清除缓存返回成功提示
                    \think\Cache::clear("arctype");
                    $this->success('保存成功');
                }
            }
        }
        // 新增分类
        else {
            // 获取广告内容唯一ID
            $nextID = create_next_id('arctype', 'id');
            // 自定义路由处理
            $customRoute = $this->arctypeCustomRouteHandle(0, preg_replace("/[^\x{4e00}-\x{9fa5}\w\-]+/u", "-", strtolower($typename)));
            // 新增数据
            $insertAll = [
                'id'              => intval($nextID),
                'channeltype'     => $this->channeltype,
                'current_channel' => $this->channeltype,
                'parent_id'       => !empty($this->paramArr['parent_id']) ? intval($this->paramArr['parent_id']) : intval($this->paramArr['topid']),
                'topid'           => !empty($this->paramArr['topid']) ? intval($this->paramArr['topid']) : 0,
                'typename'        => $typename,
                'dirname'         => $customRoute,
                'dirpath'         => $dirpath . '/' . $customRoute,
                'diy_dirpath'     => $dirpath . '/' . $customRoute,
                'grade'           => 0,
                'litpic'          => !empty($this->paramArr['litpic']) ? get_default_pic($this->paramArr['litpic']) : '',
                'templist'        => !empty($this->paramArr['templist']) ? trim($this->paramArr['templist']) : '',
                'tempview'        => !empty($this->paramArr['tempview']) ? trim($this->paramArr['tempview']) : '',
                'seo_title'       => !empty($this->paramArr['seo_title']) ? trim($this->paramArr['seo_title']) : '',
                'seo_keywords'    => !empty($this->paramArr['seo_keywords']) ? trim($this->paramArr['seo_keywords']) : '',
                'seo_description' => !empty($this->paramArr['seo_description']) ? trim($this->paramArr['seo_description']) : '',
                'sort_order'      => 100,
                'lang'            => $this->showLang,
                'add_time'        => $this->times,
                'update_time'     => $this->times,
            ];
            if (!empty($this->paramArr['topid'])) $insertAll['grade'] = 1;
            if (!empty($this->paramArr['parent_id'])) $insertAll['grade'] = 2;
            // 获取多语言添加数据
            $insertAll = model('Language')->getMultiLanguageInsertAll($insertAll);
            // dump($insertAll);exit;
            // 执行新增
            if (!empty($insertAll[0]['id'])) {
                $resultID = $this->arctype_db->insertAll($insertAll);
                if (!empty($resultID)) {
                    \think\Cache::clear("arctype");
                    if (6 === intval($this->channeltype)) {
                        return [$nextID];
                    } else {
                        $result = [
                            'showMsg' => 1,
                            'id' => intval($insertAll[0]['id']),
                            'channeltype' => intval($this->channeltype),
                        ];
                        $this->success('保存成功', url('Arctype/edit', $result));
                    }
                }
            }
        }

        // 错误提示
        $this->error('保存失败');
    }

    // 删除分类数据
    private function deleteClassifyListData()
    {
        // 分类ID
        if (empty($this->paramArr['id'])) $this->error('请选择要删除的分类');

        // 查询删除分类ID
        $where = [
            'current_channel' => $this->channeltype,
            'id|topid|parent_id' => intval($this->paramArr['id']),
        ];
        $columnID = $this->arctype_db->where($where)->column('auto_id');
        if (empty($columnID)) $this->error('未查询到相关分类');

        // 查询单页内容aid一并删除
        $aidArr = [];
        if (6 === intval($this->channeltype)) {
            $typeidArr = $this->arctype_db->where($where)->column('id');
            if (!empty($typeidArr)) {
                $where = [
                    'typeid' => ['IN', $typeidArr],
                    'channel' => $this->channeltype
                ];
                $aidArr = Db::name('archives')->where($where)->column('aid');
            }
        }

        // 执行删除指定分类
        $where = [
            'auto_id' => ['IN', $columnID],
            'current_channel' => $this->channeltype
        ];
        $deleteID = $this->arctype_db->where($where)->cache(true, null, "arctype")->delete(true);
        // 删除分类后续操作
        if (!empty($deleteID)) {
            // 删除单页内容
            if (!empty($aidArr)) model('Archives')->delArchives(eyIntval($aidArr), 'single', false);

            \think\Cache::clear("arctype");
            $this->success('删除成功');
        }
        $this->error('删除失败');
    }

    // 检测路由是否重名，重名则在后面加上(-n)标记
    public function arctypeCustomRouteHandle($id = 0, $dirName = '', $dirNameOld = '', $index = 1)
    {
        // 查询条件
        $where = [
            'dirname' => trim($dirName),
        ];
        if (!empty($id)) $where['id'] = ['NEQ', intval($id)];
        $count = Db::name('arctype')->where($where)->count();
        if (!empty($count)) {
            // 存在重名，标记(-n)后再次查询
            $dirNameOld = !empty($dirNameOld) ? trim($dirNameOld) : trim($dirName);
            return $this->arctypeCustomRouteHandle($id, $dirNameOld . '-' . $index, $dirNameOld, ++$index);
        }
        return $dirName;
    }

    // 获取指定分类的下级分类
    public function ajaxGetUnderArctypeList()
    {
        $id = input('post.id/d', 0);
        $topCount = input('post.topCount/d', 0);
        $parent_id = input('post.parent_id/d', 0);
        $parentCount = input('post.parentCount/d', 0);
        if (!empty($parent_id)) {
            $where = [
                'is_del' => 0,
                'lang' => $this->showLang,
                'parent_id' => intval($parent_id),
                'current_channel' => $this->channeltype
            ];
            $arctype = Db::name('arctype')->field('id, current_channel, typename, dirpath')->where($where)->select();
            $selecthtml = '';
            if (!empty($arctype)) {
                if (empty($id) && 0 == $id) {
                    $selecthtml .= "<option value='0' selected='true'>选择分类</option>";
                } else {
                    $selecthtml .= "<option value='0'>选择分类</option>";
                }
                $disabled = (empty($topCount) && !empty($parentCount)) || (!empty($topCount) && empty($parentCount)) ? "disabled ='true' style='background-color:#f5f5f5;'" : "";
                foreach ($arctype as $key => $value) {
                    $selected = intval($value['id']) === intval($id) ? "selected='true'" : "";
                    $selecthtml .= "<option value='{$value['id']}' data-dirpath='{$value['dirpath']}' {$selected} {$disabled}>{$value['typename']}</option>";
                }
            }
            $data = [
                'selecthtml' => $selecthtml,
            ];
            $this->success('请求成功', null, $data);
        }

        $this->error('请求失败');
    }
}