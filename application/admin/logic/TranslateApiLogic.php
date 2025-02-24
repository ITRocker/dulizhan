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

namespace app\admin\logic;

use think\Db;
use think\Cache;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;

/**
 * 业务逻辑
 */
load_trait('controller/Jump');
class TranslateApiLogic
{
    use \traits\controller\Jump;

    public $stringTagsArr = [];
    public $contentImagesArr = [];
    public $contentEyMImagesArr = [];

    // 析构函数
    public function __construct($doubaoArr = [], $adminLang = '') 
    {
        // 当前时间戳
        $this->times = getTime();
        // 提交参数
        $this->postArr = input('post.');
        //  豆包(火山引擎)配置
        $this->doubaoArr = !empty($doubaoArr) ? $doubaoArr : [];
        //  豆包(火山引擎)配置
        $this->adminLang = !empty($adminLang) ? $adminLang : get_admin_lang();
        
        $functionLogic = new \app\common\logic\FunctionLogic;
        $functionLogic->validate_authorfile(1);
    }

    // 获取 [设置]-[系统设置]-[基础设置] 要翻译的内容
    public function getConfigTranslateArr()
    {
        $where = [
            'lang' => trim($this->adminLang),
            'name' => ['IN', $this->fieldArr],
        ];
        $configArr = Db::name($this->table)->where($where)->getAllWithIndex('name');
        foreach ($this->fieldArr as $value) {
            if (!empty($configArr[$value]['value'])) $this->translateArr[$value] = htmlspecialchars_decode($configArr[$value]['value']);
        }
    }

    // 保存 [设置]-[系统设置]-[基础设置] 翻译的内容
    public function saveConfigTranslateArr()
    {
        $resultInt = 0;
        if (!empty($this->translateResult) && !empty($this->fieldArr) && !empty($this->langStr)) {
            tpCache('web', $this->translateResult, $this->langStr);
            $resultInt = 1;
        }
        return $resultInt;
    }

    // 获取 [设置]-[系统设置]-[自定义变量] 要翻译的内容
    public function getConfigAttributeTranslateArr()
    {
        $configAttributeArr = [];
        $where = [
            'lang' => trim($this->adminLang),
            'attr_var_name' => ['IN', $this->fieldArr],
        ];
        $result = Db::name($this->table)->where($where)->select();
        foreach ($result as $key => $val) {
            $configAttributeArr["config_attribute-{$val['attr_var_name']}"] = $val;
        }
        foreach ($this->fieldArr as $value) {
            if (!empty($configAttributeArr["config_attribute-{$value}"]['attr_name'])) $this->translateArr["config_attribute-{$value}"] = htmlspecialchars_decode($configAttributeArr["config_attribute-{$value}"]['attr_name']);
        }

        $where = [
            'lang' => trim($this->adminLang),
            'name' => ['IN', $this->fieldArr],
        ];
        $configArr = Db::name('config')->where($where)->getAllWithIndex('name');
        foreach ($this->fieldArr as $value) {
            if (!empty($configArr[$value]['value']) && in_array($configAttributeArr["config_attribute-{$value}"]['attr_input_type'], [0,2])) {
                $this->translateArr[$value] = htmlspecialchars_decode($configArr[$value]['value']);
            }
        }
    }

    // 保存 [设置]-[系统设置]-[自定义变量] 翻译的内容
    public function saveConfigAttributeTranslateArr()
    {
        $resultInt = 0;
        if (!empty($this->translateResult) && !empty($this->fieldArr) && !empty($this->langStr)) {
            $translateConfigResult = [];
            foreach ($this->translateResult as $key => $val) {
                if (preg_match('/^config_attribute-(.+)$/i', $key)) {
                    $attr_var_name = preg_replace('/^config_attribute-(.+)$/i', '${1}', $key);
                    Db::name('config_attribute')->where(['attr_var_name'=>$attr_var_name, 'lang'=>$this->langStr])->update(['attr_name'=>$val, 'update_time'=>getTime()]);
                } else {
                    $translateConfigResult[$key] = $val;
                }
            }
            !empty($translateConfigResult) && tpCache('web', $translateConfigResult, $this->langStr);
            $resultInt = 1;
        }
        return $resultInt;
    }

    // 获取 [设置]-[系统设置]-[网站语言]-[语言变量] 要翻译的内容
    public function getLanguagePackTranslateArr()
    {
        $this->languagePackArr = [];
        if (!empty($this->fieldArr)) {
            $where = [
                'lang' => trim($this->adminLang),
                'type' => ['IN', $this->fieldArr]
            ];
            $this->languagePackArr = Db::name($this->table)->field('pack_id, value')->where($where)->getAllWithIndex('pack_id');
            $pattern = '/<(.*?)>/i';
            foreach ($this->languagePackArr as $key => $value) {
                preg_match_all($pattern, $value['value'], $matches);
                if (!empty($matches[0]) && is_array($matches[0])) {
                    foreach ($matches[0] as $kkk => $vvv) {
                        $this->stringTagsArr[$this->times . $kkk] = trim($vvv);
                        $value['value'] = str_replace($vvv, $this->times . $kkk, $value['value']);
                    }
                }
                if (strpos(trim($value['value']), '%s') !== false) {
                    $value['value'] = str_replace('%s', $this->timesPercentsMark, $value['value']);
                }
                if (!empty($value['value'])) $this->translateArr['pack_id_' . $key] = $value['value'];
            }
        }
    }

