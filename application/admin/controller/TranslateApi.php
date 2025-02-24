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

namespace app\admin\controller;

use think\Db;
use think\Cache;
use think\Cookie;

use app\admin\logic\TranslateApiLogic;

/**
 * 翻译API管理
 */
class TranslateApi extends Base
{

    public $stringTagsArr = [];
    public $contentImagesArr = [];
    public $contentEyMImagesArr = [];
    /**
     * 构造方法
     */
    public function __construct()
    {
        parent::__construct();

        // 豆包翻译API配置
        $this->doubao = tpSetting('doubao', [], $this->show_lang);
        // 业务处理
        $this->translateApiLogic = new TranslateApiLogic($this->doubao, $this->admin_lang);
        $functionLogic = new \app\common\logic\FunctionLogic;
        $functionLogic->validate_authorfile(1);
    }

    // 首页
    public function index()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            if (!empty($post['doubao'])) {
                if (!empty($post['doubao']['doubao_api'])) {
                    if (empty($post['doubao']['doubao_access_key_id'])) $this->error('请填写Access Key ID');
                    if (empty($post['doubao']['doubao_secret_access_key'])) $this->error('请填写Secret Access Key');
                }

                $langRow = Db::name('language')->order('id asc')->cache(true, EYOUCMS_CACHE_TIME, 'language')->select();
                foreach ($langRow as $val) {
                    tpSetting('doubao', $post['doubao'], $val['mark']);
                }
            }

