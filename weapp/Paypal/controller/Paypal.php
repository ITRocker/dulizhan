<?php
/**
 * 易优CMS
 * ============================================================================
 * 版权所有 2016-2028 海南赞赞网络科技有限公司，并保留所有权利。
 * 网站地址: http://www.eyoucms.com
 * ----------------------------------------------------------------------------
 * 如果商业用途务必到官方购买正版授权, 以免引起不必要的法律纠纷.
 * ============================================================================
 * Author: 陈风任 <491085389@qq.com>
 * Date: 2020-05-22
 */

namespace weapp\Paypal\controller;

use think\Page;
use think\Db;
use app\common\controller\Weapp;
use weapp\Paypal\model\PaypalModel;
use weapp\Paypal\logic\PaypalLogic;

/**
 * 插件的控制器
 */
class Paypal extends Weapp
{
    /**
     * 实例化模型
     */
    private $payLogic;

    /**
     * 实例化模型
     */
    private $model;

    /**
     * 插件基本信息
     */
    private $weappInfo;

    /**
     * 构造方法
     */
    public function __construct(){
        parent::__construct();
        $this->payLogic = new PaypalLogic;
        $this->model = new PaypalModel;

        /*插件基本信息*/
        $this->weappInfo = $this->getWeappInfo();
        $this->assign('weappInfo', $this->weappInfo);
        /*--end*/
    }

    // 插件安装的前置操作
    public function beforeInstall()
    {
        // 安装前删除支付API中对应的数据
        if (!empty($this->weappInfo)) {
            $where = [
                'pay_mark' => $this->weappInfo['code'],
                'system_built' => 0
            ];
            Db::name('pay_api_config')->where($where)->delete(true);
        }
    }

    // 插件安装的后置操作
    public function afterInstall()
    {
        // 安装前添加支付API中对应的数据
        if (!empty($this->weappInfo)) {
            $PayApiData = [
                'pay_name'      => $this->weappInfo['name'],
                'pay_mark'      => $this->weappInfo['code'],
                'pay_info'      => '',
                'pay_terminal'  => '',
                'system_built'  => 0,
                'status'        => 1,
                'lang'          => $this->admin_lang,
                'add_time'      => getTime(),
                'update_time'   => getTime()
            ];
            Db::name('pay_api_config')->insert($PayApiData);
        }
    }

    // 插件卸载的后置操作
    public function afterUninstall()
    {
        // 安装前删除支付API中对应的数据
        if (!empty($this->weappInfo)) {
            $where = [
                'pay_mark' => $this->weappInfo['code'],
                'system_built' => 0
            ];
            Db::name('pay_api_config')->where($where)->delete(true);
        }
    }

    // 插件启用的后置操作
    public function afterEnable()
    {
        // 启用插件后，将支付API中对应的数据更新为开启
        if (!empty($this->weappInfo)) {
            $where = [
                'pay_mark' => $this->weappInfo['code'],
                'system_built' => 0
            ];
            $update = [
                'status' => 1,
                'update_time' => getTime()
            ];
            Db::name('pay_api_config')->where($where)->update($update);
        }
    }

    // 插件禁用的后置操作
    public function afterDisable()
    {
        // 启用插件后，将支付API中对应的数据更新为关闭
        if (!empty($this->weappInfo)) {
            $where = [
                'pay_mark' => $this->weappInfo['code'],
                'system_built' => 0
            ];
            $update = [
                'status' => 0,
                'update_time' => getTime()
            ];
            Db::name('pay_api_config')->where($where)->update($update);
        }
    }

    // 支付配置
    public function index()
    {
        if (!empty($this->weappInfo)) {
            $where = [
                'pay_mark' => $this->weappInfo['code'],
                'system_built' => 0
            ];
            $Config = Db::name('pay_api_config')->where($where)->find();
            $this->UnifyAction($Config);
        }

        return $this->fetch('index');
    }

    // 加载支付配置数据到模板
    public function UnifyAction($Config = [])
    {
        $pay_info = !empty($Config['pay_info']) ? unserialize($Config['pay_info']) : [];
        $this->assign('Config', $Config);
        $this->assign('pay_info', $pay_info);
        return $this->fetch('index');
    }

    // 保存支付配置数据
    public function UnifySaveConfigAction($post = [])
    {
        if (empty($post['pay_info']['is_open_pay'])) {
            foreach ($post['pay_info'] as $key => $val) {
                $post['pay_info'][$key] = trim($val);
            }
            // 配置信息不允许为空
            // if (empty($post['pay_info']['business'])) $this->error('请填写 Paypal 的 商户账号');
            // if (empty($post['pay_info']['client_id'])) $this->error('请填写Paypal的Client ID');
            // if (empty($post['pay_info']['secret'])) $this->error('请填写Paypal的Secret');
            // $tokenData = $this->payLogic->getAccessToken(true, $post['pay_info']);
            // if (empty($tokenData['code'])) $this->error($tokenData['msg']);
            // $post['pay_info']['token_data'] = $tokenData['token_data'];
        }

        // 保存配置
        $update['pay_info'] = serialize($post['pay_info']);
        $update['update_time'] = getTime();
        $where = [
            'pay_id' => $post['pay_id'],
            'pay_mark' => $this->weappInfo['code'],
            'system_built' => 0
        ];
        $resultID = Db::name('pay_api_config')->where($where)->update($update);

        // 返回结果
        if (!empty($resultID)) {
            $this->success('保存成功');
        } else {
            $this->error('数据错误');
        }
    }

    // 获取支付参数
    public function UnifyGetPayAction($PayInfo = [], $Order = [], $ReturnUrl = null)
    {
        return $this->payLogic->UnifyGetPayAction($PayInfo, $Order, $ReturnUrl);
    }

    // 查询订单支付状态
    public function OtherPayProcessing($PayInfo = [], $unified_number = null, $transaction_type = 1)
    {
        return $this->payLogic->OtherPayProcessing($PayInfo, $unified_number, $transaction_type);
    }
}