    // 保存 [设置]-[系统设置]-[网站语言]-[语言变量] 翻译的内容
    public function saveLanguagePackTranslateArr()
    {
        $resultInt = 0;
        $packIDArr = [];
        foreach ($this->translateResult as $key => $value) {
            $keyArr = explode('pack_id_', $key);
            if (!empty($keyArr[1])) {
                $pack_id = intval($keyArr[1]);
                array_push($packIDArr, $pack_id);
                if (!empty($this->languagePackArr[$pack_id])) $this->languagePackArr[$pack_id]['value'] = $value;
            }
        }
        if (!empty($packIDArr)) {
            $where = [
                'lang' => trim($this->langStr),
                'type' => ['IN', $this->fieldArr]
            ];
            $languagePackArr_ = Db::name($this->table)->field('auto_id, pack_id, value')->where($where)->select();
            foreach ($languagePackArr_ as $key => $value) {
                if (!empty($this->languagePackArr[$value['pack_id']]['value'])) $languagePackArr_[$key]['value'] = $this->languagePackArr[$value['pack_id']]['value'];
            }
            $a = model('LanguagePack')->saveAll($languagePackArr_);
            if (!empty($a)) {
                $resultInt = 1;
                Cache::clear('language_pack');
                model('LanguagePack')->updateLangFile(); // 生成语言包文件
            }
        }
        return $resultInt;
    }

    // 获取 [网站]-[网站设置]-[导航管理] 要翻译的内容
    public function getNavListTranslateArr()
    {
        $this->navListArr = [];
        if (!empty($this->fieldArr)) {
            $where = [
                'lang' => trim($this->adminLang),
                'position_id' => intval($this->postArr['position_id'])
            ];
            if (!empty($this->postArr['nav_id'])) $where['nav_id'] = intval($this->postArr['nav_id']);
            $this->navListArr = Db::name($this->table)->field('nav_id, nav_name')->where($where)->getAllWithIndex('nav_id');
            foreach ($this->navListArr as $key => $value) {
                if (!empty($value['nav_name'])) $this->translateArr['nav_id_' . $key] = $value['nav_name'];
            }
        }
    }

    // 保存 [网站]-[网站设置]-[导航管理] 翻译的内容
    public function saveNavListTranslateArr()
    {
        $resultInt = 0;
        $navIDArr = [];
        foreach ($this->translateResult as $key => $value) {
            $keyArr = explode('nav_id_', $key);
            if (!empty($keyArr[1])) {
                $nav_id = intval($keyArr[1]);
                array_push($navIDArr, $nav_id);
                if (!empty($this->navListArr[$nav_id])) $this->navListArr[$nav_id]['nav_name'] = $value;
            }
        }
        if (!empty($navIDArr)) {
            $where = [
                'lang' => trim($this->langStr),
                'position_id' => intval($this->postArr['position_id'])
            ];
            if (!empty($this->postArr['nav_id'])) $where['nav_id'] = intval($this->postArr['nav_id']);
            $navListArr_ = Db::name($this->table)->field('auto_id, nav_id, nav_name')->where($where)->select();
            foreach ($navListArr_ as $key => $value) {
                if (!empty($this->navListArr[$value['nav_id']]['nav_name'])) $navListArr_[$key]['nav_name'] = $this->navListArr[$value['nav_id']]['nav_name'];
            }
            $a = model('NavList')->saveAll($navListArr_);
            $resultInt = !empty($a) ? 1 : 0;
        }
        return $resultInt;
    }

    // 获取 文档分类 要翻译的内容
    public function getArctypeTranslateArr()
    {
        $this->arctypeArr = $this->arctypeAllArr = [];
        if (!empty($this->fieldArr)) {
            $where = [
                'lang' => trim($this->adminLang),
                'id' => intval($this->postArr['tid']),
            ];
            $this->arctypeAllArr = Db::name($this->table)->field('auto_id, add_time, update_time', true)->where($where)->find();
            foreach ($this->fieldArr as $value) {
                if (!empty($this->arctypeAllArr[$value])) {
                    $this->arctypeArr[$value] = htmlspecialchars_decode($this->arctypeAllArr[$value]);
                    $this->translateArr[$value] = htmlspecialchars_decode($this->arctypeAllArr[$value]);
                }
            }
        }
    }

