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

use think\Db;
use app\common\logic\SitemapLogic;
use think\template\driver\File;

class Sitemap extends Base
{
    private $tcp;
    private $lang;
    private $sitemapLogic;
    private $languageList;

    public function _initialize() {
        parent::_initialize();
        $this->tcp = config('is_https') ? 'https' : 'http';
        $this->sitemapLogic = new SitemapLogic;
        $this->lang = get_current_lang();
        if (preg_match('/^(xml_|txt_)/i', ACTION_NAME)) {
            if (empty($this->zan['global']['sitemap_open'])) {
                abort(404);
            }
            $this->languageList = $this->sitemapLogic->get_language_list();
            if (empty($this->languageList[$this->lang])) {
                abort(404);
            }
        }
        // 更新频率
        empty($this->zan['global']['sitemap_changefreq_index']) && $this->zan['global']['sitemap_changefreq_index'] = 'always';
        empty($this->zan['global']['sitemap_changefreq_list']) && $this->zan['global']['sitemap_changefreq_list'] = 'hourly';
        empty($this->zan['global']['sitemap_changefreq_view']) && $this->zan['global']['sitemap_changefreq_view'] = 'daily';
        // 优先级别
        empty($this->zan['global']['sitemap_priority_index']) && $this->zan['global']['sitemap_priority_index'] = '1.0';
        empty($this->zan['global']['sitemap_priority_list']) && $this->zan['global']['sitemap_priority_list'] = '0.8';
        empty($this->zan['global']['sitemap_priority_view']) && $this->zan['global']['sitemap_priority_view'] = '0.5';
        // 每个xml的文档显示数
        empty($this->zan['global']['sitemap_archives_num']) && $this->zan['global']['sitemap_archives_num'] = 5000;
    }

    /**
     * 主地图
     * @return [type] [description]
     */
    public function xml_index()
    {
        $redata = $this->sitemapLogic->update_sitemap($this->zan['global']);
        if (!empty($redata['code'])) {
            header("Content-type: text/xml");
            echo $redata['content'];
            exit;
        }
        abort(404);
    }

    /**
     * 分类地图
     * @return [type] [description]
     */
    public function xml_type() {
        $page = input('param.page/d');
        $page = ($page > 1) ? $page : 1;
        $totalRows = $this->sitemapLogic->get_arctype_count($this->lang);
        $pagesize = 5000;
        $firstRow = ($page - 1) * $pagesize;
        $totalPages = ceil($totalRows / $pagesize) > 0 ? ceil($totalRows / $pagesize) : 1; //总页数
        if ($page > $totalPages) {
            abort(404);
        }

        $site_url = rtrim(langurl($this->languageList[$this->lang]), '/');
        $xml_content = '<?xml version="1.0" encoding="utf-8"?>'.PHP_EOL;
        $xml_content .= '<urlset xmlns="'.$this->tcp.'://www.sitemaps.org/schemas/sitemap/0.9">'.PHP_EOL;
        // 首页
        $xml_content .= '<url>'.PHP_EOL;
        $xml_content .= '<loc>' . $site_url . '</loc>'.PHP_EOL;
        $xml_content .= '<lastmod>' . MyDate("Y-m-d", getTime()) . '</lastmod>'.PHP_EOL;
        $xml_content .= '<changefreq>'.$this->zan['global']['sitemap_changefreq_index'].'</changefreq>'.PHP_EOL;
        $xml_content .= '<priority>'.$this->zan['global']['sitemap_priority_index'].'</priority>'.PHP_EOL;
        $xml_content .= '</url>'.PHP_EOL;
        // 分类
        $arctypeList = $this->sitemapLogic->get_arctype_list($this->lang, $pagesize, $firstRow);
        $channel_tmp = [];
        foreach($arctypeList as $key => $val) {
            /*if (!in_array($val['current_channel'], $channel_tmp)) {
                $channel_tmp[] = $val['current_channel'];
                $loc = typeurl("home/{$val['ctl_name']}/alls", [], true, true);
                $xml_content .= '<url>'.PHP_EOL;
                $xml_content .= '<loc>' . $loc . '</loc>'.PHP_EOL;
                $xml_content .= '<lastmod>' . MyDate("Y-m-d", getTime()) . '</lastmod>'.PHP_EOL;
                $xml_content .= '<changefreq>'.$this->zan['global']['sitemap_changefreq_list'].'</changefreq>'.PHP_EOL;
                $xml_content .= '<priority>'.$this->zan['global']['sitemap_priority_list'].'</priority>'.PHP_EOL;
                $xml_content .= '</url>'.PHP_EOL;
            }*/
            $typeurl = typeurl("home/{$val['ctl_name']}/lists", $val, true, true);
            $loc = htmlspecialchars(urldecode($typeurl));
            $xml_content .= '<url>'.PHP_EOL;
            $xml_content .= '<loc>' . $loc . '</loc>'.PHP_EOL;
            $xml_content .= '<lastmod>' . MyDate("Y-m-d", getTime()) . '</lastmod>'.PHP_EOL;
            $xml_content .= '<changefreq>'.$this->zan['global']['sitemap_changefreq_list'].'</changefreq>'.PHP_EOL;
            $xml_content .= '<priority>'.$this->zan['global']['sitemap_priority_list'].'</priority>'.PHP_EOL;
            $xml_content .= '</url>'.PHP_EOL;
        }
        // 结束
        $xml_content .= '</urlset>';

        header("Content-type: text/xml");
        echo $xml_content;
        exit;
    }

