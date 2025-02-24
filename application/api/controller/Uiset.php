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

namespace app\api\controller;

use think\Controller;
use think\Db;
// use think\Session;

class Uiset extends Controller
{
    public $uipath = '';
    public $theme_style = '';
    public $theme_style_path = '';
    public $v = '';
    private $urltypeid = 0;
    private $urlaid = 0;
    private $idcode = '';
    private $languageList = [];

    /**
     * 析构函数
     */
    function __construct() 
    {
        header("Cache-control: private");  // history.back返回后输入框值丢失问题
        parent::__construct();
        $this->theme_style = THEME_STYLE;
        $this->theme_style_path = THEME_STYLE_PATH;
        $this->uipath = RUNTIME_PATH.'ui/'.$this->theme_style_path.'/';
        // if (!file_exists(ROOT_PATH.'template/'.TPL_THEME.'pc/uiset.txt') && !file_exists(ROOT_PATH.'template/'.TPL_THEME.'mobile/uiset.txt')) {
        //     abort(404,'页面不存在');
        // }
    }
    
    /*
     * 初始化操作
     */
    public function _initialize() 
    {
        //过滤不需要登陆的行为
        $ctl_act = CONTROLLER_NAME.'@'.ACTION_NAME;
        $ctl_all = CONTROLLER_NAME.'@*';
        $filter_login_action = config('filter_login_action');
        if (in_array($ctl_act, $filter_login_action) || in_array($ctl_all, $filter_login_action)) {
            //return;
        }else{
            if(!session('?admin_id')){
                $this->error('请先登录后台！');
                exit;
            }
        }

        /*电脑版与手机版的切换*/
        $this->v = input('param.v/s', '');
        $this->v = trim($this->v, '/');
        $this->assign('v', $this->v);
        /*--end*/

        // 语言列表，当前语言排在第一位
        $languageRow = Db::name('language')->alias('a')
            ->field('a.title,a.mark,b.cn_title')
            ->join('language_mark b', 'a.mark = b.mark', 'left')
            ->order('a.is_home_default desc, a.sort_order asc, a.id asc')
            ->getAllWithIndex('mark');
        $this->languageList[] = $languageRow[$this->home_lang];
        foreach ($languageRow as $key => $val) {
            if ($val['mark'] != $this->home_lang) {
                $this->languageList[] = $val;
            }
        }
        $this->assign('languageList', $this->languageList);

        // 豆包翻译API配置
        $doubao = tpSetting('doubao', [], $this->home_lang);
        $this->assign('doubao', $doubao);

        $this->idcode = input('param.idcode/s');
        $this->urltypeid = input('param.urltypeid/d');
        $this->urlaid = input('param.urlaid/d');
        if (!empty($this->urlaid)) {
            $this->idcode = md5("{$this->v}_view_{$this->urlaid}");
        } else if (!empty($this->urltypeid)) {
            $this->idcode = md5("{$this->v}_lists_{$this->urltypeid}");
        }
    }

    public function submit()
    {
        if (is_adminlogin()) {

            if (!check_template_uiset()) {
                $this->error('不存在的可编辑区域');
            }

            $post = input('post.');
            $type = $post['type'];
            $id = $post['id'];
            $page = $post['page'];
            $content = isset($post['content']) ? $post['content'] : '';

            // 同步外观调试的变量值到config，前提是变量名在config是存在
            $this->synConfigVars($id, $content, $type);

            switch ($type) {
                case 'text':
                    $this->textHandle($id, $page, $post);
                    break;
                    
                case 'html':
                    $this->htmlHandle($id, $page, $post);
                    break;
                    
                case 'type':
                    $this->typeHandle($id, $page, $post);
                    break;
                    
                case 'arclist':
                    $this->arclistHandle($id, $page, $post);
                    break;
                    
                case 'channel':
                    $this->channelHandle($id, $page, $post);
                    break;
                    
                case 'upload':
                    $this->uploadHandle($id, $page, $post);
                    break;
                    
                case 'map':
                    $this->mapHandle($id, $page, $post);
                    break;
                    
                case 'code':
                    $this->codeHandle($id, $page, $post);
                    break;
                    
                case 'background':
                    $this->backgroundHandle($id, $page, $post);
                    break;
                    
                case 'single':
                    $this->singleHandle($id, $page, $post);
                    break;

                default:
                    $this->error('不存在的可编辑区域');
                    exit;
                    break;
            }

        }

        $this->error('请先登录后台！');
        exit;
    }

