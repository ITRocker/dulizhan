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

namespace app\home\controller;

use think\Db;
use think\Config;
use think\AjaxPage;
use think\Request;

class Ajax extends Base
{
    public function _initialize() {
        parent::_initialize();
    }

    /**
     * 跳转到文档详情页
     * @return [type] [description]
     */
    public function toView()
    {
        $aid = input('param.aid/d');
        if (!empty($aid)) {
            $archives = Db::name('archives')->alias('a')
                ->field('b.*, a.*, c.ctl_name')
                ->join('arctype b', 'a.typeid = b.id', 'LEFT')
                ->join('channeltype c', 'c.id = a.channel', 'LEFT')
                ->where(['a.aid'=>$aid])
                ->find();
            $url = arcurl('home/'.$archives['ctl_name'].'/view', $archives, true, true);
            header('Location: '.$url);
            exit;
        }
    }

    /**
     * 获取评论列表
     * @return mixed
     */
    public function product_comment()
    {
        \think\Session::pause(); // 暂停session，防止session阻塞机制
        $post = input('post.');
        $post['aid'] = !empty($post['aid']) ? $post['aid'] : input('param.aid/d');

        if (isMobile() && 1 < $post['p']) {
            $Result = [];
        } else {
            $Result = cache('EyouHomeAjaxComment_' . $post['aid']);
            if (empty($Result)) {
                /*商品评论数计算*/
                $time = getTime();
                $where = [
                    'is_show' => 1,
                    'add_time' => ['<=', $time],
                    'product_id' => $post['aid']
                ];
                $count = Db::name('shop_order_comment')->field('total_score, is_new_comment')->where($where)->select();

                $Result['total']  = count($count);
                $Result['good']   = 0;
                $Result['middle'] = 0;
                $Result['bad']    = 0;
                foreach ($count as $k => $v) {
                    // 评价转换星级评分(旧版评价数据执行)
                    $v['total_score'] = empty($v['is_new_comment']) ? GetScoreArray($v['total_score']) : $v['total_score'];
                    if (in_array($v['total_score'], [1, 2])) {
                        $Result['bad']++;
                    } else if (in_array($v['total_score'], [3, 4])) {
                        $Result['middle']++;
                    } else if (in_array($v['total_score'], [5])) {
                        $Result['good']++;
                    }
                }
                $Result['good_percent'] = $Result['good'] > 0 ? round($Result['good'] / $Result['total'] * 100) : 0;
                if (0 === intval($Result['good_percent']) && $Result['total'] === 0) $Result['good_percent'] = 100;
                $Result['middle_percent'] = $Result['middle'] > 0 ? round($Result['middle'] / $Result['total'] * 100) : 0;
                $Result['bad_percent'] = $Result['bad'] > 0 ? 100 - $Result['good_percent'] - $Result['middle_percent'] : 0;
                // 存在评论则执行
                // if (!empty($Result)) cache('EyouHomeAjaxComment_' . $post['aid'], $Result, null, 'shop_order_comment');
            }

            /*选中状态*/
            $Result['Class_1'] = 0 == $post['score'] ? 'check' : '';
            $Result['Class_2'] = 1 == $post['score'] ? 'check' : '';
            $Result['Class_3'] = 2 == $post['score'] ? 'check' : '';
            $Result['Class_4'] = 3 == $post['score'] ? 'check' : '';
        }
        
        // 调用评价列表
        $this->GetCommentList($post);
        $this->assign('Result', $Result);
        return $this->fetch('system/product_comment');
    }

    // 手机端加载更多时调用
    public function comment_list()
    {
        \think\Session::pause(); // 暂停session，防止session阻塞机制
        // 调用评价列表
        $this->GetCommentList(input('post.'));
        return $this->fetch('system/comment_list');
    }