    /**
     * 文档地图
     * @return [type] [description]
     */
    public function xml_lists() {
        $page = input('param.page/d');
        $page = ($page > 1) ? $page : 1;
        $totalRows = $this->sitemapLogic->get_archives_count();
        $pagesize = (int)$this->zan['global']['sitemap_archives_num'];
        $firstRow = ($page - 1) * $pagesize;
        $totalPages = ceil($totalRows / $pagesize) > 0 ? ceil($totalRows / $pagesize) : 1; //总页数
        if ($page > $totalPages) {
            abort(404);
        }

        $site_url = rtrim(langurl($languageList[$this->lang]), '/');
        $xml_content = '<?xml version="1.0" encoding="utf-8"?>'.PHP_EOL;
        $xml_content .= '<urlset xmlns="'.$this->tcp.'://www.sitemaps.org/schemas/sitemap/0.9">'.PHP_EOL;
        // 文档
        $archivesList = $this->sitemapLogic->get_archives_list($pagesize, $firstRow);
        foreach($archivesList as $key => $val) {
            empty($val["update_time"]) && $val["update_time"] = $val["add_time"];
            $arcurl= get_arcurl($val,false);
            $loc = htmlspecialchars(urldecode($arcurl));
            $xml_content .= '<url>'.PHP_EOL;
            $xml_content .= '<loc>'.$loc.'</loc>'.PHP_EOL;
            $xml_content .= '<lastmod>'.MyDate("Y-m-d", $val["update_time"]).'</lastmod>'.PHP_EOL;
            $xml_content .= '<changefreq>'.$this->zan['global']['sitemap_changefreq_view'].'</changefreq>'.PHP_EOL;
            $xml_content .= '<priority>'.$this->zan['global']['sitemap_priority_view'].'</priority>'.PHP_EOL;
            $xml_content .= '</url>'.PHP_EOL;
        }
        // 结束
        $xml_content .= '</urlset>';

        header("Content-type: text/xml");
        echo $xml_content;
        exit;
    }

    public function sitefeed()
    {
        $sitemap_xml = update_sitemap();
        header("Content-type: text/rss");
        echo $sitemap_xml;
        exit;
    }