    /**
     * 同步外观调试的变量值到config，前提是变量名在config是存在
     */
    private function synConfigVars($name, $value = '', $type = '')
    {
        if (in_array($type, array('text', 'html')) && !in_array($name, ['image_type','file_type','media_type'])) {
            $count = M('config')->where([
                'name'  => $name,
                'lang'  => $this->home_lang,
            ])->count('id');
            if ($count > 0) {
                if ($name == binaryJoinChar(config('binary.0'), 13)) {
                    $value = preg_replace('#<a([^>]*)>(\s*)'.binaryJoinChar(config('binary.1'), 18).'<(\s*)\/a>#i', '', htmlspecialchars_decode($value));
                    $value = htmlspecialchars($value);
                }
                $nameArr = explode('_', $name);
                M('config')->where([
                    'name'  => $name,
                    'lang'  => $this->home_lang,
                ])->cache(true,EYOUCMS_CACHE_TIME,'config')->update(array('value'=>$value));

                /*多语言*/
                $langRow = Db::name('language')->order('id asc')->select();
                foreach ($langRow as $key => $val) {
                    tpCache($nameArr[0], [$name=>$value], $val['mark']);
                }
                /*--end*/

                $this->success('操作成功，数据已保存');
                exit;
            }  
        }
    }

    /**
     * 纯文本编辑
     */
    public function text($id, $page)
    {
        $type = 'text';
        $id = input('param.id/s');
        $page = input('param.page/s');
        $lang = input('param.lang/s', $this->home_lang);
        $info = array();
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $inc = ui_read_bidden_inc($filenameArr);
        if (!empty($inc)) {
            foreach ($this->languageList as $key => $val) {
                $inckey = "{$val['mark']}_{$type}_{$id}";
                if (!empty($inc[$val['mark']][$inckey])) {
                    $data = json_decode($inc[$val['mark']][$inckey], true);
                    $info[$val['mark']] = $data['info'];
                    // $type = $data['type'];
                }
            }
        }

        $assign = array(
            'id'    => $id,
            'type'  => $type,
            'page'  => $page,
            'info'   => $info,
            'lang'  => $lang,
            'idcode' => $this->idcode,
        );
        $this->assign('field', $assign);

        $iframe = input('param.iframe/d');
        if ($iframe == 1) {
            $viewfile = 'text_m';
        } else {
            $viewfile = 'text';
        }

        return $this->fetch($viewfile);
    }

    /**
     * 纯文本编辑处理
     */
    private function textHandle($id, $page, $post = array())
    {
        $type = 'text';
        // $lang = $post['lang'];
        $content = !empty($post['content']) ? $post['content'] : [];
        $dataArr = [];
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $arr = array(
                "{$val['mark']}_{$type}_{$id}" => json_encode(array(
                    'id'    => $id,
                    'type'  => $type,
                    'page'  => $page,
                    'lang'  => $val['mark'],
                    'idcode' => $this->idcode,
                    'info'   => array(
                        'value'    => empty($content[$val['mark']]) ? '' : $content[$val['mark']],
                    ),
                )),
            );
            $dataArr[$val['mark']] = $arr;
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $redata = ui_write_bidden_inc($dataArr, $filenameArr, true);
        if (!empty($redata['code'])) {
            $this->success('操作成功，数据已保存');
            exit;
        } else {
            $msg = empty($redata['msg']) ? '写入失败' : $redata['msg'];
            $this->error($msg);
            exit;
        }
    }

    /**
     * 带html的富文本处理
     */
    public function html($id, $page)
    {
        $type = 'html';
        $id = input('param.id/s');
        $page = input('param.page/s');
        $lang = input('param.lang/s', $this->home_lang);
        $info = array();
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $inc = ui_read_bidden_inc($filenameArr);
        if (!empty($inc)) {
            foreach ($this->languageList as $key => $val) {
                $inckey = "{$val['mark']}_{$type}_{$id}";
                if (!empty($inc[$val['mark']][$inckey])) {
                    $data = json_decode($inc[$val['mark']][$inckey], true);
                    $info[$val['mark']] = $data['info'];
                    // $type = $data['type'];
                }
            }
        }

        $assign = array(
            'id'    => $id,
            'type'  => $type,
            'page'  => $page,
            'info'   => $info,
            'lang'  => $lang,
            'idcode' => $this->idcode,
        );
        $this->assign('field', $assign);

        $iframe = input('param.iframe/d');
        if ($iframe == 1) {
            $viewfile = 'html_m';
        } else {
            $viewfile = 'html';
        }

        return $this->fetch($viewfile);
    }