    // 保存 文档分类 翻译的内容
    public function saveArctypeTranslateArr()
    {
        $resultInt = 0;
        // 处理返回的内容
        foreach ($this->translateResult as $key => $value) {
            // 更新文档表字段
            $this->arctypeArr[$key] = $value;
            $this->arctypeAllArr[$key] = $value;
        }

        // 执行(新增/更新)文档表字段
        if (!empty($this->arctypeArr) || !empty($this->arctypeAllArr)) {
            $where = [
                'lang' => trim($this->langStr),
                'id' => intval($this->postArr['tid']),
            ];
            $arctypeCount = Db::name($this->table)->where($where)->count();
            if (!empty($arctypeCount)) {
                $update = array_merge($this->arctypeArr, ['update_time' => $this->times]);
                $a = Db::name($this->table)->where($where)->update($update);
                $resultInt = !empty($a) ? 1 : 0;
            } else {
                $this->arctypeAllArr['add_time'] = $this->times;
                $this->arctypeAllArr['update_time'] = $this->times;
                $a = Db::name($this->table)->insert($this->arctypeAllArr);
                $resultInt = !empty($a) ? 1 : 0;
            }
        }

        // 查询是否存在单页内容
        $where = [
            'typeid' => intval($this->postArr['tid']),
            'channel' => 6,
        ];
        $archivesFind = Db::name('archives')->where($where)->find();
        if (!empty($archivesFind['aid'])) {
            $where = [
                'aid' => intval($archivesFind['aid']),
            ];
            // 执行(新增/更新)文档表字段
            if (!empty($this->arctypeArr['typename'])) {
                $archivesCount = Db::name('archives_' . $this->langStr)->where($where)->count();
                if (!empty($archivesCount)) {
                    $update = [
                        'title' => $this->arctypeArr['typename'],
                        'update_time' => $this->times,
                    ];
                    $a = Db::name('archives_' . $this->langStr)->where($where)->update($update);
                    $resultInt = !empty($a) ? 1 : 0;
                } else {
                    $archivesFind['title'] = trim($this->arctypeArr['typename']);
                    $archivesFind['add_time'] = $this->times;
                    $archivesFind['update_time'] = $this->times;
                    $a = Db::name('archives_' . $this->langStr)->insert($archivesFind);
                    $resultInt = !empty($a) ? 1 : 0;
                }
            }

            // 执行(新增/更新)内容表字段
            if ((!empty($this->arctypeArr['seo_title']) || !empty($this->arctypeArr['seo_keywords']) || !empty($this->arctypeArr['seo_description']))) {
                $contentCount = Db::name('single_content_' . $this->langStr)->where($where)->count();
                if (!empty($contentCount)) {
                    $update = [
                        'update_time' => $this->times,
                    ];
                    if (isset($this->arctypeArr['seo_title'])) $update['seo_title'] = trim($this->arctypeArr['seo_title']);
                    if (isset($this->arctypeArr['seo_keywords'])) $update['seo_keywords'] = trim($this->arctypeArr['seo_keywords']);
                    if (isset($this->arctypeArr['seo_description'])) $update['seo_description'] = trim($this->arctypeArr['seo_description']);
                    $a = Db::name('single_content_' . $this->langStr)->where($where)->update($update);
                    $resultInt = !empty($a) ? 1 : 0;
                } else {
                    $singleContent = Db::name('single_content')->field('auto_id', true)->where($where)->find();
                    if (isset($this->arctypeArr['seo_title'])) $singleContent['seo_title'] = trim($this->arctypeArr['seo_title']);
                    if (isset($this->arctypeArr['seo_keywords'])) $singleContent['seo_keywords'] = trim($this->arctypeArr['seo_keywords']);
                    if (isset($this->arctypeArr['seo_description'])) $singleContent['seo_description'] = trim($this->arctypeArr['seo_description']);
                    $singleContent['add_time'] = $this->times;
                    $singleContent['update_time'] = $this->times;
                    $a = Db::name('single_content_' . $this->langStr)->insert($singleContent);
                    $resultInt = !empty($a) ? 1 : 0;
                }
            }
        }

        return $resultInt;
    }

    // 获取 留言表单字段 要翻译的内容
    public function getGuestbookAttrTranslateArr()
    {
        $this->guestbookFormArr = [];
        if (!empty($this->fieldArr) && in_array('form_name', $this->fieldArr)) {
            $where = [
                'lang' => trim($this->adminLang),
                'form_id' => intval($this->postArr['form_id'])
            ];
            $this->guestbookFormArr = Db::name('form')->field('form_id, intro, form_name')->where($where)->find();
            if (!empty($this->guestbookFormArr)) $this->translateArr['intro_' . $this->guestbookFormArr['form_id']] = $this->guestbookFormArr['intro'];
            if (!empty($this->guestbookFormArr)) $this->translateArr['form_name_' . $this->guestbookFormArr['form_id']] = $this->guestbookFormArr['form_name'];
        }

        $this->guestbookAttrArr = [];
        if (!empty($this->fieldArr) && (in_array('attr_name', $this->fieldArr) || in_array('placeholder', $this->fieldArr))) {
            $where = [
                'lang' => trim($this->adminLang),
                'typeid' => intval($this->postArr['form_id'])
            ];
            $this->guestbookAttrArr = Db::name($this->table)->field('attr_id, attr_name, placeholder')->where($where)->getAllWithIndex('attr_id');
            foreach ($this->guestbookAttrArr as $key => $value) {
                if (!empty($value['attr_name'])) $this->translateArr['attr_name_' . $key] = $value['attr_name'];
                if (!empty($value['placeholder'])) $this->translateArr['placeholder_' . $key] = $value['placeholder'];
            }
        }
    }

    // 保存 留言表单字段 翻译的内容
    public function saveGuestbookAttrTranslateArr()
    {
        $resultInt = 0;
        $attridArr = [];
        foreach ($this->translateResult as $key => $value) {
            $a = explode('intro_', $key);
            if (!empty($a[1]) && intval($a[1]) === intval($this->guestbookFormArr['form_id'])) $this->guestbookFormArr['intro'] = $value;
            $b = explode('form_name_', $key);
            if (!empty($b[1]) && intval($b[1]) === intval($this->guestbookFormArr['form_id'])) $this->guestbookFormArr['form_name'] = $value;

            $c = explode('attr_name_', $key);
            if (!empty($c[1])) {
                $attr_id = intval($c[1]);
                array_push($attridArr, $attr_id);
                if (!empty($this->guestbookAttrArr[$attr_id])) $this->guestbookAttrArr[$attr_id]['attr_name'] = $value;
            }
            $d = explode('placeholder_', $key);
            if (!empty($d[1])) {
                $attr_id = intval($d[1]);
                array_push($attridArr, $attr_id);
                if (!empty($this->guestbookAttrArr[$attr_id])) $this->guestbookAttrArr[$attr_id]['placeholder'] = $value;
            }
        }

        if (!empty($this->guestbookFormArr)) {
            $where = [
                'lang' => trim($this->langStr),
                'form_id' => intval($this->postArr['form_id'])
            ];
            $this->guestbookFormArr['update_time'] = $this->times;
            $a = Db::name('form')->where($where)->update($this->guestbookFormArr);
            $resultInt = !empty($a) ? 1 : 0;
        }

        if (!empty($attridArr)) {
            $where = [
                'lang' => trim($this->langStr),
                'typeid' => intval($this->postArr['form_id'])
            ];
            $guestbookAttrArr_ = Db::name($this->table)->field('auto_id, attr_id, attr_name, placeholder')->where($where)->select();
            foreach ($guestbookAttrArr_ as $key => $value) {
                $guestbookAttrArr_[$key]['update_time'] = $this->times;
                if (!empty($this->guestbookAttrArr[$value['attr_id']]['attr_name'])) $guestbookAttrArr_[$key]['attr_name'] = $this->guestbookAttrArr[$value['attr_id']]['attr_name'];
                if (!empty($this->guestbookAttrArr[$value['attr_id']]['placeholder'])) $guestbookAttrArr_[$key]['placeholder'] = $this->guestbookAttrArr[$value['attr_id']]['placeholder'];
            }
            $a = model('GuestbookAttribute')->saveAll($guestbookAttrArr_);
            $resultInt = !empty($a) ? 1 : 0;
        }
        return $resultInt;
    }

