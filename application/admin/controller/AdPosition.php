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

use think\Page;
use think\Db;
use think\Cache;

class AdPosition extends Base
{
    private $times = 0; // 当前时间戳
    private $ad_position_system_id = array(); // 系统默认位置ID，不可删除

    public function _initialize() {
        parent::_initialize();
        $this->times = getTime();
    }

    public function index()
    {
        $list = array();
        $get = input('get.');
        $keywords = input('keywords/s');
        $condition = [];
        // 应用搜索条件
        foreach (['keywords', 'type'] as $key) {
            $get[$key] = addslashes(trim($get[$key]));
            if (isset($get[$key]) && $get[$key] !== '') {
                if ($key == 'keywords') {
                    $condition['a.title'] = array('LIKE', "%{$get[$key]}%");
                } else {
                    $tmp_key = 'a.'.$key;
                    $condition[$tmp_key] = array('eq', $get[$key]);
                }
            }
        }

        // 多语言
        $condition['a.lang'] = array('eq', $this->admin_lang);

        $adPositionM =  Db::name('ad_position');
        $count = $adPositionM->alias('a')->where($condition)->count();// 查询满足要求的总记录数
        $Page = new Page($count, config('paginate.list_rows'));// 实例化分页类 传入总记录数和每页显示的记录数
        $list = $adPositionM->alias('a')->where($condition)->order('id desc')->limit($Page->firstRow.','.$Page->listRows)->getAllWithIndex('id');

        // 每组获取三张图片
        $pids = get_arr_column($list, 'id');
        $ad = Db::name('ad')->where(['pid' => ['IN', $pids], 'lang' => $this->admin_lang])->order('pid asc, id asc')->select();
        foreach ($list as $k => $v) {
            if (1 == $v['type']) {
                // 图片封面图片
                $v['ad'] = [];
                foreach ($ad as $m => $n) {
                    if ($v['id'] == $n['pid']) {
                        $n['litpic'] = get_default_pic($n['litpic']); // 支持子目录
                        $v['ad'][] = $n;
                        unset($ad[$m]);
                    } else {
                        continue;
                    }
                }
                // 若没有内容则显示默认图片
                if (empty($v['ad'])) {
                    $v['ad_count'] = 0;
                    $v['ad'][]['litpic'] = ROOT_DIR . '/public/static/common/images/not_adv.jpg';
                } else {
                    $v['ad_count'] = count($v['ad']);
                }
                // 广告类型
                $v['type_name'] = '图片';
            } else if (2 == $v['type']) {
                // 多媒体封面图片
                $v['ad'][]['litpic'] = ROOT_DIR . '/public/static/admin/images/ad_type_media.png';
                // 广告类型
                $v['type_name'] = '多媒体';
            } else if (3 == $v['type']) {
                // HTML代码封面图片
                $v['ad'][]['litpic'] = ROOT_DIR . '/public/static/admin/images/ad_type_html.png';
                // 广告类型
                $v['type_name'] = 'HTML代码';
            }
            $list[$k] = $v;
        }

        $show = $Page->show();// 分页显示输出
        $this->assign('page',$show);// 赋值分页输出
        $this->assign('list',$list);// 赋值数据集
        $this->assign('pager',$Page);// 赋值分页对象

        return $this->fetch();
    }
    