    /**
     * 富文本编辑器处理
     */
    private function htmlHandle($id, $page, $post = array())
    {
        $type = 'html';
        // $lang = $post['lang'];
        $content = !empty($post['content']) ? $post['content'] : [];
        $dataArr = [];
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $arr = array(
                "{$val['mark']}_{$type}_{$id}" => json_encode(array(
                    'id'    => $id,
                    'type'  => $type,
                    'page'  => $page,
                    'lang'  => $val['mark'],
                    'idcode' => $this->idcode,
                    'info'   => array(
                        'value'    => empty($content[$val['mark']]) ? '' : $content[$val['mark']],
                    ),
                )),
            );
            $dataArr[$val['mark']] = $arr;
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $redata = ui_write_bidden_inc($dataArr, $filenameArr, true);
        if (!empty($redata['code'])) {
            $this->success('操作成功，数据已保存');
            exit;
        } else {
            $msg = empty($redata['msg']) ? '写入失败' : $redata['msg'];
            $this->error($msg);
            exit;
        }
    }

    /**
     * 分类编辑
     */
    public function type($id, $page)
    {
        $type = 'type';
        $id = input('param.id/s');
        $page = input('param.page/s');
        $lang = input('param.lang/s', $this->home_lang);
        $typeid = 0;
        $modelid = 0;
        $info = array();
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $inc = ui_read_bidden_inc($filenameArr);
        if (!empty($inc)) {
            foreach ($this->languageList as $key => $val) {
                $inckey = "{$val['mark']}_{$type}_{$id}";
                if (!empty($inc[$val['mark']][$inckey])) {
                    $data = json_decode($inc[$val['mark']][$inckey], true);
                    $typeid = $data['typeid'];
                    $modelid = $data['modelid'];
                    $info[$val['mark']] = $data['info'];
                    // $type = $data['type'];
                }
            }
        }

        // 模型的全部分类
        $allow_release_channel = config('global.allow_release_channel');
        $channeltypeList = model('Channeltype')->getAll('*', ['id'=>['IN', $allow_release_channel], 'status'=>1]);
        foreach ($channeltypeList as $key => $val) {
            if (1 == $val['id']) {
                $val['all_title'] = lang('crumb49', [], $lang);
            } else if (2 == $val['id']) {
                $val['all_title'] = lang('crumb48', [], $lang);
            } else if (3 == $val['id']) {
                $val['all_title'] = lang('crumb57', [], $lang);
            } else {
                $val['all_title'] = lang('sys51', [], $lang);
            }
            $channeltypeList[$key] = $val;
        }
        $this->assign('channeltypeList', $channeltypeList);

        $assign = array(
            'id'    => $id,
            'type'  => $type,
            'page'  => $page,
            'typeid'   => $typeid,
            'modelid'   => $modelid,
            'info'  => $info,
            'lang'  => $lang,
            'idcode' => $this->idcode,
        );
        $this->assign('field', $assign);

        $iframe = input('param.iframe/d');
        if ($iframe == 1) {
            $viewfile = 'type_m';
        } else {
            $viewfile = 'type';
        }

        return $this->fetch($viewfile);
    }

    /**
     * 分类编辑处理
     */
    private function typeHandle($id, $page, $post = array())
    {
        $type = 'type';
        // $lang = $post['lang'];
        $dataArr = [];
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $arr = array(
                "{$val['mark']}_{$type}_{$id}" => json_encode(array(
                    'id'    => $id,
                    'type'  => $type,
                    'page'  => $page,
                    'typeid' => preg_replace('/([^0-9]*)/i', '', $post['typeid']),
                    'modelid' => preg_replace('/([^0-9]*)/i', '', $post['modelid']),
                    'lang'  => $val['mark'],
                    'idcode' => $this->idcode,
                    'info'   => $post,
                )),
            );
            $dataArr[$val['mark']] = $arr;
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $redata = ui_write_bidden_inc($dataArr, $filenameArr, true);
        if (!empty($redata['code'])) {
            $this->success('操作成功，数据已保存');
            exit;
        } else {
            $msg = empty($redata['msg']) ? '写入失败' : $redata['msg'];
            $this->error($msg);
            exit;
        }
    }