    // 调用评价列表
    private function GetCommentList($post = [])
    {
        // 商品评论数据处理
        $field = 'a.*, u.username, u.nickname, u.email, u.head_pic, u.sex, b.data';
        // $field = 'a.*, u.username, u.nickname, u.email, u.head_pic, u.sex, l.level_name, b.data';
        $time = getTime();
        $where = [
            'a.is_show' => 1,
            'a.add_time' => ['<=', $time],
            'a.product_id' => $post['aid']
        ];
        if (!empty($post['score'])) {
            // $where['a.total_score'] = $post['score'];
            if (3 === intval($post['score'])) {
                $where['a.total_score'] = ['IN', [1, 2]];
            } else if (2 === intval($post['score'])) {
                $where['a.total_score'] = ['IN', [3, 4]];
            } else if (1 === intval($post['score'])) {
                $where['a.total_score'] = ['IN', [5]];
            }
        }
        $count = Db::name('shop_order_comment')->alias('a')->where($where)->count();
        $Page = new AjaxPage($count, 5);
        $Comment = Db::name('shop_order_comment')
            ->alias('a')
            ->field($field)
            ->where($where)
            ->join('__SHOP_ORDER_DETAILS__ b', 'a.details_id = b.details_id', 'LEFT')
            ->join('__USERS__ u', 'a.users_id = u.users_id', 'LEFT')
            // ->join('__USERS_LEVEL__ l', 'u.level = l.level_id', 'LEFT')
            ->order('a.add_time desc')
            ->limit($Page->firstRow . ',' . $Page->listRows)
            ->select();
        $Comment = !empty($Comment) ? $Comment : [];
        foreach ($Comment as &$value) {
            // 规格处理
            $value['data'] = !empty($value['data']) ? unserialize($value['data']) : [];
            $value['spec_value'] = !empty($value['data']['spec_value']) ? htmlspecialchars_decode($value['data']['spec_value']) : '';
            $value['spec_value'] = !empty($value['spec_value']) ? rtrim(str_replace("<br/>", "，", $value['spec_value']), '，') : '';
            // 评价昵称和邮箱处理
            $value['nickname'] = empty($value['nickname']) ? $value['username'] : $value['nickname'];
            $value['nickname'] = !empty($value['visitors_name']) ? trim($value['visitors_name']) : $value['nickname'];
            $value['email'] = !empty($value['visitors_email']) ? trim($value['visitors_email']) : $value['email'];
            // 评价头像处理
            $value['head_pic'] = handle_subdir_pic(get_head_pic($value['head_pic'], false, $value['sex']));
            // $value['head_pic'] = get_head_pic($value['head_pic'], false, $value['sex']);
            // 是否匿名评价
            $value['nickname'] = empty($value['is_anonymous']) ? $value['nickname'] : '匿名用户';
            // 评价转换星级评分(旧版评价数据执行)
            $value['total_score'] = empty($value['is_new_comment']) ? GetScoreArray($value['total_score']) : $value['total_score'];
            // 评价上传的图片
            $value['upload_img'] = !empty($value['upload_img']) ? explode(',', unserialize($value['upload_img'])) : '';
            // 评价的内容
            $value['content'] = !empty($value['content']) ? htmlspecialchars_decode(unserialize($value['content'])) : '';
            // 回复的内容
            $adminReply = !empty($value['admin_reply']) ? unserialize($value['admin_reply']) : [];
            $adminReply['adminReply'] = !empty($adminReply['adminReply']) ? htmlspecialchars_decode($adminReply['adminReply']) : '';
            $value['admin_reply'] = $adminReply;
        }

        // 新版评价处理，查询全部评价评分
        $totalScoreAll = Db::name('shop_order_comment')->alias('a')->field('total_score, is_new_comment')->where($where)->select();
        $totalScore = $praiseNum = 0;
        foreach ($totalScoreAll as $score) {
            // 计算总评分
            $score['total_score'] = empty($score['is_new_comment']) ? GetScoreArray($score['total_score']) : $score['total_score'];
            $totalScore = intval($totalScore) + intval($score['total_score']);
            // 好评数统计(4星以上算好评)
            if (intval($score['total_score']) >= 4) $praiseNum++;
        }
        // 评价总数
        $totalScoreRows = count($totalScoreAll);
        // 好评率(4星以上算好评)
        $praiseRate = intval($totalScoreRows) == 0 ? 0 : intval((intval($praiseNum) / intval($totalScoreRows)) * 100);
        if (0 === intval($praiseRate)) $praiseRate = 100;
        // 总评分 / 评价人数 = 评分平均值
        // $averageRating = floatval(sprintf("%.2f", strval(intval($totalScore) / intval($totalScoreRows))));
        $averageRating = intval($totalScoreRows) == 0 ? 0 : sprintf("%.1f", strval(intval($totalScore) / intval($totalScoreRows)));
        if (0 === intval($averageRating)) $averageRating = '5.0';
        // 平均值占比
        $averageRatingRate = floatval(sprintf("%.2f", (strval($averageRating) / strval(5)) * strval(100)));
        $this->assign('praiseRate', $praiseRate);
        $this->assign('averageRating', $averageRating);
        $this->assign('totalScoreRows', $totalScoreRows);
        $this->assign('averageRatingRate', $averageRatingRate);

        // 加载渲染模板
        $this->assign('Page', $Page->show());
        $this->assign('PageObj', $Page);
        $this->assign('Comment', $Comment);
        $this->assign('productID', $post['aid']);
        $this->assign('users', GetUsersLatestData());
        $this->assign('commentCount', intval($count));
        $this->assign('submitUrl', dynamic_url('home/Ajax/submitComment', ['_ajax'=>1]));
    }