    /**
     * 新增
     */
    public function add()
    {
        //防止php超时
        function_exists('set_time_limit') && set_time_limit(0);

        if (IS_POST) {
            $post = input('post.');
            $map = array(
                'title' => trim($post['title']),
                'lang'  => $this->admin_lang,
            );
            if(Db::name('ad_position')->where($map)->count() > 0){
                $this->error('该广告名称已存在，请检查', url('AdPosition/index'));
            }

            $new_adv_id = create_next_id('ad_position', 'id');
            $langRow = Db::name('language')->order('id asc')->select();
            // 添加广告位置表信息
            $advData = [];
            foreach ($langRow as $key => $val) {
                $advData[] = [
                    'id'          => $new_adv_id,
                    'title'       => trim($post['title']),
                    'type'        => $post['type'],
                    'intro'       => $post['intro'],
                    'admin_id'    => session('admin_id'),
                    'lang'        => $val['mark'],
                    'add_time'    => $this->times,
                    'update_time' => $this->times,
                ];
            }
            $rdata = model('AdPosition')->saveAll($advData);
            if (false !== $rdata) {
                // 读取组合广告位的图片及信息
                $adData = [];
                $new_ad_id = create_next_id('ad', 'id');
                if (1 == $post['type'] && !empty($post['img_litpic'])) { // 图片类型
                    $i = 1;
                    foreach ($post['img_litpic'] as $key => $value) {
                        if (!empty($value)) {
                            foreach ($langRow as $_k => $_v) {
                                $adInfo = [];
                                // 主要参数
                                $adInfo['litpic'] = str_ireplace(['http:','https:'], "", $value);
                                $adInfo['id']    = $new_ad_id;
                                $adInfo['pid']    = $new_adv_id;
                                $adInfo['title']  = trim($post['img_title'][$key]);
                                $adInfo['links']  = $post['img_links'][$key];
                                $adInfo['intro']  = $post['img_intro'][$key];
                                $adInfo['target'] = !empty($post['img_target'][$key]) ? 1 : 0;
                                // 其他参数
                                $adInfo['media_type']  = 1;
                                $adInfo['admin_id']    = session('admin_id');
                                $adInfo['lang']        = $_v['mark'];
                                $adInfo['sort_order']  = $i;
                                $adInfo['add_time']    = $this->times;
                                $adInfo['update_time'] = $this->times;
                                $adData[] = $adInfo;
                            }
                            $i++;
                            $new_ad_id++;
                        }
                    }
                }
                else if (2 == $post['type'] && !empty($post['video_litpic'])) { // 媒体类型
                    foreach ($langRow as $_k => $_v) {
                        $adInfo = [];
                        // 主要参数
                        $adInfo['litpic'] = str_ireplace(['http:','https:'], "", $post['video_litpic']);
                        $adInfo['id']    = $new_ad_id;
                        $adInfo['pid']    = $new_adv_id;
                        $adInfo['title']  = trim($post['title']);
                        // 其他参数
                        $adInfo['intro']       = '';
                        $adInfo['links']       = '';
                        $adInfo['target']      = 0;
                        $adInfo['media_type']  = 2;
                        $adInfo['admin_id']    = session('admin_id');
                        $adInfo['lang']        = $_v['mark'];
                        $adInfo['sort_order']  = 1;
                        $adInfo['add_time']    = $this->times;
                        $adInfo['update_time'] = $this->times;
                        $adData[] = $adInfo;
                    }
                }
                else if (3 == $post['type'] && !empty($post['html_intro'])) { // HTML代码
                    foreach ($langRow as $_k => $_v) {
                        $adInfo = [];
                        // 主要参数
                        $adInfo['id']    = $new_ad_id;
                        $adInfo['pid']   = $new_adv_id;
                        $adInfo['title'] = trim($post['title']);
                        $adInfo['intro'] = $post['html_intro'];
                        // 其他参数
                        $adInfo['litpic']      = '';
                        $adInfo['links']       = '';
                        $adInfo['target']      = 0;
                        $adInfo['media_type']  = 3;
                        $adInfo['admin_id']    = session('admin_id');
                        $adInfo['lang']        = $_v['mark'];
                        $adInfo['sort_order']  = 1;
                        $adInfo['add_time']    = $this->times;
                        $adInfo['update_time'] = $this->times;
                        $adData[] = $adInfo;
                    }
                }
                $r = true;
                if (false !== $r && !empty($adData)) {
                    $r = model('Ad')->saveAll($adData);
                }
                if (false !== $r) {
                    Cache::clear('ad');
                    adminLog('新增广告：'.$post['title']);
                    $this->success("操作成功", url('AdPosition/index'));
                }
            }
            $this->error("操作失败", url('AdPosition/index'));
        }

        // 上传通道
        $WeappConfig = Db::name('weapp')->field('code, status')->where('code', 'IN', ['Qiniuyun', 'AliyunOss', 'Cos', 'AwsOss'])->select();
        $WeappOpen = [];
        foreach ($WeappConfig as $value) {
            if ('Qiniuyun' == $value['code']) {
                $WeappOpen['qny_open'] = $value['status'];
            } else if ('AliyunOss' == $value['code']) {
                $WeappOpen['oss_open'] = $value['status'];
            } else if ('Cos' == $value['code']) {
                $WeappOpen['cos_open'] = $value['status'];
            } else if ('AwsOss' == $value['code']) {
                $WeappOpen['aws_open'] = $value['status'];
            }
        }
        $this->assign('WeappOpen', $WeappOpen);

        // 系统最大上传视频的大小
        $upload_max_filesize = upload_max_filesize();
        $this->assign('upload_max_filesize', $upload_max_filesize);

        // 视频类型
        $media_type = !empty($this->globalConfig['media_type']) ? $this->globalConfig['media_type'] : config('global.media_ext');
        $media_type = str_replace(",", "|", $media_type);
        $assign_data['media_type'] = $media_type;
        $file_upload_media_type = '.'.str_replace("|", ",.", $media_type);
        $assign_data['file_upload_media_type'] = $file_upload_media_type;

        $this->assign($assign_data);
        return $this->fetch();
    }

    
    /**
     * 编辑
     */
    public function edit()
    {
        if (IS_POST) {
            $post = input('post.');
            if (!empty($post['id'])) {
                $post['title'] = trim($post['title']);
                $post['id'] = intval($post['id']);
                if (array_key_exists($post['id'], $this->ad_position_system_id)) {
                    $this->error("不可更改系统预定义位置", url('AdPosition/edit',array('id'=>$post['id'])));
                }

                /* 判断除自身外是否还有相同广告名称已存在 */
                $map = array(
                    'id'    => array('NEQ', $post['id']),
                    'title' => $post['title'],
                    'lang'  => $this->admin_lang,
                );
                if (Db::name('ad_position')->where($map)->count() > 0) $this->error('该广告名称已存在，请检查');
                /* END */

                /* 判断广告是否切换广告类型 */
                // $where = [
                //     'id'   => $post['id'],
                //     'type' => $post['type'],
                //     'lang' => $this->admin_lang
                // ];
                // if (Db::name('ad_position')->where($where)->count() == 0) {
                //     // 已切换广告类型，清除广告中的广告内容
                //     $where = [
                //         'pid'  => $post['id'],
                //     ];
                //     Db::name('ad')->where($where)->delete();
                // }
                /* END */

                /* 修改广告主体信息 */
                $advEditData = [];
                foreach ($post['intro'] as $mark => $val) {
                    $advEditData[] = [
                        'auto_id'     => empty($post['auto_id'][$mark]) ? 0 : intval($post['auto_id'][$mark]),
                        'title'       => $post['title'],
                        'type'        => $post['type'],
                        'intro'       => empty($post['intro'][$mark]) ? '' : $post['intro'][$mark],
                        'update_time' => $this->times,
                    ];
                }
                $resultID = model('AdPosition')->saveAll($advEditData);
                /* END */
            }

            if (false !== $resultID) {
                $init_ad_id = create_next_id('ad', 'id');
                $langRow = Db::name('language')->order('id asc')->select();
                $adAddData = $adEditData = [];
                if (1 == $post['type'] && !empty($post['img_litpic'])) { // 图片类型
                    // 读取组合广告位的图片及信息
                    foreach ($post['img_litpic'] as $mark => $val) {
                        $i = 1;
                        $new_ad_id = $init_ad_id;
                        foreach ($val as $_k => $_v) {
                            if (!empty($_v)) {
                                // 去掉http: / https:
                                $litpic = str_ireplace(['http:','https:'], "", $post['img_litpic'][$mark][$_k]);
                                // 是否新窗口打开
                                $target = !empty($post['img_target'][$mark][$_k]) ? 1 : 0;
                                // 广告ID，为空则表示添加
                                $ad_id = $post['img_id'][$mark][$_k];
                                if (!empty($ad_id)) {
                                    // 查询更新条件
                                    $where = [
                                        'id'   => $ad_id,
                                        'lang' => $mark,
                                    ];
                                    if (Db::name('ad')->where($where)->count() > 0) {
                                        $adInfo = [];
                                        // 主要参数
                                        $adInfo['auto_id']     = $post['img_auto_id'][$mark][$_k];
                                        $adInfo['litpic']      = $litpic;
                                        $adInfo['title']       = empty($post['img_title'][$mark][$_k]) ? '' : $post['img_title'][$mark][$_k];
                                        $adInfo['links']       = empty($post['img_links'][$mark][$_k]) ? '' : $post['img_links'][$mark][$_k];
                                        $adInfo['intro']       = empty($post['img_intro'][$mark][$_k]) ? '' : $post['img_intro'][$mark][$_k];
                                        $adInfo['target']      = $target;
                                        // 其他参数
                                        $adInfo['sort_order']  = $i++;
                                        $adInfo['update_time'] = $this->times;
                                        $adEditData[] = $adInfo;
                                    } else {
                                        $adInfo = [];
                                        // 主要参数
                                        $adInfo['id']          = $new_ad_id;
                                        $adInfo['litpic']      = $litpic;
                                        $adInfo['pid']         = $post['id'];
                                        $adInfo['title']       = empty($post['img_title'][$mark][$_k]) ? '' : $post['img_title'][$mark][$_k];
                                        $adInfo['links']       = empty($post['img_links'][$mark][$_k]) ? '' : $post['img_links'][$mark][$_k];
                                        $adInfo['intro']       = empty($post['img_intro'][$mark][$_k]) ? '' : $post['img_intro'][$mark][$_k];
                                        $adInfo['target']      = $target;
                                        // 其他参数
                                        $adInfo['media_type']  = 1;
                                        $adInfo['admin_id']    = session('admin_id');
                                        $adInfo['lang']        = $mark;
                                        $adInfo['sort_order']  = $i++;
                                        $adInfo['add_time']    = $this->times;
                                        $adInfo['update_time'] = $this->times;
                                        $new_ad_id++;
                                        $adAddData[] = $adInfo;
                                    }
                                } else {
                                    $adInfo = [];
                                    // 主要参数
                                    $adInfo['id']          = $new_ad_id;
                                    $adInfo['litpic']      = $litpic;
                                    $adInfo['pid']         = $post['id'];
                                    $adInfo['title']       = empty($post['img_title'][$mark][$_k]) ? '' : $post['img_title'][$mark][$_k];
                                    $adInfo['links']       = empty($post['img_links'][$mark][$_k]) ? '' : $post['img_links'][$mark][$_k];
                                    $adInfo['intro']       = empty($post['img_intro'][$mark][$_k]) ? '' : $post['img_intro'][$mark][$_k];
                                    $adInfo['target']      = $target;
                                    // 其他参数
                                    $adInfo['media_type']  = 1;
                                    $adInfo['admin_id']    = session('admin_id');
                                    $adInfo['lang']        = $mark;
                                    $adInfo['sort_order']  = $i++;
                                    $adInfo['add_time']    = $this->times;
                                    $adInfo['update_time'] = $this->times;
                                    $new_ad_id++;
                                    $adAddData[] = $adInfo;
                                }
                            }
                        }
                    }
                }
                else if (2 == $post['type'] && !empty($post['video_litpic'])) { // 媒体类型
                    foreach ($post['video_litpic'] as $mark => $val) {
                        // 去掉http: / https:
                        $video_litpic = str_ireplace(['http:','https:'], "", $post['video_litpic'][$mark]);
                        if (!empty($post['video_id'][$mark])) {
                            $adInfo = [];
                            // 更新广告内容
                            $adInfo['auto_id']     = $post['video_auto_id'][$mark];
                            $adInfo['litpic']      = $video_litpic;
                            $adInfo['title']       = $post['title'];
                            $adInfo['media_type']  = 2;
                            $adInfo['update_time'] = $this->times;
                            $adEditData[] = $adInfo;
                        } else {
                            $adInfo = [];
                            // 新增广告内容
                            $adInfo['id']          = $new_ad_id;
                            $adInfo['litpic']      = $video_litpic;
                            $adInfo['pid']         = $post['id'];
                            $adInfo['title']       = $post['title'];
                            $adInfo['links']       = '';
                            $adInfo['intro']       = '';
                            $adInfo['target']      = 0;
                            $adInfo['media_type']  = 2;
                            $adInfo['admin_id']    = session('admin_id');
                            $adInfo['lang']        = $mark;
                            $adInfo['sort_order']  = 1;
                            $adInfo['add_time']    = $this->times;
                            $adInfo['update_time'] = $this->times;
                            $adAddData[] = $adInfo;
                        }
                    }
                }
                else if (3 == $post['type'] && !empty($post['html_intro'])) { // HTML代码
                    foreach ($post['html_intro'] as $mark => $val) {
                        if (!empty($post['html_id'][$mark])) {
                            $adInfo = [];
                            // 更新广告内容
                            $adInfo['auto_id']     = $post['html_auto_id'][$mark];
                            $adInfo['title']       = $post['title'];
                            $adInfo['intro']       = empty($post['html_intro'][$mark]) ? '' : $post['html_intro'][$mark];
                            $adInfo['media_type']  = 3;
                            $adInfo['update_time'] = $this->times;
                            $adEditData[] = $adInfo;
                        } else {
                            $adInfo = [];
                            // 新增广告内容
                            $adInfo['id']          = $new_ad_id;
                            $adInfo['litpic']      = '';
                            $adInfo['pid']         = $post['id'];
                            $adInfo['title']       = $post['title'];
                            $adInfo['intro']       = empty($post['html_intro'][$mark]) ? '' : $post['html_intro'][$mark];
                            $adInfo['links']       = '';
                            $adInfo['target']      = 0;
                            $adInfo['media_type']  = 3;
                            $adInfo['admin_id']    = session('admin_id');
                            $adInfo['lang']        = $mark;
                            $adInfo['sort_order']  = 1;
                            $adInfo['add_time']    = $this->times;
                            $adInfo['update_time'] = $this->times;
                            $adAddData[] = $adInfo;
                        }
                    }
                }
                $r = true;
                if ($r !== false && !empty($adEditData)) {
                    $r = model('Ad')->saveAll($adEditData);
                }
                if ($r !== false && !empty($adAddData)) {
                    $r = model('Ad')->saveAll($adAddData);
                }
                if ($r !== false) {
                    Cache::clear('ad');
                    adminLog('编辑广告：'.$post['title']);
                    $this->success("操作成功", url('AdPosition/index'));
                }
            }
            $this->error("操作失败");
        }

        $assign_data = [];

        // 查询广告位
        $id = input('id/d');
        $adv_data = array();
        $result = Db::name('ad_position')->where(['id'=>$id])->order('lang asc, id asc')->select();
        foreach ($result as $key => $val) {
            $adv_data[$val['lang']] = $val;
        }
        $assign_data['adv_data'] = $adv_data;
        $field = $adv_data[$this->admin_lang];
        if (empty($field)) $this->error('广告不存在，请联系管理员！');
        switch ($field['type']) {
            case '1':
                $field['type_name'] = '图片';
                break;
            case '2':
                $field['type_name'] = '多媒体';
                break;
            case '3':
                $field['type_name'] = 'HTML代码';
                break;
        }
        $assign_data['field'] = $field;

        // 多语言列表
        $languageList = Db::name('language')->alias('a')
            ->field('a.title,a.mark,a.is_home_default,a.is_admin_default,b.cn_title')
            ->join('language_mark b', 'a.mark = b.mark', 'left')
            ->order('a.is_home_default desc, a.sort_order asc, a.id asc')
            ->getAllWithIndex('mark');
        $assign_data['languageList'] = $languageList;

        // 查询广告内容
        $ad_data = array();
        $result = Db::name('ad')->where(['pid'=>$field['id']])->order('lang asc, sort_order asc, id asc')->select();
        foreach ($result as $key => $val) {
            if (1 == $val['media_type']) {
                $val['litpic'] = get_default_pic($val['litpic']); // 支持子目录
            }
            $ad_data[$val['lang']]['list'][] = $val;
            $ad_data[$val['lang']]['info'] = $languageList[$val['lang']];
        }
        $assign_data['ad_data'] = $ad_data;

        // 上传通道
        $WeappConfig = Db::name('weapp')->field('code, status')->where('code', 'IN', ['Qiniuyun', 'AliyunOss', 'Cos', 'AwsOss'])->select();
        $WeappOpen = [];
        foreach ($WeappConfig as $value) {
            if ('Qiniuyun' == $value['code']) {
                $WeappOpen['qny_open'] = $value['status'];
            } else if ('AliyunOss' == $value['code']) {
                $WeappOpen['oss_open'] = $value['status'];
            } else if ('Cos' == $value['code']) {
                $WeappOpen['cos_open'] = $value['status'];
            } else if ('AwsOss' == $value['code']) {
                $WeappOpen['aws_open'] = $value['status'];
            }
        }
        $this->assign('WeappOpen', $WeappOpen);

        // 系统最大上传视频的大小
        $file_size  = empty($this->globalConfig['file_size']) ? 0 : $this->globalConfig['file_size'];
        $postsize   = @ini_get('file_uploads') ? ini_get('post_max_size') : -1;
        $fileupload = @ini_get('file_uploads') ? ini_get('upload_max_filesize') : -1;
        $min_size   = strval($file_size) < strval($postsize) ? $file_size : $postsize;
        $min_size   = strval($min_size) < strval($fileupload) ? $min_size : $fileupload;
        $upload_max_filesize = intval($min_size) * 1024 * 1024;
        $assign_data['upload_max_filesize'] = $upload_max_filesize;

        // 视频类型
        $media_type = !empty($this->globalConfig['media_type']) ? $this->globalConfig['media_type'] : config('global.media_ext');
        $media_type = str_replace(",", "|", $media_type);
        $assign_data['media_type'] = $media_type;
        $file_upload_media_type = '.'.str_replace("|", ",.", $media_type);
        $assign_data['file_upload_media_type'] = $file_upload_media_type;

        $this->assign($assign_data);
        return $this->fetch();
    }

