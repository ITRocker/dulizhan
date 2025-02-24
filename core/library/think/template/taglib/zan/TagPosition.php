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

namespace think\template\taglib\zan;

use think\Db;

/**
 * 栏目位置
 */
class TagPosition extends Base
{
    //初始化
    protected function _initialize()
    {
        parent::_initialize();
        /*应用于文档列表*/
        if ($this->aid > 0) {
            $this->tid = $this->get_aid_typeid($this->aid);
        }
        /*--end*/
    }

    /**
     * 获取面包屑位置
     * @author wengxianhu by 2018-4-20
     */
    public function getPosition($typeid = '', $symbol = '', $style = 'crumb')
    {
        $typeid = !empty($typeid) ? $typeid : $this->tid;

        // $basicConfig = tpCache('basic');
        // $basic_indexname = !empty($basicConfig['basic_indexname']) ? $basicConfig['basic_indexname'] : '首页';
        // $symbol = !empty($symbol) ? $symbol : $basicConfig['list_symbol'];
        $basic_indexname = lang('crumb47', [], self::$home_lang);
        $symbol = !empty($symbol) ? $symbol : lang('crumb50', [], self::$home_lang);

        /*首页链接*/
        $inletStr = '/index.php';
        $seo_inlet = config('ey_config.seo_inlet');
        1 == intval($seo_inlet) && $inletStr = '';

        // 多语言站点
        $lang = input('param.lang/s', '');
        if (empty($lang)) {
            $home_url = $this->root_dir.'/'; // 支持子目录
        } else {
            $home_url = langurl(self::$lang_info);
        }
        $home_url = get_absolute_url($home_url,'url');
        /*--end*/        
        $str = "<a href='{$home_url}' class='{$style}'>{$basic_indexname}</a>";
        if (!empty($typeid)) {            
            $result = model('Arctype')->getAllPid($typeid);
            $i = 1;
            foreach ($result as $key => $val) {
                /*if ($i == 1) {
                    $typename_all = lang('sys51', [], self::$home_lang);
                    if ('Article' == CONTROLLER_NAME) {
                        $typename_all = lang('crumb49', [], self::$home_lang);
                    } else if ('Product' == CONTROLLER_NAME) {
                        $typename_all = lang('crumb48', [], self::$home_lang);
                    } else if ('Images' == CONTROLLER_NAME) {
                        $typename_all = lang('crumb57', [], self::$home_lang);
                    }
                    $str .= " {$symbol} <a href='".typeurl('home/'.CONTROLLER_NAME.'/alls')."' class='{$style}'>{$typename_all}</a>";
                }*/
                
                if ($i < count($result)) {
                    $str .= " {$symbol} <a href='{$val['typeurl']}' class='{$style}'>{$val['typename']}</a>";
                } else {
                    $str .= " {$symbol} <a href='{$val['typeurl']}'>{$val['typename']}</a>";
                }
                ++$i;
            }
        } else {
            if (!empty($this->aid)) {
                /*if ('Single' == CONTROLLER_NAME) {
                    $cacheKey = 'taglib-TagPosition-Single-archives-aid-'.$this->aid.self::$home_lang;
                    $result = cache($cacheKey);
                    if (empty($result)) {
                        $result = Db::name('archives')->field('a.aid, a.title, a.htmlfilename, b.title as new_title')
                            ->alias('a')
                            ->join('archives_'.self::$home_lang.' b', 'a.aid = b.aid', 'LEFT')
                            ->where(['a.aid'=>$this->aid])
                            ->find();
                        !empty($result['new_title']) && $result['title'] = $result['new_title'];
                        $result['typeurl'] = arcurl('home/'.CONTROLLER_NAME.'/view', $result);
                        cache($cacheKey, $result, null, 'archives');
                    }
                    $str .= " {$symbol} <a href='{$result['typeurl']}' class='{$style}'>{$result['title']}</a>";
                } else {
                    $typename_all = lang('sys51', [], self::$home_lang);
                    if ('Article' == CONTROLLER_NAME) {
                        $typename_all = lang('crumb49', [], self::$home_lang);
                    } else if ('Product' == CONTROLLER_NAME) {
                        $typename_all = lang('crumb48', [], self::$home_lang);
                    } else if ('Images' == CONTROLLER_NAME) {
                        $typename_all = lang('crumb57', [], self::$home_lang);
                    }
                    $str .= " {$symbol} <a href='".typeurl('home/'.CONTROLLER_NAME.'/alls')."' class='{$style}'>{$typename_all}</a>";
                }*/
            } else {
                if (ACTION_NAME == 'alls') {
                    $channeltype_list = config('global.channeltype_list');                    
                    if (isset($channeltype_list[strtolower(CONTROLLER_NAME)])) {
                        if ('Article' == CONTROLLER_NAME) {                                                      
                            $typename_all = lang('crumb49', [], self::$home_lang);
                        } else if ('Product' == CONTROLLER_NAME) {                            
                            $typename_all = lang('crumb48', [], self::$home_lang);
                        } else if ('Images' == CONTROLLER_NAME) {
                            $typename_all = lang('crumb57', [], self::$home_lang);
                        } else {
                            $typename_all = lang('sys51', [], self::$home_lang);
                        }          
                        $seo_rewrite_format = config('ey_config.seo_rewrite_format');                                   
                        if($seo_rewrite_format==3 || $seo_rewrite_format==1){                            
                            $str .= " {$symbol} <a href='/all-".strtolower(CONTROLLER_NAME)."/' class='{$style}'>{$typename_all}</a>";
                        }else{                            
                            $str .= " {$symbol} <a href='".typeurl('home/'.CONTROLLER_NAME.'/'.ACTION_NAME)."' class='{$style}'>{$typename_all}</a>";
                        }
                    }
                }
            }
        }

        return $str;
    }
}