    public function submitComment()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            // 请填写评价内容
            if (empty($post['content'])) $this->error('请填写评价内容');
            // 登录会员ID
            $users_id = session('users_id');
            // 访问游客ID
            $isVisitors = 0;
            $visitorsID = model('ShopPublicHandle')->getVisitorsID();
            if (empty($users_id) && !empty($visitorsID)) {
                if (empty($post['visitors_name'])) {
                    $this->error(lang('users271', [lang('users208', [], $this->home_lang)], $this->home_lang));
                } else if (empty($post['visitors_email'])) {
                    $this->error(lang('users114', [], $this->home_lang));
                } else if (!check_email($post['visitors_email'])) {
                    $this->error(lang('users121', [], $this->home_lang));
                }
                $isVisitors = 1;
            }

            // 是否开启评价自动审核
            $shopOpenCommentAudit = getUsersConfigData('shop.shop_open_comment_audit');

            // 添加评价数据
            $insert = [
                'users_id'    => !empty($users_id) ? intval($users_id) : intval($visitorsID),
                'product_id'  => !empty($post['productID']) ? intval($post['productID']) : 0,
                'total_score' => !empty($post['total_score']) ? intval($post['total_score']) : 5,
                'content'     => !empty($post['content']) ? serialize(htmlspecialchars($post['content'])) : '',
                'upload_img'  => '',
                'ip_address'  => clientIP(),
                'is_new_comment' => 1,
                'is_show'     => !empty($shopOpenCommentAudit) ? 0 : 1,
                'is_visitors' => $isVisitors,
                'visitors_name' => !empty($post['visitors_name']) ? trim($post['visitors_name']) : '',
                'visitors_email' => !empty($post['visitors_email']) ? trim($post['visitors_email']) : '',
                'lang'        => $this->home_lang,
                'add_time'    => getTime(),
                'update_time' => getTime(),
            ];
            $resultID = Db::name('shop_order_comment')->insertGetId($insert);
            if (!empty($resultID)) {
                // 商品主表增加评价数
                if (!empty($post['productID'])) {
                    $where = [
                        'aid' => $post['productID'],
                    ];
                    Db::name('archives')->where($where)->setInc('appraise', 1);
                    // 清理缓存并返回结束
                    cache('EyouHomeAjaxComment_' . $post['productID'], null, null, 'shop_order_comment');
                }
                $this->success(!empty($shopOpenCommentAudit) ? lang('users381', [], $this->home_lang) : lang('users305', [], $this->home_lang));
            } else {
                $this->error(lang('users306', [], $this->home_lang));
            }
        }
    }

    // 联动地址获取
    public function ajax_get_region_data()
    {
        $parent_id = input('param.parent_id/d');
        // 获取指定区域ID下的城市并判断是否需要处理特殊市返回值
        $RegionData = $this->SpecialCityDealWith($parent_id);
        // 处理数据
        $region_html = $region_names = $region_ids = '';
        if ($RegionData) {
            // 拼装下拉选项
            foreach ($RegionData as $key => $value) {
                $region_html .= "<option value='{$value['id']}'>{$value['name']}</option>";
                if ($key > '0') {
                    $region_names .= '，';
                    $region_ids   .= ',';
                }
                $region_names .= $value['name'];
                $region_ids   .= $value['id'];
            }
        }
        $return = [
            'region_html'  => $region_html,
            'region_names' => $region_names,
            'region_ids'   => $region_ids,
//            'parent_array' => config('global.field_region_all_type'),
        ];
        echo json_encode($return);
    }

    // 获取指定区域ID下的城市并判断是否需要处理特殊市返回值
    // 特殊市：北京市，上海市，天津市，重庆市
    private function SpecialCityDealWith($parent_id = 0)
    {
        empty($parent_id) && $parent_id = 0;

        /*parent_id在特殊范围内则执行*/
        // 处理北京市，上海市，天津市，重庆市逻辑
        $RegionData   = Db::name('region')->where("parent_id", $parent_id)->select();
        $parent_array = config('global.field_region_type');
        if (in_array($parent_id, $parent_array)) {
            $region_ids = get_arr_column($RegionData, 'id');
            $RegionData = Db::name('region')->where('parent_id', 'IN', $region_ids)->select();
        }
        /*结束*/
        return $RegionData;
    }

    public function openGoodsDetails()
    {
        $aid = input('param.aid/d', 0);
        $where = [
            'aid' => intval($aid)
        ];
        $archivesModel = new \app\admin\model\Archives();
        $archives = $archivesModel->getDetailsData($where, '*', $this->home_lang);
        $this->assign('archives', $archives);
        $productImgList = !empty($archives['aid']) ? model('ProductImg')->getProImg($archives['aid']) : [];
        $this->assign('productImgList', !empty($productImgList[$archives['aid']]) ? $productImgList[$archives['aid']] : []);
        return $this->fetch(':open_details');
    }

    public function inquiry()
    {
        // 会员ID或临时记录ID
        $users_id = session('users_id');
        $users_id = !empty($users_id) ? intval($users_id) : model('ShopPublicHandle')->getVisitorsID();
        // 查询询盘记录
        $homeLang = input('param.lang/s', $this->home_lang);
        $where = [
            'a.lang' => $homeLang,
            'a.status' => 0,
            'a.users_id' => intval($users_id),
        ];
        // dump($where);exit;
        $field = 'a.*, b.typeid, b.stypeid, b.channel, b.title, b.litpic, b.htmlfilename';
        $goodsList = Db::name('guestbook_goods')->alias('a')->join('__ARCHIVES__ b', 'a.goods_id = b.aid', 'LEFT')->where($where)->field($field)->select();
        // dump($goodsList);
        // 查询对应语言商品信息
        $aidArr = !empty($goodsList) ? get_arr_column($goodsList, 'goods_id') : [];
        if (!empty($aidArr)) {
            $where = [
                'aid' => ['IN', $aidArr],
            ];
            $goodsLang = Db::name('archives_' . $homeLang)->where($where)->field('aid, title')->getAllWithIndex('aid');
            foreach ($goodsList as $key => $value) {
                $value['title'] = !empty($goodsLang[$value['goods_id']]['title']) ? trim($goodsLang[$value['goods_id']]['title']) : trim($value['title']);
                $value['litpic'] = !empty($value['litpic']) ? handle_subdir_pic($value['litpic']) : trim($value['litpic']);
                $value['htmlfilename'] = !empty($value['htmlfilename']) ? get_arcurl($value) : trim($value['htmlfilename']);
                $goodsList[$key] = $value;
            }
        }
        // dump($goodsList);
        // exit;
        $this->assign('goodsList', $goodsList);
        $functionLogic = new \app\common\logic\FunctionLogic;
        $functionLogic->validate_authorfile(1);
        // 基础信息
        $this->assign('zan', $this->zan);
        return $this->fetch(':product_inquiry');
    }

    public function addInquiryList()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            // 会员ID或临时记录ID
            $users_id = session('users_id');
            $users_id = !empty($users_id) ? intval($users_id) : model('ShopPublicHandle')->getVisitorsID();
            // 保存询盘记录
            $homeLang = input('param.lang/s', $this->home_lang);
            $insert = [
                'lang' => $homeLang,
                'status' => 0,
                'users_id' => intval($users_id),
                'goods_id' => intval($post['goods_id'])
            ];
            $count = Db::name('guestbook_goods')->where($insert)->count();
            if (!empty($count)) {
                $resultID = Db::name('guestbook_goods')->where($insert)->setInc('goods_num', intval($post['goods_num']));
            } else {
                $insert = array_merge($insert, [
                    'add_time' => getTime(),
                    'goods_num' => intval($post['goods_num']),
                ]);
                $resultID = Db::name('guestbook_goods')->insert($insert);
            }
            if (!empty($resultID)) $this->success(lang('users272', [], $homeLang));
        }
        $this->error('操作失败');
    }

    public function editInquiryList()
    {
        if (IS_AJAX_POST) {
            $post = input('post.');
            // 会员ID或临时记录ID
            $users_id = session('users_id');
            $users_id = !empty($users_id) ? intval($users_id) : model('ShopPublicHandle')->getVisitorsID();
            // 保存询盘记录
            $homeLang = input('param.lang/s', $this->home_lang);
            $where = [
                'lang' => $homeLang,
                'status' => 0,
                'users_id' => intval($users_id),
                'goods_id' => intval($post['goods_id'])
            ];
            $count = Db::name('guestbook_goods')->where($where)->count();
            if (!empty($count)) {
                $resultID = Db::name('guestbook_goods')->where($where)->update(['goods_num' => intval($post['goods_num']), 'update_time' => getTime()]);
                if (!empty($resultID)) $this->success(lang('users272', [], $homeLang));
            } else {
                $this->success(lang('users131', [], $homeLang));
            }
        }
        $this->error('操作失败');
    }

    public function delInquiryList()
    {
        if (IS_AJAX_POST) {
            $goods_id = input('post.goods_id/d', 0);
            // 会员ID或临时记录ID
            $users_id = session('users_id');
            $users_id = !empty($users_id) ? intval($users_id) : model('ShopPublicHandle')->getVisitorsID();
            // 保存询盘记录
            $homeLang = input('param.lang/s', $this->home_lang);
            $where = [
                'lang' => $homeLang,
                'status' => 0,
                'users_id' => intval($users_id),
                'goods_id' => intval($goods_id)
            ];
            $resultID = Db::name('guestbook_goods')->where($where)->delete(true);
            if (!empty($resultID)) {
                $where = [
                    'lang' => $homeLang,
                    'status' => 0,
                    'users_id' => intval($users_id),
                ];
                $count = Db::name('guestbook_goods')->where($where)->count();
                $this->success(lang('users272', [], $homeLang), null, $count);
            }
        }
        $this->error('操作失败');
    }
}