    /**
     * 分类文章编辑
     */
    public function arclist($id, $page)
    {
        $type = 'arclist';
        $id = input('param.id/s');
        $page = input('param.page/s');
        $lang = input('param.lang/s', $this->home_lang);
        $typeid = 0;
        $modelid = 0;
        $info = array();
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $inc = ui_read_bidden_inc($filenameArr);
        if (!empty($inc)) {
            foreach ($this->languageList as $key => $val) {
                $inckey = "{$val['mark']}_{$type}_{$id}";
                if (!empty($inc[$val['mark']][$inckey])) {
                    $data = json_decode($inc[$val['mark']][$inckey], true);
                    $typeid = $data['typeid'];
                    $modelid = $data['modelid'];
                    $info[$val['mark']] = $data['info'];
                    // $type = $data['type'];
                }
            }
        }

        // 模型的全部分类
        $allow_release_channel = config('global.allow_release_channel');
        $channeltypeList = model('Channeltype')->getAll('*', ['id'=>['IN', $allow_release_channel], 'status'=>1]);
        foreach ($channeltypeList as $key => $val) {
            if (1 == $val['id']) {
                $val['all_title'] = lang('crumb49', [], $lang);
            } else if (2 == $val['id']) {
                $val['all_title'] = lang('crumb48', [], $lang);
            } else if (3 == $val['id']) {
                $val['all_title'] = lang('crumb57', [], $lang);
            } else {
                $val['all_title'] = lang('sys51', [], $lang);
            }
            $channeltypeList[$key] = $val;
        }
        $this->assign('channeltypeList', $channeltypeList);

        /*不允许发布文档的模型ID，用于JS判断*/
        $allow_release_channel = config('global.allow_release_channel');
        $js_allow_channel_arr = '[';
        foreach ($allow_release_channel as $key => $val) {
            if ($key > 0) {
                $js_allow_channel_arr .= ',';
            }
            $js_allow_channel_arr .= $val;
        }
        $js_allow_channel_arr = $js_allow_channel_arr.']';
        $this->assign('js_allow_channel_arr', $js_allow_channel_arr);
        /*--end*/

        $assign = array(
            'id'    => $id,
            'type'  => $type,
            'page'  => $page,
            'typeid'   => $typeid,
            'modelid'   => $modelid,
            'info'  => $info,
            'lang'  => $lang,
            'idcode' => $this->idcode,
        );
        $this->assign('field', $assign);

        $iframe = input('param.iframe/d');
        if ($iframe == 1) {
            $viewfile = 'arclist_m';
        } else {
            $viewfile = 'arclist';
        }

        return $this->fetch($viewfile);
    }

    /**
     * 分类文章编辑处理
     */
    private function arclistHandle($id, $page, $post = array())
    {
        $type = 'arclist';
        // $lang = $post['lang'];
        $dataArr = [];
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $arr = array(
                "{$val['mark']}_{$type}_{$id}" => json_encode(array(
                    'id'    => $id,
                    'type'  => $type,
                    'page'  => $page,
                    'typeid' => preg_replace('/([^0-9]*)/i', '', $post['typeid']),
                    'modelid' => preg_replace('/([^0-9]*)/i', '', $post['modelid']),
                    'lang'  => $val['mark'],
                    'idcode' => $this->idcode,
                    'info'   => $post,
                )),
            );
            $dataArr[$val['mark']] = $arr;
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $redata = ui_write_bidden_inc($dataArr, $filenameArr, true);
        if (!empty($redata['code'])) {
            $this->success('操作成功，数据已保存');
            exit;
        } else {
            $msg = empty($redata['msg']) ? '写入失败' : $redata['msg'];
            $this->error($msg);
            exit;
        }
    }

    /**
     * 分类列表编辑
     */
    public function channel($id, $page)
    {
        $type = 'channel';
        $id = input('param.id/s');
        $page = input('param.page/s');
        $lang = input('param.lang/s', $this->home_lang);
        $typeid = 0;
        $info = array();
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $inc = ui_read_bidden_inc($filenameArr);
        if (!empty($inc)) {
            foreach ($this->languageList as $key => $val) {
                $inckey = "{$val['mark']}_{$type}_{$id}";
                if (!empty($inc[$val['mark']][$inckey])) {
                    $data = json_decode($inc[$val['mark']][$inckey], true);
                    $typeid = $data['typeid'];
                    $info[$val['mark']] = $data['info'];
                    // $type = $data['type'];
                }
            }
        }

        /*所有分类列表*/
        $map = array(
            'is_del'    => 0, // 回收站功能
            'status'   => 1,
        );
        $arctype_html = model('Arctype')->getList(0, $typeid, true, $map);
        $this->assign('arctype_html', $arctype_html);
        /*--end*/

        $assign = array(
            'id'    => $id,
            'type'  => $type,
            'page'  => $page,
            'typeid'   => $typeid,
            'info'  => $info,
            'lang'  => $lang,
            'idcode' => $this->idcode,
        );
        $this->assign('field', $assign);

        $iframe = input('param.iframe/d');
        if ($iframe == 1) {
            $viewfile = 'channel_m';
        } else {
            $viewfile = 'channel';
        }

        return $this->fetch($viewfile);
    }

