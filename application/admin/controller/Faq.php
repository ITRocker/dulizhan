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

namespace app\admin\controller;

use think\Db;
use think\Page;
use think\Cache;

class Faq extends Base
{

    public function _initialize() {
        parent::_initialize();
        $this->times = getTime();
        $this->faqGroupDb = Db::name('faq_group');
        $this->faqAsklistDb = Db::name('faq_asklist');
    }

    public function index()
    {
        // 查询条件
        $where = [
            'lang' => $this->admin_lang
        ];
        $keywords = input('keywords/s');
        if (!empty($keywords)) $where['group_title'] = ['LIKE', "%{$keywords}%"];

        // 查询列表
        $count = $this->faqGroupDb->where($where)->count();
        $pageObj = new Page($count, config('paginate.list_rows'));
        $list = $this->faqGroupDb->where($where)->order('group_id desc')->limit($pageObj->firstRow.','.$pageObj->listRows)->getAllWithIndex('group_id');

        // 加载模板
        $this->assign('list', $list);
        $this->assign('pager', $pageObj);
        $this->assign('page', $pageObj->show());

        return $this->fetch();
    }

    public function add()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            // 是否存在分组名称
            $where = [
                'group_title' => trim($post['group_title']),
                'lang'  => $this->admin_lang,
            ];
            if ($this->faqGroupDb->where($where)->count() > 0) $this->error('分组名称已存在，请检查');
            
            // 语言列表
            $langRow = Db::name('language')->order('id asc')->select();

