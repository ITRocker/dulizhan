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
 * 导航菜单模型
 */
load_trait('controller/Jump');
class NavList extends Model
{
    use \traits\controller\Jump;

    public $paramArr;
    // 初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        // 时间戳
        $this->times = getTime();
        // post参数组
        $this->paramArr = input('param.');
        // 导航菜单列表
        $this->navListDb = Db::name('nav_list');
        // 导航菜单位置表
        $this->navPositionDb = Db::name('nav_position');
        // 后台默认语言
        $this->adminLang = get_admin_lang();
        // 后台URL语言(编辑切换时使用)
        $this->showLang = input('showlang/s', $this->adminLang);
    }

    // 获取导航菜单内容列表数据
    public function getNavListContentList()
    {

    }

    // 保存导航菜单内容列表数据
    public function saveNavListContentList()
    {
        if (empty($this->paramArr['nav_url']) && -5 === intval($this->paramArr['type_id'])) $this->error("请填写链接地址");
        if (empty($this->paramArr['nav_name'])) $this->error("请填写菜单名称");

        // 如果链接为空则获取指定链接
        $this->paramArr['nav_url'] = empty($this->paramArr['nav_url']) ? $this->getNavListBasicArr($this->paramArr['type_id']) : $this->paramArr['nav_url'];

        // 编辑
        if (!empty($this->paramArr['auto_id'])) {
            // 编辑数据
            $update = [
                'nav_name'    => trim($this->paramArr['nav_name']),
                'update_time' => $this->times
            ];
            // 执行更新
            $result = $this->navListDb->where(['auto_id' => $this->paramArr['auto_id']])->cache(true, null, "nav_list")->update($update);
            if (!empty($result)) {
                if (trim($this->showLang) === trim($this->adminLang)) {
                    // 默认语言才可以编辑其他信息
                    $update = [
                        // 'parent_id'   => !empty($this->paramArr['parent_id']) ? intval($this->paramArr['parent_id']) : 0,
                        // 'topid'       => !empty($this->paramArr['topid']) ? intval($this->paramArr['topid']) : 0,
                        'nav_url'     => !empty($this->paramArr['nav_url']) ? htmlspecialchars_decode($this->paramArr['nav_url']) : '',
                        'position_id' => !empty($this->paramArr['position_id']) ? intval($this->paramArr['position_id']) : 0,
                        'host_id'     => !empty($this->paramArr['host_id']) ? intval($this->paramArr['host_id']) : 0,
                        'type_id'     => !empty($this->paramArr['type_id']) ? intval($this->paramArr['type_id']) : 0,
                        'arctype_sync'=> 0,
                        'target'      => !empty($this->paramArr['target']) ? 1 : 0,
                        'nofollow'    => !empty($this->paramArr['nofollow']) ? 1 : 0,
                        'update_time' => $this->times
                    ];
                    if (!empty($update['type_id'])) $update['arctype_sync'] = 1;

                    // 更新保存导航
                    $this->navListDb->where(['nav_id' => $this->paramArr['nav_id']])->cache(true, null, "nav_list")->update($update);
                }
                return true;
            }
        }
        // 新增
        else {
            // 获取广告内容唯一ID
            $nextID = create_next_id('nav_list', 'nav_id');
            // 获取导航的顶级ID
            if (!empty($this->paramArr['parent_id'])) {
                $this->paramArr['topid'] = Db::name('nav_list')->where('nav_id', $this->paramArr['parent_id'])->value('topid');
                if (0 === intval($this->paramArr['topid'])) $this->paramArr['topid'] = $this->paramArr['parent_id'];
            }
            // 新增数据
            $insert = [
                'nav_id'      => intval($nextID),
                'nav_name'    => trim($this->paramArr['nav_name']),
                'parent_id'   => !empty($this->paramArr['parent_id']) ? intval($this->paramArr['parent_id']) : 0,
                'topid'       => !empty($this->paramArr['topid']) ? intval($this->paramArr['topid']) : 0,
                'nav_url'     => !empty($this->paramArr['nav_url']) ? htmlspecialchars_decode($this->paramArr['nav_url']) : '',
                'position_id' => !empty($this->paramArr['position_id']) ? intval($this->paramArr['position_id']) : 0,
                'host_id'     => !empty($this->paramArr['host_id']) ? intval($this->paramArr['host_id']) : 0,
                'type_id'     => !empty($this->paramArr['type_id']) ? intval($this->paramArr['type_id']) : 0,
                'arctype_sync'=> 0,
                'target'      => !empty($this->paramArr['target']) ? 1 : 0,
                'nofollow'    => !empty($this->paramArr['nofollow']) ? 1 : 0,
                'is_del'      => 0,
                'lang'        => $this->showLang,
                'add_time'    => $this->times,
                'update_time' => $this->times
            ];
            if (!empty($insert['type_id'])) $insert['arctype_sync'] = 1;

            // 获取多语言添加数据
            $insertAll = model('Language')->getMultiLanguageInsertAll($insert);
            // 执行批量新增
            if (!empty($insertAll)) {
                $result = $this->navListDb->insertAll($insertAll);
                if (!empty($result)) return true;
            }
        }

        return false;
    }

    public function getNavListBasicArr($id = 0)
    {
        $seo_rewrite_format = config('ey_config.seo_rewrite_format');
        $basicArr = [
            -1 => ['type_id' => -1, 'type_url' => '/', 'type_name' => '主页'],
            -2 => ['type_id' => -2, 'type_url' => $seo_rewrite_format==3? '/all-product/':typeurl('home/Product/alls'), 'type_name' => '全部产品'],
            -3 => ['type_id' => -3, 'type_url' => $seo_rewrite_format==3? '/all-article/':typeurl('home/Article/alls'), 'type_name' => '全部新闻'],
            -4 => ['type_id' => -4, 'type_url' => $seo_rewrite_format==3? '/all-images/':typeurl('home/Images/alls'), 'type_name' => '全部案例'],
            -5 => ['type_id' => -5, 'type_url' => '', 'type_name' => '自定义'],
        ];
        return !empty($id) ? $basicArr[$id]['type_url'] : $basicArr;
    }
}