    public function txt_index()
    {
        $redata = $this->sitemapLogic->update_siteurls($this->zan['global']);
        if (!empty($redata['code'])) {
            header("Content-type: text/txt");
            echo $redata['content'];
            exit;
        }
        abort(404);
    }

    /**
     * 生成sitemap
     * @return [type] [description]
     */
    public function ajax_update_sitemap()
    {
        sitemap_all();
        if (IS_POST) {
            $this->success('更新成功');
        }
        exit('success');
    }

    /**
     * 生成sitemap.xml
     * @return [type] [description]
     */
    public function ajax_update_sitemap_xml()
    {
        sitemap_all('xml');
        if (IS_POST) {
            $this->success('更新成功');
        }
        exit('success');
    }

    /**
     * 生成sitemap.txt
     * @return [type] [description]
     */
    public function ajax_update_sitemap_txt()
    {
        sitemap_all('txt');
        if (IS_POST) {
            $this->success('更新成功');
        }
        exit('success');
    }

    /**
     * 生成sitemap.html
     * @return [type] [description]
     */
    public function ajax_update_sitemap_html(){
        \think\Session::pause(); // 暂停session，防止session阻塞机制
        $msg = $this->handleBuildSitemap();
        if (IS_AJAX) {
            if (empty($msg)) {
                $this->success('更新成功');
            } else {
                $this->error('更新失败', null, ['msg'=>$msg]);
            }
        }
        if (empty($msg)) {
            exit('success');
        } else {
            exit($msg);
        }
    }
    