    /**
     * 分类列表编辑处理
     */
    private function channelHandle($id, $page, $post = array())
    {
        $type = 'channel';
        // $lang = $post['lang'];
        $dataArr = [];
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $arr = array(
                "{$val['mark']}_{$type}_{$id}" => json_encode(array(
                    'id'    => $id,
                    'type'  => $type,
                    'page'  => $page,
                    'typeid' => preg_replace('/([^0-9]*)/i', '', $post['typeid']),
                    'lang'  => $val['mark'],
                    'idcode' => $this->idcode,
                    'info'   => $post,
                )),
            );
            $dataArr[$val['mark']] = $arr;
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $redata = ui_write_bidden_inc($dataArr, $filenameArr, true);
        if (!empty($redata['code'])) {
            $this->success('操作成功，数据已保存');
            exit;
        } else {
            $msg = empty($redata['msg']) ? '写入失败' : $redata['msg'];
            $this->error($msg);
            exit;
        }
    }

    /**
     * 图片编辑
     */
    public function upload($id, $page)
    {
        $type = 'upload';
        $id = input('param.id/s');
        $page = input('param.page/s');
        $lang = input('param.lang/s', $this->home_lang);
        $is_remote = [];
        $info = array();
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $inc = ui_read_bidden_inc($filenameArr);
        if (!empty($inc)) {
            foreach ($this->languageList as $key => $val) {
                $inckey = "{$val['mark']}_{$type}_{$id}";
                if (!empty($inc[$val['mark']][$inckey])) {
                    $data = json_decode($inc[$val['mark']][$inckey], true);
                    $info[$val['mark']] = $data['info'];
                    // $type = $data['type'];
                    if (!empty($info[$val['mark']]['value']) && is_http_url($info[$val['mark']]['value'])) {
                        $is_remote[$val['mark']] = 1;
                    } else {
                        $is_remote[$val['mark']] = 0;
                    }
                }
            }
        }

        $assign = array(
            'id'    => $id,
            'type'  => $type,
            'page'  => $page,
            'is_remote' => $is_remote,
            'info'  => $info,
            'lang'  => $lang,
            'idcode' => $this->idcode,
        );
        $this->assign('field', $assign);

        $iframe = input('param.iframe/d');
        if ($iframe == 1) {
            $viewfile = 'upload_m';
        } else {
            $viewfile = 'upload';
        }

        return $this->fetch($viewfile);
    }

    /**
     * 图片编辑处理
     */
    private function uploadHandle($id, $page, $post = array())
    {
        $type = 'upload';
        // $lang = $post['lang'];
        $alt = !empty($post['alt']) ? trim($post['alt']) : '';
        $alt = str_replace(['"',"'"], '', $alt);
        $is_remote = !empty($post['is_remote']) ? (int)$post['is_remote'] : 0;
        $litpic = '';
        if ($is_remote == 1) {
            $litpic = $post['litpic_remote'];
        } else {
            $litpic = trim($post['litpic']);
            $uplaod_data = func_common('litpic_local');
            if ($uplaod_data['errcode'] === 0) {
                $litpic = $uplaod_data['img_url'];
            } else {
                if (empty($litpic)) {
                    $this->error($uplaod_data['errmsg']);
                }
            }
            $litpic = handle_subdir_pic($litpic);
        }
        $oldhtml = urldecode($post['oldhtml']);
        $html = img_replace_url($oldhtml, $litpic);

        $dataArr = [];
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            if (preg_match('/(\s+)alt(\s*)=(\s*)[\'|\"]/i', $html)) {
                $html = preg_replace('/(\s+)alt(\s*)=(\s*)[\'|\"]([^\'\"]*)[\'|\"]/i', " alt='{$alt}'", $html);
            } else {
                $html = preg_replace('/(\s+)src(\s*)=(\s*)[\'|\"]([^\'\"]*)[\'|\"]/', ' src="${4}" alt="'.$alt.'" ', $html);
            }
            $arr = array(
                "{$val['mark']}_{$type}_{$id}" => json_encode(array(
                    'id'    => $id,
                    'type'  => $type,
                    'page'  => $page,
                    'lang'  => $val['mark'],
                    'idcode' => $this->idcode,
                    'info'   => array(
                        'value'    => htmlspecialchars($html),
                        'litpic'   => $litpic,
                        'alt'      => htmlspecialchars($alt),
                    ),
                )),
            );
            $dataArr[$val['mark']] = $arr;
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $redata = ui_write_bidden_inc($dataArr, $filenameArr, true);
        if (!empty($redata['code'])) {
            $data = [
                'imgsrc' => $litpic,
                'html'  => urlencode($html),
            ];
            $this->success('操作成功，数据已保存', null, $data);
            exit;
        } else {
            $msg = empty($redata['msg']) ? '写入失败' : $redata['msg'];
            $this->error($msg);
            exit;
        }
    }

