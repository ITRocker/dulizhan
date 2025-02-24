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

namespace app\common\logic;

use think\Db;

/**
 * sitemap类
 */
class SitemapLogic 
{
    private $tcp;
    private $lang;
    private $default_lang;
    
    public function __construct() 
    {
        $this->tcp = config('is_https') ? 'https' : 'http';
        $this->lang = get_current_lang();
        $this->default_lang = get_default_lang();
    }

    public function get_language_list($lang = '')
    {
        $languageList = get_language_list();
        if (empty($lang)) {
            foreach ($languageList as $key => $val) {
                if (!empty($val['translate_mode'])) {
                    unset($languageList[$key]);
                }
            }
            return $languageList;
        } else {
            return empty($languageList[$lang]) ? [] : $languageList[$lang];
        }
    }

    /**
     * 分类总数
     * @return [type] [description]
     */
    public function get_arctype_count($lang)
    {
        $cacheKey = 'app\common\logic\SitemapLogic\get_arctype_count'.json_encode([$lang]);
        $totalRows = (int)cache($cacheKey);
        if (empty($totalRows)) {
            $totalRows = (int)Db::name('arctype')->where([
                    'status'    => 1,
                    'is_del'    => 0,
                    'lang'      => $lang,
                ])->count('id');
            cache($cacheKey, $totalRows, null, 'arctype');
        }

        return $totalRows;
    }

    /**
     * 分类列表
     * @return [type] [description]
     */
    public function get_arctype_list($lang, $pagesize = 0, $firstRow = 0)
    {
        $cacheKey = 'app\common\logic\SitemapLogic\get_arctype_list'.json_encode([$lang,$pagesize,$firstRow]);
        $arctypeList = cache($cacheKey);
        if (empty($arctypeList)) {
            $builder = Db::name('arctype')->alias('a')
                ->field('a.*, b.ctl_name')
                ->join('channeltype b', 'a.current_channel = b.id', 'left')
                ->where([
                    'a.status'    => 1,
                    'a.is_del'    => 0,
                    'a.lang'      => $lang,
                ]);
            if (!empty($pagesize)) {
                $builder->limit($pagesize, $firstRow);
            }
            $arctypeList = $builder->order('a.current_channel asc, a.sort_order asc, a.id asc')->select();
            cache($cacheKey, $arctypeList, null, 'arctype');
        }

        return $arctypeList;
    }

    /**
     * 文档总数
     * @return [type] [description]
     */
    public function get_archives_count()
    {
        $cacheKey = 'app\common\logic\SitemapLogic\get_archives_count';
        $totalRows = (int)cache($cacheKey);
        if (empty($totalRows)) {
            $totalRows = (int)Db::name('archives')->where([
                    'channel' => ['IN', config('global.allow_release_channel')],
                    'status' => 1,
                    'is_del' => 0,
                ])->count('aid');
            cache($cacheKey, $totalRows, null, 'archives');
        }

        return $totalRows;
    }

    /**
     * 文档列表
     * @return [type] [description]
     */
    public function get_archives_list($pagesize = 0, $firstRow = 0)
    {
        $cacheKey = 'app\common\logic\SitemapLogic\get_archives_list'.json_encode([$pagesize,$firstRow]);
        $archivesList = cache($cacheKey);
        if (empty($archivesList)) {
            $builder = Db::name('archives')->alias('a')
                ->field('a.aid,a.typeid,a.htmlfilename,a.add_time,a.update_time,b.ctl_name,a.channel,a.stypeid')
                ->join('channeltype b', 'a.channel = b.id', 'left')
                ->where([
                    'a.channel' => ['IN', config('global.allow_release_channel')],
                    'a.status' => 1,
                    'a.is_del' => 0,
                ]);
            if (!empty($pagesize)) {
                $builder->limit($pagesize, $firstRow);
            }
            $archivesList = $builder->order('a.aid desc')->select();
            cache($cacheKey, $archivesList, null, 'archives');
        }        
        return $archivesList;
    }