    /*
     * 处理生成html
     */
    private function handleBuildSitemap()
    {
        $is_auto = input('param.is_auto/s', 'on'); // 是否自动生成，还是手工生成
        $sitemapid = tpSetting('system.system_sitemapid1647228884');  //四个模块最后一条id，type_arc_tag_ask
        $last_type = $last_arc = $last_tag = $last_ask = 0;
        $is_create = false;
        if (!is_file('./sitemap.html') || 'off' == $is_auto) {
            $is_create = true;
        }
        if (!empty($sitemapid)){
            $sitemapid_arr = explode("_",$sitemapid);
            $last_type = !empty($sitemapid_arr[0]) ? $sitemapid_arr[0] : 0;
            $last_arc = !empty($sitemapid_arr[1]) ? $sitemapid_arr[1] : 0;
            $last_tag = !empty($sitemapid_arr[2]) ? $sitemapid_arr[2] : 0;
            $last_ask = !empty($sitemapid_arr[3]) ? $sitemapid_arr[3] : 0;
        }

        $globalConfig = tpCache('global');
        $web_name = empty($globalConfig['web_name']) ? $globalConfig['web_title'] : $globalConfig['web_name'];
        $lang = get_current_lang();
        //栏目信息
        $type_map = array(
            'status'    => 1,
            'is_del'    => 0,
            'lang'      => $lang,
        );
        if (is_array($globalConfig)) {
            // 过滤隐藏栏目
            if (isset($globalConfig['sitemap_not1']) && $globalConfig['sitemap_not1'] > 0) {
                $type_map['is_hidden'] = 0;
            }
            // 过滤外部模块
            if (isset($globalConfig['sitemap_not2']) && $globalConfig['sitemap_not2'] > 0) {
                $type_map['is_part'] = 0;
            }
        }
        $result_arctype = Db::name('arctype')->field("*")
            ->where($type_map)
            ->order('id asc')
            ->getAllWithIndex('id');
        $last_type_new = reset($result_arctype);
        if ($is_create == false && !empty($last_type_new['id']) && $last_type_new['id'] > $last_type){
            $is_create = true;
            $last_type = $last_type_new['id'];
        }
        $type_list = [];
        foreach ($result_arctype as $sub){
            if ($sub['is_part'] == 1 && !empty($sub['typelink'])) {
                $url = $sub['typelink'];
            } else {
                $url = get_typeurl($sub, false);
            }
            $type_list[] = [
                'url' => $url,
                'title' => $sub['typename']
            ];
        }
        //文档信息
        $arc_map = array(
            'channel'   => ['IN', config('global.allow_release_channel')],
            'arcrank'   => array('gt', -1),
            'status'    => 1,
            'is_del'    => 0,
            'lang'      => $lang,
        );
        if (is_array($globalConfig)) {
            // 过滤外部模块
            if (isset($globalConfig['sitemap_not2']) && $globalConfig['sitemap_not2'] > 0) {
                $arc_map['is_jump'] = 0;
            }
        }
        /*定时文档显示插件*/
        if (is_dir('./weapp/TimingTask/')) {
            $weappModel = new \app\admin\model\Weapp;
            $TimingTaskRow = $weappModel->getWeappList('TimingTask');
            if (!empty($TimingTaskRow['status']) && 1 == $TimingTaskRow['status']) {
                $arc_map['add_time'] = ['elt', getTime()]; // 只显当天或之前的文档
            }
        }
        /*end*/
        if (!isset($globalConfig['sitemap_archives_num']) || $globalConfig['sitemap_archives_num'] === '') {
            $sitemap_archives_num = 1000;
        } else {
            $sitemap_archives_num = intval($globalConfig['sitemap_archives_num']);
        }
        $field = "aid, channel, is_jump, jumplinks, htmlfilename, add_time, update_time, typeid,title,province_id,city_id,area_id";
        $result_archives = Db::name('archives')->field($field)
            ->where($arc_map)
            ->order('aid desc')
            ->limit($sitemap_archives_num)
            ->select();
        $arc_list = [];
        if ($is_create == false && !empty($result_archives[0]['aid']) && $result_archives[0]['aid'] > $last_arc){
            $is_create = true;
            $last_arc = $result_archives[0]['aid'];
        }
        foreach ($result_archives as $val){
            if (empty($result_arctype[$val['typeid']])){
                continue;
            }
            $val = array_merge($result_arctype[$val['typeid']], $val);
            if ($val['is_jump'] == 1) {
                $url = $val['jumplinks'];
            } else {
                $url = get_arcurl($val, false);
            }
            $arc_list[] = [
                'url' => $url,
                'title' => $val['title']
            ];
        }
        //tags页面
        if (!isset($globalConfig['sitemap_tags_num']) || $globalConfig['sitemap_tags_num'] === '') {
            $sitemap_tags_num = 1000;
        } else {
            $sitemap_tags_num = intval($globalConfig['sitemap_tags_num']);
        }
        $tags_map = array(
            'lang'      => $lang,
        );
        $field = "id, add_time, tag";
        $result_tags = Db::name('tagindex')->field($field)
            ->where($tags_map)
            ->order('id desc')
            ->limit($sitemap_tags_num)
            ->select();
        if ($is_create == false && !empty($result_tags[0]['id']) && $result_tags[0]['id'] > $last_tag){
            $is_create = true;
            $last_tag = $result_tags[0]['id'];
        }
        $tags_list = [];
        foreach ($result_tags as $val){
            $tags_list[] = [
                'url' => get_tagurl($val['id']),
                'title' => $val['tag']
            ];
        }

        // 问答插件
        $ask_list = [];
        if (is_dir('./weapp/Ask/')) {
            try{
                $askLogic = new \app\plugins\logic\AskLogic;
                $Askow = Db::name("weapp")->where(['code'=>'Ask'])->field("status,data")->find();
                if (!empty($Askow['status']) && 1 == $Askow['status']) {
                    $ask_map = [
                        'is_review' =>1,
                    ];

                    $ask_seo_pseudo = 1;
                    $Askow['data'] = unserialize($Askow['data']);
                    if (!empty($Askow['data']['seo_pseudo'])) {
                        $ask_seo_pseudo = intval($Askow['data']['seo_pseudo']);
                    }
                    //问答首页
                    if (method_exists($askLogic, 'askurl')) {
                        $url = $askLogic->askurl('plugins/Ask/index', [], true, false, $ask_seo_pseudo);
                    } else {
                        $url = url('plugins/Ask/index', [], true, false, $ask_seo_pseudo);
                    }
                    $ask_list[] = [
                        'url' => auto_hide_index($url),
                        'title' => "问答首页"
                    ];
                    //问答栏目
                    $result_ask_type = Db::name("weapp_ask_type")->field("type_id,type_name")->order('sort_order asc')->select();
                    foreach ($result_ask_type as $val){
                        if (method_exists($askLogic, 'askurl')) {
                            $url = $askLogic->askurl('plugins/Ask/index', ['type_id'=>$val['type_id']],true,false,$ask_seo_pseudo);
                        } else {
                            $url = url('plugins/Ask/index', ['type_id'=>$val['type_id']],true,false,$ask_seo_pseudo);
                        }
                        $ask_list[] = [
                            'url' => auto_hide_index($url),
                            'title' => $val['type_name']
                        ];
                    }
                    //问答内容
                    $result_ask = Db::name('weapp_ask')->field('ask_id,type_id,ask_title')
                        ->where($ask_map)
                        ->order('ask_id desc')
                        ->select();
                    foreach ($result_ask as $val){
                        if (method_exists($askLogic, 'askurl')) {
                            $url = $askLogic->askurl('plugins/Ask/details', ['ask_id'=>$val['ask_id']],true,false,$ask_seo_pseudo);
                        } else {
                            $url = url('plugins/Ask/details', ['ask_id'=>$val['ask_id']],true,false,$ask_seo_pseudo);
                        }
                        $ask_list[] = [
                            'url' => auto_hide_index($url),
                            'title' => $val['ask_title']
                        ];
                    }
                    if ($is_create == false && !empty($result_ask[0]['ask_id']) && $result_ask[0]['ask_id'] > $last_ask){
                        $is_create = true;
                        $last_ask = $result_ask[0]['ask_id'];
                    }
                }
            }catch (\Exception $e){}
        }

        $msg = '';
        if ($is_create){
            //数据整合与生成
            $zan = array(
                'seo_title' => $web_name.'_网站地图',
                'seo_keywords' => '',
                'seo_description' => '',
                'index' => ['url'=>request()->domain().ROOT_DIR.'/','title'=>$web_name],  //首页信息（url链接和title）
                'type_list' => $type_list,
                'arc_list' => $arc_list,
                'tags_list' => $tags_list,
                'ask_list' => $ask_list
            );
            $this->assign('zan', $zan);
            try {
                $savepath = "./sitemap.html";
                $tpl      = 'index';
                $this->filePutContents($savepath, $tpl);
                $sitemapid = $last_type."_".$last_arc."_".$last_tag."_".$last_ask;
                $r = tpSetting('system',['system_sitemapid1647228884'=>$sitemapid]);
            } catch (\Exception $e) {
                $msg .= '<span>sitemap.html生成失败！' . $e->getMessage() . '</span><br>';
            }
        }

        return $msg;
    }
    /*
      * 写入静态页面
      * $savepath    保存位置
      * $tpl         模板名称
      *
      */
    private function filePutContents($savepath, $tpl)
    {
        ob_start();
        static $templateConfig = null;
        null === $templateConfig && $templateConfig = \think\Config::get('template');
        $templateConfig['view_path'] = "./public/html/";
        $template                    = "./public/html/sitemap.{$templateConfig['view_suffix']}";

        $content                     = $this->fetch($template, [], [], $templateConfig);

        /*解决模板里没有设置编码的情况*/
        if (!stristr($content, 'utf-8')) {
            $content = str_ireplace('<head>', "<head>\n<meta charset='utf-8'>", $content);
        }
        /*end*/
        echo $content;
        $_cache = ob_get_contents();
        ob_end_clean();

        static $File = null;
        null === $File && $File = new File;
        $File->fwrite($savepath, $_cache);
    }
}
