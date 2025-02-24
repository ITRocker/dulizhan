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

use think\Page;
use think\Db;
use think\Cache;

/**
 * 插件的控制器
 */
class Language extends Base
{
    /**
     * 语言库模型
     */
    public $langModel;

    /**
     * 国家语言模型
     */
    public $langMarkModel;

    /**
     * 语言包模型
     */
    public $langPackModel;

    /**
     * 构造方法
     */
    public function __construct(){
        parent::__construct();
        $this->langModel = model('Language');
        $this->langMarkModel = model('LanguageMark');
        $this->langPackModel = model('LanguagePack');
    }

    /**
     * 多语言 - 列表
     */
    public function index()
    {
        function_exists('set_time_limit') && set_time_limit(0); //防止备份数据过程超时

        $list = array();
        $keywords = input('keywords/s');

        $map = array();
        if (!empty($keywords)) {
            $map['title'] = array('LIKE', "%{$keywords}%");
        }
        // 获取当前访问的域名        
        $domain = $_SERVER['HTTP_HOST'];        
        $parts = explode('.', $domain);        
        if (count($parts) > 2) {
            $domain = implode('.', array_slice($parts, -2));
        }        
        if ((!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') || $_SERVER['SERVER_PORT'] == 443) {
            $protocol = 'https://';
        } else {
            $protocol = 'http://';
        }
        $this->assign('protocol', $protocol); 
        $this->assign('domain', $domain); 
        $language_db = Db::name('language');
        $count = $language_db->where($map)->count('id');// 查询满足要求的总记录数
        $pageObj = new Page($count, config('paginate.list_rows'));// 实例化分页类 传入总记录数和每页显示的记录数
        $list = $language_db->where($map)
            ->order('is_home_default desc, sort_order asc, id asc')
            ->limit($pageObj->firstRow.','.$pageObj->listRows)
            ->select();
        if (!empty($list)) {
            $marks = get_arr_column($list, 'mark');
            $languagemarkList = Db::name('language_mark')->field('mark,cn_title')
                ->where([
                    'mark'  => ['IN', $marks]
                ])->getAllWithIndex('mark');
            $this->assign('languagemarkList', $languagemarkList);
            foreach ($list as $key => $value) {
                if(empty($value['url'])){
                    $value['langurl'] = langurl($value); 
                }else{
                    $value['langurl'] =$protocol.$value['url'].'.'.$domain;
                }
                $list2[]=$value;
            }
        }
        $pageStr = $pageObj->show(); // 分页显示输出
        $this->assign('list', $list2); // 赋值数据集
        $this->assign('pageStr', $pageStr); // 赋值分页输出
        $this->assign('pageObj', $pageObj); // 赋值分页对象

        return $this->fetch();
    }

    /**
     * 多语言 - 功能配置
     */
    public function conf()
    {
        if (IS_POST) {
            $post = input('post.');
            $tpCacheData = [];
            $language_split = 0;
            foreach ($post as $key => $val) {
                if (in_array($key, ['language'])) {
                    $language_split = $val['language_split'];
                    $tpCacheData[$key] = $val;
                }
            }
            if (!empty($tpCacheData)) {
                foreach ($tpCacheData as $key => $val) {
                    $langRow = Db::name('language')->order('id asc')->select();
                    foreach ($langRow as $_k => $_v) {
                        tpCache($key, $val, $_v['mark']);
                    }
                }
                adminLog("多语言分离：".($language_split ? '开启' : '关闭'));
            }
            $this->success('保存成功');
        }

        return $this->fetch();
    }

    /**
     * 多语言 - 新增
     */
    public function add()
    {
        //防止php超时
        function_exists('set_time_limit') && set_time_limit(0);
        @ini_set('memory_limit','-1');
        $functionLogic = new \app\common\logic\FunctionLogic;
        $functionLogic->validate_authorfile(1);
        if (IS_POST) {
            $post = input('post.');
            $mark = addslashes(trim($post['mark']));
            $count = $this->langModel->where('mark',$mark)->count();
            if (!empty($count)) {
                $this->error('该语言已存在，请检查');
            }
            $langInfo = Db::name('language_mark')->where(['mark'=>$mark])->find();
            /*组装存储数据*/
            $saveData = array(
                'title' => $langInfo['title'],
                'mark' => $mark,
                'domain' => $mark,
                'status' => 1,
                'sort_order' => 100,
                'add_time'    => getTime(),
                'update_time'    => getTime(),
            );
            /*--end*/
            $this->langModel->delLangData([$mark]); // 创建时删除多余的语言数据
            $this->langModel->save($saveData);
            $insertId = $this->langModel->id;
            if (false !== $insertId) {
                $post = $saveData;
                $post['copy_lang'] = Db::name('language')->order('is_home_default desc, status desc, id asc')->value('mark');
                $syn_status = $this->langModel->afterAdd($insertId, $post);
                if (false !== $syn_status) {
                    $this->langPackModel->updateLangFile([$mark]); // 生成语言包文件
                    adminLog('添加多语言：'.$saveData['title']); // 写入操作日志
                    $jump = 0;
                    if (!in_array($mark, $this->langModel->system_lang_arr())) {
                        $jump = 1;
                        cookie('pack_batch_save_jump_tips', 1);
                    }
                    $this->success("添加成功", url('Language/pack_batch_save', ['mark'=>$mark, 'jump'=>$jump]), ['mark'=>$mark, 'jump'=>$jump]);
                } else {
                    $id_arr = [$insertId];
                    $lang_list = [$mark];
                    $this->langModel->where("id",'IN',$id_arr)->delete();
                    $this->langModel->afterDel($id_arr, $lang_list);
                    $this->error("同步数据失败，请重新添加");
                }
            }
            $this->error("操作失败");
        }

        $assign_data = [];
        $use_marks = Db::name('language')->column('mark');
        $assign_data['languagemark'] = $this->langMarkModel
            ->field('title,mark,cn_title')
            ->where(['status'=>1, 'mark'=>['NOTIN', $use_marks]])
            ->order('sort_order asc, pinyin asc')
            ->select(); // 多国语言列表
        $this->assign($assign_data);

        return $this->fetch();
    }
    
    /**
     * 多语言 - 编辑
     */
    public function edit()
    {
        if (IS_POST) {
            $post = input('post.');
            $post['id'] = eyIntval($post['id']);
            if(!empty($post['id'])){
                $is_home_default = intval($post['is_home_default']);
                $mark = $post['mark'] = trim($post['mark']);
                $post['url'] = trim($post['url']);

                $count = $this->langModel->where([
                    'mark'=>$mark,
                    'id'=>['NEQ', $post['id']]
                ])->count();
                if (!empty($count)) {
                    $this->error('该语言已存在，请检查');
                }                
                if(!empty($post['url']) && empty($is_home_default)){
                    if (Db::name('language')->where(['id'=>['neq',$post['id']],'url'=>$post['url']])->count()) {
                        $this->error('域名已绑定其他语言');
                    }
                    $post['is_open'] = 1;                    
                }else{
                    $post['is_open'] = 0;                    
                    $post['url'] = '';
                }                        
                // 至少要保留一种语言是启用状态
                if (empty($post['status'])) {
                    $return = $this->langModel->isValidateStatus('status', $post['status']);
                    if (is_array($return)) {
                        $this->error($return['msg']);
                    }
                }
                /*组装存储数据*/
                $nowData = array(
                    'is_home_default'    => $is_home_default,
                    'is_admin_default'    => $is_home_default,
                    'update_time'    => getTime(),
                );                
                $saveData = array_merge($post, $nowData);
                /*--end*/
                $r = $this->langModel->save($saveData, ['id'=>$post['id']]);
                if ($r !== false) {
                    if($saveData['url']){
                        $diy_domain = get_domain($saveData['mark']);
                    }else{
                        $diy_domain = get_domain();
                    }
                    Db::name('config')->where(['lang'=>$saveData['mark'],'name'=>'web_basehost'])->update([
                        'value' => $diy_domain,
                        'update_time' => getTime(),
                    ]);
                    /*默认语言的设置*/
                    if (1 == $is_home_default) { // 设置默认语言，只允许有一个是默认，其他取消
                        $this->langModel->where('id','NEQ',$post['id'])->update([
                            'is_home_default' => 0,'is_admin_default' => 0,
                            'update_time' => getTime(),
                        ]);
                        /*多语言 设置默认前台语言*/
                        $langRow = \think\Db::name('language')->order('id asc')->select();
                        foreach ($langRow as $key => $val) {
                            tpCache('system', ['system_home_default_lang'=>$mark], $val['mark']);
                        }
                        //设置其他语言为前台默认语言，执行模式切换操作
                        if ($mark != 'cn'){
                            $seo_pseudo = tpCache('global.seo_pseudo');
                            //前台默认语言不是中文的时候，不允许使用静态模式，强制转换为伪静态
                            if ($seo_pseudo == 2){
                                tpCache('seo',['seo_pseudo'=>3],'cn');
                                tpCache('seo',['seo_pseudo'=>3],$mark);
                            }
                            del_html_dirpath();
                        }
                        /*--end*/
                    } else { // 默认语言取消之后，自动将第一个语言设置为默认
                        $count = Db::name('language')->where(['is_home_default'=>1])->count();
                        if (empty($count)) {
                            $langInfo = Db::name('language')->field('id,mark')->order('id asc')->limit(1)->find();
                            $this->langModel->where('id','eq',$langInfo['id'])->update([
                                'is_home_default' => 1,'is_admin_default' => 1,
                                'update_time' => getTime(),
                            ]);
                            /*多语言 设置默认前台语言*/
                            $langRow = \think\Db::name('language')->order('id asc')->select();
                            foreach ($langRow as $key => $val) {
                                tpCache('system', ['system_home_default_lang'=>$langInfo['mark']], $val['mark']);
                            }
                            /*--end*/
                        }
                    }
                    /*--end*/

                    // 统计多语言数量
                    $this->langModel->setLangNum();
                    
                    adminLog('编辑多语言：'.$post['title']); // 写入操作日志
                    $this->success("操作成功", url('Language/index'));
                }
            }
            $this->error("操作失败");
        }        
        $host = $_SERVER['HTTP_HOST']; 
        $hostarr = explode('.',$host);
        $ymstr = $hostarr[1].'.'.$hostarr[2];
        $id = input('id/d', 0);
        $row = $this->langModel->find($id);
        $row['cn_title'] = Db::name('language_mark')->where([
                'mark'  => $row['mark']
            ])->getField('cn_title');
        if (empty($row)) {
            $this->error('数据不存在，请联系管理员！');
            exit;
        }
        $this->assign('row',$row);
        $this->assign('ymstr',$ymstr);

        $count = Db::name('language')->count();
        $this->assign('count', $count);

        return $this->fetch();
    }
    
    /**
     * 多语言 - 删除文档
     */
    public function del()
    {
        //防止php超时
        function_exists('set_time_limit') && set_time_limit(0);
        
        $id_arr = input('del_id/a');
        $id_arr = eyIntval($id_arr);
        if(IS_POST && !empty($id_arr)){

            /*不允许删除默认语言*/
            $count = $this->langModel->where([
                    'id'    => ['IN', $id_arr],
                    'is_home_default' => 1,
                ])->count();
            if (!empty($count)) {
                $this->error('禁止删除默认语言');
            }
            /*--end*/

            $result = Db::name('language')->where("id",'IN',$id_arr)->select();
            $title_list = get_arr_column($result, 'title');
            $lang_list = get_arr_column($result, 'mark');

            $r = $this->langModel->where("id",'IN',$id_arr)->delete();
            if($r !== false){
                $this->langModel->afterDel($id_arr, $lang_list);
                adminLog('删除多语言：'.implode(',', $title_list));
                $this->success("删除成功");
            }
        }
        $this->error("删除失败");
    }

    /**
     * 模板语言变量
     */
    public function pack_index()
    {
        $list = array();
        $param = input('param.');
        $keywords = input('param.keywords/s');
        $mark = input('param.mark/s');
        $condition = array();
        // 应用搜索条件
        foreach (['keywords'] as $key) {
            if (isset($param[$key]) && $param[$key] !== '') {
                if ($key == 'keywords') {
                    $condition['a.name|a.value'] = array('LIKE', "%{$param[$key]}%");
                } else {
                    $condition['a.'.$key] = array('eq', $param[$key]);
                }
            }
        }

        // 多语言
        $condition['a.lang'] = $mark;

        $pack_db =  Db::name('language_pack');
        $count = $pack_db->alias('a')->where($condition)->count();// 查询满足要求的总记录数
        $Page = $pager = new Page($count, config('paginate.list_rows'));// 实例化分页类 传入总记录数和每页显示的记录数
        $list = $pack_db->alias('a')
            ->where($condition)
            ->order('type asc, pack_id asc')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        $this->assign('page',$Page->show());// 赋值分页输出
        $this->assign('list',$list);// 赋值数据集
        $this->assign('pager',$pager);// 赋值分页对象

        return $this->fetch();
    }

    /**
     * 模板语言变量 - 新增
     */
    public function pack_add()
    {
        $type = 99;
        $this->assign('type', $type);

        if (IS_POST) {
            $new_pack_id = create_next_id('language_pack', 'pack_id', ['is_system'=>0]);
            $name = "diy{$new_pack_id}";
            $values = input('post.value/a', '', 'strip_sql');

            $saveData = [];
            $languageRow = Db::name('language')->field('mark')
                ->order('is_home_default desc, sort_order asc, id asc')
                ->select();
            foreach ($languageRow as $key => $val) {
                $saveData[] = [
                    'pack_id' => $new_pack_id,
                    'type' => $type,
                    'name' => $name,
                    'value' => !empty($values[$val['mark']]) ? $values[$val['mark']] : '',
                    'is_system' => 0,
                    'lang'  => $val['mark'],
                    'sort_order'    => 100,
                    'add_time'  => getTime(),
                    'update_time'  => getTime(),
                ];
            }

            $r = $this->langPackModel->saveAll($saveData);
            if (false !== $r) {
                $this->langPackModel->updateLangFile(); // 生成语言包文件
                adminLog('新增语言变量：'.$name); // 写入操作日志
                $this->success("操作成功", url('Language/pack_batch_save', ['type'=>$type,'opt_source'=>'pack_add']));
            }else{
                $this->error("操作失败");
            }
        }

        $languageRow = Db::name('language')->field('mark,title,is_home_default')
            ->order('is_home_default desc, sort_order asc, id asc')
            ->select();
        $this->assign('languageRow', $languageRow);
        // 分组
        $this->assign('pack_type_arr', $this->langPackModel->pack_type_arr);

        return $this->fetch();
    }

    /**
     * 模板语言变量 - 批量新增
     */
    public function pack_batch_add()
    {
        //防止php超时
        function_exists('set_time_limit') && set_time_limit(0);
        
        $type = input('param.type/d', 1);
        $this->assign('type', $type);

        // 语言列表
        $languageRow = Db::name('language')->field('mark,title')
            ->order('id asc')
            ->select();

        if (IS_POST) {
            $content = input('post.content/s', '', 'strip_sql');

            $tmp_content = trim(str_replace(PHP_EOL,"",$content)); //去掉回车换行符号
            if (empty($tmp_content)) {
                $this->error('数据不能为空！');
            }

            $r = true;
            $saveDataAll = [];
            $time = getTime();
            $new_pack_id = create_next_id('language_pack', 'pack_id', ['is_system'=>0]);
            $data = explode(PHP_EOL, $content);
            foreach ($data as $key => $val) {
                $val = trim($val);
                if (empty($val)) {
                    continue;
                }
                $values = explode('=', str_replace('＝', '=', $val));
                foreach ($languageRow as $k2 => $v2) {
                    $saveDataAll[] = [
                        'pack_id' => $new_pack_id,
                        'type' => $type,
                        'name'  => 'lang'.$new_pack_id,
                        'value' => !empty($values[$k2]) ? $values[$k2] : '',
                        'lang'  => $v2['mark'],
                        'sort_order'    => 100,
                        'add_time'  => $time,
                        'update_time'  => $time,
                    ];
                }
                $new_pack_id++;
            }
            if (!empty($saveDataAll)) {
                $r = $this->langPackModel->saveAll($saveDataAll);
            }

            if (false !== $r) {
                $this->langPackModel->updateLangFile(); // 生成语言包文件
                adminLog('新增语言变量：'.str_replace(PHP_EOL, '|', $content)); // 写入操作日志
                $this->success("操作成功", url('Language/pack_index'));
            }else{
                $this->langPackModel->where(['add_time'=>$time])->delete();
                $this->error("操作失败");
            }
        }

        $languageStr = implode('=', get_arr_column($languageRow, 'title')).PHP_EOL;
        $this->assign('languageStr', $languageStr);

        return $this->fetch();
    }

    /**
     * 模板语言变量 - 编辑
     */
    public function pack_edit()
    {
        if (IS_POST) {
            $auto_id = input('post.auto_id/d');
            $name = strtolower(input('post.name/s'));
            $values = input('post.value/a', '', 'strip_sql');
            $languagepack_db = Db::name('language_pack');

            // 旧的变量名
            $old_name = $languagepack_db->where([
                    'auto_id'  => $auto_id,
                    'lang'    => $this->admin_lang,
                ])->getField('name');

            // 检测变量名
            if ($old_name != $name) {
                if (preg_match('/^(sys)(\d+)$/i', $name)) {
                    $this->error('禁止使用sys+数字的变量名，请更换');
                } else if (!preg_match('/^([\w\-]+)$/i', $name)) {
                    $this->error('仅支持字母、数字、下划线、连接符，不区分大小写');
                }
            }

            $count = $languagepack_db->where([
                    'name'  => $name,
                    'auto_id'    => ['NEQ', $auto_id],
                    'lang'  => $this->admin_lang,
                ])->count();
            if (!empty($count)) {
                $this->error('该变量名已存在，请检查');
            }

            // 所有语言对应此变量的id
            $idRow = $languagepack_db->field('auto_id,lang')
                ->where(['name'=>$old_name])
                ->getAllWithIndex('lang');

            // 更新变量值
            $updateData = [];
            foreach ($values as $key => $val) {
                $updateData[] = [
                    'auto_id' => $idRow[$key]['auto_id'],
                    'name' => $name,
                    'lang' => $key,
                    'value' => $val,
                    'update_time'   => getTime(),
                ];
            }
            $r = $this->langPackModel->saveAll($updateData);
            if (false !== $r) {
                $this->langPackModel->updateLangFile(); // 生成语言包文件
                adminLog('编辑语言变量：'.$name); // 写入操作日志
                $this->success("操作成功", url('Language/pack_index'));
            }else{
                $this->error("操作失败");
            }
        }

        $id = input('id/d');
        $row = Db::name('language_pack')->where([
                'auto_id'    => $id,
                'lang'  => $this->admin_lang,
            ])->find();
        if (empty($row)) {
            $this->error('数据不存在，请联系管理员！');
            exit;
        }
        $this->assign('row',$row);

        // 语言列表
        $languageRow = Db::name('language')->field('mark,title')
            ->order('sort_order asc,id asc')
            ->select();
        $this->assign('languageRow', $languageRow);

        // 变量值列表
        $values = Db::name('language_pack')->field('lang,value')->where([
                'name'    => $row['name'],
            ])->getAllWithIndex('lang');
        $this->assign('values', $values);

        return $this->fetch();
    }
    
    /**
     * 模板语言变量 - 删除
     */
    public function pack_del()
    {
        if (IS_POST) {
            $type = input('param.type/d', 0);
            $id_arr = input('del_id/a');
            $id_arr = eyIntval($id_arr);
            if(!empty($id_arr)){
                $count = Db::name('language_pack')->where([
                        'pack_id'    => ['IN', $id_arr],
                        'type'  => $type,
                        'is_system'=> 1,
                    ])->count();
                if (!empty($count)) {
                    $this->error('官方内置语言变量，禁止删除');
                }

                $names = Db::name('language_pack')->where([
                        'pack_id'    => ['IN', $id_arr],
                        'type'  => $type,
                    ])->column('name');

                $r = Db::name('language_pack')->where([
                        'pack_id'    => ['IN', $id_arr],
                        'type'  => $type,
                    ])->delete();
                if ($r !== false) {
                    $this->langPackModel->updateLangFile(); // 生成语言包文件
                    adminLog('删除语言变量：'.implode(',', $names));
                    $this->success('删除成功');
                }
            }
        }
        $this->error('删除失败');
    }
    
    /**
     * 语言变量列表
     */
    public function pack_batch_save()
    {
        //防止php超时
        function_exists('set_time_limit') && set_time_limit(0);
        @ini_set('memory_limit','-1');
        
        if (IS_POST) {
            $type = input('post.type/d', 1);
            $post = input('post.', '', 'strip_sql');

            /*if (empty($post['value'])) {
                $this->error('至少添加一个语言变量！');
            } else {
                $is_empty = false;
                $empty_value_key = 0;
                foreach ($post['value'] as $mark => $val) {
                    foreach ($val as $_k => $_v) {
                        $_v = trim($_v);
                        if (empty($_v)) {
                            $is_empty = true;
                            $empty_value_key = $_k;
                            break;
                        }
                    }
                    if (true === $is_empty) {
                        break;
                    }
                }
                if (true === $is_empty) {
                    $this->error('请填写全部数据！', null, ['empty_value_key'=>$empty_value_key, 'mark'=>$mark]);
                }
            }*/

            // 数据拼装
            $now_time = getTime();
            // $new_pack_id = create_next_id('language_pack', 'pack_id', ['is_system'=>1]);
            $addData = $editData = [];
            foreach ($post['value'] as $mark => $val) {
                foreach ($val as $_k => $_v) {
                    $_v  = trim($_v);
                    if (!empty($_v)) {
                        if (empty($post['auto_id'][$mark][$_k])) {
                            // $addData[] = [
                            //     'pack_id' => $new_pack_id,
                            //     'type' => $type,
                            //     'sort_order' => $post['sort_order'][$mark][$_k] ? intval($post['sort_order'][$mark][$_k]) : 100,
                            //     'lang' => $mark,
                            //     'add_time' => $now_time,
                            //     'update_time' => $now_time,
                            // ];
                        } else {
                            if (trim($post['value'][$mark][$_k]) != trim($post['old_value'][$mark][$_k])) {
                                $auto_id = intval($post['auto_id'][$mark][$_k]);
                                $editData[] = [
                                    'auto_id' => $auto_id,
                                    'value' => $_v,
                                    'update_time' => $now_time,
                                ];
                            }
                        }
                    }
                }
            }

            if (!empty($addData)) {
                $this->langPackModel->saveAll($addData);
            }

            $r = true;
            if (!empty($editData)) {
                $r = $this->langPackModel->saveAll($editData);
            }

            if ($r !== false) {
                Cache::clear('language_pack');
                $this->langPackModel->updateLangFile(); // 生成语言包文件
                adminLog('保存语言变量');
                $this->success('操作成功', url('language/pack_batch_save'));
            }
        }

        $assign_data = [];
        $assign_data['mark'] = input('param.mark/s');
        $assign_data['jump'] = input('param.jump/d', 0);
        $assign_data['type'] = $type = input('param.type/d', 0);

        // 完善语言变量为空的记录
        $this->langPackModel->update_empty_pack_data($assign_data['mark']);

        $packlist = array();
        $param = input('param.');
        $keywords = input('keywords/s');
        $keywords = trim($keywords);
        $condition = [];
        // 应用搜索条件
        foreach (['keywords'] as $key) {
            if (isset($param[$key]) && $param[$key] !== '') {
                if ($key == 'keywords') {
                    $pack_ids = Db::name('language_pack')->where(['name|value'=>['LIKE', "%{$keywords}%"]])->column('pack_id');
                    $condition['pack_id'] = array('IN', $pack_ids);
                } else {
                    $condition[$key] = array('eq', trim($param[$key]));
                }
            }
        }
        if (!empty($type)) {
            $condition['type'] = $type;
        } else {
            if ($this->php_servicemeal <= 1) {
                $condition['type'] = ['IN', array_keys($this->langPackModel->pack_type_arr)];
            }
        }
        $condition['lang'] = 'cn';
        $condition['pack_id'] = ['NOTIN', model('LanguagePack')->getUsersParameterPackIds()];

        $count = Db::name('language_pack')->where($condition)->count('auto_id');// 查询满足要求的总记录数
        $Page = $pager = new Page($count, 50);// 实例化分页类 传入总记录数和每页显示的记录数
        $packlist = Db::name('language_pack')->where($condition)->order('type asc,sort_order asc, pack_id asc')->limit($Page->firstRow.','.$Page->listRows)->select();
        $assign_data['page'] = $pager->show();// 分页显示输出
        $assign_data['pager'] = $pager;

        $pack_ids = [];
        foreach ($packlist as $key => $val) {
            $pack_ids[] = $val['pack_id'];
        }

        $languageList = Db::name('language')->alias('a')
            ->field('a.title,a.mark,b.cn_title')
            ->join('language_mark b', 'a.mark = b.mark', 'left')
            ->order('a.is_home_default desc, a.sort_order asc, a.id asc')
            ->getAllWithIndex('mark');
        $assign_data['languageList'] = $languageList;

        $data = array();
        $where = [
            'pack_id'=>['IN', $pack_ids],
            'is_system' => (99 == $type) ? 0 : 1,
        ];
        $result = Db::name('language_pack')->where($where)->order('lang asc, type asc, sort_order asc, pack_id asc')->select();
        foreach ($result as $k => $v) {
            $data[$v['lang']]['list'][$v['name']] = $v;
            $data[$v['lang']]['info'] = $languageList[$v['lang']];
        }
        $assign_data['data'] = $data;

        // 分组
        $assign_data['pack_type_arr'] = $this->langPackModel->pack_type_arr;

        $this->assign($assign_data);

        // 豆包翻译API配置
        $doubao = tpSetting('doubao', [], $this->show_lang);
        $this->assign('doubao', $doubao);

        return $this->fetch();
    }

    public function ajax_update_sort_order()
    {
        $id_arr = input('ids/a');
        $id_arr = eyIntval($id_arr);
        if (!empty($id_arr)) {
            $data = [];
            foreach ($id_arr as $key => $val) {
                $data[] = [
                    'id' => $val,
                    'sort_order' => 10 + $key,
                ];
            }
            $r = $this->langModel->saveAll($data);
            if ($r !== false) {
                Cache::clear('language');
                $this->success('操作成功');
            }
        }
        $this->error('操作失败');
    }

    public function ajax_syn_language_pack()
    {
        $mark = input('param.mark/s');
        $mark = addslashes($mark);
        if (IS_POST && !empty($mark)) {
            $r = true;
            if (!in_array($mark, $this->langModel->system_lang_arr())) {
                // 默认语言的语言变量
                $default_lang = Db::name('language')->where(['is_home_default'=>1])->value('mark');
                $default_pack_list = Db::name('language_pack')->field('auto_id', true)->where(['lang'=>$default_lang])->getAllWithIndex('name');
                // 需要同步语言的语言变量
                $saveData = [];
                $pack_list = Db::name('language_pack')->field('auto_id,name,value')->where(['lang'=>$mark])->select();
                if (empty($pack_list)) {
                    foreach ($default_pack_list as $key => $val) {
                        $val['lang'] = $mark;
                        $saveData[] = $val;
                    }
                } else {
                    foreach ($pack_list as $key => $val) {
                        $val['value'] = empty($default_pack_list[$val['name']]) ? $val['value'] : $default_pack_list[$val['name']]['value'];
                        $saveData[] = $val;
                    }
                }
                !empty($saveData) && $r = $this->langPackModel->saveAll($saveData);
            }
            if ($r !== false) {
                $this->success('同步成功');
            }
        }
        $this->error('同步失败');
    }

    /**
     * ai翻译
     */
    public function help()
    {

        return $this->fetch();
    }
}