    /**
     * 背景图片编辑
     */
    public function background($id, $page)
    {
        $type = 'background';
        $id = input('param.id/s');
        $page = input('param.page/s');
        $lang = input('param.lang/s', $this->home_lang);
        $is_remote = [];
        $info = array();
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $inc = ui_read_bidden_inc($filenameArr);
        if (!empty($inc)) {
            foreach ($this->languageList as $key => $val) {
                $inckey = "{$val['mark']}_{$type}_{$id}";
                if (!empty($inc[$val['mark']][$inckey])) {
                    $data = json_decode($inc[$val['mark']][$inckey], true);
                    $info[$val['mark']] = $data['info'];
                    // $type = $data['type'];
                    if (!empty($info[$val['mark']]['value']) && is_http_url($info[$val['mark']]['value'])) {
                        $is_remote[$val['mark']] = 1;
                    } else {
                        $is_remote[$val['mark']] = 0;
                    }
                }
            }
        }

        $assign = array(
            'id'    => $id,
            'type'  => $type,
            'page'  => $page,
            'is_remote' => $is_remote,
            'info'  => $info,
            'lang'  => $lang,
            'idcode' => $this->idcode,
        );
        $this->assign('field', $assign);

        $iframe = input('param.iframe/d');
        if ($iframe == 1) {
            $viewfile = 'background_m';
        } else {
            $viewfile = 'background';
        }

        return $this->fetch($viewfile);
    }

    /**
     * 背景图片编辑处理
     */
    private function backgroundHandle($id, $page, $post = array())
    {
        $type = 'background';
        // $lang = $post['lang'];
        $is_remote = !empty($post['is_remote']) ? $post['is_remote'] : 0;
        $litpic = '';
        if ($is_remote == 1) {
            $litpic = $post['litpic_remote'];
        } else {
            $litpic = trim($post['litpic']);
            $uplaod_data = func_common('litpic_local');
            if ($uplaod_data['errcode'] === 0) {
                $litpic = $uplaod_data['img_url'];
            } else {
                if (empty($litpic)) {
                    $this->error($uplaod_data['errmsg']);
                }
            }
            $litpic = handle_subdir_pic($litpic);
        }

        $dataArr = [];
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $arr = array(
                "{$val['mark']}_{$type}_{$id}" => json_encode(array(
                    'id'    => $id,
                    'type'  => $type,
                    'page'  => $page,
                    'lang'  => $val['mark'],
                    'idcode' => $this->idcode,
                    'info'   => array(
                        'value'    => $litpic,
                        'litpic'   => $litpic,
                    ),
                )),
            );
            $dataArr[$val['mark']] = $arr;
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $redata = ui_write_bidden_inc($dataArr, $filenameArr, true);
        if (!empty($redata['code'])) {
            $data = [
                'imgsrc' => $litpic,
            ];
            $this->success('操作成功，数据已保存', null, $data);
            exit;
        } else {
            $msg = empty($redata['msg']) ? '写入失败' : $redata['msg'];
            $this->error($msg);
            exit;
        }
    }

    /**
     * 百度地图
     */
    public function map($id, $page)
    {
        $type = 'map';
        $id = input('param.id/s');
        $page = input('param.page/s');
        $lang = input('param.lang/s', $this->home_lang);
        $inckey = "{$lang}_{$type}_{$id}";
        $keyword =  input('param.keyword/s');
        $info = array();

        $filename = $this->uipath."{$page}.inc.php";
        $inc = ui_read_bidden_inc($filename);
        if ($inc && !empty($inc[$inckey])) {
            $data = json_decode($inc[$inckey], true);
            $info = $data['info'];
            $type = $data['type'];
        }

        $lng = 110.34678620675;
        $lat = 20.001944329655;
        $coordinate = !empty($info['value']) ? trim($info['value']) : '';
        if($coordinate && strpos($coordinate,',') !== false)
        {
            $map = explode(',',$coordinate);
            $lng = $map[0];
            $lat = isset($map[1]) ? $map[1] : 0;
        }

        $zoom = !empty($info['zoom']) ? intval($info['zoom']) : 13;

        $mapConf    = [
            'lng'   => $lng,
            'lat'   => $lat,
            'zoom'  => $zoom,
            'ak'   => base64_decode(config('global.baidu_map_ak')),
            'keyword'   => $keyword,
        ];

        $assign = array(
            'id'    => $id,
            'type'  => $type,
            'page'  => $page,
            'info'   => $info,
            'lang'  => $lang,
            'mapConf'   => $mapConf,
            'idcode' => $this->idcode,
        );
        $this->assign('field', $assign);

        $iframe = input('param.iframe/d');
        if ($iframe == 1) {
            $viewfile = 'map_m';
        } else {
            $viewfile = 'map';
        }

        return $this->fetch($viewfile);
    }

