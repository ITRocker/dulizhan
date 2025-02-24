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
 * 图集图片
 */
class ImagesUpload extends Model
{
    //初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        // 当前时间戳
        $this->times = getTime();
    }

    /**
     * 获取单条图集的所有图片
     * @author 小虎哥 by 2018-4-3
     */
    public function getImagesUpload($aid, $field = '*')
    {
        // 查询产品图集主表
        $where = [
            'aid' => intval($aid),
        ];
        $result = Db::name('images_upload')->field($field)->where($where)->order('sort_order asc')->select();
        foreach ($result as $key => $value) {
            // 图片处理
            if (isset($value['image_url'])) $value['image_url'] = handle_subdir_pic($value['image_url']);
            // 覆盖原数据
            $result[$key] = $value;
        }
        return $result;
    }

    /**
     * 删除单条图集的所有图片
     * @author 小虎哥 by 2018-4-3
     */
    public function delImagesUpload($aid = [])
    {
        if (!is_array($aid)) $aid = array($aid);
        $where = [
            'aid' => ['IN', $aid]
        ];
        return Db::name('images_upload')->where($where)->delete(true);
    }

    /**
     * 保存图集图片
     * @author 小虎哥 by 2018-4-3
     */
    public function saveImagesUpload($post = [])
    {
        $imgupload = isset($post['imgupload']) ? $post['imgupload'] : [];

        // 删除产品原来的图片
        if (!empty($post['aid'])) $this->delImagesUpload($post['aid']);

        // 添加图片
        if (!empty($imgupload) && count($imgupload) > 1) {
            // 弹出最后一个
            array_pop($imgupload);

            $insertAll = [];
            $sort_order = 0;
            foreach($imgupload as $key => $val) {
                if ($val == null || empty($val)) continue;

                $img_info = [];
                $filesize = 0;
                if (is_http_url($val)) {
                    $imgurl = handle_subdir_pic($val);
                } else {
                    $imgurl = ROOT_PATH.ltrim($val, '/');
                    $img_info = @getimagesize($imgurl);
                    $filesize = @filesize('.' . $val);
                }
                $insertAll[] = [
                    'aid'         => intval($post['aid']),
                    'title'       => !empty($post['title']) ? trim($post['title']) : '',
                    'image_url'   => $val,
                    'intro'       => !empty($imgintro[$key]) ? trim($imgintro[$key]) : '',
                    'width'       => isset($img_info[0]) ? intval($img_info[0]) : 0,
                    'height'      => isset($img_info[1]) ? intval($img_info[1]) : 0,
                    'filesize'    => $filesize,
                    'mime'        => isset($img_info['mime']) ? trim($img_info['mime']) : '',
                    'sort_order'  => ++$sort_order,
                    'add_time'    => $this->times,
                    'update_time' => $this->times,
                ];
            }

            // 新增图片集
            if (!empty($insertAll)) Db::name('images_upload')->insertAll($insertAll);

            // 删除缩略图
            delFile(UPLOAD_PATH . "images/thumb/" . $post['aid']);
        }
    }
}