    public function getFaqAsklistTranslateArr()
    {
        $this->faqAsklistArr = [];
        if (!empty($this->fieldArr) && (in_array('asklist_title', $this->fieldArr) || in_array('asklist_content', $this->fieldArr))) {
            $where = [
                'lang' => trim($this->adminLang),
                'group_id' => intval($this->postArr['group_id'])
            ];
            $this->faqAsklistArr = Db::name($this->table)->field('asklist_id, asklist_title, asklist_content')->where($where)->getAllWithIndex('asklist_id');
            foreach ($this->faqAsklistArr as $key => $value) {
                if (!empty($value['asklist_title']) && in_array('asklist_title', $this->fieldArr)) {
                    $this->translateArr['asklist_title_' . $key] = $value['asklist_title'];
                }
                if (!empty($value['asklist_content']) && in_array('asklist_content', $this->fieldArr)) {
                    $this->translateArr['asklist_content_' . $key] = $value['asklist_content'];
                }
            }
        }
    }

    public function saveFaqAsklistTranslateArr()
    {
        $resultInt = 0;
        $asklistidArr = [];
        foreach ($this->translateResult as $key => $value) {
            $a = explode('asklist_title_', $key);
            if (!empty($a[1])) {
                $asklist_id = intval($a[1]);
                array_push($asklistidArr, $asklist_id);
                if (!empty($this->faqAsklistArr[$asklist_id])) $this->faqAsklistArr[$asklist_id]['asklist_title'] = $value;
            }
            $b = explode('asklist_content_', $key);
            if (!empty($b[1])) {
                $asklist_id = intval($b[1]);
                array_push($asklistidArr, $asklist_id);
                if (!empty($this->faqAsklistArr[$asklist_id])) $this->faqAsklistArr[$asklist_id]['asklist_content'] = $value;
            }
        }

        if (!empty($asklistidArr)) {
            $where = [
                'lang' => trim($this->langStr),
                'group_id' => intval($this->postArr['group_id'])
            ];
            $faqAsklistArr_ = Db::name($this->table)->field('auto_id, asklist_id, asklist_title, asklist_content')->where($where)->select();
            foreach ($faqAsklistArr_ as $key => $value) {
                $faqAsklistArr_[$key]['update_time'] = $this->times;
                if (!empty($this->faqAsklistArr[$value['asklist_id']]['asklist_title'])) {
                    $faqAsklistArr_[$key]['asklist_title'] = $this->faqAsklistArr[$value['asklist_id']]['asklist_title'];
                }
                if (!empty($this->faqAsklistArr[$value['asklist_id']]['asklist_content'])) {
                    $faqAsklistArr_[$key]['asklist_content'] = $this->faqAsklistArr[$value['asklist_id']]['asklist_content'];
                }
            }
            $a = model('FaqAsklist')->saveAll($faqAsklistArr_);
            $resultInt = !empty($a) ? 1 : 0;
        }
        return $resultInt;
    }

