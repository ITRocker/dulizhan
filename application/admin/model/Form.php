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
use think\Cache;

load_trait('controller/Jump');
class Form extends Model
{
    use \traits\controller\Jump;

    public $adminLang = 'cn';

    // 初始化
    protected function initialize()
    {
        // 需要调用`Model`的`initialize`方法
        parent::initialize();
        // 时间戳
        $this->times = getTime();
        // 接收参数
        $this->paramArr = input('param.');
        // 数据表
        $this->formDb = Db::name('form');
        $this->formAttrDb = Db::name('guestbook_attribute');
        // 后台默认语言
        $this->adminLang = get_admin_lang();
        // 后台URL语言(编辑切换时使用)
        $this->showLang = input('showlang/s', $this->adminLang);
    }

    // 查询表单提交的数量
    public function GetFormListCount($form_ids = [])
    {
        // 查询条件
        $where = [
            'typeid' => ['IN', $form_ids],
            'form_type' => 1,
            'lang' => $this->adminLang,
        ];

        // 执行查询
        $form_list_count = Db::name('guestbook')
            ->field('typeid as form_id, count(aid) AS count')
            ->where($where)
            ->group('form_id')
            ->getAllWithIndex('form_id');

        // 返回结果
        return $form_list_count;
    }

    /**
     * 删除的后置操作方法
     * 自定义的一个函数 用于数据删除后做的相应处理操作, 使用时手动调用
     * @param int $aid
     */
    public function afterDel($aidArr = array())
    {
        if (is_string($aidArr)) {
            $aidArr = explode(',', $aidArr);
        }

        // 同时删除属性内容
        Db::name('guestbook_attr')->where([
                'aid'   => ['IN', $aidArr]
            ])->delete();
    }

    public function getFormList($lang = '')
    {
        $where = [
            'lang' => !empty($lang) ? $lang : $this->showLang,
        ];
        return $this->formDb->where($where)->order('form_id asc')->getAllWithIndex('form_id');
    }

    public function getFormFind($form_id = 1)
    {
        $where = [
            'form_id' => $form_id,
            'lang' => $this->showLang,
        ];
        return $this->formDb->where($where)->find();
    }

    public function saveFormData()
    {
        if (empty($this->paramArr['form_id'])) $this->error('表单ID丢失，请刷新重试~');
        // 更新保存表单数据
        $where = [
            'lang'    => $this->showLang,
            'form_id' => $this->paramArr['form_id'],
        ];
        $update = [
            'intro'       => $this->paramArr['intro'],
            'form_name'   => $this->paramArr['form_name'],
            'update_time' => $this->times,
        ];
        $resultID = $this->formDb->where($where)->cache(true, null, 'form')->update($update);
        // 后续操作
        if (!empty($resultID)) {
            // 保存表单字段信息
            if (!empty($this->paramArr['auto_id'])) {
                $saveAll = [];
                foreach ($this->paramArr['auto_id'] as $value) {
                    $saveAll[] = [
                        'auto_id' => intval($value),
                        'required' => !empty($this->paramArr['required'][$value]) ? 1 : 0,
                        'attr_name' => !empty($this->paramArr['attr_name'][$value]) ? strval($this->paramArr['attr_name'][$value]) : '',
                        'placeholder' => !empty($this->paramArr['placeholder'][$value]) ? strval($this->paramArr['placeholder'][$value]) : '',
                        'update_time' => $this->times,
                    ];
                }
                if (!empty($saveAll)) model('GuestbookAttribute')->saveAll($saveAll);
            }

            // 默认语言保存则更新其他表单是否开启开启验证码功能
            if (trim($this->showLang) === trim($this->adminLang) && $this->paramArr['open_validate'] != $this->paramArr['open_validate_old']) {
                $where = [
                    'form_id' => $this->paramArr['form_id'],
                ];
                $update = [
                    'update_time'   => $this->times,
                    'open_validate' => !empty($this->paramArr['open_validate']) ? intval($this->paramArr['open_validate']) : 0,
                ];
                $this->formDb->where($where)->cache(true, null, 'form')->update($update);
            }

            // 返回提示
            $this->success('保存成功');
        }

        $this->error('保存失败');
    }

    public function getFormAttrList($form_id = 1)
    {
        $where = [
            'form_type' => 1,
            'typeid' => $form_id,
            'lang' => $this->showLang,
        ];
        return $this->formAttrDb->where($where)->order('sort_order asc, auto_id asc')->select();
    }

    public function getFormAttrFind($attr_id = 1)
    {
        $where = [
            'form_type' => 1,
            'attr_id' => $attr_id,
            'lang' => $this->showLang,
        ];
        return $this->formAttrDb->where($where)->find();
    }

    public function saveFormAttrData()
    {
        if (empty($this->paramArr['auto_id']) || empty($this->paramArr['attr_id'])) $this->error('表单字段ID丢失，请刷新重试~');
        // 更新保存表单字段数据
        $where = [
            'auto_id' => $this->paramArr['auto_id'],
        ];
        $update = [
            'attr_name'   => $this->paramArr['attr_name'],
            'placeholder' => $this->paramArr['placeholder'],
            'update_time' => $this->times,
        ];
        $resultID = $this->formAttrDb->where($where)->cache(true, null, 'guestbook_attribute')->update($update);
        // 后续操作
        if (!empty($resultID)) {
            // 默认语言保存则更新其他表单字段是否开启前台必填功能
            if (trim($this->showLang) === trim($this->adminLang) && $this->paramArr['required'] != $this->paramArr['required_old']) {
                $where = [
                    'attr_id' => $this->paramArr['attr_id'],
                ];
                $update = [
                    'required'    => !empty($this->paramArr['required']) ? intval($this->paramArr['required']) : 0,
                    'update_time' => $this->times,
                ];
                $this->formAttrDb->where($where)->cache(true, null, 'guestbook_attribute')->update($update);
            }

            // 返回提示
            $this->success('保存成功');
        }

        $this->error('保存失败');
    }
}