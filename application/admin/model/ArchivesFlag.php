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
 * 文档属性
 */
class ArchivesFlag extends Model
{
    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
    }

    /**
     * 获取启用的文档属性列表
     * @return [type] [description]
     */
    public function getList($where = [])
    {
    	if (empty($where)) {
    		$where['status'] = ['gt', 0];
    	}
        $result = Db::name('archives_flag')->where($where)
        	->order("sort_order asc, id asc")
        	->cache(true, EYOUCMS_CACHE_TIME, 'archives_flag')
        	->select();

        return $result;
    }
}