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

namespace app\admin\controller;

use think\Db;
use think\Page;
use app\common\logic\ArctypeLogic;
use app\admin\logic\FieldLogic;
use app\admin\model\ClassModel;

class Arctype extends Base
{
    public $fieldLogic;
    public $arctypeLogic;
    // 栏目对应模型ID
    public $arctype_channel_id = '';
    // 允许发布文档的模型ID
    public $allowReleaseChannel = array();
    // 禁用的目录名称
    public $disableDirname = [];

    public function _initialize()
    {
        parent::_initialize();
        $this->fieldLogic          = new FieldLogic();
        $this->arctypeLogic        = new ArctypeLogic();
        $this->allowReleaseChannel = config('global.allow_release_channel');
        $this->arctype_channel_id  = config('global.arctype_channel_id');
        $this->disableDirname      = config('global.disable_dirname');
        $this->arctype_db  = Db::name('arctype');
        $this->archives = Db::name('archives');

        // 模型ID
        $current_channel = input('current_channel/d', 0);
        $this->channeltype = input('channeltype/d', $current_channel);
        $this->assign('channeltype', $this->channeltype);

        // 分类模型
        $this->classModel = new ClassModel($this->channeltype);

        /*兼容每个用户的自定义字段，重新生成数据表字段缓存文件*/
        $arctypeFieldInfo = include DATA_PATH . 'schema/zan_arctype.php';
        foreach (['weapp_code'] as $key => $val) {
            if (!isset($arctypeFieldInfo[$val])) {
                try {
                    schemaTable('arctype');
                } catch (\Exception $e) {}
                break;
            }
        }
        /*--end*/

        // 返回列表页
        $this->assign('returnUrl', url('Arctype/lists', ['lang' => get_admin_lang()]));
        // $this->assign('returnUrl', url('Arctype/index', ['channeltype' => $this->channeltype, 'lang' => get_admin_lang()]));
    }

    public function lists()
    {
        // 获取对应模型分类列表
        $result = $this->classModel->getClassifyListData([], $this->showLangList);
        $this->assign($result);
        return $this->fetch();
    }