            $this->success('操作成功');
        }

        $this->assign('doubao', $this->doubao);
        return $this->fetch();
    }

    public function batchTranslateAction()
    {
        $resultInt = 0;
        $post = input('post.');
        // 文档分类批量翻译
        if (!empty($post['tidArr'])) {
            foreach ($post['tidArr'] as $value) {
                $post['tid'] = intval($value);
                $resultInt = $this->executeTranslate($post, true);
            }
        }
        // 文档内容批量翻译
        else if (!empty($post['aidArr'])) {
            foreach ($post['aidArr'] as $value) {
                $post['aid'] = intval($value);
                $resultInt = $this->executeTranslate($post, true);
            }
        }
        // 导航列表批量翻译
        else if (!empty($post['navIdArr'])) {
            foreach ($post['navIdArr'] as $value) {
                $post['nav_id'] = intval($value);
                $resultInt = $this->executeTranslate($post, true);
            }
        }

        // 延迟1秒返回
        // sleep(1);
        if (!empty($resultInt)) {
            $this->success('翻译成功', null, ['code' => 1, 'msg' => '翻译成功，请切换语言查看内容']);
        } else {
            $this->success('翻译失败', null, ['code' => 0, 'msg' => '内容更新失败，请再次翻译该语言内容']);
        }
    }

    public function batchTranslate()
    {
        if (IS_AJAX_POST) {
            /*$resultInt = true;
            // 延迟1秒返回
            sleep(1);
            if (!empty($resultInt)) {
                $this->success('翻译成功', null, ['code' => 1]);
            } else {
                $this->success('翻译失败', null, ['code' => 0]);
            }
            exit;*/

            $resultInt = 0;
            $post = input('post.');
            if ((!empty($post['tidArr']) && empty($post['tid'])) || (!empty($post['aidArr']) && empty($post['aid'])) || (!empty($post['navIdArr']))) {
                $this->batchTranslateAction();
            } else {
                $resultInt = $this->executeTranslate($post);
            }

            // 延迟1秒返回
            // sleep(1);
            if (!empty($resultInt)) {
                $this->success('翻译成功', null, ['code' => 1, 'msg' => '翻译成功，请切换语言查看内容']);
            } else {
                $this->success('翻译失败', null, ['code' => 0, 'msg' => '内容更新失败，请再次翻译该语言内容']);
            }
        }

        // 查询翻译语言
        $langStr = input('langStr/s', '');
        $langArr = !empty($langStr) ? explode(',', $langStr) : [];
        $where = [
            'mark' => ['IN', $langArr]
        ];
        $markList = Db::name('language_mark')->where($where)->select();
        $this->assign('markList', $markList);

        return $this->fetch('translate');
    }

    public function executeTranslate($post = [], $cover = false)
    {
        // 设置API逻辑参数
        $this->translateApiLogic->setApiLogicParam($post, $cover);

        // 获取 [设置]-[系统设置]-[基础设置] 要翻译的内容
        if (!empty($post['table']) && 'config' == trim($post['table'])) {
            $this->translateApiLogic->getConfigTranslateArr();
        }
        // 获取 [设置]-[系统设置]-[自定义变量] 要翻译的内容
        else if (!empty($post['table']) && 'config_attribute' == trim($post['table'])) {
            $this->translateApiLogic->getConfigAttributeTranslateArr();
        }
        // 获取 [设置]-[系统设置]-[网站语言]-[语言变量] 要翻译的内容
        else if (!empty($post['table']) && 'language_pack' == trim($post['table'])) {
            $this->translateApiLogic->getLanguagePackTranslateArr();
        }
        // 获取 [网站]-[网站设置]-[导航管理] 要翻译的内容
        else if (!empty($post['table']) && 'nav_list' == trim($post['table'])) {
            $this->translateApiLogic->getNavListTranslateArr();
        }
        // 获取 文档分类 要翻译的内容
        else if (!empty($post['table']) && 'arctype' == trim($post['table'])) {
            $this->translateApiLogic->getArctypeTranslateArr();
        }
        // 获取 留言表单字段 要翻译的内容
        else if (!empty($post['table']) && 'guestbook_attribute' == trim($post['table'])) {
            $this->translateApiLogic->getGuestbookAttrTranslateArr();
        }
        // 获取 常见问题 要翻译的内容
        else if (!empty($post['table']) && 'faq_asklist' == trim($post['table'])) {
            $this->translateApiLogic->getFaqAsklistTranslateArr();
        }
        // 获取 文档 要翻译的内容
        else if (!empty($post['aid'])) {
            $this->translateApiLogic->getArchivesTranslateArr();
        }

        // 执行翻译
        $this->translateApiLogic->executeTranslate();

        $resultInt = 0;
        // 保存 [设置]-[系统设置]-[基础设置] 翻译的内容
        if (!empty($post['table']) && 'config' == trim($post['table'])) {
            $resultInt = $this->translateApiLogic->saveConfigTranslateArr();
        }
        // 保存 [设置]-[系统设置]-[自定义变量] 翻译的内容
        else if (!empty($post['table']) && 'config_attribute' == trim($post['table'])) {
            $resultInt = $this->translateApiLogic->saveConfigAttributeTranslateArr();
        }
        // 保存 [设置]-[系统设置]-[网站语言]-[语言变量] 翻译的内容
        else if (!empty($post['table']) && 'language_pack' == trim($post['table'])) {
            $resultInt = $this->translateApiLogic->saveLanguagePackTranslateArr();
        }
        // 保存 [网站]-[网站设置]-[导航管理] 翻译的内容
        else if (!empty($post['table']) && 'nav_list' == trim($post['table'])) {
            $resultInt = $this->translateApiLogic->saveNavListTranslateArr();
        }
        // 保存 文档分类 翻译的内容
        else if (!empty($post['table']) && 'arctype' == trim($post['table'])) {
            $resultInt = $this->translateApiLogic->saveArctypeTranslateArr();
        }
        // 保存 留言表单字段 翻译的内容
        else if (!empty($post['table']) && 'guestbook_attribute' == trim($post['table'])) {
            $resultInt = $this->translateApiLogic->saveGuestbookAttrTranslateArr();
        }
        // 保存 常见问题 要翻译的内容
        else if (!empty($post['table']) && 'faq_asklist' == trim($post['table'])) {
            $resultInt = $this->translateApiLogic->saveFaqAsklistTranslateArr();
        }
        // 保存 文档 要翻译的内容
        else if (!empty($post['aid'])) {
            $resultInt = $this->translateApiLogic->saveArchivesTranslateArr();
        }
        return $resultInt;
    }
}