    /**
     * 删除广告图片
     */
    public function del_imgupload()
    {
        $id_arr = input('del_id/a');
        $id_arr = eyIntval($id_arr);
        if(IS_POST && !empty($id_arr)){
            $r = Db::name('ad')->where([
                    'id' => ['IN', $id_arr],
                ])->delete();
            if ($r !== false) {
                Cache::clear('ad');
                adminLog('删除广告-id：'.implode(',', $id_arr));
            }
        }
    }

    /**
     * 删除
     */
    public function del()
    {
        $id_arr = input('del_id/a');
        $id_arr = eyIntval($id_arr);
        if(IS_POST && !empty($id_arr)){
            foreach ($id_arr as $key => $val) {
                if(array_key_exists($val, $this->ad_position_system_id)){
                    $this->error('系统预定义，不能删除');
                }
            }
            $r = Db::name('ad_position')->where('id','IN',$id_arr)->delete();
            if ($r !== false) {
                Db::name('ad')->where('pid','IN',$id_arr)->delete();
                Cache::clear('ad');
                adminLog('删除广告-id：'.implode(',', $id_arr));
                $this->success('删除成功');
            }
        }
        $this->error('删除失败');
    }

    /**
     * 打开预览视频
     */
    public function open_preview_video()
    {
        $post = input('post.');
        $video_litpic = $post['video_litpic'];
        if (!is_http_url($video_litpic)) {
            $video_litpic = request()->domain() . handle_subdir_pic($video_litpic, 'media');
        }
        $this->success('执行成功', $video_litpic);
    }

    /**
     * 检测广告名称是否存在重复
     */
    public function detection_title_repeat()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            $where = [
                'id'    => ['NEQ', $post['id']],
                'title' => trim($post['title']),
                'lang'  => $this->admin_lang,
            ];
            $count = Db::name('ad_position')->where($where)->count();
            if (empty($count)) {
                $this->success('检测通过');
            } else {
                $this->error('该广告名称已存在，请检查');
            }
        }
    }
}