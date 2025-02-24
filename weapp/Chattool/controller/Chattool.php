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
 * Date: 2018-06-28
 */

namespace weapp\Chattool\controller;

use think\Db;
use app\common\controller\Weapp;
use weapp\Chattool\model\ChattoolModel;

/**
 * 插件的控制器
 */
class Chattool extends Weapp
{

    /**
     * 实例化模型
     */
    private $model;

    /**
     * 插件基本信息
     */
    private $weappInfo;

    private $scan_url = '/weapp/Chattool/template/skin/images/weixin.jpg';

    /**
     * 构造方法
     */
    public function __construct()
    {
        parent::__construct();
        $this->model = new ChattoolModel;

        /*插件基本信息*/
        $this->weappInfo = $this->getWeappInfo();
        $this->assign('weappInfo', $this->weappInfo);
        /*--end*/
    }

    /**
     * 插件使用指南
     */
    public function doc()
    {
        return $this->fetch('doc');
    }

    /**
     * 插件前台展示 - show钩子方法
     * @param  mixed $params 传入的参数
     */
    public function show($params = null)
    {
        $Chattool = $this->model->getWeappData();
        $this->assign('Chattool', $Chattool);
        echo $this->fetch('show');
    }

    /**
     * 插件后台管理 - 列表
     */
    public function index()
    {
        $Chattool = $this->model->getWeappData();

        /*同时拥有本地上传与远程URL的逻辑处理*/
        if (empty($Chattool['data'])) {
            $Chattool['data'] = [];
        }
        if (isset($Chattool['data']['wechat_logo']) && is_http_url($Chattool['data']['wechat_logo'])) {
            $Chattool['data']['is_remote'] = 1;
            $Chattool['data']['wechat_logo_remote'] = !empty($Chattool['data']['wechat_logo']) ? $Chattool['data']['wechat_logo'] : '';
        } else {
            $Chattool['data']['is_remote'] = 0;
            $Chattool['data']['wechat_logo_local'] = !empty($Chattool['data']['wechat_logo']) ? $Chattool['data']['wechat_logo'] : '/weapp/Chattool/template/skin/images/weixin.jpg';
        }
        /*--end*/

        $this->assign('Chattool', $Chattool);
        return $this->fetch('index');
    }

    /**
     * 插件后台管理 - 编辑
     */
    public function save()
    {
        if (IS_POST) {
            $data = I('post.');
            if (!empty($data['code'])) {

                /*处理LOGO的本地上传与远程*/
                $is_remote = !empty($data['is_remote']) ? $data['is_remote'] : 0;
                $wechat_logo = '';
                if ($is_remote == 1) {
                    $wechat_logo = $data['wechat_logo_remote']; // 远程链接
                } else {
                    $wechat_logo = $data['wechat_logo_local']; // 本地上传链接
                }
                $data['wechat_logo'] = $wechat_logo;
                /*--end*/
                
                $saveData = array(
                    'data' => serialize($data),
                    'tag_weapp' => $data['tag_weapp'],
                    'update_time' => getTime(),
                );
                $r = Db::name('weapp')->where(array('code' => $data['code']))->update($saveData);
                if ($r) {
                    adminLog('编辑' . $this->weappInfo['name'] . '成功'); // 写入操作日志
                    $this->success("操作成功!", weapp_url('Chattool/Chattool/index'));
                }
            }
        }
        $this->error("操作失败");
    }
}