    // 获取 文档 要翻译的内容
    public function getArchivesTranslateArr()
    {
        // 查询条件
        $where = [
            'aid' => intval($this->postArr['aid'])
        ];
        
        // 查询文档表字段
        $this->archivesArr = [];
        if (in_array('title', $this->fieldArr)) {
            $this->archivesArr = Db::name('archives_' . $this->adminLang)->where($where)->find();
            if (empty($this->archivesArr)) $this->archivesArr = Db::name('archives')->where($where)->find();
            if (!empty($this->archivesArr['title'])) $this->translateArr['title'] = trim($this->archivesArr['title']);
        }

        // 查询内容表字段
        $pattern = '~<img [^>]*[\s]?[\/]?[\s]?>~';
        $this->contentArr = Db::name($this->table . '_content_' . $this->adminLang)->where($where)->find();
        if (empty($this->contentArr)) $this->contentArr = Db::name($this->table . '_content')->where($where)->find();
        // dump($this->contentArr);exit;
        foreach ($this->fieldArr as $value) {
            if (!empty($this->contentArr[$value])) $this->translateArr[$value] = htmlspecialchars_decode($this->contentArr[$value]);
            if (in_array($value, ['content', 'content_ey_m']) && !empty($this->translateArr[$value])) {
                $b = '';
                // $a = str_replace('<li>', '<p>', htmlspecialchars_decode($this->translateArr[$value]));
                // $a = str_replace('</li>', '</p>', $a);
                $a = explode('</p>', htmlspecialchars_decode($this->translateArr[$value]));
                foreach ($a as $k => $v) {
                    if (!empty($v)) {
                        preg_match_all($pattern, $v, $matches);
                        if (!empty($matches[0])) {
                            $imagesStr = count($matches[0]) > 1 ? implode('', $matches[0]) : $matches[0][0];
                            if (in_array($value, ['content'])) {
                                $this->contentImagesArr[$this->times . $k] = trim($imagesStr) . $this->timesSplitMark;
                            } else if (in_array($value, ['content_ey_m'])) {
                                $this->contentEyMImagesArr[$this->times . $k] = trim($imagesStr) . $this->timesSplitMark;
                            }
                            $b .= $this->times . $k;
                        } else {
                            $b .= $v;
                            if (strpos(trim($b), '<h1>') !== false) {
                                $b = str_replace('<h1>', $this->timesh1Mark, $b);
                            }
                            if (strpos(trim($b), '</h1>') !== false) {
                                $b = str_replace('</h1>', $this->timesh1Mark_, $b);
                            }

                            if (strpos(trim($b), '<h2>') !== false) {
                                $b = str_replace('<h2>', $this->timesh2Mark, $b);
                            }
                            if (strpos(trim($b), '</h2>') !== false) {
                                $b = str_replace('</h2>', $this->timesh2Mark_, $b);
                            }

                            if (strpos(trim($b), '<h3>') !== false) {
                                $b = str_replace('<h3>', $this->timesh3Mark, $b);
                            }
                            if (strpos(trim($b), '</h3>') !== false) {
                                $b = str_replace('</h3>', $this->timesh3Mark_, $b);
                            }

                            if (strpos(trim($b), '<h4>') !== false) {
                                $b = str_replace('<h4>', $this->timesh4Mark, $b);
                            }
                            if (strpos(trim($b), '</h4>') !== false) {
                                $b = str_replace('</h4>', $this->timesh4Mark_, $b);
                            }

                            if (strpos(trim($b), '<h5>') !== false) {
                                $b = str_replace('<h5>', $this->timesh5Mark, $b);
                            }
                            if (strpos(trim($b), '</h5>') !== false) {
                                $b = str_replace('</h5>', $this->timesh5Mark_, $b);
                            }

                            if (strpos(trim($b), '<br/>') !== false) {
                                $b = str_replace('<br/>', $this->timesBrMark, $b);
                            }

                            $b = checkStrHtml($b) . $this->timesSplitMark;
                        }
                    }
                }

                if (!empty($b)) $this->translateArr[$value] = $b;
            }
        }

        // 查询参数表字段
        $paramFieldStr = '';
        if (in_array('param_name', $this->fieldArr)) $paramFieldStr .= 'param_name';
        if (in_array('param_value', $this->fieldArr)) $paramFieldStr .= !empty($paramFieldStr) ? ', param_value' : 'param_value';
        $this->productParamArr = [];
        if (!empty($paramFieldStr)) {
            $paramFieldStr = 'param_id, ' . $paramFieldStr . ', update_time';
            $this->productParamArr = Db::name('product_param_' . $this->adminLang)->field($paramFieldStr)->where($where)->getAllWithIndex('param_id');
            if (empty($this->productParamArr)) $this->productParamArr = Db::name('product_param')->field($paramFieldStr)->where($where)->getAllWithIndex('param_id');
            foreach ($this->productParamArr as $key => $value) {
                foreach ($value as $key_1 => $value_1) {
                    if (in_array($key_1, ['param_name', 'param_value'])) $this->translateArr[$key_1 . '_' . $key] = $value_1;
                }
            }
        }
    }