    public function lists_save()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            // 添加到分类表
            if (empty($post['channel'])) $post['channel'] = 6;
            if (!empty($post['typename'])) $post['title'] = $post['seo_title'] = trim($post['typename']);
            $post['stypeid'] = $this->classModel->goodsClassifyAction('insert', $post);
            if (!empty($post['stypeid']) && 6 === intval($post['current_channel'])) {
                // 获取新增文档数据
                [$insert, $content] = model('Archives')->getInsertArchivesArray($post, true);

                // 保存文档基础数据
                $aid = Db::name('archives')->insertGetId($insert);
                if (!empty($aid)) {
                    $post['aid'] = $aid;

                    // 保存文档内容数据
                    if (empty($content['aid'])) $content['aid'] = intval($aid);
                    Db::name('single_content')->insertGetId($content);

                    // 同步保存对应语言文档数据
                    $resultID = model('Archives')->saveArchivesDetails($post);
                    if (!empty($resultID)) {
                        adminLog('新增单页：' . $insert['title']);
                        $this->success("新增成功");
                    }
                }
            } else if (!empty($post['stypeid'])) {
                $this->success("新增成功");
            }
            $this->error("操作失败");
        }

        // 分类信息
        $auto_id = input('auto_id/d', 0);
        $field = $this->arctype_db->where(['auto_id' => intval($auto_id)])->find();
        if (empty($field['parent_id']) && empty($field['topid'])) $field['topid'] = intval($field['id']);
        if (!empty($field['parent_id']) && !empty($field['topid'])) $field['parent_id'] = intval($field['id']);
        $this->assign('field', $field);

        // 模型列表
        $where = [
            'status' => 1,
            // 'nid' => ['NEQ', 'single']
        ];
        $channelList = Db::name('channeltype')->where($where)->getAllWithIndex('id');
        $this->assign('channelList', $channelList);

        return $this->fetch();
    }

    public function index()
    {
        // 获取对应模型分类列表
        $result = $this->classModel->getClassifyListData();
        $this->assign($result);

        return $this->fetch();
    }
    
    // 新增
    public function add()
    {
        if (IS_AJAX_POST) {
            $this->classModel->goodsClassifyAction('insert');
        }

        // 获取页面所需数据
        $result = $this->classModel->getGoodsClassifyPublic('insert');
        // dump($result);exit;
        $this->assign($result);

        $map = array(
            'status'    => 1,
        );
        $channeltype_list = model('Channeltype')->getAll('id,title,nid', $map, 'id');
        $this->assign('channeltype_list', $channeltype_list);
        $this->assign('current_channel', $this->channeltype);

        $templateList = $this->ajax_getTemplateList('add');
        $this->assign('templateList', $templateList);

        $js_allow_channel_arr = '[';
        foreach ($this->allowReleaseChannel as $key => $val) {
            if ($key > 0) {
                $js_allow_channel_arr .= ',';
            }
            $js_allow_channel_arr .= $val;
        }
        $js_allow_channel_arr = $js_allow_channel_arr.']';
        $this->assign('js_allow_channel_arr', $js_allow_channel_arr);

        return $this->fetch();
    }
    
    // 编辑
    public function edit()
    {
        if (IS_AJAX_POST) {
            $a = $this->classModel->goodsClassifyAction('update');
            if (6 === intval($this->channeltype)) {
                if (!empty($a)) {
                    $id = input('post.id/d', 0);
                    $templist = input('post.templist/s', '');
                    if (!empty($id) && !empty($templist)) {
                        Db::name('archives')->where(['typeid' => intval($id)])->update(['tempview' => trim($templist), 'update_time' => getTime()]);
                    }
                    // 清除缓存返回成功提示
                    \think\Cache::clear("arctype");
                    $this->success('保存成功');
                } else {
                    $this->error('保存失败');
                }
            }
        }

        // 获取页面所需数据
        $result = $this->classModel->getGoodsClassifyPublic('update');
        $this->assign($result);

        // 豆包翻译API配置
        $doubao = tpSetting('doubao', [], $this->show_lang);
        $this->assign('doubao', $doubao);

        /* 模型 */
        $map = "status = 1 OR id = '".$result['arctype']['current_channel']."'";
        $channeltype_list = model('Channeltype')->getAll('id,title,nid,ctl_name', $map, 'id');
        // 模型对应模板文件不存在报错
        if (!isset($channeltype_list[$result['arctype']['current_channel']])) {
            $row = model('Channeltype')->getInfo($result['arctype']['current_channel']);
            $file = 'lists_'.$row['nid'].'.htm';
            $this->error($row['title'].'缺少模板文件'.$file);
        }
        $this->assign('channeltype_list', $channeltype_list);
        $this->assign('current_channel', $this->channeltype);
        $templateList = $this->ajax_getTemplateList('edit', $result['arctype']['templist'], $result['arctype']['tempview']);
        $this->assign('templateList', $templateList);

        $js_allow_channel_arr = '[';
        foreach ($this->allowReleaseChannel as $key => $val) {
            if ($key > 0) {
                $js_allow_channel_arr .= ',';
            }
            $js_allow_channel_arr .= $val;
        }
        $js_allow_channel_arr = $js_allow_channel_arr.']';
        $this->assign('js_allow_channel_arr', $js_allow_channel_arr);
        $seo_rewrite_format = config('ey_config.seo_rewrite_format');
        $this->assign('seo_rewrite_format', $seo_rewrite_format);
        return $this->fetch();
    }

    // 删除
    public function del()
    {
        if (IS_AJAX_POST) {
            $this->classModel->goodsClassifyAction('delete');
        }
        $this->error('请求失败');
    }

    // 获取指定分类的下级分类
    public function ajaxGetUnderArctypeList()
    {
        if (IS_AJAX_POST) {
            $this->classModel->ajaxGetUnderArctypeList();
        }
        $this->error('请求失败');
    }
    
    /**
     * 内容管理
     */
    public function single_edit()
    {
        if (IS_POST) {
            $post = input('post.');
            $typeid = input('post.typeid/d', 0);
            if(!empty($typeid)){
                model('Archives')->editor_auto_210607($post);
                $info = Db::name('arctype')->field('id,typename,current_channel')
                    ->where([
                        'id'    => $typeid,
                        'lang'  => $this->admin_lang,
                    ])->find();
                $aid = Db::name('archives')->where([
                        'typeid'    => $typeid,
                        'channel'   => 6,
                        'lang'  => $this->admin_lang,
                    ])->getField('aid');
                
                /*修复新增单页栏目的关联数据不完善，进行修复*/
                if (empty($aid)) {
                    $archivesData = array(
                        'title' => $info['typename'],
                        'typeid'=> $info['id'],
                        'channel'   => $info['current_channel'],
                        'sort_order'    => 100,
                        'add_time'  => getTime(),
                        'update_time'     => getTime(),
                        'lang'  => $this->admin_lang,
                    );
                    $aid = Db::name('archives')->insertGetId($archivesData);
                }
                /*--end*/

                Db::name('archives')->where(['aid'=>$aid])->update([
                        'editor_remote_img_local'=> empty($post['editor_remote_img_local']) ? 0 : $post['editor_remote_img_local'],
                        'editor_img_clear_link'  => empty($post['editor_img_clear_link']) ? 0 : $post['editor_img_clear_link'],
                    ]);

                Db::name('arctype')->where(['id'=>$typeid])->update([
                        'empty_logic'=>!empty($post['empty_logic']) ? 1 : 0,
                        'update_time'     => getTime(),
                    ]);

                if (!isset($post['addonFieldExt'])) {
                    $post['addonFieldExt'] = array();
                }
                $updateData = array(
                    'aid'   => $aid,
                    'typename' => $info['typename'],
                    'addonFieldExt' => $post['addonFieldExt'],
                );
                model('Single')->afterSave($aid, $updateData, 'edit');

                \think\Cache::clear("arctype");
                adminLog('编辑栏目：'.$info['typename']);
                // 生成静态页面代码
                $gourl = '';
                if (!empty($post['gourl'])) {
                    $gourl = htmlspecialchars_decode($post['gourl']);
                    if (!stristr($gourl, '&typeid='.$typeid)) {
                        $gourl .= '&typeid='.$typeid;
                    }
                }
                if ($post['archives'] == 1) {
                    $gourl = url('Arctype/single_edit', ['typeid'=>$typeid,'archives'=>$post['archives'],'gourl'=>$gourl]);
                }
                $this->success("操作成功!", $gourl);
            }
            $this->error("操作失败!");
        }

        $assign_data = array();

        $typeid = input('typeid/d');
        $info = Db::name('arctype')->field('a.*, b.editor_remote_img_local, b.editor_img_clear_link')
            ->alias('a')
            ->join('archives b', 'a.id = b.typeid', 'left')
            ->where([
                'a.id'    => $typeid,
                'a.lang'  => $this->admin_lang,
            ])->find();
        if (empty($info)) {
            $this->error('数据不存在，请联系管理员！');
        }
        $info['typename'] = htmlspecialchars_decode(addslashes($info['typename']));
        $assign_data['info'] = $info;

        $editor = tpSetting('editor');
        $editor['editor_remote_img_local'] = $info['editor_remote_img_local'];
        $editor['editor_img_clear_link'] = $info['editor_img_clear_link'];

        /*自定义字段*/
        $addonFieldExtList = model('Field')->getChannelFieldList($info['current_channel'], 0, $typeid, $info);
        $field_id_row = Db::name('channelfield_bind')->where([
                'field_id'    => ['IN', get_arr_column($addonFieldExtList, 'id')],
            ])->column('field_id');
        // 匹配显示的自定义字段
        $editor_addonFieldExt = []; // 富文本的字段名
        $content_ey_m_dfvalue = ""; //手机端详情内容
        $have_content_ey_m = 0;         //是否显示手机端
        $name_arr = get_arr_column($addonFieldExtList,'name');

        if (!empty($field_id_row)) {
            // 查询绑定的自定义字段
            $channelfieldBindRow = Db::name('channelfield_bind')->where([
                    'typeid'    => ['IN', [0, $typeid]],
                ])->column('field_id');
            $first_html = '';
            foreach ($addonFieldExtList as $key => $val) {
                if (in_array($val['id'], $field_id_row) && !in_array($val['id'], $channelfieldBindRow)) {
                    unset($addonFieldExtList[$key]);
                    continue;
                }
                if ($val['dtype'] == 'htmltext') {
                    if ($val['name'] == 'content_ey_m'){
                        $content_ey_m_dfvalue = $val['dfvalue'];
                        if ($val['ifeditable']){
                            $have_content_ey_m = 1;
                        }
                    }
                    if (empty($first_html) && $val['name'] != 'content_ey_m'){
                        $addonFieldExtList[$key]['editor'] = $editor;
                        if ('content' == $val['name']) {
                            $addonFieldExtList[$key]['first'] = 1;
                            $first_html = 1;
                        }
                    }
                    $editor_addonFieldExt[] = $val['name'];
                }
                if($val['name'] == 'content_ey_m' && in_array('content',$name_arr)){  //百度编辑器，去掉content_ey_m
                    unset($addonFieldExtList[$key]);
                    continue;
                }
            }
        } else {
            $first_html = '';
            foreach ($addonFieldExtList as $key => $val) {
                if ($val['dtype'] == 'htmltext') {
                    if ($val['name'] == 'content_ey_m'){
                        $content_ey_m_dfvalue = $val['dfvalue'];
                        if ($val['ifeditable']){
                            $have_content_ey_m = 1;
                        }
                    }
                    if (empty($first_html) && $val['name'] != 'content_ey_m'){
                        $addonFieldExtList[$key]['editor'] = $editor;
                        if ('content' == $val['name']) {
                            $addonFieldExtList[$key]['first'] = 1;
                            $first_html = 1;
                        }
                    }
                    $editor_addonFieldExt[] = $val['name'];
                }
                if($val['name'] == 'content_ey_m' && in_array('content',$name_arr)){  //百度编辑器，去掉content_ey_m
                    unset($addonFieldExtList[$key]);
                    continue;
                }
            }
        }

        if (!empty($editor_addonFieldExt)){
            $editor_addonFieldExt = implode(',',$editor_addonFieldExt);
        }else{
            $editor_addonFieldExt = '';
        }
        $assign_data['editor_addonFieldExt'] = $editor_addonFieldExt;
        
        $assign_data['content_ey_m_dfvalue'] = $content_ey_m_dfvalue;
        $assign_data['have_content_ey_m'] = $have_content_ey_m;
        $assign_data['addonFieldExtList'] = $addonFieldExtList;
        $assign_data['aid'] = $typeid;
        $assign_data['channeltype'] = 6;
        $assign_data['nid'] = 'single';
        $assign_data['controller_name'] = CONTROLLER_NAME;
        $assign_data['action_name'] = ACTION_NAME;
        /*--end*/

        /*返回上一层*/
        $gourl = input('param.gourl/s', '');
        if (empty($gourl)) {
            $gourl = url('Arctype/index');
        }
        $assign_data['gourl'] = $gourl;
        /*--end*/
        $assign_data['archives'] = input('param.archives/d', 0);
        $this->assign($assign_data);
        
        /* 生成静态页面代码 */
        $this->assign('typeid',$typeid);
        /* end */
        
        return $this->fetch();
    }
    
    /**
     * 伪删除 del->彻底删除 pseudo->伪删除
     */
    public function pseudo_del()
    {
        if (IS_POST) {
            if (is_language() && empty($this->globalConfig['language_split'])) {
                $this->language_access(); // 多语言功能操作权限
            }
            
            $post = input('post.');
            $post['del_id'] = eyIntval($post['del_id']);

            /*当前栏目信息*/
            $row = Db::name('arctype')->field('id, current_channel, typename')
                ->where([
                    'id'    => $post['del_id'],
                    'lang'  => $this->admin_lang,
                ])
                ->find();
            
            if ('del' == $post['deltype']) {
                $r = model('Arctype')->del($post['del_id']);
                $logtxt = '删除栏目：'.$row['typename'];
            } else {
                $r = model('Arctype')->pseudo_del($post['del_id']);
                $logtxt = '伪删除栏目：'.$row['typename'];
            }
            if (false !== $r) {
                adminLog($logtxt);
                /*清空sql_cache_table数据缓存表 并 添加查询执行语句到mysql缓存表*/
                Db::execute('TRUNCATE TABLE '.config('database.prefix').'sql_cache_table');
                model('SqlCacheTable')->InsertSqlCacheTable(true);
                /* END */
                $this->success('删除成功');
            }
        }

        $this->error('删除失败');
    }

    /**
     * 批量伪删除/真删除
     */
    public function batch_pseudo_del()
    {
        if (IS_POST) {
            if (is_language() && empty($this->globalConfig['language_split'])) {
                $this->language_access(); // 多语言功能操作权限
            }

            $post = input('post.');
            $post['del_id'] = eyIntval($post['del_id']);
            if (!$post['del_id']) $this->error('未选择栏目');

            $typename = '';
            foreach ($post['del_id'] as $item) {
                /*当前栏目信息*/
                $row = Db::name('arctype')->field('id, current_channel, typename')
                    ->where([
                        'id'    => $item,
                        'lang'  => $this->admin_lang,
                    ])
                    ->find();

                $typename .= $row['typename'].',';

                if ('del' == $post['deltype']) {
                    model('Arctype')->del($item);
                } else {
                    model('Arctype')->pseudo_del($item);
                }
            }

            if ('del' == $post['deltype']) {
                $logtxt = '删除栏目：'.trim($typename,',');
            } else {
                $logtxt = '伪删除栏目：'.trim($typename,',');
            }
            adminLog($logtxt);
            /*清空sql_cache_table数据缓存表 并 添加查询执行语句到mysql缓存表*/
            Db::execute('TRUNCATE TABLE '.config('database.prefix').'sql_cache_table');
            model('SqlCacheTable')->InsertSqlCacheTable(true);
            /* END */
            $this->success('删除成功');
        }

        $this->error('删除失败');
    }

    /**
     * 通过模型获取栏目
     */
    public function ajax_get_arctype($channeltype = 0)
    {
        $arctype_max_level = intval(config('global.arctype_max_level'));
        $options           = $this->arctypeLogic->arctype_list(0, 0, false, $arctype_max_level, array('channeltype' => $channeltype));
        $select_html       = '<option value="0" data-grade="-1">顶级栏目</option>';
        foreach ($options AS $var)
        {
            $select_html .= '<option value="' . $var['id'] . '" data-grade="' . $var['grade'] . '" data-dirpath="'.$var['dirpath'].'"';
            $select_html .= '>';
            if ($var['level'] > 0)
            {
                $select_html .= str_repeat('&nbsp;', $var['level'] * 4);
            }
            $select_html .= htmlspecialchars_decode(addslashes($var['typename'])) . '</option>';
        }

        $returndata = array(
            'status' => 1,
            'select_html' => $select_html,
        );
        
        respose($returndata);
    }

    /**
     * 获取栏目的拼音
     */
    public function ajax_get_dirpinyin($typename = '')
    {
        $pinyin = get_pinyin($typename);
        $this->success('提取成功', null, ['pinyin'=>$pinyin]);
    }

    /**
     * 检测文件保存目录是否存在
     */
    public function ajax_check_dirpath()
    {
        $dirpath = input('post.dirpath/s');
        $id = input('post.id/d');
        $map = array(
            'dirpath' => $dirpath,
            'lang'  => $this->admin_lang,
        );
        if (intval($id) > 0) {
            $map['id'] = array('neq', $id);
        }
        $result = Db::name('arctype')->where($map)->find();
        if (!empty($result)) {
            respose(array(
                'status'    => 0,
                'msg'   => '文件保存目录已存在，请更改',
            ));
        } else {
            respose(array(
                'status'    => 1,
                'msg'   => '文件保存目录可用',
            ));
        }
    }
    //分类所属模型
    public function ajax_check_channeltype(){         
        if(IS_POST){            
            $typeid = input('post.typeid/d');
            if(empty($typeid)) return json(['code'=>0,'msg'=>'ok','data'=>'']);
            $channeltype = Db::name('arctype')->where(['id'=>$typeid,'lang'=>$this->admin_lang])->value('channeltype');
            return json(['code'=>1,'msg'=>'ok','data'=>$channeltype]);
        }
    }
    public function ajax_getTemplateList($opt = 'add', $templist = '', $tempview = '')
    {   
        $planPath = 'template/'.TPL_THEME.'pc';
        $dirRes   = opendir($planPath);
        $view_suffix = config('template.view_suffix');
        $channelList = model('Channeltype')->getAll();

        /*模板PC目录文件列表*/
        $filenameArr = ['.', '..'];
        foreach ($channelList as $k1 => $v1) {
            $filenameArr[] = "lists_{$v1['nid']}_all.htm";
        }
        $templateArr = array();
        while($filename = readdir($dirRes))
        {
            if (in_array($filename, $filenameArr)) {
                continue;
            }
            array_push($templateArr, $filename);
        }
        !empty($templateArr) && asort($templateArr);
        /*--end*/

        /*多语言全部标识*/
        $markArr = Db::name('language_mark')->column('mark');
        /*--end*/
        
        $is_language = false;
        $web_language_switch = tpCache('global.web_language_switch');
        if (!empty($web_language_switch)) {
            $languageCount = Db::name('language')->where(['status'=>1])->count('id');
            if (1 < $languageCount) {
                $is_language = true;
            }
        }

        $templateList = array();
        foreach ($channelList as $k1 => $v1) {
            $l = 1;
            $v = 1;
            $lists = ''; // 销毁列表模板
            $view = ''; // 销毁文档模板
            $templateList[$v1['id']] = array();
            foreach ($templateArr as $k2 => $v2) {
                $v2 = iconv('GB2312', 'UTF-8', $v2);

                if ('add' == $opt) {
                    $selected = 0; // 默认选中状态
                } else {
                    $selected = 1; // 默认选中状态
                }

                preg_match('/^(lists|view)_'.$v1['nid'].'(_(.*))?(_'.$this->admin_lang.')?\.'.$view_suffix.'/i', $v2, $matches1);
                $langtpl = preg_replace('/\.'.$view_suffix.'$/i', "_{$this->admin_lang}.{$view_suffix}", $v2);
                if (file_exists(realpath($planPath.DS.$langtpl))) {
                    continue;
                } else if (true == $is_language && preg_match('/^(.*)_([a-zA-z]{2,2})\.'.$view_suffix.'$/i',$v2,$matches2)) {
                    if (in_array($matches2[2], $markArr) && $matches2[2] != $this->admin_lang) {
                        continue;
                    }
                }

                if (!empty($matches1)) {
                    $selectefile = '';
                    if ('lists' == $matches1[1]) {
                        $lists .= '<option value="'.$v2.'" ';
                        $lists .= ($templist == $v2 || $selected == $l) ? " selected='true' " : '';
                        $lists .= '>'.$v2.'</option>';
                        $l++;
                    } else if ('view' == $matches1[1]) {
                        $view .= '<option value="'.$v2.'" ';
                        $view .= ($tempview == $v2 || $selected == $v) ? " selected='true' " : '';
                        $view .= '>'.$v2.'</option>';
                        $v++;
                    }
                }
            }
            $nofileArr = [];
            if (in_array($v1['nid'], ['ask'])) { // 问答模型

            } else { // 其他模型
                if ('add' == $opt) {
                    if (empty($lists)) {
                        $lists = '<option value="">无</option>';
                        $nofileArr[] = "lists_{$v1['nid']}.{$view_suffix}";
                    }
                    
                    if (empty($view)) {
                        $view = '<option value="">无</option>';
                        if (!in_array($v1['nid'], ['single','guestbook'])) {
                            $nofileArr[] = "view_{$v1['nid']}.{$view_suffix}";
                        }
                    }
                } else {
                    if (empty($lists)) {
                        $nofileArr[] = "lists_{$v1['nid']}.{$view_suffix}";
                    }
                    $lists = '<option value="">请选择模板…</option>'.$lists;

                    if (empty($view)) {
                        if (!in_array($v1['nid'], ['single','guestbook'])) {
                            $nofileArr[] = "view_{$v1['nid']}.{$view_suffix}";
                        }
                    }
                    $view = '<option value="">请选择模板…</option>'.$view;
                }
            }

            $msg = '';
            if (!empty($nofileArr)) {
                $msg = '<font color="red">该模型缺少模板文件：'.implode(' 和 ', $nofileArr).'</font>';
            }

            $templateList[$v1['id']] = array(
                'lists' => $lists,
                'view' => $view,
                'msg'    => $msg,
                'nid'    => $v1['nid'],
            );
        }

        if (IS_AJAX) {
            $this->success('请求成功', null, ['templateList'=>$templateList]);
        } else {
            return $templateList;
        }
    }

    /**
     * 新建模板文件
     */
    public function ajax_newtpl()
    {
        $this->error('出于安全考虑已禁用，请使用ftp或易优助手插件修改模板');
        if (IS_POST) {
            $post = input('post.', '', null);
            $content = input('post.content', '', null);
            $view_suffix = config('template.view_suffix');
            if (!empty($post['filename'])) {
                if (!preg_match("/^[\w\-\_]{1,}$/u", $post['filename'])) {
                    $this->error('文件名称只允许字母、数字、下划线、连接符的任意组合！');
                }
                $filename = "{$post['type']}_{$post['nid']}_{$post['filename']}.{$view_suffix}";
            } else {
                $filename = "{$post['type']}_{$post['nid']}.{$view_suffix}";
            }

            $tpldirpath = !empty($post['tpldir']) ? '/template/'.TPL_THEME.trim($post['tpldir']) : '/template/'.TPL_THEME.'pc';
            if (file_exists(ROOT_PATH.ltrim($tpldirpath, '/').'/'.$filename)) {
                $this->error('文件名称已经存在，请重新命名！', null, ['focus'=>'filename']);
            }

            $nosubmit = input('param.nosubmit/d');
            if (1 == $nosubmit) {
                $this->success('检测通过');
            }

            $filemanagerLogic = new \app\admin\logic\FilemanagerLogic;
            $r = $filemanagerLogic->editFile($filename, $tpldirpath, $content);
            if ($r === true) {
                $this->success('操作成功', null, ['filename'=>$filename,'type'=>$post['type']]);
            } else {
                $this->error($r);
            }
        }
        $type = input('param.type/s');
        $nid = input('param.nid/s');
        $tpldirList = glob('template/'.TPL_THEME.'*');
        $tpl_theme = str_replace('/', '\\/', TPL_THEME);
        foreach ($tpldirList as $key => $val) {
            if (!preg_match('/template\/'.$tpl_theme.'(pc|mobile)$/i', $val)) {
                unset($tpldirList[$key]);
            } else {
                $tpldirList[$key] = preg_replace('/^(.*)template\/'.$tpl_theme.'(pc|mobile)$/i', '$2', $val);
            }
        }
        !empty($tpldirList) && arsort($tpldirList);
        $this->assign('tpldirList', $tpldirList);
        $this->assign('type', $type);
        $this->assign('nid', $nid);
        $this->assign('tpl_theme', TPL_THEME);
        return $this->fetch();
    }

    /**
     * 批量增加分类
     */
    public function batch_add()
    {
        //防止php超时
        function_exists('set_time_limit') && set_time_limit(0);
        if (IS_POST) {
            $post = input('post.');
            if ($post) {
                if (empty($post['parent_id'])) { // 增加顶级分类
                    foreach ($post['toptype'] as $key => $val) {
                        $val = trim($val);
                        if (empty($val)) {
                            unset($post['toptype'][$key]);
                        }
                    }
                    if (empty($post['toptype'])) {
                        $this->error('顶级分类名称不能为空！');
                    }
                    $this->batch_add_toptype($post);
                } 
                else { // 增加下级分类
                    foreach ($post['reltype'] as $key => $val) {
                        $val = trim($val);
                        if (empty($val)) {
                            unset($post['reltype'][$key]);
                        }
                    }
                    if (empty($post['reltype'])) {
                        $this->error('分类名称不能为空！');
                    }
                    $this->batch_add_subtype($post);
                }
            }
            $this->error("操作失败！");
            exit;
        }

        /* 模型 */
        $map = array(
            'status'    => 1,
            'id'        => ['neq', 51], // 排除问答模型
        );
        $channeltype_list = model('Channeltype')->getAll('id,title,nid', $map, 'id');
        $this->assign('channeltype_list', $channeltype_list);
        
        /*发布文档的模型ID，用于是否显示文档模板列表*/
        $js_allow_channel_arr = '[';
        foreach ($this->allowReleaseChannel as $key => $val) {
            if ($key > 0) {
                $js_allow_channel_arr .= ',';
            }
            $js_allow_channel_arr .= $val;
        }
        $js_allow_channel_arr = $js_allow_channel_arr.']';
        $this->assign('js_allow_channel_arr', $js_allow_channel_arr);
        /*--end*/

        // 所属分类
        $select_html = '<option value="0" data-grade="-1" data-dirpath="">顶级分类</option>';
        $selected = 0;
        $arctype_max_level = intval(config('global.arctype_max_level'));
        $arctypeWhere = ['is_del'=>0];
        $options = $this->arctypeLogic->arctype_list(0, $selected, false, $arctype_max_level - 1, $arctypeWhere);
        foreach ($options AS $var)
        {
            $select_html .= '<option value="' . $var['id'] . '" data-grade="' . $var['grade'] . '"';
            if (2 == $this->globalConfig['seo_pseudo'] && 4 == $this->globalConfig['seo_html_listname']) {
                $select_html .= ' data-dirpath="'.$var['diy_dirpath'].'" ';
            } else {
                $select_html .= ' data-dirpath="'.$var['dirpath'].'" ';
            }
            $select_html .= '>';
            if ($var['level'] > 0)
            {
                $select_html .= str_repeat('&nbsp;', $var['level'] * 4);
            }
            $select_html .= htmlspecialchars_decode(addslashes($var['typename'])) . '</option>';
        }
        $this->assign('select_html',$select_html);

        /*模板列表*/
        $templateList = $this->ajax_getTemplateList('add');
        $this->assign('templateList', $templateList);
        /*--end*/

        return $this->fetch();
    }

    /**
     * 批量增加顶级分类
     */
    private function batch_add_toptype($post = [])
    {
        $saveData = [];        
        $dirnameArr = [];
        $arctype_maxid = create_next_id('arctype', 'id', []); 
        foreach ($post['toptype'] as $key => $val) {
            $typename = func_preg_replace([',','，'], '', trim($val));
            if (empty($typename)) continue;

            // 子分类
            if (!empty($post['sontype'][$key])) {
                $sontype = str_replace('，', ',', $post['sontype'][$key]);
                $post['sontype'][$key] = explode(',', $sontype);
            }

            // 目录名称
            $dirname = $this->arctypeLogic->get_dirname($typename, '', 0, $dirnameArr, false);
            array_push($dirnameArr, $dirname);

            $dirpath = '/'.$dirname;
            $data = [
                'id'=> $arctype_maxid, // 父ID
                'typename'  => $typename,
                'channeltype'   => $post['current_channel'],
                'current_channel'   => $post['current_channel'],
                'parent_id' => 0,
                'dirname'   => $dirname,
                'dirpath'   => $dirpath,
                'diy_dirpath'   => $dirpath,
                'grade' => 0,
                'litpic' => !empty($post['litpic_local'][$key]) ? $post['litpic_local'][$key] : '',
                'templist'  => !empty($post['templist']) ? $post['templist'] : '',
                'tempview'  => !empty($post['tempview']) ? $post['tempview'] : '',
                'is_hidden'  => $post['is_hidden'],
                'seo_description'   => '',
                'admin_id'  => session('admin_info.admin_id'),
                'lang'  => $this->admin_lang,
                'sort_order'    => !empty($post['sort_order'][$key]) ? intval($post['sort_order'][$key]) : 100,
                'add_time'  => getTime(),
                'update_time'  => getTime(),
            ];
            $saveData[] = $data;
            $arctype_maxid +=1;
        }        
        $langlist = Db::name('language')->field('mark')->where('mark','neq',$this->admin_lang)->select();
        foreach ($langlist as $lgval) {
            foreach ($saveData as $_v) {
                $_v['lang']=$lgval['mark'];                
                $saveData2[] = $_v;
            }
        }       
        if($saveData2 && is_array($saveData2)){
            $saveData = array_merge($saveData,$saveData2);
        } 
        if (!empty($saveData)) {            
            $result = model('Arctype')->batchAddTopData($saveData, $post);
            if (!empty($result)) {
                \think\Cache::clear('arctype');
                $typenameArr = get_arr_column($result, 'typename');
                $typenameStr = implode(',', $typenameArr);
                adminLog('批量增加分类：'.$typenameStr);

                // 生成静态页面代码
                $msg = '操作成功！';
                $seo_pseudo = config('tpcache.seo_pseudo');
                if (2 == $seo_pseudo) {
                    $msg = '操作成功，请手工生成静态页面！';
                }
                $this->success($msg, url('Arctype/lists'));
                exit;
            }
        }
        $this->error("操作失败！");
    }

    /**
     * 批量增加下级分类
     */
    private function batch_add_subtype($post = [])
    {
        // 获取所属分类信息
        $arctypeInfo = Db::name('arctype')->field('id,channeltype,topid,parent_id,grade')->where('id', $post['parent_id'])->find();

        $topid = 0;
        if (!empty($arctypeInfo['topid'])) {
            $topid = $arctypeInfo['topid'];
        } else {
            if ($arctypeInfo['grade'] == 0) {
                $topid = $arctypeInfo['id'];
            } else if ($arctypeInfo['grade'] == 1) {
                $topid = $arctypeInfo['parent_id'];
            }
        }

        $saveData = [];
        $dirnameArr = [];
        $arctype_maxid = create_next_id('arctype', 'id', []); 
        foreach ($post['reltype'] as $key => $val) {
            $typename = func_preg_replace([',','，'], '', trim($val));
            if (empty($typename)) continue;

            // 目录名称
            $dirname = $this->arctypeLogic->get_dirname($typename, '', 0, $dirnameArr, false);
            array_push($dirnameArr, $dirname);

            $dirpath = $post['dirpath'].'/'.$dirname;

            $data = [
                'id'=> $arctype_maxid, // 父ID
                'typename'  => $typename,
                'channeltype'   => $arctypeInfo['channeltype'],
                'current_channel'   => empty($post['current_channel']) ? $arctypeInfo['channeltype'] : $post['current_channel'],
                'parent_id' => intval($post['parent_id']),
                'topid'     => $topid,
                'dirname'   => $dirname,
                'dirpath'   => $dirpath,
                'diy_dirpath'   => $dirpath,
                'grade' => intval($post['grade']),
                'litpic' => !empty($post['litpic_local_1'][$key]) ? $post['litpic_local_1'][$key] : '',
                'templist'  => !empty($post['templist']) ? $post['templist'] : '',
                'tempview'  => !empty($post['tempview']) ? $post['tempview'] : '',
                'is_hidden'  => $post['is_hidden'],
                'seo_description'   => '',
                'admin_id'  => session('admin_info.admin_id'),
                'lang'  => $this->admin_lang,
                'sort_order'    => !empty($post['sort_order_1'][$key]) ? intval($post['sort_order_1'][$key]) : 100,
                'add_time'  => getTime(),
                'update_time'  => getTime(),
            ];

            $saveData[] = $data;
             $arctype_maxid +=1;
        }

        $langlist = Db::name('language')->field('mark')->where('mark','neq',$this->admin_lang)->select();
        foreach ($langlist as $lgval) {
            foreach ($saveData as $_v) {
                $_v['lang']=$lgval['mark'];                
                $saveData2[] = $_v;
            }
        }       
        if($saveData2 && is_array($saveData2)){
            $saveData = array_merge($saveData,$saveData2);
        } 
        if (!empty($saveData)) {
            $result = model('Arctype')->batchAddSubData($saveData,'');
            if (!empty($result)) {
                \think\Cache::clear('arctype');
                $typenameArr = get_arr_column($result, 'typename');
                $typenameStr = implode(',', $typenameArr);
                adminLog('批量增加分类：'.$typenameStr);

                // 生成静态页面代码
                $msg = '操作成功！';
                $seo_pseudo = config('tpcache.seo_pseudo');
                if (2 == $seo_pseudo) {
                    $msg = '操作成功，请手工生成静态页面！';
                }
                $this->success($msg, url('Arctype/lists'));
                exit;
            }
        }
        $this->error("操作失败！");
    }

    /**
     * 单页可视化入口
     */
    public function single_uiset()
    {
        $tid = input('param.tid/d');
        $v = input('param.v/s', 'pc');
        if (!empty($tid)) {
            if ('mobile' == $v) {
                $gourl = ROOT_DIR."/index.php?m=home&c=Lists&a=index&tid={$tid}&uiset=on&v={$v}&lang=".$this->admin_lang;
                $url = ROOT_DIR."/index.php?m=api&c=Uiset&a=mobileTpl&tid={$tid}&gourl=".base64_encode($gourl);
            } else {
                $url = ROOT_DIR."/index.php?m=home&c=Lists&a=index&tid={$tid}&uiset=on&v={$v}&lang=".$this->admin_lang;
            }
            $this->redirect($url);
        }
    }

    // AI翻译
    public function help()
    {
        $tid = input('tid/d', 0);
        $this->assign('tid', $tid);

        return $this->fetch();
    }
}