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

namespace think\template\taglib\zan;

/**
 * 栏目编辑
 */
class TagUitype extends Base
{
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
    }

    /**
     * 栏目编辑
     * @author wengxianhu by 2018-4-20
     */
    public function getUitype($modelid = '', $typeid = '', $e_id = '', $e_page = '')
    {
        $typeid = preg_replace('/([^0-9]*)/i', '', $typeid);
        $modelid = preg_replace('/([^0-9]*)/i', '', $modelid);

        if (empty($e_id) || empty($e_page)) {
            echo '标签uitype报错：缺少属性 e-id | e-page 。';
            return false;
        }

        $result = false;
        $inc = get_ui_inc_params($e_page, self::$home_lang);
        $inckey = self::$home_lang."_type_{$e_id}";
        if (empty($inc[$inckey])) {
            $inckey = "type_{$e_id}"; // 兼容v1.2.1之前的数据
        }

        $info = false;
        if ($inc && !empty($inc[$inckey])) {
            $data = json_decode($inc[$inckey], true);
            $info = $data['info'];
        } else {
            $info['typeid'] = $typeid;
            $info['modelid'] = $modelid;
        }

        // 兼容 type 标签，因为 type 标签的属性modelid优先级高于属性typeid
        if (!empty($info['typeid'])) {
            $info['modelid'] = '';
        } else {
            $info['typeid'] = '';
        }

        $result = array(
            'info'  => $info,
        );

        return $result;
    }
}