    // 保存 文档 要翻译的内容
    public function saveArchivesTranslateArr()
    {
        $resultInt = 0;

        /*if (!empty($this->translateResult['title'])) {
            $this->translateResult['title'] = msubstr($this->translateResult['title'], 0, 255);
        }
        if (!empty($this->translateResult['seo_title'])) {
            $this->translateResult['seo_title'] = msubstr($this->translateResult['seo_title'], 0, 70);
        }
        if (!empty($this->translateResult['short_content'])) {
            $this->translateResult['short_content'] = msubstr($this->translateResult['short_content'], 0, 500);
        }*/
        if (!empty($this->translateResult['seo_description'])) {
            $this->translateResult['seo_description'] = msubstr($this->translateResult['seo_description'], 0, 220);
        }

        // 处理返回的内容
        foreach ($this->translateResult as $key => $value) {
            // 更新文档表字段
            if (in_array($key, ['title'])) $this->archivesArr[$key] = $value;

            // 更新内容表字段
            if (in_array($key, ['content', 'content_ey_m'])) $value = htmlspecialchars($value);
            if (in_array($key, ['short_content', 'content', 'content_ey_m', 'seo_title', 'seo_keywords', 'seo_description'])) $this->contentArr[$key] = $value;

            // 获取更新参数表字段
            if (preg_match('/param_name_/i', $key)) {
                $paramNameKey = explode('param_name_', $key);
                $param_id = !empty($paramNameKey[1]) ? intval($paramNameKey[1]) : 0;
                if (!empty($this->productParamArr[$param_id])) {
                    $this->productParamArr[$param_id]['param_name'] = $value;
                    $this->productParamArr[$param_id]['update_time'] = $this->times;
                    // if (isset($this->productParamArr[$param_id]['param_id'])) unset($this->productParamArr[$param_id]['param_id']);
                }
            }
            if (preg_match('/param_value_/i', $key)) {
                $paramValueKey = explode('param_value_', $key);
                $param_id = !empty($paramValueKey[1]) ? intval($paramValueKey[1]) : 0;
                if (!empty($this->productParamArr[$param_id])) {
                    $this->productParamArr[$param_id]['param_value'] = $value;
                    $this->productParamArr[$param_id]['update_time'] = $this->times;
                    // if (isset($this->productParamArr[$param_id]['param_id'])) unset($this->productParamArr[$param_id]['param_id']);
                }
            }
        }

        // 更新条件
        $where = [
            'aid' => intval($this->postArr['aid'])
        ];

        // 查询分类ID
        $typeid = 0;
        $arctypeUpdate = [];
        if (!empty($this->postArr['channel']) && 6 === intval($this->postArr['channel'])) $typeid = Db::name('archives')->where($where)->getField('typeid');

        // 执行(新增/更新)文档表字段
        if (!empty($this->archivesArr)) {
            $archivesCount = Db::name('archives_' . $this->langStr)->where($where)->count();
            if (!empty($archivesCount)) {
                $update = [
                    'title' => $this->archivesArr['title'],
                    'update_time' => $this->times,
                ];
                $a = Db::name('archives_' . $this->langStr)->where($where)->update($update);
                $resultInt = !empty($a) ? 1 : 0;
            } else {
                if (isset($this->archivesArr['auto_id'])) unset($this->archivesArr['auto_id']);
                $this->archivesArr['add_time'] = $this->times;
                $this->archivesArr['update_time'] = $this->times;
                $a = Db::name('archives_' . $this->langStr)->insert($this->archivesArr);
                $resultInt = !empty($a) ? 1 : 0;
            }
            // 更新分类内容
            if (!empty($typeid) && !empty($this->archivesArr['title'])) $arctypeUpdate['typename'] = $this->archivesArr['title'];
        }

        // 执行(新增/更新)内容表字段
        if (!empty($this->contentArr)) {
            $contentCount = Db::name($this->table . '_content_' . $this->langStr)->where($where)->count();
            if (!empty($contentCount)) {
                $update = [
                    'update_time' => $this->times,
                ];
                if (isset($this->translateResult['content'])) $update['content'] = trim($this->contentArr['content']);
                if (isset($this->translateResult['seo_title'])) $update['seo_title'] = trim($this->contentArr['seo_title']);
                if (isset($this->translateResult['content_ey_m'])) $update['content_ey_m'] = trim($this->contentArr['content_ey_m']);
                if (isset($this->translateResult['seo_keywords'])) $update['seo_keywords'] = trim($this->contentArr['seo_keywords']);
                if (isset($this->translateResult['short_content'])) $update['short_content'] = trim($this->contentArr['short_content']);
                if (isset($this->translateResult['seo_description'])) $update['seo_description'] = trim($this->contentArr['seo_description']);
                $a = Db::name($this->table . '_content_' . $this->langStr)->where($where)->update($update);
                $resultInt = !empty($a) ? 1 : 0;
            } else {
                if (isset($this->contentArr['auto_id'])) unset($this->contentArr['auto_id']);
                $this->contentArr['add_time'] = $this->times;
                $this->contentArr['update_time'] = $this->times;
                $a = Db::name($this->table . '_content_' . $this->langStr)->insert($this->contentArr);
                $resultInt = !empty($a) ? 1 : 0;
            }

            // 更新分类内容
            if (!empty($typeid) && !empty($this->archivesArr['title'])) {
                if (isset($this->translateResult['seo_title'])) $arctypeUpdate['seo_title'] = trim($this->contentArr['seo_title']);
                if (isset($this->translateResult['seo_keywords'])) $arctypeUpdate['seo_keywords'] = trim($this->contentArr['seo_keywords']);
                if (isset($this->translateResult['seo_description'])) $arctypeUpdate['seo_description'] = trim($this->contentArr['seo_description']);
            }
        }

        // 执行更新参数表字段
        if (!empty($this->productParamArr)) {
            // 删除原有参数信息
            // Db::name('product_param_' . $this->langStr)->where($where)->delete(true);
            // 新增翻译后的参数
            // $a = Db::name('product_param_' . $this->langStr)->insertAll($this->productParamArr);
            // $resultInt = !empty($a) ? 1 : 0;

            foreach ($this->productParamArr as $update) {
                @Db::name('product_param_' . $this->langStr)->update($update);
            }
            $resultInt = 1;
        }

        // 更新分类内容
        if (!empty($arctypeUpdate)) {
            $where = [
                'lang' => trim($this->langStr),
                'id' => intval($typeid),
            ];
            $arctypeUpdate['update_time'] = $this->times;
            $a = Db::name('arctype')->where($where)->update($arctypeUpdate);
            $resultInt = !empty($a) ? 1 : 0;
        }

        return $resultInt;
    }

    // 执行翻译
    public function executeTranslate()
    {
        // 请求内容
        $this->textKey = $this->textList = [];
        foreach ($this->translateArr as $key => $value) {
            if (!empty($value) && !preg_match("/^\d+$/", $value)) {
                $this->textKey[] = $key;
                $this->textList[] = htmlspecialchars_decode(htmlspecialchars_decode($value));
            }
        }
        if (empty($this->textList)) $this->success('翻译失败', null, ['code' => 0, 'msg' => '翻译内容为空，请填写或保存再进行翻译']);

        // 获取翻译API请求信息
        $this->getTranslateApiParam();

        // 加载client
        $clientObj = new Client(['base_uri' => 'http://' . $this->requestParam['host'], 'timeout' => 120.0]);
        // 调接翻译接口
        $clientData = [
            'headers' => $this->header,
            'query' => $this->requestParam['query'],
            'body' => $this->requestParam['body']
        ];
        $resultObj = $clientObj->request($this->method, 'http://' . $this->requestParam['host'] . $this->requestParam['path'], $clientData);
        // 解析数据
        $this->resultArr = $resultObj->getBody()->getContents();
        $this->resultArr = !empty($this->resultArr) ? json_decode($this->resultArr, true) : [];

        // 检测翻译结果
        $this->detectResultArr();

        // 处理翻译结果
        $this->handleResultArr();
    }