            // 添加分组
            $new_group_id = create_next_id('faq_group', 'group_id');
            $insertAll = [];
            foreach ($langRow as $key => $val) {
                $insertAll[] = [
                    'group_id'    => intval($new_group_id),
                    'group_title' => trim($post['group_title']),
                    'lang'        => trim($val['mark']),
                    'add_time'    => $this->times,
                    'update_time' => $this->times,
                ];
            }
            $resultID = !empty($insertAll) ? $this->faqGroupDb->insertAll($insertAll) : 0;
            if (!empty($resultID)) {
                Cache::clear('faq_group');
                // 添加分组问答
                $i = 1;
                $insertAll = [];
                $new_asklist_id = create_next_id('faq_asklist', 'asklist_id');
                foreach ($post['asklist_title'] as $key => $value) {
                    $asklistTitle = trim($value);
                    $asklistContent = trim($post['asklist_content'][$key]);
                    if (!empty($asklistTitle) || !empty($asklistContent)) {
                        foreach ($langRow as $_v) {
                            $insertAll[] = [
                                'group_id'        => intval($new_group_id),
                                'asklist_id'      => intval($new_asklist_id),
                                'asklist_title'   => !empty($asklistTitle) ? trim($asklistTitle) : '',
                                'asklist_content' => !empty($asklistContent) ? trim($asklistContent) : '',
                                'sort_order'      => $i,
                                'lang'            => trim($_v['mark']),
                                'add_time'        => $this->times,
                                'update_time'     => $this->times,
                            ];
                        }
                        $i++;
                        $new_asklist_id++;
                    }
                }
                $resultID = !empty($insertAll) ? $this->faqAsklistDb->insertAll($insertAll) : 0;
                if (!empty($resultID)) {
                    Cache::clear('faq_asklist');
                    $this->success("添加成功");
                }
            }
            $this->error("添加失败，请重试~");
        }

        return $this->fetch();
    }

    public function edit()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            // dump($post);exit;
            // 是否存在分组名称
            $where = [
                'group_id'    => ['NEQ', $post['group_id']],
                'group_title' => trim($post['group_title']),
                'lang'        => $this->admin_lang,
            ];
            if ($this->faqGroupDb->where($where)->count() > 0) $this->error('分组名称已存在，请检查');

            // 修改分组信息
            $update = [
                'group_title' => trim($post['group_title']),
                'update_time' => $this->times,
            ];
            $resultID = !empty($update) ? $this->faqGroupDb->where(['group_id' => intval($post['group_id'])])->update($update) : 0;
            if (!empty($resultID)) {
                // 执行删除分组问题
                if (!empty($post['del_asklist_id'])) {
                    $this->faqAsklistDb->where(['asklist_id' => ['IN', explode(',', $post['del_asklist_id'])]])->delete(true);
                }

                // 保存分组问答
                $update = [];
                foreach ($post['asklist_title'] as $key => $value) {
                    $i = 1;
                    foreach ($value as $key_1 => $value_1) {
                        $asklistTitle = trim($value_1);
                        $asklistContent = trim($post['asklist_content'][$key][$key_1]);
                        $update[] = [
                            'auto_id'         => intval($key_1),
                            'asklist_title'   => !empty($asklistTitle) ? trim($asklistTitle) : '',
                            'asklist_content' => !empty($asklistContent) ? trim($asklistContent) : '',
                            'sort_order'      => $i,
                            'update_time'     => $this->times,
                        ];
                        $i++;
                    }
                }
                // dump($update);

                // 新增分组问题
                $new_asklist_id = create_next_id('faq_asklist', 'asklist_id');
                foreach ($post['asklist_title_new'] as $key => $value) {
                    foreach ($value as $key_1 => $value_1) {
                        $asklistTitle = trim($value_1);
                        $asklistContent = trim($post['asklist_content_new'][$key][$key_1]);
                        $insertAll[] = [
                            'group_id'        => intval($post['group_id']),
                            'asklist_id'      => intval($new_asklist_id) + intval($key_1),
                            'asklist_title'   => !empty($asklistTitle) ? trim($asklistTitle) : '',
                            'asklist_content' => !empty($asklistContent) ? trim($asklistContent) : '',
                            'sort_order'      => intval($i) + intval($key_1),
                            'lang'            => trim($key),
                            'add_time'        => $this->times,
                            'update_time'     => $this->times,
                        ];
                    }
                }
                // dump($insertAll);
                // exit;

                // 执行保存分组问答
                if (!empty($update)) model('FaqAsklist')->saveAll($update);
                // 执行新增分组问题
                if (!empty($insertAll)) $this->faqAsklistDb->insertAll($insertAll);
                // 返回结束
                Cache::clear('faq_asklist');
                $this->success("保存成功");
            }
            $this->error("保存失败，刷新重试~");
        }

        $assignData = [];
        // 查询问题分组
        $group_id = input('group_id/d', 0);
        $result = $this->faqGroupDb->where(['group_id' => $group_id])->order('lang asc, group_id asc')->select();
        $faqGroupList = [];
        foreach ($result as $key => $val) {
            $faqGroupList[$val['lang']] = $val;
        }
        $assignData['faqGroupList'] = $faqGroupList;
        // 查询当前语言分组
        $faqGroupField = $faqGroupList[$this->admin_lang];
        if (empty($faqGroupField)) $this->error('分组不存在，刷新页面重试~');
        $assignData['faqGroupField'] = $faqGroupField;

        // 多语言列表
        $languageList = Db::name('language')->alias('a')
            ->field('a.title,a.mark,a.is_home_default,a.is_admin_default,b.cn_title')
            ->join('language_mark b', 'a.mark = b.mark', 'left')
            ->order('a.is_home_default desc, a.sort_order asc, a.id asc')
            ->getAllWithIndex('mark');
        $assignData['languageList'] = $languageList;
        $assignData['languageListJson'] = json_encode($languageList);
        // $assignData['languageListMark'] = json_encode(get_arr_column($languageList, 'mark'));
        // dump($assignData['languageList']);exit;

        // 查询问题列表
        $result = $this->faqAsklistDb->where(['group_id' => $faqGroupField['group_id']])->order('lang asc, sort_order asc, asklist_id asc')->select();
        $faqAskList = [];
        foreach ($result as $key => $val) {
            $faqAskList[$val['lang']]['list'][] = $val;
            $faqAskList[$val['lang']]['info'] = $languageList[$val['lang']];
        }
        $assignData['faqAskList'] = $faqAskList;

        // dump($assignData);
        // exit;
        $this->assign($assignData);
        return $this->fetch();
    }

    public function del()
    {
        $id_arr = input('del_id/a');
        $id_arr = eyIntval($id_arr);
        if (IS_AJAX_POST && !empty($id_arr)) {
            $where = [
                'group_id' => ['IN', $id_arr]
            ];
            $r = $this->faqGroupDb->where($where)->delete(true);
            if ($r !== false) {
                Cache::clear('faq_group');
                $this->faqAsklistDb->where($where)->delete(true);
                Cache::clear('faq_asklist');
                $this->success('删除成功');
            }
        }
        $this->error('删除失败');
    }

    public function help()
    {
        $group_id = input('group_id/d', 0);
        $this->assign('group_id', $group_id);

        return $this->fetch();
    }
}