    /**
     * 百度地图搜索
     */
    public function mapGetLocationByAddress()
    {
        $address =  input('param.address/s');
        $ak      = base64_decode(config('global.baidu_map_ak'));
        $url = $this->request->scheme()."://api.map.baidu.com/geocoder/v2/?address={$address}&city=&output=json&ak={$ak}";
        $result = httpRequest($url);
        $result = json_decode($result, true);
        if (!empty($result) && $result['status'] == 0) {
            $data['lng'] = $result['result']['location']['lng']; // 经度
            $data['lat'] = $result['result']['location']['lat']; // 纬度
            $data['map'] = $data['lng'].','.$data['lat'];
            $this->success('请求成功', null, $data);
        }

        $this->error('请求失败');
    }

    /**
     * 百度地图处理
     */
    private function mapHandle($id, $page, $post = array())
    {
        $type = 'map';
        $lang = $post['lang'];
        $zoom = !empty($post['zoom']) ? intval($post['zoom']) : 13;
        $location = !empty($post['location']) ? trim($post['location']) : '';
        if (empty($location)) {
            $this->error('请选定具体位置！');
        }
        $arr = array(
            "{$lang}_{$type}_{$id}" => json_encode(array(
                'id'    => $id,
                'type'  => $type,
                'page'  => $page,
                'lang'  => $lang,
                'idcode' => $this->idcode,
                'info'   => array(
                    'zoom'    => $zoom,
                    'value'    => $location,
                ),
            )),
        );
        $filename = $this->uipath."{$page}.inc.php";
        if (ui_write_bidden_inc($arr, $filename, true)) {
            $this->success('操作成功，数据已保存');
            exit;
        } else {
            $this->error('写入失败');
            exit;
        }
    }

    /**
     * 源代码编辑处理
     */
    public function code($id, $page)
    {
        $type = 'code';
        $id = input('param.id/s');
        $page = input('param.page/s');
        $lang = input('param.lang/s', $this->home_lang);
        $info = array();
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $inc = ui_read_bidden_inc($filenameArr);
        if (!empty($inc)) {
            foreach ($this->languageList as $key => $val) {
                $inckey = "{$val['mark']}_{$type}_{$id}";
                if (!empty($inc[$val['mark']][$inckey])) {
                    $data = json_decode($inc[$val['mark']][$inckey], true);
                    $info[$val['mark']] = $data['info'];
                    // $type = $data['type'];
                }
            }
        }

        $assign = array(
            'id'    => $id,
            'type'  => $type,
            'page'  => $page,
            'info'   => $info,
            'lang'  => $lang,
            'idcode' => $this->idcode,
        );
        $this->assign('field', $assign);

        $iframe = input('param.iframe/d');
        if ($iframe == 1) {
            $viewfile = 'code_m';
        } else {
            $viewfile = 'code';
        }

        return $this->fetch($viewfile);
    }

    /**
     * 源代码编辑处理
     */
    private function codeHandle($id, $page, $post = array())
    {
        $type = 'code';
        // $lang = $post['lang'];
        $content = !empty($post['content']) ? $post['content'] : [];
        $dataArr = [];
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $arr = array(
                "{$val['mark']}_{$type}_{$id}" => json_encode(array(
                    'id'    => $id,
                    'type'  => $type,
                    'page'  => $page,
                    'lang'  => $val['mark'],
                    'idcode' => $this->idcode,
                    'info'   => array(
                        'value'    => empty($content[$val['mark']]) ? '' : trim($content[$val['mark']]),
                    ),
                )),
            );
            $dataArr[$val['mark']] = $arr;
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $redata = ui_write_bidden_inc($dataArr, $filenameArr, true);
        if (!empty($redata['code'])) {
            $this->success('操作成功，数据已保存');
            exit;
        } else {
            $msg = empty($redata['msg']) ? '写入失败' : $redata['msg'];
            $this->error($msg);
            exit;
        }
    }