    // 获取翻译API请求信息
    public function getTranslateApiParam()
    {
        $this->body = [
            'TargetLanguage' => trim($this->langStr_),
            'TextList' => $this->textList,
        ];
        $this->body = json_encode($this->body);

        // 初始化签名结构体
        $this->getRequestParam();

        // 初始化签名结果的结构体
        $this->getSignResult();

        // 计算 Signature 签名，获取请求头信息
        $this->getClientHeader();
    }

    // 初始化签名结构体
    public function getRequestParam()
    {
        $query = [
            'Action' => $this->action,
            'Version' => $this->version
        ];
        ksort($query);
        $this->requestParam = [
            'body' => $this->body,
            'host' => $this->translateHost,
            'path' => '/',
            'method' => $this->method,
            'contentType' => $this->contentType,
            'date' => gmdate('Ymd\THis\Z'),
            'query' => $query
        ];
    }

    // 初始化签名结果的结构体
    public function getSignResult()
    {
        $xDate = $this->requestParam['date'];
        $this->xContentSha256 = hash('sha256', $this->requestParam['body']);
        $this->signResult = [
            'Host' => $this->requestParam['host'],
            'X-Content-Sha256' => $this->xContentSha256,
            'X-Date' => $xDate,
            'Content-Type' => $this->requestParam['contentType']
        ];
    }

    // 计算 Signature 签名，获取请求头信息
    public function getClientHeader()
    {
        $credential = [
            'accessKeyId' => $this->doubaoAccessKeyID,
            'secretKeyId' => $this->doubaoSecretAccessKey,
            'service' => $this->service,
            'region' => $this->region,
        ];
        $signedHeaderStr = join(';', ['content-type', 'host', 'x-content-sha256', 'x-date']);
        $canonicalRequestStr = join("\n", [
            $this->requestParam['method'],
            $this->requestParam['path'],
            http_build_query($this->requestParam['query']),
            join("\n", ['content-type:' . $this->requestParam['contentType'], 'host:' . $this->requestParam['host'], 'x-content-sha256:' . $this->signResult['X-Content-Sha256'], 'x-date:' . $this->requestParam['date']]),
            '',
            $signedHeaderStr,
            $this->signResult['X-Content-Sha256']
        ]);
        $shortXDate = substr($this->requestParam['date'], 0, 8);
        $hashedCanonicalRequest = hash("sha256", $canonicalRequestStr);
        $credentialScope = join('/', [$shortXDate, $credential['region'], $credential['service'], 'request']);
        $stringToSign = join("\n", ['HMAC-SHA256', $this->requestParam['date'], $credentialScope, $hashedCanonicalRequest]);
        $kDate = hash_hmac("sha256", $shortXDate, $credential['secretKeyId'], true);
        $kRegion = hash_hmac("sha256", $credential['region'], $kDate, true);
        $kService = hash_hmac("sha256", $credential['service'], $kRegion, true);
        $kSigning = hash_hmac("sha256", 'request', $kService, true);
        $signature = hash_hmac("sha256", $stringToSign, $kSigning);
        $this->signResult['Authorization'] = sprintf("HMAC-SHA256 Credential=%s, SignedHeaders=%s, Signature=%s", $credential['accessKeyId'] . '/' . $credentialScope, $signedHeaderStr, $signature);

        $this->header = $this->signResult;
    }

    // 处理翻译结果
    public function detectResultArr()
    {
        if (empty($this->resultArr)) $this->success('翻译失败', null, ['code' => 0, 'msg' => '翻译内容存在异常，请再次翻译该语言内容']);
        if (!empty($this->resultArr['ResponseMetaData']['Error'])) {
            $msg = '火山引擎接口提示: ' . $this->resultArr['ResponseMetaData']['Error']['Message'];
            if ('-400' == strval($this->resultArr['ResponseMetaData']['Error']['Code'])) {
                $msg = '火山引擎接口提示: 详情信息字数超过限制(仅支持5k字符翻译)，请简短内容再次翻译该语言内容';
            }
            else if ('-415' == strval($this->resultArr['ResponseMetaData']['Error']['Code'])) {
                $msg = '火山引擎接口提示: 暂不支持该语言翻译';
            }
            else if ('-429' == strval($this->resultArr['ResponseMetaData']['Error']['Code'])) {
                $msg = '火山引擎接口提示: 当前语言请求过于频繁，请稍后再次翻译该语言内容';
            }
            else if ('-500' == strval($this->resultArr['ResponseMetaData']['Error']['Code'])) {
                $msg = '火山引擎接口提示: 当前翻译服务内部错误，请稍后再次翻译该语言内容';
            }
            $this->success('翻译失败', null, ['code' => 0, 'msg' => $msg]);
        }
        else if (!empty($this->resultArr['ResponseMetadata']['Error'])) {
            $msg = '火山引擎接口提示: ' . $this->resultArr['ResponseMetadata']['Error']['Code'];
            if (100009 === intval($this->resultArr['ResponseMetadata']['Error']['CodeN'])) {
                $msg = '火山引擎接口提示: 请求的Access Key ID错误。 请检查本系统的[设置]-[翻译设置]-[Access Key ID]是否填写正确，注意不要有多余的空格符号';
            }
            else if (100010 === intval($this->resultArr['ResponseMetadata']['Error']['CodeN'])) {
                $msg = '火山引擎接口提示: 请求的Secret Access Key错误。 请检查本系统的[设置]-[翻译设置]-[Secret Access Key]是否填写正确，注意不要有多余的空格符号';
            }
            $this->error($msg);
        }
    }