    /**
     * 更新sitemap地图
     */
    public function update_sitemap($globalConfig = [], $is_write = false)
    {
        empty($globalConfig) && $globalConfig = tpCache('global', [], $this->lang);
        $languageList = $this->get_language_list();
        // 开始
        $xml_content = '<?xml version="1.0" encoding="utf-8"?>'.PHP_EOL;
        $xml_content .= '<sitemapindex xmlns="'.$this->tcp.'://www.sitemaps.org/schemas/sitemap/0.9">'.PHP_EOL;
        // 当前语言的首页url
        $site_url = rtrim(langurl($languageList[$this->lang]), '/');
        // 默认语言的首页url
        $default_lang_url = rtrim(langurl($languageList[$this->default_lang]), '/');
        // 分类
        $totalRows = $this->get_arctype_count($this->lang);
        $pagesize = 5000;
        $pageNum = ceil($totalRows / $pagesize);
        for ($i=1; $i <= $pageNum; $i++) {
            $loc = auto_hide_index(url('api/Sitemap/xml_type', ['page'=>$i], true, $default_lang_url, $globalConfig['seo_pseudo'], null, 0));
            $xml_content .= '<sitemap>'.PHP_EOL;
            $xml_content .= '<loc>' . $loc . '</loc>'.PHP_EOL;
            $xml_content .= '<lastmod>' . MyDate("Y-m-d", getTime()) . '</lastmod>'.PHP_EOL;
            $xml_content .= '</sitemap>'.PHP_EOL;
        }
        // 文档
        $totalRows = $this->get_archives_count();
        $pagesize = !empty($globalConfig['sitemap_archives_num']) ? (int)$globalConfig['sitemap_archives_num'] : 5000;
        $pageNum = ceil($totalRows / $pagesize);
        for ($i=1; $i <= $pageNum; $i++) {
            $loc = auto_hide_index(url('api/Sitemap/xml_lists', ['page'=>$i], true, $default_lang_url, $globalConfig['seo_pseudo'], null, 0));
            $xml_content .= '<sitemap>'.PHP_EOL;
            $xml_content .= '<loc>' . $loc . '</loc>'.PHP_EOL;
            $xml_content .= '<lastmod>' . MyDate("Y-m-d", getTime()) . '</lastmod>'.PHP_EOL;
            $xml_content .= '</sitemap>'.PHP_EOL;
        }
        // 其他语言主地图
        /*if ($this->default_lang == $this->lang) {
            foreach ($languageList as $key => $val) {
                if ($val['mark'] == $this->lang) {
                    continue;
                }
                $lang_url = rtrim(langurl($val), '/');
                $loc = auto_hide_index(url('api/Sitemap/xml_index', [], true, $lang_url, $globalConfig['seo_pseudo'], null, 0));
                $xml_content .= '<sitemap>'.PHP_EOL;
                $xml_content .= '<loc>' . $loc . '</loc>'.PHP_EOL;
                $xml_content .= '<lastmod>' . MyDate("Y-m-d", getTime()) . '</lastmod>'.PHP_EOL;
                $xml_content .= '</sitemap>'.PHP_EOL;
            }
        }*/
        // 结束
        $xml_content .= '</sitemapindex>'.PHP_EOL;

        if (!empty($is_write)) {
            try {
                $file = './sitemap.xml';
                $fp = @fopen($file, "w+");
                if (!empty($fp)) {
                    @fwrite($fp, $xml_content);
                }
                @fclose($fp);
            } catch (\Exception $e) {
                
            }
        }

        return ['code'=>1, 'msg'=>'ok', 'content'=>$xml_content];
    }

    /**
     * 更新txt地图
     */
    public function update_siteurls($globalConfig = [], $is_write = false)
    {
        empty($globalConfig) && $globalConfig = tpCache('global', [], $this->lang);
        $languageList = $this->get_language_list();
        // 开始
        $txt_content = '';
        // 当前语言的首页url
        $site_url = rtrim(langurl($languageList[$this->lang]), '/');
        // 默认语言的首页url
        $default_lang_url = rtrim(langurl($languageList[$this->default_lang]), '/');

        // 首页
        $txt_content .= $site_url.PHP_EOL;
        // 分类
        $arctypeList = $this->get_arctype_list($this->lang, 5000);
        $channel_tmp = [];
        foreach($arctypeList as $key => $val) {
            /*if (!in_array($val['current_channel'], $channel_tmp)) {
                $channel_tmp[] = $val['current_channel'];
                $loc = typeurl("home/{$val['ctl_name']}/alls", [], true, true);
                $txt_content .= $loc.PHP_EOL;
            }*/                                    
            $typeurl = get_typeurl($val, false, true);
            //$typeurl = typeurl("home/{$val['ctl_name']}/lists", $val, true, true);
            $loc = htmlspecialchars(urldecode($typeurl));
            $txt_content .= $loc.PHP_EOL;
        }        
        // 文档
        $archivesList = $this->get_archives_list(10000);
        foreach($archivesList as $key => $val) {                        
            $arcurl= get_arcurl($val,false);            
            //$arcurl = arcurl("home/{$val['ctl_name']}/view", $val, true, true);
            $loc = htmlspecialchars(urldecode($arcurl));
            $txt_content .= $loc.PHP_EOL;
        }
        // 其他语言主地图
        /*if ($this->default_lang == $this->lang) {
            foreach ($languageList as $key => $val) {
                if ($val['mark'] == $this->lang) {
                    continue;
                }
                $lang_url = rtrim(langurl($val), '/');
                $loc = auto_hide_index(url('api/Sitemap/txt_index', [], true, $lang_url, $globalConfig['seo_pseudo'], null, 0));
                $txt_content .= $loc.PHP_EOL;
            }
        }*/

        if (!empty($is_write)) {
            try {
                $file = './siteurls.txt';
                $fp = @fopen($file, "w+");
                if (!empty($fp)) {
                    @fwrite($fp, $txt_content);
                }
                @fclose($fp);
            } catch (\Exception $e) {
                
            }
        }

        return ['code'=>1, 'msg'=>'ok', 'content'=>$txt_content];
    }    
}
