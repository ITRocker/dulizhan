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
 * 广告表
 */
class Ad extends Model
{
    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        // 当前时间戳
        $this->times = getTime();
        // 后台默认语言
        $this->adminLang = get_admin_lang();
        // 后台URL语言(编辑切换时使用)
        $this->showLang = input('showlang/s', $this->adminLang);
    }

    // 保存广告内容列表数据
    public function saveAdContentList($post = [])
    {
        // 排序值
        $sort = 1;
        // 新增编辑
        $insertAll = $updateAll = [];
        // 管理员ID
        $admin_id = session('admin_id');
        // 获取广告内容唯一ID
        $nextID = create_next_id('ad', 'id');
        // 查询使用的语言列表
        $markList = Db::name('language')->where(['status' => 1])->column('mark');
        foreach ($post['img_litpic'] as $key => $value) {
            if (!empty($value)) {
                $target = !empty($post['img_target'][$key]) ? 1 : 0;
                $value = str_replace(["http:", "https:"], "", $value);
                $title = !empty($post['img_title'][$key]) ? trim($post['img_title'][$key]) : '';
                $links = !empty($post['img_links'][$key]) ? trim($post['img_links'][$key]) : '';
                $intro = !empty($post['img_intro'][$key]) ? trim($post['img_intro'][$key]) : '';
                if (!empty($post['img_auto_id'][$key])) {
                    $updateAll[] = [
                        'auto_id'     => intval($post['img_auto_id'][$key]),
                        'litpic'      => $value,
                        'title'       => $title,
                        'links'       => $links,
                        'intro'       => $intro,
                        'target'      => $target,
                        'sort_order'  => $sort++,
                        'update_time' => $this->times,
                    ];
                } else {
                    $insert = [
                        'id'          => $nextID++,
                        'pid'         => intval($post['id']),
                        'media_type'  => 1,
                        'title'       => $title,
                        'links'       => $links,
                        'litpic'      => $value,
                        'intro'       => $intro,
                        'sort_order'  => $sort++,
                        'target'      => $target,
                        'admin_id'    => $admin_id,
                        'lang'        => 'cn',
                        'add_time'    => $this->times,
                        'update_time' => $this->times,
                    ];
                    if (!empty($markList)) {
                        foreach ($markList as $lang) {
                            if (!empty($lang)) {
                                $insert['lang'] = $lang;
                                $insertAll[] = $insert;
                            }
                        }
                    } else {
                        $insertAll[] = $insert;
                    }
                }
            }
        }

        // 合并需要保存的数据
        $insertAll = !empty($updateAll) ? array_merge($insertAll, $updateAll) : $insertAll;
        // 如果存在数据则执行
        if (!empty($insertAll) || !empty($post['del_ad_id'])) {
            // 批量保存数据
            if (!empty($insertAll)) $this->saveAll($insertAll);
            // 删除指定数据
            if (!empty($post['del_ad_id'])) $this->where(['id' => ['IN', explode(',', $post['del_ad_id'])]])->delete(true);
            // 返回成功
            return true;
        } else {
            // 返回失败
            return false;
        }
    }
}