    // 处理翻译结果
    public function handleResultArr()
    {
        // 处理并返回翻译结果
        $this->translateResult = [];
        foreach ($this->textList as $key => $value) {
            if (!empty($this->resultArr['TranslationList'][$key]['Translation'])) {
                $this->translateResult[$this->textKey[$key]] = htmlspecialchars_decode($this->resultArr['TranslationList'][$key]['Translation']);
            }

            if (in_array($this->textKey[$key], ['content', 'content_ey_m']) && !empty($this->translateResult[$this->textKey[$key]])) {
                $bb = '';
                $aa = $this->translateResult[$this->textKey[$key]];
                $aa = str_replace($this->timesBrMark, '<br/>', $aa);
                $aa = str_replace($this->timesh1Mark, '<h1>', $aa);
                $aa = str_replace($this->timesh1Mark_, '</h1>', $aa);
                $aa = str_replace($this->timesh2Mark, '<h2>', $aa);
                $aa = str_replace($this->timesh2Mark_, '</h2>', $aa);
                $aa = str_replace($this->timesh3Mark, '<h3>', $aa);
                $aa = str_replace($this->timesh3Mark_, '</h3>', $aa);
                $aa = str_replace($this->timesh4Mark, '<h4>', $aa);
                $aa = str_replace($this->timesh4Mark_, '</h4>', $aa);
                $aa = str_replace($this->timesh5Mark, '<h5>', $aa);
                $aa = str_replace($this->timesh5Mark_, '</h5>', $aa);
                if (!empty($this->contentImagesArr)) $aa = str_replace(array_keys($this->contentImagesArr), array_values($this->contentImagesArr), $aa);
                if (!empty($this->contentEyMImagesArr)) $aa = str_replace(array_keys($this->contentEyMImagesArr), array_values($this->contentEyMImagesArr), $aa);
                $aa = !empty($aa) ? explode($this->timesSplitMark, $aa) : [];
                foreach ($aa as $vv) {
                    $vv_ = trim($vv);
                    if (!empty($vv_)) {
                        preg_match_all('/<h[1-6](.*?)h[1-6]>/i', $vv_, $hhhhh);
                        if (!empty($hhhhh[0])) {
                            $bb .= $vv;
                        } else {
                            $bb .= '<p>' . $vv . '</p>';
                        }
                    }
                }
                if (!empty($bb)) $this->translateResult[$this->textKey[$key]] = $bb;
            }
            else if (strpos(trim($this->textKey[$key]), 'pack_id_') !== false && !empty($this->translateResult[$this->textKey[$key]])) {
                $dd = $this->translateResult[$this->textKey[$key]];
                $dd = str_replace($this->timesPercentsMark, '%s', $this->translateResult[$this->textKey[$key]]);
                if (!empty($this->stringTagsArr)) $dd = str_replace(array_keys($this->stringTagsArr), array_values($this->stringTagsArr), $dd);
                $this->translateResult[$this->textKey[$key]] = $dd;
            }
        }
    }

    // 设置API逻辑参数
    public function setApiLogicParam($post = [], $cover = false)
    {
        $this->postArr = !empty($post) && !empty($cover) ? $post : $this->postArr;
        // 翻译API参数
        $this->method = 'POST';
        $this->region = "cn-north-1";
        $this->service = "translate";
        $this->version = "2020-06-01";
        $this->action = 'TranslateText';
        $this->contentType = "application/json";
        $this->translateHost = "translate.volcengineapi.com";
        $this->doubaoAccessKeyID = !empty($this->doubaoArr['doubao_access_key_id']) ? trim($this->doubaoArr['doubao_access_key_id']) : '';
        $this->doubaoSecretAccessKey = !empty($this->doubaoArr['doubao_secret_access_key']) ? trim($this->doubaoArr['doubao_secret_access_key']) : '';

        // POST接收的翻译数据表
        $this->table = !empty($this->postArr['table']) ? $this->postArr['table'] : '';

        // POST接收的翻译字段
        $this->fieldArr = !empty($this->postArr['fieldArr']) ? $this->postArr['fieldArr'] : [];

        // 提交API接口的翻译字段内容数组
        $this->translateArr = [];

        // 查询翻译语言
        $this->langStr_ = $this->langStr = !empty($this->postArr['langArr'][0]) ? trim($this->postArr['langArr'][0]) : '';
        if ('cn' === trim($this->langStr)) {
            $this->langStr_ = 'zh';
        } else if ('zh' === trim($this->langStr)) {
            $this->langStr_ = 'zh-Hant';
        }

        // 2024-10-01 00:00:00时间戳标记 '<br/>'
        $this->timesBrMark = 117277120001;
        // 2024-10-02 00:00:00时间戳标记 分割符
        $this->timesSplitMark = 117277984001;
        // 2024-10-03 00:00:00时间戳标记 '%s'
        $this->timesPercentsMark = 117278848001;
        // 2024-10-04 00:00:00时间戳标记 '<h1>'
        $this->timesh1Mark = 117279712001;
        // 2024-10-04 00:00:00时间戳标记 '</h1>'
        $this->timesh1Mark_ = 217279712002;
        // 2024-10-05 00:00:00时间戳标记 '<h2>'
        $this->timesh2Mark = 117280576001;
        // 2024-10-05 00:00:00时间戳标记 '</h2>'
        $this->timesh2Mark_ = 217280576002;
        // 2024-10-06 00:00:00时间戳标记 '<h3>'
        $this->timesh3Mark = 117281440001;
        // 2024-10-06 00:00:00时间戳标记 '</h3>'
        $this->timesh3Mark_ = 217281440002;
        // 2024-10-07 00:00:00时间戳标记 '<h4>'
        $this->timesh4Mark = 117282304001;
        // 2024-10-07 00:00:00时间戳标记 '</h4>'
        $this->timesh4Mark_ = 217282304002;
        // 2024-10-08 00:00:00时间戳标记 '<h5>'
        $this->timesh5Mark = 117283168001;
        // 2024-10-08 00:00:00时间戳标记 '</h5>'
        $this->timesh5Mark_ = 217283168002;
    }


}