    /**
     * 单页编辑
     */
    public function single($id, $page)
    {
        $type = 'single';
        $id = input('param.id/s');
        $page = input('param.page/s');
        $lang = input('param.lang/s', $this->home_lang);
        $typeid = 0;
        $info = array();
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $inc = ui_read_bidden_inc($filenameArr);
        if (!empty($inc)) {
            foreach ($this->languageList as $key => $val) {
                $inckey = "{$val['mark']}_{$type}_{$id}";
                if (!empty($inc[$val['mark']][$inckey])) {
                    $data = json_decode($inc[$val['mark']][$inckey], true);
                    $typeid = $data['typeid'];
                    $info[$val['mark']] = $data['info'];
                    // $type = $data['type'];
                }
            }
        }

        /*所有单页列表*/
        $arctype_html = allow_release_arctype($typeid, [6]);
        $this->assign('arctype_html', $arctype_html);
        /*--end*/

        $assign = array(
            'id'    => $id,
            'type'  => $type,
            'page'  => $page,
            'typeid'   => $typeid,
            'info'  => $info,
            'lang'  => $lang,
            'idcode' => $this->idcode,
        );
        $this->assign('field', $assign);

        $iframe = input('param.iframe/d');
        if ($iframe == 1) {
            $viewfile = 'single_m';
        } else {
            $viewfile = 'single';
        }

        return $this->fetch($viewfile);
    }

    /**
     * 单页编辑处理
     */
    private function singleHandle($id, $page, $post = array())
    {
        $type = 'single';
        // $lang = $post['lang'];
        $dataArr = [];
        $filenameArr = [];
        foreach ($this->languageList as $key => $val) {
            $arr = array(
                "{$val['mark']}_{$type}_{$id}" => json_encode(array(
                    'id'    => $id,
                    'type'  => $type,
                    'page'  => $page,
                    'typeid' => preg_replace('/([^0-9]*)/i', '', $post['typeid']),
                    'lang'  => $val['mark'],
                    'idcode' => $this->idcode,
                    'info'   => $post,
                )),
            );
            $dataArr[$val['mark']] = $arr;
            $filenameArr[$val['mark']] = $this->uipath."{$val['mark']}/{$page}.inc.php";
        }
        $redata = ui_write_bidden_inc($dataArr, $filenameArr, true);
        if (!empty($redata['code'])) {
            $this->success('操作成功，数据已保存');
            exit;
        } else {
            $msg = empty($redata['msg']) ? '写入失败' : $redata['msg'];
            $this->error($msg);
            exit;
        }
    }

    /**
     * 清除页面数据
     */
    public function clear_data()
    {
        $type = input('param.type/s');
        if (IS_POST && !empty($type) && !empty($this->v)) {
            $where = [
                'idcode'    => $this->idcode,
            ];
            if ($type != 'all') {
                $where['type'] = $type;
            }
            $result = Db::name('ui_config')->where($where)->select();
            $r = Db::name('ui_config')->where($where)->delete();
            if ($r !== false) {
                \think\Cache::clear('ui_config');
                foreach ($result as $key => $val) {
                    $filename = RUNTIME_PATH.'ui/'.TPL_THEME.$this->v."/{$val['lang']}/{$val['page']}.inc.php";
                    @unlink($filename);
                }
                $this->success('操作成功，数据已重置');
            }
        }
        $this->error('操作失败');
    }

    public function mobileTpl()
    {
        $assign_data = [];
        $gourl = input('param.gourl/s');
        $assign_data['murl'] = base64_decode($gourl).'&iframe=1';

        $webConfig = tpCache('web');
        $web_adminbasefile = !empty($webConfig['web_adminbasefile']) ? $webConfig['web_adminbasefile'] : $this->root_dir.'/login.php'; // 后台入口文件路径
        $assign_data['web_adminbasefile'] = $web_adminbasefile;

        $tid = input('param.tid/d');
        $assign_data['tid'] = $tid;

        $aid = input('param.aid/d');
        $assign_data['aid'] = $aid;
        $assign_data['lang'] = $this->home_lang;

        $iframe = input('param.iframe/d');
        $assign_data['iframe'] = $iframe;

        $this->assign($assign_data);

        return $this->fetch();
    }

    /**
    * 获取模型的分类列表
    */  
    public function ajax_get_arctype_list($modelid = 0, $typeid = 0, $text = '--请选择--')
    {
        $map = array(
            'lang' => $this->home_lang,
            'current_channel' => (int)$modelid,
            'is_del'    => 0, // 回收站功能
            'status'   => 1,
        );
        $html = "<option value=''>".urldecode($text)."</option>";
        $arctype_html = model('Arctype')->getList(0, (int)$typeid, true, $map);
        $html .= $arctype_html;
        $isempty = 0;
        if (empty($arctype_html)){
            $isempty = 1;
        }
        $this->success($html,'',['isempty'=>$isempty]);
    }
}