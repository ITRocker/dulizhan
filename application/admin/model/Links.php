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
use think\Cache;
use think\Model;

/**
 * 友情链接
 */
class Links extends Model
{
    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        // 时间戳
        $this->times = getTime();
        // post参数组
        $this->paramArr = input('param.');
        // 友情链接数据表
        $this->linksDb = Db::name('links');
        // 后台默认语言
        $this->adminLang = get_admin_lang();
        // 后台URL语言(编辑切换时使用)
        $this->showLang = input('showlang/s', $this->adminLang);
    }

    public function getLinksList()
    {
        // 查询数据
        $where = [
            'lang' => $this->showLang,
        ];
        $count = $this->linksDb->where($where)->count('id');
        $pageObj = $pager = new Page($count, config('paginate.list_rows'));
        $list = $this->linksDb->where($where)->limit($pageObj->firstRow.','.$pageObj->listRows)->order('sort_order asc, id asc')->select();

        // 返回数据
        return [
            'page' => $pageObj->show(),
            'list' => $list,
            'pager' => $pageObj,
        ];
    }

    public function saveLinksContentList()
    {
        if (empty($this->paramArr['title'])) $this->error("请填写网站名称");
        if (empty($this->paramArr['url'])) $this->error("请填写网站URL");

        // 编辑
        if (!empty($this->paramArr['auto_id'])) {
            // 编辑数据
            $update = [
                'title'       => trim($this->paramArr['title']),
                'url'         => preg_replace('/(<|>|;|\(|\)|\!)/i', '', trim($this->paramArr['url'])),
                'sort_order'  => !empty($this->paramArr['sort_order']) ? intval($this->paramArr['sort_order']) : 0,
                'intro'       => !empty($this->paramArr['intro']) ? htmlspecialchars_decode($this->paramArr['intro']) : '',
                'target'      => !empty($this->paramArr['target']) ? 1 : 0,
                'nofollow'    => !empty($this->paramArr['nofollow']) ? 1 : 0,
                'update_time' => $this->times
            ];
            // 执行更新
            $result = $this->linksDb->where(['id' => $this->paramArr['id']])->cache(true, null, "links")->update($update);
            if (!empty($result)) return true;
        }
        // 新增
        else {
            // 获取友情链接内容唯一ID
            $nextID = create_next_id('links', 'id');
            // 新增数据
            $insert = [
                'id'          => intval($nextID),
                'typeid'      => 1,
                'title'       => trim($this->paramArr['title']),
                'url'         => preg_replace('/(<|>|;|\(|\)|\!)/i', '', trim($this->paramArr['url'])),
                'sort_order'  => !empty($this->paramArr['sort_order']) ? intval($this->paramArr['sort_order']) : 0,
                'intro'       => !empty($this->paramArr['intro']) ? htmlspecialchars_decode($this->paramArr['intro']) : '',
                'target'      => !empty($this->paramArr['target']) ? 1 : 0,
                'nofollow'    => !empty($this->paramArr['nofollow']) ? 1 : 0,
                'lang'        => $this->showLang,
                'add_time'    => $this->times,
                'update_time' => $this->times
            ];
            // 获取多语言添加数据
            $insertAll = model('Language')->getMultiLanguageInsertAll($insert);
            // 执行批量新增
            if (!empty($insertAll)) {
                $result = $this->linksDb->insertAll($insertAll);
                if (!empty($result)) return true;
            }
        }

        return false;
    }
}