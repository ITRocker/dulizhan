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
 * 单页编辑
 */
class TagUisingle extends Base
{
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
    }

    /**
     * 单页编辑
     * @author wengxianhu by 2018-4-20
     */
    public function getUisingle($typeid = '', $aid = '', $e_id = '', $e_page = '')
    {
        $aid = preg_replace('/([^0-9]*)/i', '', $aid);
        $typeid = preg_replace('/([^0-9]*)/i', '', $typeid);

        if (empty($e_id) || empty($e_page)) {
            echo '标签uisingle报错：缺少属性 e-id | e-page 。';
            return false;
        }

        $result = false;
        $inc = get_ui_inc_params($e_page, self::$home_lang);
        $inckey = self::$home_lang."_single_{$e_id}";
        if (empty($inc[$inckey])) {
            $inckey = "single_{$e_id}"; // 兼容v1.2.1之前的数据
        }

        $info = false;
        if ($inc && !empty($inc[$inckey])) {
            $data = json_decode($inc[$inckey], true);
            $info = $data['info'];
        } else {
            $info['aid'] = $aid;
            $info['typeid'] = $typeid;
        }

        // 兼容v2.0.1版本或以下低版本的 single 标签，因为 single 标签早期可以传属性aid，现定typeid优先级高于属性aid
        if (empty($info['typeid']) && !empty($info['aid'])) {
            $info['typeid'] = $this->get_aid_typeid($info['aid']);
        }

        $result = array(
            'info'  => $info,
        );

        return $result;
    }
}