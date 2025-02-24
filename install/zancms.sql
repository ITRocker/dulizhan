-- ----------------------------------------
-- ZanCms MySQL Data Transfer 
-- 
-- Server         : 127.0.0.1_3306
-- Server Version : 5.7.26
-- Host           : 127.0.0.1:3306
-- Database       : z2_6
-- 
-- Part : #1
-- Version : #v2.0.6
-- Date : 2025-02-24 11:56:23
-- -----------------------------------------

SET FOREIGN_KEY_CHECKS = 0;


-- -----------------------------
-- Table structure for `zan_ad`
-- -----------------------------
DROP TABLE IF EXISTS `zan_ad`;
CREATE TABLE `zan_ad` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '广告id',
  `pid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '广告位置ID',
  `media_type` tinyint(1) DEFAULT '0' COMMENT '广告类型',
  `title` varchar(60) DEFAULT '' COMMENT '广告名称',
  `links` varchar(255) DEFAULT '' COMMENT '广告链接',
  `litpic` varchar(255) DEFAULT '' COMMENT '图片地址',
  `start_time` int(11) DEFAULT '0' COMMENT '投放时间',
  `end_time` int(11) DEFAULT '0' COMMENT '结束时间',
  `intro` text COMMENT '描述',
  `link_man` varchar(60) DEFAULT '' COMMENT '添加人',
  `link_email` varchar(60) DEFAULT '' COMMENT '添加人邮箱',
  `link_phone` varchar(60) DEFAULT '' COMMENT '添加人联系电话',
  `click` int(11) DEFAULT '0' COMMENT '点击量',
  `bgcolor` varchar(30) DEFAULT '' COMMENT '背景颜色',
  `status` tinyint(1) unsigned DEFAULT '1' COMMENT '1=显示，0=屏蔽',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序',
  `target` varchar(50) DEFAULT '' COMMENT '是否开启浏览器新窗口',
  `admin_id` int(10) DEFAULT '0' COMMENT '管理员ID',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '伪删除，1=是，0=否',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '多语言',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `id` (`id`,`lang`),
  KEY `position_id` (`pid`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='广告表';

-- -----------------------------
-- Records of `zan_ad`
-- -----------------------------
INSERT INTO `zan_ad` VALUES ('5', '2', '1', '1', 'dress', '/', '/uploads/allimg/20241107/1-24110G5140Nb.webp', '0', '0', '', '', '', '', '0', '', '1', '2', '1', '1', '0', 'en', '1727657294', '1729501506');
INSERT INTO `zan_ad` VALUES ('2', '1', '1', '1', 'new product', '/', '/uploads/allimg/20241107/1-24110G5134T46.webp', '0', '0', '', '', '', '', '0', '', '1', '1', '1', '1', '0', 'en', '1727657294', '1729501506');

-- -----------------------------
-- Table structure for `zan_ad_position`
-- -----------------------------
DROP TABLE IF EXISTS `zan_ad_position`;
CREATE TABLE `zan_ad_position` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL DEFAULT '0',
  `title` varchar(60) NOT NULL DEFAULT '' COMMENT '广告位置名称',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '广告展示类型，1图片类型，2媒体类型，3HTML代码',
  `width` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '广告位宽度',
  `height` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '广告位高度',
  `intro` text NOT NULL COMMENT '广告描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0关闭1开启',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '多语言',
  `admin_id` int(10) NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '伪删除，1=是，0=否',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `id` (`id`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='广告位置表';

-- -----------------------------
-- Records of `zan_ad_position`
-- -----------------------------
INSERT INTO `zan_ad_position` VALUES ('2', '1', '广告位', '1', '1920', '550', '广告图片的宽高度随着浏览器大小而改变', '1', 'en', '0', '0', '1524209276', '1690166783');

-- -----------------------------
-- Table structure for `zan_admin`
-- -----------------------------
DROP TABLE IF EXISTS `zan_admin`;
CREATE TABLE `zan_admin` (
  `admin_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user_name` varchar(20) NOT NULL DEFAULT '' COMMENT '用户名',
  `pen_name` varchar(50) DEFAULT '' COMMENT '笔名（发布文章后显示责任编辑的名字）',
  `true_name` varchar(20) DEFAULT '' COMMENT '真实姓名',
  `mobile` varchar(11) DEFAULT '' COMMENT '手机号码',
  `email` varchar(60) DEFAULT '' COMMENT 'email',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '密码',
  `pwd_lenth` smallint(5) DEFAULT '0' COMMENT '密码长度',
  `head_pic` varchar(255) DEFAULT '' COMMENT '头像',
  `last_login` int(11) DEFAULT '0' COMMENT '最后登录时间',
  `last_ip` varchar(15) DEFAULT '' COMMENT '最后登录ip',
  `login_cnt` int(11) DEFAULT '0' COMMENT '登录次数',
  `session_id` varchar(50) DEFAULT '' COMMENT 'session_id',
  `parent_id` int(10) DEFAULT '0' COMMENT '父管理员ID',
  `role_id` int(10) NOT NULL DEFAULT '-1' COMMENT '角色组ID（-1表示超级管理员）',
  `mark_lang` varchar(50) DEFAULT 'cn' COMMENT '当前语言标识',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态(0=屏蔽，1=正常)',
  `syn_users_id` int(10) DEFAULT '0' COMMENT '同步注册到会员表',
  `desc` varchar(500) DEFAULT '' COMMENT '工作内容',
  `wechat_appid` varchar(50) DEFAULT '' COMMENT '公众号appid',
  `wechat_followed` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '记录是否关注了微信公众号，默认0；0=未关注、1=已关注',
  `wechat_open_id` varchar(50) NOT NULL DEFAULT '' COMMENT 'open_id，关注微信公众号后存入',
  `union_id` varchar(50) DEFAULT '' COMMENT '微信用户的unionId',
  `add_time` int(11) DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`admin_id`),
  KEY `user_name` (`user_name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='管理员表';

-- -----------------------------
-- Records of `zan_admin`
-- -----------------------------
INSERT INTO `zan_admin` VALUES ('1', 'admin', '', 'admin', '', '', '$2y$11$5e4def0b7303a9d745733uMVF8yYImvD9bVZl6z4WnviKfjiYAFAy', '0', '', '1740369345', '127.0.0.1', '2', 'rro6i22u9elnrde593km7e4vv5', '0', '-1', 'cn', '1', '0', '', '', '0', '', '', '1740369341', '0');

-- -----------------------------
-- Table structure for `zan_admin_log`
-- -----------------------------
DROP TABLE IF EXISTS `zan_admin_log`;
CREATE TABLE `zan_admin_log` (
  `log_id` bigint(16) unsigned NOT NULL AUTO_INCREMENT COMMENT '表id',
  `admin_id` int(10) NOT NULL DEFAULT '-1' COMMENT '管理员id',
  `log_info` text COMMENT '日志描述',
  `log_ip` varchar(30) DEFAULT '' COMMENT 'ip地址',
  `log_url` varchar(255) DEFAULT '' COMMENT 'url',
  `log_time` int(11) DEFAULT '0' COMMENT '日志时间',
  PRIMARY KEY (`log_id`),
  KEY `admin_id` (`admin_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=47 DEFAULT CHARSET=utf8 COMMENT='管理员操作日志表';

-- -----------------------------
-- Records of `zan_admin_log`
-- -----------------------------
INSERT INTO `zan_admin_log` VALUES ('11', '1', '新增语言变量：diy2', '127.0.0.1', '/login.php', '1740102504');
INSERT INTO `zan_admin_log` VALUES ('10', '1', '新增语言变量：diy1', '127.0.0.1', '/login.php', '1740102464');
INSERT INTO `zan_admin_log` VALUES ('9', '1', '系统在线升级：v2.0.5 -&gt; v2.0.6', '127.0.0.1', '/login.php', '1740102337');
INSERT INTO `zan_admin_log` VALUES ('8', '1', '后台登录', '127.0.0.1', '/login.php', '1740102310');
INSERT INTO `zan_admin_log` VALUES ('12', '1', '新增语言变量：diy3', '127.0.0.1', '/login.php', '1740102546');
INSERT INTO `zan_admin_log` VALUES ('13', '1', '新增语言变量：diy4', '127.0.0.1', '/login.php', '1740102558');
INSERT INTO `zan_admin_log` VALUES ('14', '1', '新增语言变量：diy5', '127.0.0.1', '/login.php', '1740102570');
INSERT INTO `zan_admin_log` VALUES ('15', '1', '编辑多语言：', '127.0.0.1', '/login.php', '1740103162');
INSERT INTO `zan_admin_log` VALUES ('16', '1', '删除询盘-id：1', '127.0.0.1', '/login.php', '1740103284');
INSERT INTO `zan_admin_log` VALUES ('17', '1', '备份数据库', '127.0.0.1', '/login.php', '1740103474');
INSERT INTO `zan_admin_log` VALUES ('18', '1', '编辑多语言：', '127.0.0.1', '/login.php', '1740103696');
INSERT INTO `zan_admin_log` VALUES ('19', '1', '编辑多语言：', '127.0.0.1', '/login.php', '1740103716');
INSERT INTO `zan_admin_log` VALUES ('20', '1', '编辑多语言：', '127.0.0.1', '/login.php', '1740103731');
INSERT INTO `zan_admin_log` VALUES ('21', '1', '编辑多语言：', '127.0.0.1', '/login.php', '1740103777');
INSERT INTO `zan_admin_log` VALUES ('22', '1', '编辑多语言：', '127.0.0.1', '/login.php', '1740104029');
INSERT INTO `zan_admin_log` VALUES ('23', '1', '编辑多语言：', '127.0.0.1', '/login.php', '1740104036');
INSERT INTO `zan_admin_log` VALUES ('24', '1', '新增单页：FAQ', '127.0.0.1', '/login.php', '1740104211');
INSERT INTO `zan_admin_log` VALUES ('25', '1', '编辑多语言：', '127.0.0.1', '/login.php', '1740104476');
INSERT INTO `zan_admin_log` VALUES ('26', '1', '新增图集：跨季节穿搭：巧用叠穿，让你的女装四季常青', '127.0.0.1', '/login.php', '1740108090');
INSERT INTO `zan_admin_log` VALUES ('27', '1', '编辑图集：Cross-seasonal wear: skillfully use stacking to make your women\'s clothing evergreen', '127.0.0.1', '/login.php', '1740108108');
INSERT INTO `zan_admin_log` VALUES ('28', '1', '编辑图集：跨季節穿搭：巧用疊穿，讓你的女裝四季常青', '127.0.0.1', '/login.php', '1740108122');
INSERT INTO `zan_admin_log` VALUES ('29', '1', '新增图集：职场新宠：简约风女装助你高效拿下商务谈判', '127.0.0.1', '/login.php', '1740108165');
INSERT INTO `zan_admin_log` VALUES ('30', '1', '编辑图集：The new favorite in the workplace: simple women\'s clothing helps you win business negotiations efficiently', '127.0.0.1', '/login.php', '1740108177');
INSERT INTO `zan_admin_log` VALUES ('31', '1', '编辑图集：職場新寵：簡約風女裝助你高效拿下商務談判', '127.0.0.1', '/login.php', '1740108189');
INSERT INTO `zan_admin_log` VALUES ('32', '1', '编辑图集：The new favorite in the workplace: simple women\'s clothing helps you win business negotiations efficiently', '127.0.0.1', '/login.php', '1740108199');
INSERT INTO `zan_admin_log` VALUES ('33', '1', '编辑图集：Cross-seasonal wear: skillfully use stacking to make your women\'s clothing evergreen', '127.0.0.1', '/login.php', '1740108231');
INSERT INTO `zan_admin_log` VALUES ('34', '1', '删除数据库备份文件', '127.0.0.1', '/login.php', '1740109054');
INSERT INTO `zan_admin_log` VALUES ('35', '1', '备份数据库', '127.0.0.1', '/login.php', '1740109188');
INSERT INTO `zan_admin_log` VALUES ('36', '1', '编辑产品：Elegant Jacquard Loose Long Sleeve Dress', '127.0.0.1', '/login.php', '1740124097');
INSERT INTO `zan_admin_log` VALUES ('37', '1', '编辑产品：Solid color waist V-neck sleeveless party dress skirt', '127.0.0.1', '/login.php', '1740124116');
INSERT INTO `zan_admin_log` VALUES ('38', '1', '编辑产品：Slim-fit hip-wrapped shoulder-knitted fishtail dress dress', '127.0.0.1', '/login.php', '1740124127');
INSERT INTO `zan_admin_log` VALUES ('39', '1', '编辑产品：Suit Collar Black And White Splicing Seven-quarter Sleeve Waist And Hip Dress', '127.0.0.1', '/login.php', '1740124147');
INSERT INTO `zan_admin_log` VALUES ('40', '1', '编辑产品：French over-knee bow strap medium and long high-waisted pleated chiffon retro dress', '127.0.0.1', '/login.php', '1740124166');
INSERT INTO `zan_admin_log` VALUES ('41', '1', '编辑产品：Contrast color large lapel waist slit denim A-shaped skirt', '127.0.0.1', '/login.php', '1740124179');
INSERT INTO `zan_admin_log` VALUES ('42', '1', '编辑产品：Chiffon splicing fake two-piece set, shoulder-slipping splicing waist and thin hip skirt', '127.0.0.1', '/login.php', '1740124196');
INSERT INTO `zan_admin_log` VALUES ('43', '1', '删除数据库备份文件', '127.0.0.1', '/login.php', '1740124211');
INSERT INTO `zan_admin_log` VALUES ('44', '1', '后台登录', '127.0.0.1', '/login.php', '1740369345');
INSERT INTO `zan_admin_log` VALUES ('45', '1', '删除多语言：简体中文', '127.0.0.1', '/login.php', '1740369357');
INSERT INTO `zan_admin_log` VALUES ('46', '1', '删除多语言：繁体中文', '127.0.0.1', '/login.php', '1740369361');

-- -----------------------------
-- Table structure for `zan_admin_menu`
-- -----------------------------
DROP TABLE IF EXISTS `zan_admin_menu`;
CREATE TABLE `zan_admin_menu` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `menu_id` int(11) DEFAULT '0',
  `title` varchar(100) DEFAULT '' COMMENT '导航名称',
  `original_title` varchar(100) DEFAULT '' COMMENT '原导航名称',
  `controller_name` varchar(50) DEFAULT '' COMMENT '控制器',
  `action_name` varchar(50) DEFAULT '' COMMENT '方法名',
  `param` varchar(255) DEFAULT '' COMMENT '参数',
  `icon` varchar(50) DEFAULT 'iconfont e-lanmuguanli' COMMENT '图标',
  `is_menu` tinyint(1) DEFAULT '0' COMMENT '是否显示为左侧菜单',
  `is_switch` tinyint(1) DEFAULT '0' COMMENT '是否显示在switch_map页面中',
  `target` varchar(50) DEFAULT 'workspace' COMMENT '链接打开方式',
  `sort_order` int(10) DEFAULT '100' COMMENT '排序号',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态，1=显示，0=隐藏',
  `lang` varchar(20) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `menu_id` (`menu_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='外挂功能地图菜单表';

-- -----------------------------
-- Records of `zan_admin_menu`
-- -----------------------------
INSERT INTO `zan_admin_menu` VALUES ('2', '1001', '分类', '分类', 'Arctype', 'lists', '|mt20|1', 'iconfont e-lanmuguanli', '0', '1', 'workspace', '2', '1', 'cn', '1650263716', '1723795757');
INSERT INTO `zan_admin_menu` VALUES ('3', '1002', '内容', '内容', 'ShopProduct', 'index', '', 'iconfont e-neirongwendang', '1', '1', 'workspace', '2', '1', 'cn', '1650263716', '1728726508');
INSERT INTO `zan_admin_menu` VALUES ('5', '1003', '广告', '广告', 'AdPosition', 'index', '', 'iconfont e-guanggao', '0', '1', 'workspace', '5', '1', 'cn', '1650263716', '1650263716');
INSERT INTO `zan_admin_menu` VALUES ('1', '1005', '概览', '概览', 'Index', 'welcome', '', 'iconfont e-shujutongji', '1', '1', 'workspace', '0', '1', 'cn', '1650263716', '1650263716');
INSERT INTO `zan_admin_menu` VALUES ('6', '2001', '设置', '设置', 'System', 'web', '', 'iconfont e-shezhi', '1', '1', 'workspace', '6', '1', 'cn', '1650263716', '1723795910');
INSERT INTO `zan_admin_menu` VALUES ('7', '2002', '网站', '网站', 'Uiset', 'template_list', '', 'iconfont e-keshihuabianji', '1', '1', 'workspace', '5', '1', 'cn', '1650263716', '1724644643');
INSERT INTO `zan_admin_menu` VALUES ('8', '2003', '运营', '运营', 'Seo', 'index', '', 'iconfont e-seo', '0', '1', 'workspace', '100', '1', 'cn', '1650263716', '1733207484');
INSERT INTO `zan_admin_menu` VALUES ('9', '2004', '功能', '功能', 'Index', 'switch_map', '', 'iconfont e-caidangongneng', '1', '0', 'workspace', '10000', '1', 'cn', '1650263716', '1650263716');
INSERT INTO `zan_admin_menu` VALUES ('10', '2005', '应用', '应用', 'Weapp', 'index', '', 'iconfont e-chajian', '1', '1', 'workspace', '100', '1', 'cn', '1650263716', '1724295694');
INSERT INTO `zan_admin_menu` VALUES ('11', '2006', '客户', '客户', 'Member', 'users_index', '', 'iconfont e-gerenzhongxin', '1', '1', 'workspace', '4', '1', 'cn', '1650263716', '1650263716');
INSERT INTO `zan_admin_menu` VALUES ('12', '2008', '商城', '商城', 'Shop', 'home', '', 'iconfont e-shangcheng', '0', '1', 'workspace', '100', '1', 'cn', '1650263716', '1732181690');
INSERT INTO `zan_admin_menu` VALUES ('15', '2004013', '导航', '导航', 'Navigation', 'index', '', 'iconfont e-daohangguanli', '0', '1', 'workspace', '6', '1', 'cn', '1724124422', '1724124422');
INSERT INTO `zan_admin_menu` VALUES ('14', '2004018', '询盘', '询盘', 'Form', 'index', '|form_id|1', 'iconfont e-biaodanguanli', '1', '1', 'workspace', '3', '1', 'cn', '1677037793', '1733210248');
INSERT INTO `zan_admin_menu` VALUES ('16', '2004021', '订单', '订单', 'Order', 'index', '', 'iconfont e-dingdanguanli', '1', '1', 'workspace', '1', '1', 'cn', '1725007538', '1733196715');

-- -----------------------------
-- Table structure for `zan_admin_theme`
-- -----------------------------
DROP TABLE IF EXISTS `zan_admin_theme`;
CREATE TABLE `zan_admin_theme` (
  `theme_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `theme_type` tinyint(1) DEFAULT '0' COMMENT '主题类型：1=登录页，2=欢迎页',
  `theme_title` varchar(50) DEFAULT '' COMMENT '主题标题',
  `theme_pic` varchar(255) DEFAULT '' COMMENT '主题效果图',
  `theme_color_model` varchar(10) DEFAULT '' COMMENT '主题颜色模式',
  `theme_main_color` varchar(20) DEFAULT '' COMMENT '主题主色',
  `theme_assist_color` varchar(20) DEFAULT '' COMMENT '主题辅色',
  `login_logo` varchar(255) DEFAULT '' COMMENT '登录图标',
  `login_bgimg_model` varchar(10) DEFAULT '' COMMENT '登录背景图模式',
  `login_bgimg` varchar(255) DEFAULT '' COMMENT '登录背景图',
  `login_tplname` varchar(100) DEFAULT '' COMMENT '登录页自定义模板',
  `admin_logo` varchar(255) DEFAULT '' COMMENT '后台Logo',
  `welcome_tplname` varchar(100) DEFAULT '' COMMENT '欢迎页自定义模板',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '内置主题',
  `sort_order` int(10) DEFAULT '100' COMMENT '排序号',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`theme_id`)
) ENGINE=MyISAM AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COMMENT='后台主题风格表';

-- -----------------------------
-- Records of `zan_admin_theme`
-- -----------------------------
INSERT INTO `zan_admin_theme` VALUES ('1', '1', '经典蓝主题', '/public/static/admin/images/theme/theme_pic_1.png', '1', '#3398cc', '#2189be', '/public/static/admin/login/login-logo_ey.png', '1', '/public/static/admin/loginbg/login-bg-1.png', '', '/public/static/admin/logo/logo_ey.png', '', '1', '100', '1681200988', '1681200988');
INSERT INTO `zan_admin_theme` VALUES ('2', '1', '易优橙主题', '/public/static/admin/images/theme/theme_pic_2.png', 'custom', '#197971', '#fa921b', '/public/static/admin/login/login-logo.png', '2', '/public/static/admin/loginbg/login-bg-1.png', '', '/public/static/admin/logo/logo.png', '', '1', '100', '1681866512', '1681866512');
INSERT INTO `zan_admin_theme` VALUES ('4', '2', '商城欢迎页', '/public/static/admin/images/theme/theme_pic_4.png', '', '', '', '', '', '', '', '', 'welcome_shop.htm', '1', '100', '1681200988', '1681200988');
INSERT INTO `zan_admin_theme` VALUES ('5', '2', '任务流欢迎页', '/public/static/admin/images/theme/theme_pic_5.png', '', '', '', '', '', '', '', '', 'welcome_taskflow.htm', '1', '100', '1681200988', '1681200988');
INSERT INTO `zan_admin_theme` VALUES ('3', '2', '默认欢迎页', '/public/static/admin/images/theme/theme_pic_default.png', '', '', '', '', '', '', '', '', '', '1', '100', '1681200988', '1681200988');
INSERT INTO `zan_admin_theme` VALUES ('100', '1', '默认主题', '/public/static/admin/images/theme/theme_pic_default.png', '1', '#3398cc', '#2189be', '/public/static/admin/images/login-logo_ey.png', '1', '/public/static/admin/images/login-bg.jpg', '', '/public/static/admin/images/logo_ey.png', '', '0', '100', '1692667955', '1692667955');

-- -----------------------------
-- Table structure for `zan_admin_wxlogin`
-- -----------------------------
DROP TABLE IF EXISTS `zan_admin_wxlogin`;
CREATE TABLE `zan_admin_wxlogin` (
  `wx_id` int(11) NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '1=官方公众号，2=微信应用',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `openid` varchar(50) NOT NULL DEFAULT '' COMMENT 'openid',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '微信昵称',
  `unionid` varchar(200) NOT NULL DEFAULT '' COMMENT 'unionid',
  `headimgurl` varchar(200) NOT NULL DEFAULT '' COMMENT '头像',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`wx_id`),
  KEY `openid` (`openid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='后台微信登录记录表';


-- -----------------------------
-- Table structure for `zan_archives`
-- -----------------------------
DROP TABLE IF EXISTS `zan_archives`;
CREATE TABLE `zan_archives` (
  `aid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档主表自增ID',
  `typeid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '当前栏目',
  `stypeid` varchar(100) DEFAULT '' COMMENT '副栏目ID集合',
  `channel` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '模型ID',
  `title` varchar(500) DEFAULT '' COMMENT '文档标题',
  `litpic` varchar(255) DEFAULT '' COMMENT '封面图片',
  `is_litpic` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否存在图片(0:否; 1:是;)',
  `is_b` tinyint(1) DEFAULT '0' COMMENT '加粗',
  `is_head` tinyint(1) DEFAULT '0' COMMENT '头条（0=否，1=是）',
  `is_special` tinyint(1) DEFAULT '0' COMMENT '特荐（0=否，1=是）',
  `is_top` tinyint(1) DEFAULT '0' COMMENT '置顶（0=否，1=是）',
  `is_recom` tinyint(1) DEFAULT '0' COMMENT '推荐（0=否，1=是）',
  `is_roll` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '滚动（0=否，1=是）',
  `is_slide` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '幻灯（0=否，1=是）',
  `is_diyattr` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '自定义（0=否，1=是）',
  `is_jump` tinyint(1) DEFAULT '0' COMMENT '跳转链接（0=否，1=是）',
  `jumplinks` varchar(255) DEFAULT '' COMMENT '跳转网址',
  `tempview` varchar(200) DEFAULT '' COMMENT '文档模板',
  `htmlfilename` varchar(500) DEFAULT '' COMMENT '自定义文件名',
  `click` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击数',
  `author` varchar(100) DEFAULT '' COMMENT '作者',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0:屏蔽; 1:正常;)',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序号',
  `spec_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '商品规格类型(1:单规格; 2:多规格;)',
  `users_price` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '会员价',
  `crossed_price` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '商品划线价',
  `users_discount_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '产品会员折扣类型(0:系统默认折扣; 1:指定会员级别; 2:不参与折扣;)',
  `free_shipping` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '商品是否包邮(1包邮(免运费)  0跟随系统)',
  `sales_num` int(10) NOT NULL DEFAULT '0' COMMENT '总销售量',
  `virtual_sales` int(10) DEFAULT '0' COMMENT '商品虚拟销售量',
  `sales_all` int(10) DEFAULT '0' COMMENT '虚拟总销量',
  `stock_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品库存量',
  `stock_show` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '商品库存在产品详情页是否显示，1为显示，0为不显示',
  `prom_type` tinyint(1) unsigned DEFAULT '0' COMMENT '产品类型：0=普通产品，1=虚拟(默认手动发货)，2=虚拟(网盘)，3=虚拟(自定义文本) 4-核销',
  `logistics_type` varchar(100) DEFAULT '1' COMMENT '商品物流支持类型(1: 物流配送; 2: 到店核销)',
  `appraise` int(10) DEFAULT '0' COMMENT '评价数',
  `collection` int(10) DEFAULT '0' COMMENT '收藏数',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '伪删除(0:否; 1:是;)',
  `del_method` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '伪删除状态(1:主动删除; 2:跟随上级栏目被动删除;)',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `editor_img_clear_link` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '清除非本站链接',
  `editor_remote_img_local` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '远程图片本地化',
  PRIMARY KEY (`aid`),
  UNIQUE KEY `aid` (`aid`),
  KEY `add_time` (`add_time`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=68 DEFAULT CHARSET=utf8 COMMENT='文档主表';

-- -----------------------------
-- Records of `zan_archives`
-- -----------------------------
INSERT INTO `zan_archives` VALUES ('19', '5', '5', '1', 'BICES 2024 Exhibitor talks about BICES exhibition', '/uploads/allimg/20241009/1-2410091F100955.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'light-luxury-new-style-is-irresistible-male-charm', '800', '小编', '1', '100', '1', '0.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1728464463', '1730365740', '1', '1');
INSERT INTO `zan_archives` VALUES ('23', '1', '1', '2', '纯色翻领收腰系带气质开叉连衣长裙', '/uploads/allimg/20241011/1-24101115450G40.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'spring-and-summer-new-solid-color-crew-neck-pleated-lace-up-dress', '664', '小编', '1', '100', '1', '40.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1728613140', '1730766606', '1', '1');
INSERT INTO `zan_archives` VALUES ('18', '5', '5', '1', 'BICES 2024 User representative talks about BICES', '/uploads/allimg/20241009/1-2410091A9201D.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'light-luxury-and-elegance-customize-your-romantic-outfit-without-fear-of-winter-cold', '532', '小编', '1', '100', '1', '0.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1728464382', '1730766857', '1', '1');
INSERT INTO `zan_archives` VALUES ('16', '15', '15', '6', '关于我们', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', 'lists_single.htm', 'About-Us', '217', '小编', '1', '100', '1', '0.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1727399159', '1732245160', '1', '1');
INSERT INTO `zan_archives` VALUES ('17', '16', '16', '6', '联系我们', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', 'lists_single_contact.htm', 'contact-us', '117', '小编', '1', '100', '1', '0.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1728464226', '1732245160', '1', '1');
INSERT INTO `zan_archives` VALUES ('20', '5', '5', '1', 'High-tech gathering! Xugong fire Yangtze River Delta emergency exhibition', '/uploads/allimg/20241009/1-2410091F20Y35.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'simple-commute-low-key-senior-elegant-choice-for-working-women', '344', '小编', '1', '100', '1', '0.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1728464531', '1730766691', '1', '1');
INSERT INTO `zan_archives` VALUES ('21', '5', '5', '1', 'CCTV spotlight! Infrastructure heat in excavator index', '/uploads/allimg/20241009/1-2410091G055917.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'simple-literature-and-art-full-of-intellectual-charm', '983', '小编', '1', '100', '1', '0.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1728465066', '1730766635', '1', '1');
INSERT INTO `zan_archives` VALUES ('24', '1', '1', '2', '长袖纯色长裙纯色收腰连衣裙', '/uploads/allimg/20241011/1-241011155033592.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'solid-color-waist-v-neck-sleeveless-party-dress-skirt', '477', '小编', '1', '100', '1', '24.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1728633173', '1740124113', '1', '1');
INSERT INTO `zan_archives` VALUES ('25', '1', '1', '2', '气质优雅提花宽松长袖连衣裙', '/uploads/allimg/20241011/1-241011155AH15.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'elegant-jacquard-loose-long-sleeve-dress', '717', '小编', '1', '100', '1', '35.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1728634536', '1740124087', '1', '1');
INSERT INTO `zan_archives` VALUES ('26', '1', '1', '2', '修身包臀一字肩针织鱼尾裙连衣裙', '/uploads/allimg/20241011/1-241011162053330.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'slim-fit-hip-wrapped-shoulder-knitted-fishtail-dress-dress', '852', '小编', '1', '100', '1', '69.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1728634895', '1740124127', '1', '1');
INSERT INTO `zan_archives` VALUES ('27', '1', '1,2', '2', '西装领黑白拼接七分袖收腰包臀连衣裙', '/uploads/allimg/20241011/1-2410111F145953.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'suit-collar-black-and-white-splicing-seven-quarter-sleeve-waist-and-hip-dress', '406', '小编', '1', '100', '1', '89.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1728637484', '1740124143', '1', '1');
INSERT INTO `zan_archives` VALUES ('33', '1', '1', '2', '法式过膝蝴蝶结系带中长款高腰百褶雪纺复古连衣裙', '/uploads/allimg/20241016/1-2410160R944S8.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'french-over-knee-bow-strap-medium-and-long-high-waisted-pleated-chiffon-retro-dress', '326', '小编', '1', '100', '1', '0.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1729038726', '1740124157', '1', '1');
INSERT INTO `zan_archives` VALUES ('34', '1', '1', '2', '撞色大翻领收腰开衩牛仔A字裙', '/uploads/allimg/20241016/1-2410160S5361C.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'contrast-color-large-lapel-waist-slit-denim-a-shaped-skirt', '633', '小编', '1', '100', '1', '20.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1729038975', '1740124175', '1', '1');
INSERT INTO `zan_archives` VALUES ('35', '1', '1', '2', '雪纺拼接假两件套溜肩拼接收腰显瘦包臀裙', '/uploads/allimg/20241016/1-2410160T13S03.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'chiffon-splicing-fake-two-piece-set-shoulder-slipping-splicing-waist-and-thin-hip-skirt', '194', '小编', '1', '100', '1', '0.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1729128655', '1740124188', '1', '1');
INSERT INTO `zan_archives` VALUES ('41', '1', '1', '2', '法式衬衫设计感一字领上衣夏季小衫', '/uploads/allimg/20241016/1-2410161H516496.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'french-shirt-design-one-letter-collar-top-summer-shirt', '281', '小编', '1', '100', '1', '18.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1729070729', '1730766570', '0', '0');
INSERT INTO `zan_archives` VALUES ('65', '17', '17', '6', 'FAQ', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', 'lists_single_faq.htm', 'faq', '490', '小编', '1', '100', '1', '0.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1740104211', '1740104322', '0', '0');
INSERT INTO `zan_archives` VALUES ('66', '6', '6', '3', '跨季节穿搭：巧用叠穿，让你的女装四季常青', '/uploads/allimg/20250221/1-25022111211M01.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'cross-seasonal-wear-skillfully-use-stacking-to-make-your-women-s-clothing-evergreen', '128', '小编', '1', '100', '1', '0.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1740107869', '1740108231', '1', '1');
INSERT INTO `zan_archives` VALUES ('67', '6', '6', '3', '职场新宠：简约风女装助你高效拿下商务谈判', '/uploads/allimg/20250221/1-25022111211R38.jpg', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', 'the-new-favorite-in-the-workplace-simple-women-s-clothing-helps-you-win-business-negotiations-efficiently', '353', '小编', '1', '100', '1', '0.00', '0.00', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '1', '0', '0', '1740108128', '1740108199', '1', '1');

-- -----------------------------
-- Table structure for `zan_archives_cn`
-- -----------------------------
DROP TABLE IF EXISTS `zan_archives_cn`;
CREATE TABLE `zan_archives_cn` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '中文文档自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `typeid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '当前栏目',
  `stypeid` varchar(100) DEFAULT '' COMMENT '副栏目ID集合',
  `channel` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '模型ID',
  `title` varchar(500) DEFAULT '' COMMENT '文档标题',
  `litpic` varchar(255) DEFAULT '' COMMENT '封面图片',
  `is_litpic` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否存在图片(0:否; 1:是;)',
  `is_b` tinyint(1) DEFAULT '0' COMMENT '加粗',
  `is_head` tinyint(1) DEFAULT '0' COMMENT '头条（0=否，1=是）',
  `is_special` tinyint(1) DEFAULT '0' COMMENT '特荐（0=否，1=是）',
  `is_top` tinyint(1) DEFAULT '0' COMMENT '置顶（0=否，1=是）',
  `is_recom` tinyint(1) DEFAULT '0' COMMENT '推荐（0=否，1=是）',
  `is_roll` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '滚动（0=否，1=是）',
  `is_slide` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '幻灯（0=否，1=是）',
  `is_diyattr` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '自定义（0=否，1=是）',
  `is_jump` tinyint(1) DEFAULT '0' COMMENT '跳转链接（0=否，1=是）',
  `jumplinks` varchar(255) DEFAULT '' COMMENT '跳转网址',
  `click` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击数',
  `author` varchar(100) DEFAULT '' COMMENT '作者',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0:屏蔽; 1:正常;)',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序号',
  `users_price` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '会员价',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '伪删除(0:否; 1:是;)',
  `del_method` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '伪删除状态(1:主动删除; 2:跟随上级栏目被动删除;)',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `editor_img_clear_link` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '清除非本站链接',
  `editor_remote_img_local` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '远程图片本地化',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`),
  KEY `add_time` (`add_time`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=64 DEFAULT CHARSET=utf8 COMMENT='中文文档 -- 基础数据表';


-- -----------------------------
-- Table structure for `zan_archives_en`
-- -----------------------------
DROP TABLE IF EXISTS `zan_archives_en`;
CREATE TABLE `zan_archives_en` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '中文文档自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `typeid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '当前栏目',
  `stypeid` varchar(100) DEFAULT '' COMMENT '副栏目ID集合',
  `channel` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '模型ID',
  `title` varchar(500) DEFAULT '' COMMENT '文档标题',
  `litpic` varchar(255) DEFAULT '' COMMENT '封面图片',
  `is_litpic` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否存在图片(0:否; 1:是;)',
  `is_b` tinyint(1) DEFAULT '0' COMMENT '加粗',
  `is_head` tinyint(1) DEFAULT '0' COMMENT '头条（0=否，1=是）',
  `is_special` tinyint(1) DEFAULT '0' COMMENT '特荐（0=否，1=是）',
  `is_top` tinyint(1) DEFAULT '0' COMMENT '置顶（0=否，1=是）',
  `is_recom` tinyint(1) DEFAULT '0' COMMENT '推荐（0=否，1=是）',
  `is_roll` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '滚动（0=否，1=是）',
  `is_slide` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '幻灯（0=否，1=是）',
  `is_diyattr` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '自定义（0=否，1=是）',
  `is_jump` tinyint(1) DEFAULT '0' COMMENT '跳转链接（0=否，1=是）',
  `jumplinks` varchar(255) DEFAULT '' COMMENT '跳转网址',
  `click` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击数',
  `author` varchar(100) DEFAULT '' COMMENT '作者',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0:屏蔽; 1:正常;)',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序号',
  `users_price` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '会员价',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '伪删除(0:否; 1:是;)',
  `del_method` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '伪删除状态(1:主动删除; 2:跟随上级栏目被动删除;)',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `editor_img_clear_link` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '清除非本站链接',
  `editor_remote_img_local` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '远程图片本地化',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`),
  KEY `add_time` (`add_time`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COMMENT='中文文档 -- 基础数据表';

-- -----------------------------
-- Records of `zan_archives_en`
-- -----------------------------
INSERT INTO `zan_archives_en` VALUES ('6', '23', '0', '', '2', 'Spring and summer new solid color crew neck pleated lace-up dress', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '285', '小编', '1', '100', '40.00', '1', '0', '0', '1728613215', '1728639292', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('5', '16', '0', '', '6', 'About Us', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '237', '小编', '1', '100', '0.00', '1', '0', '0', '1727399183', '1730167681', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('7', '24', '0', '', '2', 'Solid color waist V-neck sleeveless party dress skirt', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '589', '小编', '1', '100', '0.00', '1', '0', '0', '1728633173', '1740124113', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('8', '25', '0', '', '2', 'Elegant Jacquard Loose Long Sleeve Dress', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '822', '小编', '1', '100', '0.00', '1', '0', '0', '1728634536', '1740124087', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('22', '17', '0', '', '6', 'Contact Us', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '672', '小编', '1', '100', '0.00', '1', '0', '0', '1729156516', '1729156516', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('9', '26', '0', '', '2', 'Slim-fit hip-wrapped shoulder-knitted fishtail dress dress', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '725', '小编', '1', '100', '0.00', '1', '0', '0', '1728634895', '1740124127', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('10', '27', '0', '', '2', 'Suit Collar Black And White Splicing Seven-quarter Sleeve Waist And Hip Dress', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '487', '小编', '1', '100', '0.00', '1', '0', '0', '1728637484', '1740124143', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('11', '18', '0', '', '1', 'Light luxury and elegance, customize your romantic outfit, without fear of winter cold', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '297', '小编', '1', '100', '0.00', '1', '0', '0', '1728975125', '1730766840', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('12', '21', '0', '', '1', 'Simple literature and art, full of intellectual charm', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '820', '小编', '1', '100', '0.00', '1', '0', '0', '1728978275', '1730766731', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('14', '33', '0', '', '2', 'French over-knee bow strap medium and long high-waisted pleated chiffon retro dress', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '256', '小编', '1', '100', '0.00', '1', '0', '0', '1729038726', '1740124157', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('15', '34', '0', '', '2', 'Contrast color large lapel waist slit denim A-shaped skirt', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '441', '小编', '1', '100', '0.00', '1', '0', '0', '1729038975', '1740124175', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('21', '41', '0', '', '2', 'French shirt design one-letter collar top summer shirt', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '483', '小编', '1', '100', '18.00', '1', '0', '0', '1729128864', '1730684963', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('20', '35', '0', '', '2', 'Chiffon splicing fake two-piece set, shoulder-slipping splicing waist and thin hip skirt', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '435', '小编', '1', '100', '0.00', '1', '0', '0', '1729128655', '1740124188', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('17', '19', '0', '', '1', 'Light luxury new style, is irresistible male charm', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '438', '小编', '1', '100', '0.00', '1', '0', '0', '1729061538', '1730766872', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('18', '20', '0', '', '1', 'Simple commute, low-key senior, elegant choice for working women', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '259', '小编', '1', '100', '0.00', '1', '0', '0', '1729063567', '1730766760', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('19', '40', '0', '', '2', 'sdfdsfsfdsfsa', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '323', '小编', '1', '100', '33.00', '1', '0', '0', '1729068955', '1729068955', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('33', '66', '0', '', '3', 'Cross-seasonal wear: skillfully use stacking to make your women\'s clothing evergreen', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '859', '小编', '1', '100', '0.00', '1', '0', '0', '1740107869', '1740108231', '1', '1');
INSERT INTO `zan_archives_en` VALUES ('34', '67', '0', '', '3', 'The new favorite in the workplace: simple women\'s clothing helps you win business negotiations efficiently', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '468', '小编', '1', '100', '0.00', '1', '0', '0', '1740108128', '1740108199', '1', '1');

-- -----------------------------
-- Table structure for `zan_archives_flag`
-- -----------------------------
DROP TABLE IF EXISTS `zan_archives_flag`;
CREATE TABLE `zan_archives_flag` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `flag_name` varchar(255) NOT NULL DEFAULT '' COMMENT '文档属性名称',
  `flag_attr` varchar(10) NOT NULL DEFAULT '' COMMENT '属性值',
  `flag_fieldname` varchar(255) NOT NULL DEFAULT '' COMMENT '字段名',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态， 1---显示， 0---隐藏',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '0',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `flag_attr` (`flag_attr`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='文档属性配置表';

-- -----------------------------
-- Records of `zan_archives_flag`
-- -----------------------------
INSERT INTO `zan_archives_flag` VALUES ('1', '头条', 'h', 'is_head', '1', '1', 'cn', '1606272350', '1606272350');
INSERT INTO `zan_archives_flag` VALUES ('2', '推荐', 'c', 'is_recom', '1', '2', 'cn', '1606272350', '1606272350');
INSERT INTO `zan_archives_flag` VALUES ('3', '加推', 'a', 'is_special', '1', '3', 'cn', '1606272350', '1606272350');
INSERT INTO `zan_archives_flag` VALUES ('4', '标粗', 'b', 'is_b', '1', '4', 'cn', '1606272350', '1606272350');
INSERT INTO `zan_archives_flag` VALUES ('5', '有图', 'p', 'is_litpic', '1', '5', 'cn', '1606272350', '1606272350');
INSERT INTO `zan_archives_flag` VALUES ('6', '外链', 'j', 'is_jump', '1', '6', 'cn', '1606272350', '1606272350');
INSERT INTO `zan_archives_flag` VALUES ('7', '轮播', 's', 'is_slide', '1', '7', 'cn', '1606272350', '1606272350');
INSERT INTO `zan_archives_flag` VALUES ('8', '滚动', 'r', 'is_roll', '1', '8', 'cn', '1606272350', '1606272350');
INSERT INTO `zan_archives_flag` VALUES ('9', '热文', 'd', 'is_diyattr', '1', '9', 'cn', '1606272350', '1606272350');

-- -----------------------------
-- Table structure for `zan_archives_zh`
-- -----------------------------
DROP TABLE IF EXISTS `zan_archives_zh`;
CREATE TABLE `zan_archives_zh` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '中文文档自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `typeid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '当前栏目',
  `stypeid` varchar(100) DEFAULT '' COMMENT '副栏目ID集合',
  `channel` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '模型ID',
  `title` varchar(500) DEFAULT '' COMMENT '文档标题',
  `litpic` varchar(255) DEFAULT '' COMMENT '封面图片',
  `is_litpic` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否存在图片(0:否; 1:是;)',
  `is_b` tinyint(1) DEFAULT '0' COMMENT '加粗',
  `is_head` tinyint(1) DEFAULT '0' COMMENT '头条（0=否，1=是）',
  `is_special` tinyint(1) DEFAULT '0' COMMENT '特荐（0=否，1=是）',
  `is_top` tinyint(1) DEFAULT '0' COMMENT '置顶（0=否，1=是）',
  `is_recom` tinyint(1) DEFAULT '0' COMMENT '推荐（0=否，1=是）',
  `is_roll` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '滚动（0=否，1=是）',
  `is_slide` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '幻灯（0=否，1=是）',
  `is_diyattr` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '自定义（0=否，1=是）',
  `is_jump` tinyint(1) DEFAULT '0' COMMENT '跳转链接（0=否，1=是）',
  `jumplinks` varchar(255) DEFAULT '' COMMENT '跳转网址',
  `click` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击数',
  `author` varchar(100) DEFAULT '' COMMENT '作者',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0:屏蔽; 1:正常;)',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序号',
  `users_price` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '会员价',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '伪删除(0:否; 1:是;)',
  `del_method` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '伪删除状态(1:主动删除; 2:跟随上级栏目被动删除;)',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `editor_img_clear_link` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '清除非本站链接',
  `editor_remote_img_local` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '远程图片本地化',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`),
  KEY `add_time` (`add_time`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COMMENT='中文文档 -- 基础数据表';


-- -----------------------------
-- Table structure for `zan_arcmulti`
-- -----------------------------
DROP TABLE IF EXISTS `zan_arcmulti`;
CREATE TABLE `zan_arcmulti` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `tagid` varchar(60) NOT NULL DEFAULT '' COMMENT '标签ID',
  `tagname` varchar(60) NOT NULL DEFAULT '' COMMENT '标签名',
  `innertext` text NOT NULL COMMENT '标签模板代码',
  `pagesize` int(10) NOT NULL DEFAULT '0' COMMENT '分页列表',
  `querysql` text NOT NULL COMMENT '完整SQL',
  `ordersql` varchar(200) DEFAULT '' COMMENT '排序SQL',
  `addfieldsSql` varchar(255) DEFAULT '' COMMENT '附加字段SQL',
  `addtableName` varchar(50) DEFAULT '' COMMENT '附加字段的数据表，不包含表前缀',
  `attstr` text COMMENT '属性字符串',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='多页标记存储数据表';


-- -----------------------------
-- Table structure for `zan_arcrank`
-- -----------------------------
DROP TABLE IF EXISTS `zan_arcrank`;
CREATE TABLE `zan_arcrank` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `rank` smallint(6) DEFAULT '0' COMMENT '权限值',
  `name` char(20) DEFAULT '' COMMENT '会员名称',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='文档阅读权限表';

-- -----------------------------
-- Records of `zan_arcrank`
-- -----------------------------
INSERT INTO `zan_arcrank` VALUES ('3', '0', '开放浏览', 'en', '1552376880', '1552376880');
INSERT INTO `zan_arcrank` VALUES ('4', '-1', '待审核稿件', 'en', '1552376880', '1552376880');

-- -----------------------------
-- Table structure for `zan_arctype`
-- -----------------------------
DROP TABLE IF EXISTS `zan_arctype`;
CREATE TABLE `zan_arctype` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `id` int(10) NOT NULL DEFAULT '0' COMMENT '栏目ID',
  `channeltype` int(10) DEFAULT '0' COMMENT '栏目顶级模型ID',
  `current_channel` int(10) DEFAULT '0' COMMENT '栏目当前模型ID',
  `parent_id` int(10) DEFAULT '0' COMMENT '栏目上级ID',
  `topid` int(10) DEFAULT '0' COMMENT '顶级栏目ID',
  `typename` varchar(200) DEFAULT '' COMMENT '栏目名称',
  `dirname` varchar(200) DEFAULT '' COMMENT '目录英文名',
  `dirpath` varchar(200) DEFAULT '' COMMENT '目录存放HTML路径',
  `diy_dirpath` varchar(200) DEFAULT '' COMMENT '列表静态文件存放规则',
  `rulelist` varchar(200) DEFAULT '' COMMENT '列表静态文件存放规则',
  `ruleview` varchar(200) DEFAULT '' COMMENT '文档静态文件存放规则',
  `englist_name` varchar(200) DEFAULT '' COMMENT '栏目英文名',
  `grade` tinyint(1) DEFAULT '0' COMMENT '栏目等级',
  `typelink` varchar(200) DEFAULT '' COMMENT '栏目链接',
  `litpic` varchar(250) DEFAULT '' COMMENT '栏目图片',
  `templist` varchar(200) DEFAULT '' COMMENT '列表模板文件名',
  `tempview` varchar(200) DEFAULT '' COMMENT '文档模板文件名',
  `seo_title` varchar(200) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(200) DEFAULT '' COMMENT 'seo关键字',
  `seo_description` text COMMENT 'seo描述',
  `sort_order` int(10) DEFAULT '0' COMMENT '排序号',
  `is_hidden` tinyint(1) DEFAULT '0' COMMENT '是否隐藏栏目：0=显示，1=隐藏',
  `is_part` tinyint(1) DEFAULT '0' COMMENT '栏目属性：0=内容栏目，1=外部链接',
  `admin_id` int(10) DEFAULT '0' COMMENT '管理员ID',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '伪删除，1=是，0=否',
  `del_method` tinyint(1) DEFAULT '0' COMMENT '伪删除状态，1为主动删除，2为跟随上级栏目被动删除',
  `status` tinyint(1) DEFAULT '1' COMMENT '启用 (1=正常，0=屏蔽)',
  `is_release` tinyint(1) DEFAULT '0' COMMENT '栏目是否应用于会员投稿发布，1是，0否',
  `weapp_code` varchar(50) DEFAULT '' COMMENT '插件栏目唯一标识',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  `target` tinyint(1) DEFAULT '0' COMMENT '新窗口打开',
  `nofollow` tinyint(1) DEFAULT '0' COMMENT '防抓取',
  `typearcrank` int(10) DEFAULT '0' COMMENT '阅读权限：0=开放浏览，-1=待审核稿件',
  `empty_logic` tinyint(1) DEFAULT '0' COMMENT '空内容逻辑',
  `page_limit` varchar(10) DEFAULT '0' COMMENT '限制页面 1-栏目页面 0-文档页面',
  `total_arc` int(10) DEFAULT '0' COMMENT '栏目下文档数量',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `id` (`id`,`dirname`,`lang`),
  KEY `parent_id` (`channeltype`,`parent_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=682 DEFAULT CHARSET=utf8 COMMENT='文档栏目表';

-- -----------------------------
-- Records of `zan_arctype`
-- -----------------------------
INSERT INTO `zan_arctype` VALUES ('2', '1', '2', '2', '0', '0', 'dress', 'dress', '/dress', '/dress', '', '', '', '0', '', '', 'lists_product.htm', 'view_product.htm', 'Title (Title)', 'Key words', 'Description', '100', '0', '0', '0', '0', '0', '1', '0', '', 'en', '1727665779', '1740124196', '0', '0', '0', '0', '0', '0');
INSERT INTO `zan_arctype` VALUES ('6', '2', '2', '2', '0', '0', 'T-shirt', 't-shirt', '/t-shirt', '/t-shirt', '', '', '', '0', '', '', 'lists_product.htm', 'view_product.htm', '', '', '', '100', '0', '0', '0', '0', '0', '1', '0', '', 'en', '1727665779', '1740124147', '0', '0', '0', '0', '0', '0');
INSERT INTO `zan_arctype` VALUES ('37', '9', '2', '2', '0', '0', 'trousers', 'trousers', '/trousers', '/trousers', '', '', '', '0', '', '', '', '', 'trousers', '', '', '100', '0', '0', '0', '0', '0', '1', '0', '', 'en', '1728610036', '1730443532', '0', '0', '0', '0', '0', '0');
INSERT INTO `zan_arctype` VALUES ('34', '8', '2', '2', '0', '0', 'skirt', 'skirt', '/skirt', '/skirt', '', '', '', '0', '', '', '', '', 'skirt', 'skirt', 'The skirt has a variety of styles such as A-shaped skirt, straight skirt, and umbrella skirt. The A-shaped skirt is A-shaped, narrow at the top and wide at the bottom, which can modify the lines of the hips and legs; the straight skirt has simple and smooth lines, which looks sharp and neat; the umbrella skirt has a larger skirt, which has an elegant and romantic temperament.', '100', '0', '0', '0', '0', '0', '1', '0', '', 'en', '1728610019', '1730365318', '0', '0', '0', '0', '0', '0');
INSERT INTO `zan_arctype` VALUES ('31', '7', '2', '2', '0', '0', 'sweater', 'sweater', '/sweater', '/sweater', '', '', '', '0', '', '', '', '', 'EARTHMOVING', '', '', '100', '0', '0', '0', '0', '0', '1', '0', '', 'en', '1728609980', '1730365318', '0', '0', '0', '0', '0', '0');
INSERT INTO `zan_arctype` VALUES ('16', '5', '1', '1', '0', '0', 'Company News', 'company-news', '/company-news', '/company-news', '', '', '', '0', '', '', '', '', 'Company News', '', '', '100', '0', '0', '0', '0', '0', '1', '0', '', 'en', '1728442913', '1730885964', '0', '0', '0', '0', '0', '0');
INSERT INTO `zan_arctype` VALUES ('28', '6', '3', '3', '0', '0', 'Case', 'case', '/case', '/case', '', '', '', '0', '', '', 'lists_images.htm', 'view_images.htm', '', '', '', '100', '0', '0', '0', '0', '0', '1', '0', '', 'en', '1728608097', '1740108257', '0', '0', '0', '0', '0', '0');
INSERT INTO `zan_arctype` VALUES ('662', '14', '1', '1', '0', '0', 'Industry information', 'industry-information', '/industry-information', '/industry-information', '', '', '', '0', '', '', '', '', 'Industry information', '', '', '100', '0', '0', '0', '0', '0', '1', '0', '', 'en', '1730447786', '1730885997', '0', '0', '0', '0', '0', '0');
INSERT INTO `zan_arctype` VALUES ('675', '15', '6', '6', '0', '0', 'About Us', 'About-Us', '/About-Us', '/About-Us', '', '', '', '0', '', '', 'lists_single.htm', '', 'About Us', 'New energy, carbon emissions', 'In the long river of time, there are always some bright stars illuminating the way forward. [Clothing company name], is the shining star in the fashion starry sky. Since its establishment, we have embarked on this creative and challenging journey with awe and pursuit of beauty. From the moment of inspiration to the careful selection of every inch of fabric, we treat each garment like a work of art.', '100', '0', '0', '0', '0', '0', '1', '0', '', 'en', '1732245160', '1732245160', '0', '0', '0', '0', '0', '0');
INSERT INTO `zan_arctype` VALUES ('678', '16', '6', '6', '0', '0', 'Contact Us', 'contact-us', '/contact-us', '/contact-us', '', '', '', '0', '', '', 'lists_single_contact.htm', '', '联系我们', '', '&quot;Contact Us&quot; is usually a page or information section that provides a', '100', '0', '0', '0', '0', '0', '1', '0', '', 'en', '1732245160', '1732245160', '0', '0', '0', '0', '0', '0');
INSERT INTO `zan_arctype` VALUES ('680', '17', '6', '6', '0', '0', 'FAQ', 'faq', '/faq', '/faq', '', '', '', '0', '', '', 'lists_single_faq.htm', '', 'FAQ', '', '', '100', '0', '0', '0', '0', '0', '1', '0', '', 'en', '1740104211', '1740104322', '0', '0', '0', '0', '0', '0');

-- -----------------------------
-- Table structure for `zan_article_content`
-- -----------------------------
DROP TABLE IF EXISTS `zan_article_content`;
CREATE TABLE `zan_article_content` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='文档主表 -- 内容数据表';

-- -----------------------------
-- Records of `zan_article_content`
-- -----------------------------
INSERT INTO `zan_article_content` VALUES ('6', '18', '&lt;p style=&quot;font-family: Heebo-Light; padding: 0px; color: rgb(85, 85, 85); text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;&gt;On June 13, 2024, the 16th China (Beijing) International Construction Machinery, Building Materials Machinery and Mining Machinery Exhibition and Technical Exchange Conference (referred to as &amp;quot;BICES 2023&amp;quot;) press conference and exhibition reserve meeting was held in Beijing. Representatives from CCCC, China Railway, China Railway Construction, China Construction, China Road and Bridge, Beijing Construction, China Chemical Construction Enterprise Association, China Metallurgical Construction Association Hoisting Committee and other user units attended the meeting.&lt;/p&gt;&lt;p style=&quot;font-family: Heebo-Light; padding: 0px; color: rgb(85, 85, 85); text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;&gt;Among them, the relevant responsible persons of four user units as representatives, combined with the project construction and equipment purchase management of their respective units, expressed the desire to strengthen the cooperation with the upstream and downstream supply chain of the construction machinery industry through BICES exhibition and carry out equipment selection and procurement on the exhibition platform.&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '', 'BICES 2024 User representative talks about BICES', '', 'On June 13, 2024, the 16th China (Beijing) International Construction Machinery, Building Materials Machinery and Mining Machinery Exhibition and Technical Exchange Conference (referred to as &quot;BICES 2023&quot;) press conference and exhibition reserve meeting was held in Beijing. Representatives from CCCC, China Railway, China Railway Construction, China Construction, China Road and Bridge, Beijing Construction, China Chemical Construction Enterprise Association, China Metallurgical Construction Assoc', 'On June 13, 2024, the 16th China (Beijing) International Construction Machinery, Building Materials Machinery and Mining Machinery Exhibition and Technical Exchange Conference (referred to as &quot;BICES 2023&quot;) press conference and exhibition reserve meeting was held in Beijing. Representatives from CCCC, China Railway, China Railway Construction, China Construction, China Road and Bridge, Beijing Construction, China Chemical Construction Enterprise Association, China Metallurgical Construction Assoc', '1728464382', '1728464382');
INSERT INTO `zan_article_content` VALUES ('7', '19', '&lt;p&gt;On June 13, 2024, the 16th China (Beijing) International Construction Machinery, Building Materials Machinery and Mining Machinery Exhibition and Technical Exchange Conference (referred to as &amp;quot;BICES 2023&amp;quot;) press conference and exhibition reserve meeting was held in Beijing. From Liugong, Shandong Lingong, Sany Heavy Industry, Caterpillar, Zoomlion, Xugong Group, Komatsu, Shantui, Diwanren (China), Hangzhan Group, Railway Construction Heavy Industry, Heavy Weight Group, Hitachi Construction Machinery, Cummins, Nanjing Iron and Steel, Tangshan Shenghang, Bohui Shitong, Huatai Mining Machinery, Kawasaki Precision, Henan Jiachen, Shanxi Jinta, Jiangsu Telong, Leica Measurement, Qingzhou Yawei, Representatives from Fangyuan Group, Shell China, Tianshui Wind, Beijing Construction Machinery Institute, Tujiang, China Machinery Inspection, Machinery Development, Zhongke Huituo, China Railway Construction Capital Lease, Sales, Aerospace Hengli and other exhibitors attended the meeting.&lt;/p&gt;&lt;p&gt;Among them, the relevant persons in charge of six exhibitors as representatives of exhibitors, to exchange speeches on the exhibition BICES. Focusing on the theme of the exhibition, the delegates reported their respective units&amp;#39; experience of participating in BICES and their preparations for BICES 2023 in terms of brand strategy, expanding the scale of the exhibition, increasing the content of the exhibition, organizing rich activities and inviting more customers to attend the exhibition.&lt;/p&gt;&lt;p&gt;&lt;br style=&quot;color: rgb(85, 85, 85); text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '', 'BICES 2024 Exhibitor talks about BICES exhibition', '', 'On June 13, 2024, the 16th China (Beijing) International Construction Machinery, Building Materials Machinery and Mining Machinery Exhibition and Technical Exchange Conference (referred to as &quot;BICES 2023&quot;) press conference and exhibition reserve meeting was held in Beijing. From Liugong, Shandong Lingong, Sany Heavy Industry, Caterpillar, Zoomlion, Xugong Group, Komatsu, Shantui, Diwanren (China), Hangzhan Group, Railway Construction Heavy Industry, Heavy Weight Group, Hitachi Construction Machi', 'On June 13, 2024, the 16th China (Beijing) International Construction Machinery, Building Materials Machinery and Mining Machinery Exhibition and Technical Exchange Conference (referred to as &quot;BICES 2023&quot;) press conference and exhibition reserve meeting was held in Beijing. From Liugong, Shandong Lingong, Sany Heavy Industry, Caterpillar, Zoomlion, Xugong Group, Komatsu, Shantui, Diwanren (China), Hangzhan Group, Railway Construction Heavy Industry, Heavy Weight Group, Hitachi Construction Machi', '1728464463', '1728464463');
INSERT INTO `zan_article_content` VALUES ('8', '20', '&lt;p&gt;The exhibition also unveiled the industry&amp;#39;s largest flow, the highest level of intelligence of 5000m³/h vertical water supply and drainage emergency vehicle GP50C, &amp;quot;Twin God will&amp;quot; child and mother of large flow drainage emergency vehicle PS50F, the world&amp;#39;s fastest crawler bulldozer XTV16J type rubber crawler bulldozer, as well as the industry&amp;#39;s first 15 meters high fire extinguishing robot.&lt;/p&gt;&lt;p&gt;Disaster prevention, relief and mitigation. In response to the strategic requirements of &amp;quot;full disaster, great emergency&amp;quot;, Xugong continues to increase the layout and R&amp;amp;D investment of emergency rescue products, and continues to dig deep in the fields of high mobility, high intelligence, and multi-function, providing Xugong solutions for the global emergency rescue industry and helping the high-quality development of China&amp;#39;s emergency industry to a new level.&lt;/p&gt;&lt;p&gt;&lt;br style=&quot;color: rgb(85, 85, 85); text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '', 'High-tech gathering! Xugong fire Yangtze River Delta emergency exhibition', '', 'The exhibition also unveiled the industry\'s largest flow, the highest level of intelligence of 5000m³/h vertical water supply and drainage emergency vehicle GP50C, &quot;Twin God will&quot; child and mother of large flow drainage emergency vehicle PS50F, the world\'s fastest crawler bulldozer XTV16J type rubber crawler bulldozer, as well as the industry\'s first 15 meters high fire extinguishing robot.', 'The exhibition also unveiled the industry\'s largest flow, the highest level of intelligence of 5000m³/h vertical water supply and drainage emergency vehicle GP50C, &quot;Twin God will&quot; child and mother of large flow drainage emergency vehicle PS50F, the world\'s fastest crawler bulldozer XTV16J type rubber crawler bulldozer, as well as the industry\'s first 15 meters high fire extinguishing robot.', '1728464531', '1728464531');
INSERT INTO `zan_article_content` VALUES ('9', '21', '&lt;p&gt;Since the beginning of this year, China&amp;#39;s infrastructure investment has accelerated, becoming an important support for economic growth. On June 29, CCTV&amp;#39;s &amp;quot;News 30 Minutes&amp;quot; aired a special report on &amp;quot;Leading Indicators to see the Trend&amp;quot;, looking at China&amp;#39;s infrastructure heat through the Sany Excavator index.&lt;/p&gt;&lt;p&gt;Infrastructure heat in excavator index&lt;/p&gt;&lt;p&gt;On the root cloud platform of the &amp;quot;cross-industry and cross-field Industrial Internet platform&amp;quot; of the Ministry of Industry and Information Technology, 67.15%, which is the construction machinery operating rate in May this year, is also the most important indicator in the excavator index. From March to May, despite the impact of the epidemic, the indicators remained stable and maintained a slight increase.&lt;/p&gt;&lt;p&gt;Wang Jinxia, excavator index analyst: Due to the improvement of the epidemic prevention and control situation, including the intensive introduction of investment policies in some countries, the construction machinery operating rate data continues to increase, reflecting the continuous recovery of large-scale engineering construction projects and the continuous release of demand.&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '', 'CCTV spotlight! Infrastructure heat in excavator index', '', 'Since the beginning of this year, China&#39;s infrastructure investment has acce', '', '1728465066', '1728465066');

-- -----------------------------
-- Table structure for `zan_article_content_cn`
-- -----------------------------
DROP TABLE IF EXISTS `zan_article_content_cn`;
CREATE TABLE `zan_article_content_cn` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '中文文档自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='中文文档 -- 内容数据表';


-- -----------------------------
-- Table structure for `zan_article_content_en`
-- -----------------------------
DROP TABLE IF EXISTS `zan_article_content_en`;
CREATE TABLE `zan_article_content_en` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '中文文档自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='中文文档 -- 内容数据表';

-- -----------------------------
-- Records of `zan_article_content_en`
-- -----------------------------
INSERT INTO `zan_article_content_en` VALUES ('2', '18', '&lt;p style=&quot;text-align: left;&quot;&gt;　Leave a place fragrant, self-confidence exudes charming charm, the elegance of an independent woman, restrained and noble. Women with romantic flair are undoubtedly eye-catching, and the refreshment of their actions is naturally the taste of youth. The skirt is elegant in the breeze, like a lively and jumping elf, giving you lightness, stirring up the splashes of your life, and giving you endless reverie.&lt;/p&gt;&lt;p style=&quot;text-align: left;&quot;&gt;The camel color with calm emotion can give you a retro atmosphere. It is a free and easy personality, but also a dignified atmosphere. It has two characteristics. It is the fulcrum for you to open your charm, and the graceful and graceful of women can be fully released. Cashmere is soft and has its own fashionable texture, which makes your elegant intellect more attitude. It is a scale that other tastes cannot cross, allowing you to bloom in this busy world to the fullest.&lt;/p&gt;&lt;p style=&quot;text-align: left;&quot;&gt;Black, introverted and mysterious, elegant and noble, sharpened the years of tempering, creating a rough dip and dyeing, cleverly embellished with the classical atmosphere of vision, soft leather fabric with its own light, with a hollow delicate black gauze skirt light luxury intellectual, with a charming attitude to open the course of December, the rest of the life is a wonderful shot. French lapel, cool Sa personality, retro new style.&lt;/p&gt;&lt;p style=&quot;text-align: left;&quot;&gt;Gorgeous turn to the dream country of winter weaving, maintain self-individuality, keep quiet, and naturally form the focus of winter with a humble attitude. The simple and neat tailoring makes the beautiful curves more tempting, and simply creates a female modern temperament. The raw but not hard gray defines the clothing for workplace wear, and the unique design expresses the feminine decency and atmosphere, opening the personality aura in the temperament.&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '', 'Light luxury and elegance, customize your romantic outfit, without fear of winter cold', '', 'Leave a place fragrant, self-confidence exudes charming charm, the elegance of an independent woman, restrained and noble. Women with romantic flair are undoubtedly eye-catching, and the refreshment of their actions is', 'Leave a place fragrant, self-confidence exudes charming charm, the elegance of an independent woman, restrained and noble. Women with romantic flair are undoubtedly eye-catching, and the refreshment of their actions is naturally the taste of youth. The skirt is elegant in the breeze, like a lively and jumping elf, giving you lightness, stirring up the splashes of your life, and giving you endless reverie.', '1728975125', '1730766840');
INSERT INTO `zan_article_content_en` VALUES ('4', '19', '&lt;p style=&quot;text-align: left;&quot;&gt;Elegance and propriety are the basic rules of dressing, the inside is skin-friendly and soft, the appearance is exquisite and handsome, and it is more attractive to exude the charm of male maturity. With the calm and wisdom of winter, you can get rid of the sense of restraint, give you comfort and fashion, and the bleak winter is also a stage for you to express yourself confidently.&lt;/p&gt;&lt;p style=&quot;text-align: left;&quot;&gt;The pure black stand up and cut, and the version design creates a sense of silhouette, which opens up the fashion tension, even the restrained dark color can make people see it at a glance. The simple style opens up the release of the fashionable texture, and the overall simplicity and atmosphere, especially the decoration of the pocket tooling style on both sides, which is full of cool and cool, and the cool and handsome image naturally rises, forming the dazzling scenery of the urban street, which is an irresistible temptation.&lt;/p&gt;&lt;p style=&quot;text-align: left;&quot;&gt;The small coat with a foreign style and fashionable sense is your courage to walk freely in the workplace, giving people meticulous rigor. The smooth simple lines modify the coat to be simple, dry, cool, and handsome. The design of the fluffy fur collar has a personality that attracts the eyes, exudes a mysterious temperament, and enhances the overall structure to show more levels. With a similar black bottom coat, it keeps warm and skin-friendly, fresh and natural.&lt;/p&gt;&lt;p style=&quot;text-align: left;&quot;&gt;With a cool coat, the light luxury undergarment inside makes your confidence more dazzling. The medium-saturation blue fades a bit of dryness, taking away seriousness, and decorates the lazy feeling with a small round neck with a sense of leisure, leisurely and comfortable, leisurely and casual. With black trousers, you are a promising young man who is low-key and luxurious without flamboyance. Using natural and comfortable popular elements, you can create a harmonious beauty of classics and fashion, characteristics and sports, a rare versatile weapon.&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '', 'Light luxury new style, is irresistible male charm', '', 'Elegance and propriety are the basic rules of dressing, the inside is skin-friendly and soft, the appearance is exquisite and handsome, and it is more attractive to exude the charm of male maturity. With the calm and', 'Elegance and propriety are the basic rules of dressing, the inside is skin-friendly and soft, the appearance is exquisite and handsome, and it is more attractive to exude the charm of male maturity. With the calm and wisdom of winter, you can get rid of the sense of restraint, give you comfort and fashion, and the bleak winter is also a stage for you to express yourself confidently.', '1729061538', '1730766872');
INSERT INTO `zan_article_content_en` VALUES ('3', '21', '&lt;p&gt;In the busy urban life, every woman is looking for her own unique style. The design concept of simplicity and literature has created a series of new options for commuting wear for working women. These items are stylish and distinct, cleverly integrated into casual and mature elements, allowing you to easily switch between free styles, grasp the scale and tension, and show the intellectual charm.&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;White commuter shirt is an elegant item tailor-made by working women. Pure white tones, simple and pure, bring out women&amp;#39;s intelligence and generosity. Black polka dots, filling layers, give fashion tension. The design of the neckline is just right, retaining the formality of the workplace without losing the softness and delicacy of women.&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;Blue denim jacket, as a representative of casual style, has always been the darling of the fashion industry. Integrating this coat into commuter wear brings more possibilities to working women. The blue tone is fresh and natural, the material of denim is wear-resistant and rich in texture. The cut of the coat is simple and generous, and the lines are smooth, creating a casual but elegant commuter look.&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;Khaki, as a representative of neutral color, has always been loved by working women. Integrate this color into the design of the shirt and skirt to create an intellectual and casual commuter item. The tailoring of the dress is neat and generous, the lines are smooth, and the matching of the shirt and skirt is just right, which retains the formality of the workplace without losing the softness and delicacy of women. The khaki tone is warm and soft, setting off the temperament and charm of women.&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '', 'Simple literature and art, full of intellectual charm', '', 'In the busy urban life, every woman is looking for her own unique style. The minimalist and literary design concept has created a series of new options for commuting wear for working women. These items are stylish and', 'In the busy urban life, every woman is looking for her own unique style. The minimalist and literary design concept has created a series of new options for commuting wear for working women. These items are stylish and cleverly integrated with casual and mature elements, allowing you to easily switch between free styles, grasp the scale and tension, and show the intellectual charm.', '1728978275', '1730766731');
INSERT INTO `zan_article_content_en` VALUES ('5', '20', '&lt;p&gt;Simple commuter wear is designed, with a low-key and high-end attitude, bringing an indifferent poetry to the workplace elite. It does not stick to complicated decoration, nor does it pursue flamboyant colors, but through exquisite tailoring, ingenious details, and just the right white space, it shows an elegant charm from the inside out.&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;simple gray cashmere vest, the choice of gray tone, caters to the low-key requirements of workplace wear. V-neck design elongates the neck line, adding a bit of elegance. And the broken edge design, the finishing touch of the whole vest, it breaks the dullness of traditional commuter wear, revealing a bit of casual and casual, with a lighter relaxed tension, presenting high-quality.&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;commuting gray-black lace-up suit, the classic gray-black tone, low-key without losing a sense of high-end, in line with the capable requirements of workplace wear. In the version design, the lines are angular, simple and generous, showing the elegance and confidence of women in the workplace. At the same time, the lace-up design adds retro charm to the suit, which can visually elongate the proportion of the body, making the wearer look taller and slender.&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;black velvet fit dress, elegant and high-end, skin-friendly velvet fabric is delicate and textured, and exudes a charming light when walking. The choice of black tone is mysterious and extravagant, and it shines elegantly at the lantern night banquet. The version design is fit and slim, and the just cut does not appear to be bound at all, and the steps are calm. The plush splicing on the chest shows the luxurious temperament, and the generous round neck shows your decent and noble.&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-241016144419494.jpg&quot; alt=&quot;2021121402293455.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;11111111111&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160S53L01.jpg&quot; alt=&quot;O1CN01Zk7a3328VeqPJC10a_!!1665777938-0-cib.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;22222222222222&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241031/1-2410311H112325.webp&quot; title=&quot;&quot; alt=&quot;1-220224145J11V.jpg&quot;/&gt;&lt;img src=&quot;/uploads/allimg/20241031/1-2410311F153606.webp&quot; alt=&quot;1-220323100512M6.png&quot;/&gt;&lt;/p&gt;&lt;p&gt;33333333333333333&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160S5361C.jpg&quot; alt=&quot;O1CN01czw9Y728VeqNWUWii_!!1665777938-0-cib.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;444444444444444&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160R944930.jpg&quot; alt=&quot;O1CN01y0lpqe28Vev2g2DlR_!!1665777938-0-cib.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-241016154302K9.jpg&quot; alt=&quot;2024101509570924.jpg&quot;/&gt;&lt;/p&gt;', 'Simple commute, low-key senior, elegant choice for working women', '', 'The simple commuting style is designed, and the low-key and high-end posture brings an indifferent poetry to the workplace elite. It does not stick to complicated decoration or pursue flamboyant colors, but through', 'The simple commuting style is designed, and the low-key and high-end posture brings an indifferent poetry to the workplace elite. It does not stick to complicated decoration or pursue flamboyant colors, but through exquisite tailoring, ingenious details, and just the right white space, it shows an elegant charm from the inside out.', '1729063567', '1730766760');

-- -----------------------------
-- Table structure for `zan_article_content_zh`
-- -----------------------------
DROP TABLE IF EXISTS `zan_article_content_zh`;
CREATE TABLE `zan_article_content_zh` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '中文文档自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='中文文档 -- 内容数据表';


-- -----------------------------
-- Table structure for `zan_article_order`
-- -----------------------------
DROP TABLE IF EXISTS `zan_article_order`;
CREATE TABLE `zan_article_order` (
  `order_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文章订单ID',
  `order_code` varchar(50) NOT NULL DEFAULT '' COMMENT '媒体订单编号',
  `users_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `order_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单状态：0未付款，1已付款',
  `order_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单应付总金额',
  `pay_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `pay_name` varchar(20) NOT NULL DEFAULT '' COMMENT '支付方式名称',
  `wechat_pay_type` varchar(20) NOT NULL DEFAULT '' COMMENT '微信支付时，标记使用的支付类型（扫码支付，微信内部，微信H5页面）',
  `pay_details` text COMMENT '支付时返回的数据，以serialize序列化后存入，用于后续查询。',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '视频文档ID',
  `product_name` varchar(100) DEFAULT '' COMMENT '视频文档名称',
  `product_litpic` varchar(500) DEFAULT '' COMMENT '视频文档封面图片',
  `lang` varchar(30) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned DEFAULT '0' COMMENT '下单时间',
  `update_time` int(11) unsigned DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `order_code` (`order_code`) USING BTREE,
  KEY `users_id` (`users_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='文章订单表';


-- -----------------------------
-- Table structure for `zan_article_pay`
-- -----------------------------
DROP TABLE IF EXISTS `zan_article_pay`;
CREATE TABLE `zan_article_pay` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aid` int(11) DEFAULT '0',
  `part_free` tinyint(1) DEFAULT '0' COMMENT '是否试看 0-否 1-是',
  `size` varchar(50) DEFAULT '1' COMMENT 'KB',
  `free_content` longtext COMMENT '试看内容',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0',
  `update_time` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='文章付费预览表';


-- -----------------------------
-- Table structure for `zan_auth_role`
-- -----------------------------
DROP TABLE IF EXISTS `zan_auth_role`;
CREATE TABLE `zan_auth_role` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '' COMMENT '角色名',
  `pid` int(10) DEFAULT '0' COMMENT '父角色ID',
  `remark` text COMMENT '备注信息',
  `grade` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '级别',
  `language` text COMMENT '多语言权限',
  `online_update` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '在线升级',
  `switch_map` tinyint(1) DEFAULT '0' COMMENT '功能地图',
  `only_oneself` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '只看自己发布',
  `check_oneself` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '发布文档自动通过审核，1--是，0--否',
  `cud` varchar(255) DEFAULT '' COMMENT '增改删',
  `permission` longtext COMMENT '已允许的权限',
  `built_in` tinyint(1) DEFAULT '0' COMMENT '内置用户组，1表示内置',
  `sort_order` int(10) DEFAULT '0' COMMENT '排序号',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态(1=正常，0=屏蔽)',
  `admin_id` int(10) DEFAULT '0' COMMENT '操作管理员ID',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='管理员角色表';

-- -----------------------------
-- Records of `zan_auth_role`
-- -----------------------------
INSERT INTO `zan_auth_role` VALUES ('1', '优化推广员', '0', '', '0', 'a:1:{i:0;s:2:\"cn\";}', '0', '1', '1', '1', 'a:3:{i:0;s:3:\"add\";i:1;s:4:\"edit\";i:2;s:3:\"del\";}', 'a:2:{s:5:\"rules\";a:8:{i:0;s:1:\"1\";i:1;s:1:\"3\";i:2;s:1:\"4\";i:3;s:1:\"8\";i:4;s:1:\"9\";i:5;s:2:\"10\";i:6;s:2:\"14\";i:7;i:2;}s:7:\"arctype\";a:108:{i:0;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:4;i:5;i:5;i:8;i:6;i:9;i:7;i:10;i:8;i:11;i:9;i:12;i:10;i:20;i:11;i:21;i:12;i:22;i:13;i:24;i:14;i:25;i:15;i:26;i:16;i:27;i:17;i:28;i:18;i:29;i:19;i:30;i:20;i:64;i:21;i:66;i:22;i:6;i:23;i:7;i:24;i:13;i:25;i:14;i:26;i:15;i:27;i:16;i:28;i:17;i:29;i:18;i:30;i:19;i:31;i:23;i:32;i:31;i:33;i:32;i:34;i:33;i:35;i:34;i:36;i:35;i:37;i:36;i:38;i:37;i:39;i:38;i:40;i:39;i:41;i:40;i:42;i:41;i:43;i:42;i:44;i:43;i:45;i:44;i:46;i:45;i:47;i:46;i:48;i:47;i:49;i:48;i:50;i:49;i:51;i:50;i:52;i:51;i:53;i:52;i:54;i:53;i:55;i:54;i:56;i:55;i:57;i:56;i:58;i:57;i:59;i:58;i:60;i:59;i:61;i:60;i:62;i:61;i:63;i:62;i:64;i:63;i:65;i:65;i:66;i:68;i:67;i:67;i:68;i:69;i:69;i:70;i:70;i:71;i:71;i:72;i:72;i:73;i:73;i:74;i:74;i:75;i:75;i:76;i:76;i:77;i:77;i:78;i:78;i:79;i:79;i:80;i:80;i:81;i:81;i:82;i:82;i:83;i:83;i:84;i:84;i:85;i:85;i:86;i:86;i:87;i:87;i:88;i:88;s:2:\"89\";i:89;s:2:\"90\";i:90;s:2:\"91\";i:91;s:2:\"92\";i:92;s:2:\"93\";i:93;s:2:\"94\";i:94;s:2:\"95\";i:95;s:2:\"96\";i:96;s:2:\"97\";i:97;s:2:\"98\";i:98;s:2:\"99\";i:99;s:3:\"100\";i:100;s:3:\"101\";i:101;s:3:\"102\";i:102;s:3:\"103\";i:103;s:3:\"104\";i:104;s:3:\"105\";i:105;s:3:\"106\";i:106;s:3:\"107\";i:107;s:3:\"108\";}}', '1', '100', '1', '0', '1541207843', '1725076443');
INSERT INTO `zan_auth_role` VALUES ('2', '内容管理员', '0', '', '0', 'a:1:{i:0;s:2:\"cn\";}', '0', '1', '1', '1', 'a:3:{i:0;s:3:\"add\";i:1;s:4:\"edit\";i:2;s:3:\"del\";}', 'a:2:{s:5:\"rules\";a:4:{i:0;s:1:\"1\";i:1;s:2:\"10\";i:2;s:2:\"14\";i:3;i:2;}s:7:\"arctype\";a:108:{i:0;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:4;i:5;i:5;i:8;i:6;i:9;i:7;i:10;i:8;i:11;i:9;i:12;i:10;i:20;i:11;i:21;i:12;i:22;i:13;i:24;i:14;i:25;i:15;i:26;i:16;i:27;i:17;i:28;i:18;i:29;i:19;i:30;i:20;i:64;i:21;i:66;i:22;i:6;i:23;i:7;i:24;i:13;i:25;i:14;i:26;i:15;i:27;i:16;i:28;i:17;i:29;i:18;i:30;i:19;i:31;i:23;i:32;i:31;i:33;i:32;i:34;i:33;i:35;i:34;i:36;i:35;i:37;i:36;i:38;i:37;i:39;i:38;i:40;i:39;i:41;i:40;i:42;i:41;i:43;i:42;i:44;i:43;i:45;i:44;i:46;i:45;i:47;i:46;i:48;i:47;i:49;i:48;i:50;i:49;i:51;i:50;i:52;i:51;i:53;i:52;i:54;i:53;i:55;i:54;i:56;i:55;i:57;i:56;i:58;i:57;i:59;i:58;i:60;i:59;i:61;i:60;i:62;i:61;i:63;i:62;i:64;i:63;i:65;i:65;i:66;i:68;i:67;i:67;i:68;i:69;i:69;i:70;i:70;i:71;i:71;i:72;i:72;i:73;i:73;i:74;i:74;i:75;i:75;i:76;i:76;i:77;i:77;i:78;i:78;i:79;i:79;i:80;i:80;i:81;i:81;i:82;i:82;i:83;i:83;i:84;i:84;i:85;i:85;i:86;i:86;i:87;i:87;i:88;i:88;s:2:\"89\";i:89;s:2:\"90\";i:90;s:2:\"91\";i:91;s:2:\"92\";i:92;s:2:\"93\";i:93;s:2:\"94\";i:94;s:2:\"95\";i:95;s:2:\"96\";i:96;s:2:\"97\";i:97;s:2:\"98\";i:98;s:2:\"99\";i:99;s:3:\"100\";i:100;s:3:\"101\";i:101;s:3:\"102\";i:102;s:3:\"103\";i:103;s:3:\"104\";i:104;s:3:\"105\";i:105;s:3:\"106\";i:106;s:3:\"107\";i:107;s:3:\"108\";}}', '1', '100', '1', '0', '1541207846', '1725076443');

-- -----------------------------
-- Table structure for `zan_channelfield`
-- -----------------------------
DROP TABLE IF EXISTS `zan_channelfield`;
CREATE TABLE `zan_channelfield` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT '字段名称',
  `channel_id` int(10) NOT NULL DEFAULT '0' COMMENT '所属文档模型id',
  `title` varchar(250) NOT NULL DEFAULT '' COMMENT '字段标题',
  `dtype` varchar(32) NOT NULL DEFAULT '' COMMENT '字段类型',
  `define` text NOT NULL COMMENT '字段定义',
  `maxlength` int(10) NOT NULL DEFAULT '0' COMMENT '最大长度，文本数据必须填写，大于255为text类型',
  `dfvalue` text NOT NULL COMMENT '默认值',
  `dfvalue_unit` varchar(50) NOT NULL DEFAULT '' COMMENT '数值单位',
  `remark` varchar(256) NOT NULL DEFAULT '' COMMENT '提示说明',
  `is_screening` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否应用于条件筛选',
  `is_release` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否应用于会员投稿发布',
  `ifeditable` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在编辑页显示',
  `ifrequire` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否必填',
  `ifsystem` tinyint(1) NOT NULL DEFAULT '0' COMMENT '字段分类，1=系统(不可修改)，0=自定义',
  `ifmain` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否主表字段',
  `ifcontrol` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态，控制该条数据是否允许被控制，1为不允许控制，0为允许控制',
  `sort_order` int(5) NOT NULL DEFAULT '100' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `set_type` tinyint(3) DEFAULT '0' COMMENT '区域选择时使用是否为三级联动,1-是',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=573 DEFAULT CHARSET=utf8 COMMENT='自定义字段表';

-- -----------------------------
-- Records of `zan_channelfield`
-- -----------------------------
INSERT INTO `zan_channelfield` VALUES ('1', 'add_time', '0', '新增时间', 'datetime', 'int(11)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533091575', '1533091575', '0');
INSERT INTO `zan_channelfield` VALUES ('2', 'update_time', '0', '更新时间', 'datetime', 'int(11)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533091601', '1533091601', '0');
INSERT INTO `zan_channelfield` VALUES ('3', 'aid', '0', '文档ID', 'int', 'int(11)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533091624', '1533091624', '0');
INSERT INTO `zan_channelfield` VALUES ('4', 'typeid', '0', '当前栏目ID', 'int', 'int(11)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533091930', '1533091930', '0');
INSERT INTO `zan_channelfield` VALUES ('5', 'channel', '0', '模型ID', 'int', 'int(11)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092214', '1533092214', '0');
INSERT INTO `zan_channelfield` VALUES ('6', 'is_b', '0', '是否加粗', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092246', '1533092246', '0');
INSERT INTO `zan_channelfield` VALUES ('7', 'title', '0', '文档标题', 'text', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092381', '1533092381', '0');
INSERT INTO `zan_channelfield` VALUES ('8', 'litpic', '0', '缩略图', 'img', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092398', '1533092398', '0');
INSERT INTO `zan_channelfield` VALUES ('9', 'is_head', '0', '是否头条', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092420', '1533092420', '0');
INSERT INTO `zan_channelfield` VALUES ('10', 'is_special', '0', '是否特荐', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092439', '1533092439', '0');
INSERT INTO `zan_channelfield` VALUES ('11', 'is_top', '0', '是否置顶', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092454', '1533092454', '0');
INSERT INTO `zan_channelfield` VALUES ('12', 'is_recom', '0', '是否推荐', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092468', '1533092468', '0');
INSERT INTO `zan_channelfield` VALUES ('13', 'is_jump', '0', '是否跳转', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092484', '1533092484', '0');
INSERT INTO `zan_channelfield` VALUES ('14', 'author', '0', '编辑者', 'text', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092498', '1533092498', '0');
INSERT INTO `zan_channelfield` VALUES ('15', 'click', '0', '浏览量', 'int', 'int(11)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092512', '1533092512', '0');
INSERT INTO `zan_channelfield` VALUES ('16', 'arcrank', '0', '阅读权限', 'select', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092534', '1533092534', '0');
INSERT INTO `zan_channelfield` VALUES ('17', 'jumplinks', '0', '跳转链接', 'text', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092553', '1533092553', '0');
INSERT INTO `zan_channelfield` VALUES ('18', 'ismake', '0', '是否静态页面', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092698', '1533092698', '0');
INSERT INTO `zan_channelfield` VALUES ('19', 'seo_title', '0', 'SEO标题', 'text', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092713', '1533092713', '0');
INSERT INTO `zan_channelfield` VALUES ('20', 'seo_keywords', '0', 'SEO关键词', 'text', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092725', '1533092725', '0');
INSERT INTO `zan_channelfield` VALUES ('21', 'seo_description', '0', 'SEO描述', 'text', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092739', '1533092739', '0');
INSERT INTO `zan_channelfield` VALUES ('22', 'status', '0', '状态', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092753', '1533092753', '0');
INSERT INTO `zan_channelfield` VALUES ('23', 'sort_order', '0', '排序号', 'int', 'int(11)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092766', '1533092766', '0');
INSERT INTO `zan_channelfield` VALUES ('24', 'content', '2', '内容详情', 'htmltext', 'longtext', '250', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1533359739', '1533359739', '0');
INSERT INTO `zan_channelfield` VALUES ('25', 'content', '3', '内容详情', 'htmltext', 'longtext', '250', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1533359588', '1533359588', '0');
INSERT INTO `zan_channelfield` VALUES ('26', 'content', '4', '内容详情', 'htmltext', 'longtext', '250', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1533359752', '1533359752', '0');
INSERT INTO `zan_channelfield` VALUES ('27', 'content', '6', '内容详情', 'htmltext', 'longtext', '250', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1533464715', '1533464715', '0');
INSERT INTO `zan_channelfield` VALUES ('29', 'content', '1', '内容详情', 'htmltext', 'longtext', '250', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1533464713', '1533464713', '0');
INSERT INTO `zan_channelfield` VALUES ('30', 'update_time', '-99', '更新时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('31', 'add_time', '-99', '新增时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('32', 'status', '-99', '启用 (1=正常，0=屏蔽)', 'switch', 'tinyint(1)', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('33', 'is_part', '-99', '栏目属性：0=内容栏目，1=外部链接', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('34', 'is_hidden', '-99', '是否隐藏栏目：0=显示，1=隐藏', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('35', 'sort_order', '-99', '排序号', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('36', 'seo_description', '-99', 'seo描述', 'multitext', 'text', '0', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('37', 'seo_keywords', '-99', 'seo关键字', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('38', 'seo_title', '-99', 'SEO标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('39', 'tempview', '-99', '文档模板文件名', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('40', 'templist', '-99', '列表模板文件名', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('41', 'litpic', '-99', '栏目图片', 'img', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('42', 'typelink', '-99', '栏目链接', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('43', 'grade', '-99', '栏目等级', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('44', 'englist_name', '-99', '栏目英文名', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('45', 'dirpath', '-99', '目录存放HTML路径', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('46', 'dirname', '-99', '目录英文名', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('47', 'typename', '-99', '栏目名称', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('48', 'parent_id', '-99', '栏目上级ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('49', 'current_channel', '-99', '栏目当前模型ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('50', 'channeltype', '-99', '栏目顶级模型ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('51', 'id', '-99', '栏目ID', 'int', 'int(10)', '10', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('52', 'del_method', '-99', '伪删除状态，1为主动删除，2为跟随上级栏目被动删除', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1547890773', '1547890773', '0');
INSERT INTO `zan_channelfield` VALUES ('53', 'is_del', '0', '是否伪删除', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1547890773', '1547890773', '0');
INSERT INTO `zan_channelfield` VALUES ('54', 'del_method', '0', '伪删除状态，1为主动删除，2为跟随上级栏目被动删除', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1547890773', '1547890773', '0');
INSERT INTO `zan_channelfield` VALUES ('55', 'prom_type', '0', '产品类型：0普通产品，1虚拟产品', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('56', 'users_price', '0', '价格', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '0', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('57', 'prom_type', '2', '产品类型：0普通产品，1虚拟产品', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('58', 'users_price', '2', '价格', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '0', '100', '1', '1557042574', '1725071357', '0');
INSERT INTO `zan_channelfield` VALUES ('59', 'update_time', '2', '更新时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('60', 'add_time', '2', '新增时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('61', 'del_method', '2', '伪删除状态，1为主动删除，2为跟随上级栏目被动删除', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('62', 'is_del', '2', '伪删除，1=是，0=否', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('63', 'admin_id', '2', '管理员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('558', 'lang', '0', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '0', '0', '1', '0', '1', '100', '1', '1641862075', '1641862075', '0');
INSERT INTO `zan_channelfield` VALUES ('65', 'sort_order', '2', '排序号', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('66', 'status', '2', '状态(0=屏蔽，1=正常)', 'switch', 'tinyint(1)', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('67', 'tempview', '2', '文档模板文件名', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('68', 'seo_description', '2', 'SEO描述', 'multitext', 'text', '0', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('69', 'seo_keywords', '2', 'SEO关键词', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('70', 'seo_title', '2', 'SEO标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('71', 'ismake', '2', '是否静态页面（0=动态，1=静态）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('72', 'jumplinks', '2', '外链跳转', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('73', 'arcrank', '2', '阅读权限：0=开放浏览，-1=待审核稿件', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('74', 'click', '2', '浏览量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('75', 'author', '2', '作者', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('76', 'is_litpic', '2', '图片（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('77', 'is_jump', '2', '跳转链接（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('78', 'is_recom', '2', '推荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('79', 'is_top', '2', '置顶（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('80', 'is_special', '2', '特荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('81', 'is_head', '2', '头条（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('82', 'litpic', '2', '缩略图', 'img', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('83', 'title', '2', '标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('84', 'is_b', '2', '加粗', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('85', 'channel', '2', '模型ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('86', 'typeid', '2', '当前栏目', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('87', 'aid', '2', 'aid', 'int', 'int(10)', '10', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('127', 'users_id', '0', '会员ID', 'int', 'int(11)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('128', 'arc_level_id', '0', '文档会员权限ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('129', 'arc_level_id', '4', '文档会员权限ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('130', 'arc_level_id', '2', '文档会员权限ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1565662106', '1565662106', '0');
INSERT INTO `zan_channelfield` VALUES ('131', 'users_id', '2', '会员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1565662106', '1565662106', '0');
INSERT INTO `zan_channelfield` VALUES ('136', 'weapp_code', '-99', '插件栏目唯一标识', 'text', 'varchar(200)', '200', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('137', 'is_release', '-99', '栏目是否应用于会员投稿发布，1是，0否', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('138', 'old_price', '0', '产品旧价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('139', 'stock_count', '0', '商品库存量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('140', 'stock_show', '0', '商品库存在产品详情页是否显示，1为显示，0为不显示', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('141', 'joinaid', '0', '关联文档ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('142', 'downcount', '0', '下载次数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('143', 'downcount', '4', '下载次数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('144', 'update_time', '1', '更新时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('145', 'add_time', '1', '新增时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('146', 'downcount', '1', '下载次数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('147', 'joinaid', '1', '关联文档ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('148', 'del_method', '1', '伪删除状态，1为主动删除，2为跟随上级栏目被动删除', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('149', 'is_del', '1', '伪删除，1=是，0=否', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('150', 'arc_level_id', '1', '文档会员权限ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('151', 'users_id', '1', '会员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('152', 'admin_id', '1', '管理员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('557', 'lang', '-99', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1725005361', '1725005361', '0');
INSERT INTO `zan_channelfield` VALUES ('154', 'sort_order', '1', '排序号', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('155', 'status', '1', '状态(0=屏蔽，1=正常)', 'switch', 'tinyint(1)', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('156', 'tempview', '1', '文档模板文件名', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('157', 'prom_type', '1', '产品类型：0普通产品，1虚拟产品', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('158', 'stock_show', '1', '商品库存在产品详情页是否显示，1为显示，0为不显示', 'switch', 'tinyint(1) unsigned', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('159', 'stock_count', '1', '商品库存量', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('160', 'old_price', '1', '产品旧价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('161', 'users_price', '1', '会员价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('162', 'seo_description', '1', 'SEO描述', 'multitext', 'text', '0', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('163', 'seo_keywords', '1', 'SEO关键词', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('164', 'seo_title', '1', 'SEO标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('165', 'ismake', '1', '是否静态页面（0=动态，1=静态）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('166', 'jumplinks', '1', '外链跳转', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('167', 'arcrank', '1', '阅读权限：0=开放浏览，-1=待审核稿件', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('168', 'click', '1', '浏览量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('169', 'author', '1', '作者', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('170', 'is_litpic', '1', '图片（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('171', 'is_jump', '1', '跳转链接（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('172', 'is_recom', '1', '推荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('173', 'is_top', '1', '置顶（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('174', 'is_special', '1', '特荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('175', 'is_head', '1', '头条（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('176', 'litpic', '1', '缩略图', 'img', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('177', 'title', '1', '标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('178', 'is_b', '1', '加粗', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('179', 'channel', '1', '模型ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('180', 'typeid', '1', '当前栏目', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('181', 'aid', '1', 'aid', 'int', 'int(10)', '10', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('182', 'downcount', '2', '下载次数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233793', '1574233793', '0');
INSERT INTO `zan_channelfield` VALUES ('183', 'joinaid', '2', '关联文档ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233793', '1574233793', '0');
INSERT INTO `zan_channelfield` VALUES ('184', 'stock_show', '2', '商品库存在产品详情页是否显示，1为显示，0为不显示', 'switch', 'tinyint(1) unsigned', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233793', '1574233793', '0');
INSERT INTO `zan_channelfield` VALUES ('185', 'stock_count', '2', '商品库存量', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233793', '1574233793', '0');
INSERT INTO `zan_channelfield` VALUES ('186', 'old_price', '2', '产品旧价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233793', '1574233793', '0');
INSERT INTO `zan_channelfield` VALUES ('187', 'update_time', '3', '更新时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('188', 'add_time', '3', '新增时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('189', 'downcount', '3', '下载次数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('190', 'joinaid', '3', '关联文档ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('191', 'del_method', '3', '伪删除状态，1为主动删除，2为跟随上级栏目被动删除', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('192', 'is_del', '3', '伪删除，1=是，0=否', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('193', 'arc_level_id', '3', '文档会员权限ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('194', 'users_id', '3', '会员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('195', 'admin_id', '3', '管理员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('559', 'lang', '1', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233787', '1574233787', '0');
INSERT INTO `zan_channelfield` VALUES ('197', 'sort_order', '3', '排序号', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('198', 'status', '3', '状态(0=屏蔽，1=正常)', 'switch', 'tinyint(1)', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('199', 'tempview', '3', '文档模板文件名', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('200', 'prom_type', '3', '产品类型：0普通产品，1虚拟产品', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('201', 'stock_show', '3', '商品库存在产品详情页是否显示，1为显示，0为不显示', 'switch', 'tinyint(1) unsigned', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('202', 'stock_count', '3', '商品库存量', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('203', 'old_price', '3', '产品旧价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('204', 'users_price', '3', '会员价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('205', 'seo_description', '3', 'SEO描述', 'multitext', 'text', '0', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('206', 'seo_keywords', '3', 'SEO关键词', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('207', 'seo_title', '3', 'SEO标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('208', 'ismake', '3', '是否静态页面（0=动态，1=静态）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('209', 'jumplinks', '3', '外链跳转', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('210', 'arcrank', '3', '阅读权限：0=开放浏览，-1=待审核稿件', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('211', 'click', '3', '浏览量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('212', 'author', '3', '作者', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('213', 'is_litpic', '3', '图片（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('214', 'is_jump', '3', '跳转链接（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('215', 'is_recom', '3', '推荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('216', 'is_top', '3', '置顶（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('217', 'is_special', '3', '特荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('218', 'is_head', '3', '头条（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('219', 'litpic', '3', '缩略图', 'img', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('220', 'title', '3', '标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('221', 'is_b', '3', '加粗', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('222', 'channel', '3', '模型ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('223', 'typeid', '3', '当前栏目', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('224', 'aid', '3', 'aid', 'int', 'int(10)', '10', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('225', 'update_time', '4', '更新时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('226', 'add_time', '4', '新增时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('227', 'joinaid', '4', '关联文档ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('228', 'del_method', '4', '伪删除状态，1为主动删除，2为跟随上级栏目被动删除', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('229', 'is_del', '4', '伪删除，1=是，0=否', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('230', 'users_id', '4', '会员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('231', 'admin_id', '4', '管理员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('560', 'lang', '1', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '0', '0', '1', '0', '1', '100', '1', '1641862075', '1641862075', '0');
INSERT INTO `zan_channelfield` VALUES ('233', 'sort_order', '4', '排序号', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('234', 'status', '4', '状态(0=屏蔽，1=正常)', 'switch', 'tinyint(1)', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('235', 'tempview', '4', '文档模板文件名', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('236', 'prom_type', '4', '产品类型：0普通产品，1虚拟产品', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('237', 'stock_show', '4', '商品库存在产品详情页是否显示，1为显示，0为不显示', 'switch', 'tinyint(1) unsigned', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('238', 'stock_count', '4', '商品库存量', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('239', 'old_price', '4', '产品旧价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('240', 'users_price', '4', '会员价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('241', 'seo_description', '4', 'SEO描述', 'multitext', 'text', '0', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('242', 'seo_keywords', '4', 'SEO关键词', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('243', 'seo_title', '4', 'SEO标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('244', 'ismake', '4', '是否静态页面（0=动态，1=静态）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('245', 'jumplinks', '4', '外链跳转', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('246', 'arcrank', '4', '阅读权限：0=开放浏览，-1=待审核稿件', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('247', 'click', '4', '浏览量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('248', 'author', '4', '作者', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('249', 'is_litpic', '4', '图片（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('250', 'is_jump', '4', '跳转链接（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('251', 'is_recom', '4', '推荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('252', 'is_top', '4', '置顶（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('253', 'is_special', '4', '特荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('254', 'is_head', '4', '头条（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('255', 'litpic', '4', '缩略图', 'img', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('256', 'title', '4', '标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('257', 'is_b', '4', '加粗', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('258', 'channel', '4', '模型ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('259', 'typeid', '4', '当前栏目', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('260', 'aid', '4', 'aid', 'int', 'int(10)', '10', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('261', 'update_time', '6', '更新时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('262', 'add_time', '6', '新增时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('263', 'downcount', '6', '下载次数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('264', 'joinaid', '6', '关联文档ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('265', 'del_method', '6', '伪删除状态，1为主动删除，2为跟随上级栏目被动删除', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('266', 'is_del', '6', '伪删除，1=是，0=否', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('267', 'arc_level_id', '6', '文档会员权限ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('268', 'users_id', '6', '会员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('269', 'admin_id', '6', '管理员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('562', 'lang', '2', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '0', '0', '1', '0', '1', '100', '1', '1641862075', '1641862075', '0');
INSERT INTO `zan_channelfield` VALUES ('271', 'sort_order', '6', '排序号', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('272', 'status', '6', '状态(0=屏蔽，1=正常)', 'switch', 'tinyint(1)', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('273', 'tempview', '6', '文档模板文件名', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('274', 'prom_type', '6', '产品类型：0普通产品，1虚拟产品', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('275', 'stock_show', '6', '商品库存在产品详情页是否显示，1为显示，0为不显示', 'switch', 'tinyint(1) unsigned', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('276', 'stock_count', '6', '商品库存量', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('277', 'old_price', '6', '产品旧价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('278', 'users_price', '6', '会员价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('279', 'seo_description', '6', 'SEO描述', 'multitext', 'text', '0', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('280', 'seo_keywords', '6', 'SEO关键词', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('281', 'seo_title', '6', 'SEO标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('282', 'ismake', '6', '是否静态页面（0=动态，1=静态）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('283', 'jumplinks', '6', '外链跳转', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('284', 'arcrank', '6', '阅读权限：0=开放浏览，-1=待审核稿件', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('285', 'click', '6', '浏览量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('286', 'author', '6', '作者', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('287', 'is_litpic', '6', '图片（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('288', 'is_jump', '6', '跳转链接（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('289', 'is_recom', '6', '推荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('290', 'is_top', '6', '置顶（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('291', 'is_special', '6', '特荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('292', 'is_head', '6', '头条（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('293', 'litpic', '6', '缩略图', 'img', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('294', 'title', '6', '标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('295', 'is_b', '6', '加粗', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('296', 'channel', '6', '模型ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('297', 'typeid', '6', '当前栏目', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('298', 'aid', '6', 'aid', 'int', 'int(10)', '10', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('306', 'htmlfilename', '0', '自定义文件名', 'text', 'varchar(50)', '50', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('307', 'htmlfilename', '1', '自定义文件名', 'text', 'varchar(50)', '50', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('308', 'htmlfilename', '2', '自定义文件名', 'text', 'varchar(50)', '50', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('309', 'htmlfilename', '3', '自定义文件名', 'text', 'varchar(50)', '50', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('310', 'htmlfilename', '4', '自定义文件名', 'text', 'varchar(50)', '50', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('311', 'htmlfilename', '6', '自定义文件名', 'text', 'varchar(50)', '50', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('312', 'attrlist_id', '0', '参数列表ID', 'int', 'int(10) unsigned', '10', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533091930', '1533091930', '0');
INSERT INTO `zan_channelfield` VALUES ('313', 'sales_num', '0', '销售量', 'int', 'int(10) unsigned', '10', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533091930', '1533091930', '0');
INSERT INTO `zan_channelfield` VALUES ('314', 'update_time', '5', '更新时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('315', 'add_time', '5', '新增时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('316', 'htmlfilename', '5', '自定义文件名', 'text', 'varchar(50)', '50', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('317', 'downcount', '5', '下载次数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('318', 'joinaid', '5', '关联文档ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('319', 'del_method', '5', '伪删除状态，1为主动删除，2为跟随上级栏目被动删除', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('320', 'is_del', '5', '伪删除，1=是，0=否', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('321', 'arc_level_id', '5', '文档会员权限ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('322', 'users_id', '5', '会员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('323', 'admin_id', '5', '管理员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('561', 'lang', '2', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1563518642', '1563518642', '0');
INSERT INTO `zan_channelfield` VALUES ('325', 'sort_order', '5', '排序号', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('326', 'status', '5', '状态(0=屏蔽，1=正常)', 'switch', 'tinyint(1)', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('327', 'tempview', '5', '文档模板文件名', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('328', 'prom_type', '5', '产品类型：0=普通产品，1=虚拟(默认手动发货)，2=虚拟(网盘', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('329', 'stock_show', '5', '商品库存在产品详情页是否显示，1为显示，0为不显示', 'switch', 'tinyint(1) unsigned', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('330', 'stock_count', '5', '商品库存量', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('331', 'sales_num', '5', '销售量', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('332', 'old_price', '5', '产品旧价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('333', 'users_price', '5', '会员价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('334', 'attrlist_id', '5', '参数列表ID', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('335', 'seo_description', '5', 'SEO描述', 'multitext', 'text', '0', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('336', 'seo_keywords', '5', 'SEO关键词', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('337', 'seo_title', '5', 'SEO标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('338', 'ismake', '5', '是否静态页面（0=动态，1=静态）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('339', 'jumplinks', '5', '外链跳转', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('340', 'arcrank', '5', '阅读权限：0=开放浏览，-1=待审核稿件', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('341', 'click', '5', '浏览量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('342', 'author', '5', '作者', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('343', 'is_litpic', '5', '图片（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('344', 'is_jump', '5', '跳转链接（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('345', 'is_recom', '5', '推荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('346', 'is_top', '5', '置顶（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('347', 'is_special', '5', '特荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('348', 'is_head', '5', '头条（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('349', 'litpic', '5', '缩略图', 'img', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('350', 'title', '5', '标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('351', 'is_b', '5', '加粗', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('352', 'channel', '5', '模型ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('353', 'typeid', '5', '当前栏目', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('354', 'aid', '5', 'aid', 'int', 'int(10)', '10', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('355', 'content', '5', '内容详情', 'htmltext', 'longtext', '0', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('356', 'courseware', '5', '课件地址', 'text', 'varchar(200)', '200', '', '', '', '0', '1', '0', '0', '1', '0', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('357', 'courseware_free', '5', '课件收费', 'select', 'enum(\'免费\',\'收费\')', '0', '免费,收费', '', '', '0', '1', '0', '0', '1', '0', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('358', 'total_duration', '5', '视频总时长', 'int', 'int(10)', '10', '0', '', '', '0', '1', '0', '0', '1', '0', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('359', 'total_video', '5', '视频数', 'int', 'int(10)', '10', '0', '', '', '0', '1', '0', '0', '1', '0', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('404', 'topid', '-99', '顶级栏目ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1557042574', '1557042574', '0');
INSERT INTO `zan_channelfield` VALUES ('361', 'update_time', '7', '更新时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('362', 'add_time', '7', '新增时间', 'datetime', 'int(11)', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('363', 'htmlfilename', '7', '自定义文件名', 'text', 'varchar(50)', '50', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('364', 'downcount', '7', '下载次数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('365', 'joinaid', '7', '关联文档ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('366', 'del_method', '7', '伪删除状态，1为主动删除，2为跟随上级栏目被动删除', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('367', 'is_del', '7', '伪删除，1=是，0=否', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('368', 'arc_level_id', '7', '文档会员权限ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('369', 'users_id', '7', '会员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('370', 'admin_id', '7', '管理员ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('563', 'lang', '3', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233796', '1574233796', '0');
INSERT INTO `zan_channelfield` VALUES ('372', 'sort_order', '7', '排序号', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('373', 'status', '7', '状态(0=屏蔽，1=正常)', 'switch', 'tinyint(1)', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('374', 'tempview', '7', '文档模板文件名', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('375', 'prom_type', '7', '产品类型：0=普通产品，1=虚拟(默认手动发货)，2=虚拟(网盘', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('376', 'stock_show', '7', '商品库存在产品详情页是否显示，1为显示，0为不显示', 'switch', 'tinyint(1) unsigned', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('377', 'stock_count', '7', '商品库存量', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('378', 'sales_num', '7', '销售量', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('379', 'old_price', '7', '产品旧价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('380', 'users_free', '7', '是否会员免费，默认0不免费，1为免费', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('381', 'users_price', '7', '会员价', 'decimal', 'decimal(10,2)', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('382', 'attrlist_id', '7', '参数列表ID', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('383', 'seo_description', '7', 'SEO描述', 'multitext', 'text', '0', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('384', 'seo_keywords', '7', 'SEO关键词', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('385', 'seo_title', '7', 'SEO标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('386', 'ismake', '7', '是否静态页面（0=动态，1=静态）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('387', 'jumplinks', '7', '外链跳转', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('388', 'arcrank', '7', '阅读权限：0=开放浏览，-1=待审核稿件', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('389', 'click', '7', '浏览量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('390', 'author', '7', '作者', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('391', 'is_litpic', '7', '图片（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('392', 'is_jump', '7', '跳转链接（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('393', 'is_recom', '7', '推荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('394', 'is_top', '7', '置顶（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('395', 'is_special', '7', '特荐（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('396', 'is_head', '7', '头条（0=否，1=是）', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('397', 'litpic', '7', '缩略图', 'img', 'varchar(250)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('398', 'title', '7', '标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('399', 'is_b', '7', '加粗', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('400', 'channel', '7', '模型ID', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('401', 'typeid', '7', '当前栏目', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('402', 'aid', '7', 'aid', 'int', 'int(10)', '10', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('403', 'content', '7', '内容详情', 'htmltext', 'longtext', '0', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('405', 'is_slide', '0', '是否幻灯', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092420', '1533092420', '0');
INSERT INTO `zan_channelfield` VALUES ('406', 'is_roll', '0', '是否幻灯', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092420', '1533092420', '0');
INSERT INTO `zan_channelfield` VALUES ('407', 'is_diyattr', '0', '是否自定义', 'switch', 'tinyint(1)', '250', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533092420', '1533092420', '0');
INSERT INTO `zan_channelfield` VALUES ('408', 'restric_type', '0', '限制模式，0=免费，1=付费，2=会员专享，3=会员付费', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1616293251', '1616293251', '0');
INSERT INTO `zan_channelfield` VALUES ('409', 'diy_dirpath', '-99', '自定义HTML保存路径', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('410', 'rulelist', '-99', '列表静态文件存放规则', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('411', 'ruleview', '-99', '文档静态文件存放规则', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('412', 'subtitle', '0', '副标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1636338535', '1636338535', '0');
INSERT INTO `zan_channelfield` VALUES ('413', 'origin', '0', '来源', 'text', 'varchar(30)', '30', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1636338535', '1636338535', '0');
INSERT INTO `zan_channelfield` VALUES ('414', 'stypeid', '0', '副栏目', 'text', 'varchar(90)', '90', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1636338535', '1636338535', '0');
INSERT INTO `zan_channelfield` VALUES ('415', 'area_id', '1', '所在区域', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('416', 'city_id', '1', '所在城市', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('417', 'province_id', '1', '省份', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('418', 'collection', '1', '收藏数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('419', 'appraise', '1', '评价数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('420', 'restric_type', '1', '限制模式，0=免费，1=付费，2=会员专享，3=会员付费', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('421', 'sales_num', '1', '销售量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('422', 'users_free', '1', '是否会员免费，默认0不免费，1为免费', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('423', 'attrlist_id', '1', '参数列表ID', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('424', 'origin', '1', '来源', 'text', 'varchar(30)', '30', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('425', 'is_diyattr', '1', '自定义（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('426', 'is_slide', '1', '幻灯（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('427', 'is_roll', '1', '滚动（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('428', 'subtitle', '1', '副标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('429', 'stypeid', '1', '副栏目ID集合', 'text', 'varchar(90)', '90', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949813', '1641949813', '0');
INSERT INTO `zan_channelfield` VALUES ('430', 'area_id', '2', '所在区域', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('431', 'city_id', '2', '所在城市', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('432', 'province_id', '2', '省份', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('433', 'collection', '2', '收藏数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('434', 'appraise', '2', '评价数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('435', 'restric_type', '2', '限制模式，0=免费，1=付费，2=会员专享，3=会员付费', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('436', 'sales_num', '2', '销售量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('437', 'users_free', '2', '是否会员免费，默认0不免费，1为免费', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('438', 'attrlist_id', '2', '参数列表ID', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('439', 'origin', '2', '来源', 'text', 'varchar(30)', '30', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('440', 'is_diyattr', '2', '自定义（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('441', 'is_slide', '2', '幻灯（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('442', 'is_roll', '2', '滚动（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('443', 'subtitle', '2', '副标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('444', 'stypeid', '2', '副栏目ID集合', 'text', 'varchar(90)', '90', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949815', '1641949815', '0');
INSERT INTO `zan_channelfield` VALUES ('445', 'area_id', '3', '所在区域', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('446', 'city_id', '3', '所在城市', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('447', 'province_id', '3', '省份', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('448', 'collection', '3', '收藏数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('449', 'appraise', '3', '评价数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('450', 'restric_type', '3', '限制模式，0=免费，1=付费，2=会员专享，3=会员付费', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('451', 'sales_num', '3', '销售量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('452', 'users_free', '3', '是否会员免费，默认0不免费，1为免费', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('453', 'attrlist_id', '3', '参数列表ID', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('454', 'origin', '3', '来源', 'text', 'varchar(30)', '30', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('455', 'is_diyattr', '3', '自定义（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('456', 'is_slide', '3', '幻灯（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('457', 'is_roll', '3', '滚动（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('458', 'subtitle', '3', '副标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('459', 'stypeid', '3', '副栏目ID集合', 'text', 'varchar(90)', '90', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949817', '1641949817', '0');
INSERT INTO `zan_channelfield` VALUES ('460', 'area_id', '4', '所在区域', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('461', 'city_id', '4', '所在城市', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('462', 'province_id', '4', '省份', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('463', 'collection', '4', '收藏数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('464', 'appraise', '4', '评价数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('465', 'restric_type', '4', '限制模式，0=免费，1=付费，2=会员专享，3=会员付费', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('466', 'sales_num', '4', '销售量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('467', 'users_free', '4', '是否会员免费，默认0不免费，1为免费', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('468', 'attrlist_id', '4', '参数列表ID', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('469', 'origin', '4', '来源', 'text', 'varchar(30)', '30', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('470', 'is_diyattr', '4', '自定义（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('471', 'is_slide', '4', '幻灯（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('472', 'is_roll', '4', '滚动（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('473', 'subtitle', '4', '副标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('474', 'stypeid', '4', '副栏目ID集合', 'text', 'varchar(90)', '90', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949819', '1641949819', '0');
INSERT INTO `zan_channelfield` VALUES ('475', 'area_id', '6', '所在区域', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('476', 'city_id', '6', '所在城市', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('477', 'province_id', '6', '省份', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('478', 'collection', '6', '收藏数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('479', 'appraise', '6', '评价数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('480', 'restric_type', '6', '限制模式，0=免费，1=付费，2=会员专享，3=会员付费', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('481', 'sales_num', '6', '销售量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('482', 'users_free', '6', '是否会员免费，默认0不免费，1为免费', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('483', 'attrlist_id', '6', '参数列表ID', 'int', 'int(10) unsigned', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('484', 'origin', '6', '来源', 'text', 'varchar(30)', '30', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('485', 'is_diyattr', '6', '自定义（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('486', 'is_slide', '6', '幻灯（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('487', 'is_roll', '6', '滚动（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('488', 'subtitle', '6', '副标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('489', 'stypeid', '6', '副栏目ID集合', 'text', 'varchar(90)', '90', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949820', '1641949820', '0');
INSERT INTO `zan_channelfield` VALUES ('490', 'area_id', '7', '所在区域', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949822', '1641949822', '0');
INSERT INTO `zan_channelfield` VALUES ('491', 'city_id', '7', '所在城市', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949822', '1641949822', '0');
INSERT INTO `zan_channelfield` VALUES ('492', 'province_id', '7', '省份', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949822', '1641949822', '0');
INSERT INTO `zan_channelfield` VALUES ('493', 'collection', '7', '收藏数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949822', '1641949822', '0');
INSERT INTO `zan_channelfield` VALUES ('494', 'appraise', '7', '评价数', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949822', '1641949822', '0');
INSERT INTO `zan_channelfield` VALUES ('495', 'restric_type', '7', '限制模式，0=免费，1=付费，2=会员专享，3=会员付费', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949822', '1641949822', '0');
INSERT INTO `zan_channelfield` VALUES ('496', 'origin', '7', '来源', 'text', 'varchar(30)', '30', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949822', '1641949822', '0');
INSERT INTO `zan_channelfield` VALUES ('497', 'is_diyattr', '7', '自定义（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949822', '1641949822', '0');
INSERT INTO `zan_channelfield` VALUES ('498', 'is_slide', '7', '幻灯（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949822', '1641949822', '0');
INSERT INTO `zan_channelfield` VALUES ('499', 'is_roll', '7', '滚动（0=否，1=是）', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949822', '1641949822', '0');
INSERT INTO `zan_channelfield` VALUES ('500', 'subtitle', '7', '副标题', 'text', 'varchar(200)', '200', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949822', '1641949822', '0');
INSERT INTO `zan_channelfield` VALUES ('501', 'stypeid', '7', '副栏目ID集合', 'text', 'varchar(90)', '90', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1641949822', '1641949822', '0');
INSERT INTO `zan_channelfield` VALUES ('572', 'lang', '7', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '0', '0', '1', '0', '1', '100', '1', '1641862075', '1641862075', '0');
INSERT INTO `zan_channelfield` VALUES ('571', 'lang', '7', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('570', 'lang', '6', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '0', '0', '1', '0', '1', '100', '1', '1641862075', '1641862075', '0');
INSERT INTO `zan_channelfield` VALUES ('569', 'lang', '6', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233802', '1574233802', '0');
INSERT INTO `zan_channelfield` VALUES ('568', 'lang', '5', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '0', '0', '1', '0', '1', '100', '1', '1641862075', '1641862075', '0');
INSERT INTO `zan_channelfield` VALUES ('567', 'lang', '5', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('566', 'lang', '4', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '0', '0', '1', '0', '1', '100', '1', '1641862075', '1641862075', '0');
INSERT INTO `zan_channelfield` VALUES ('565', 'lang', '4', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1574233799', '1574233799', '0');
INSERT INTO `zan_channelfield` VALUES ('564', 'lang', '3', '语言标识', 'text', 'varchar(50)', '50', 'cn', '', '', '0', '0', '0', '0', '1', '0', '1', '100', '1', '1641862075', '1641862075', '0');
INSERT INTO `zan_channelfield` VALUES ('518', 'target', '-99', '新窗口打开', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1547890773', '1547890773', '0');
INSERT INTO `zan_channelfield` VALUES ('519', 'nofollow', '-99', '防抓取', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1547890773', '1547890773', '0');
INSERT INTO `zan_channelfield` VALUES ('520', 'content_ey_m', '1', '手机端内容详情', 'htmltext', 'longtext', '250', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1533464713', '1623047123', '0');
INSERT INTO `zan_channelfield` VALUES ('521', 'content_ey_m', '2', '手机端内容详情', 'htmltext', 'longtext', '250', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1645086030', '1645086039', '0');
INSERT INTO `zan_channelfield` VALUES ('522', 'content_ey_m', '3', '手机端内容详情', 'htmltext', 'longtext', '250', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1533359588', '1533359588', '0');
INSERT INTO `zan_channelfield` VALUES ('523', 'content_ey_m', '4', '手机端内容详情', 'htmltext', 'longtext', '250', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1533359752', '1533359752', '0');
INSERT INTO `zan_channelfield` VALUES ('524', 'content_ey_m', '5', '手机端内容详情', 'htmltext', 'longtext', '250', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1591957363', '1591957363', '0');
INSERT INTO `zan_channelfield` VALUES ('525', 'content_ey_m', '6', '手机端内容详情', 'htmltext', 'longtext', '250', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1533464715', '1533464715', '0');
INSERT INTO `zan_channelfield` VALUES ('526', 'content_ey_m', '7', '手机端内容详情', 'htmltext', 'longtext', '250', '', '', '', '0', '1', '1', '0', '1', '0', '0', '100', '1', '1602320145', '1602320145', '0');
INSERT INTO `zan_channelfield` VALUES ('527', 'typearcrank', '-99', '阅读权限：0=开放浏览，-1=待审核稿件', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1547890773', '1547890773', '0');
INSERT INTO `zan_channelfield` VALUES ('528', 'empty_logic', '-99', '空内容逻辑', 'switch', 'tinyint(1)', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1533524780', '1533524780', '0');
INSERT INTO `zan_channelfield` VALUES ('529', 'users_discount_type', '0', '产品会员折扣类型(0:系统默认折扣; 1:指定会员级别; 2:不参与折扣;)', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1683873488', '1683873488', '0');
INSERT INTO `zan_channelfield` VALUES ('530', 'logistics_type', '0', '商品物流支持类型(1: 物流配送; 2: 到店核销)', 'text', 'varchar(100)', '100', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1690364521', '1690364521', '0');
INSERT INTO `zan_channelfield` VALUES ('531', 'editor_img_clear_link', '3', '清除非本站链接', 'switch', 'tinyint(1)', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1701047939', '1701047939', '0');
INSERT INTO `zan_channelfield` VALUES ('532', 'editor_remote_img_local', '3', '远程图片本地化', 'switch', 'tinyint(1)', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1701047939', '1701047939', '0');
INSERT INTO `zan_channelfield` VALUES ('533', 'no_vip_pay', '3', 'restric_type = 2 时,会员专享,非会员可付费使用,0-关闭,1-开启', 'switch', 'tinyint(3)', '3', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1701047939', '1701047939', '0');
INSERT INTO `zan_channelfield` VALUES ('534', 'logistics_type', '3', '商品物流支持类型(1: 物流配送; 2: 到店核销)', 'text', 'varchar(100)', '100', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1701047939', '1701047939', '0');
INSERT INTO `zan_channelfield` VALUES ('535', 'sales_all', '3', '虚拟总销量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1701047939', '1701047939', '0');
INSERT INTO `zan_channelfield` VALUES ('536', 'virtual_sales', '3', '商品虚拟销售量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1701047939', '1701047939', '0');
INSERT INTO `zan_channelfield` VALUES ('537', 'users_discount_type', '3', '产品会员折扣类型(0:系统默认折扣; 1:指定会员级别; 2:不参与折扣;)', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1701047939', '1701047939', '0');
INSERT INTO `zan_channelfield` VALUES ('538', 'crossed_price', '3', '商品划线价', 'decimal', 'decimal(10,2) unsigned', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1701047939', '1701047939', '0');
INSERT INTO `zan_channelfield` VALUES ('539', 'free_shipping', '3', '商品是否包邮(1包邮(免运费)  0跟随系统)', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1701047939', '1701047939', '0');
INSERT INTO `zan_channelfield` VALUES ('540', 'merchant_id', '3', '多商家ID', 'datetime', 'int(11) unsigned', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1701047939', '1701047939', '0');
INSERT INTO `zan_channelfield` VALUES ('541', 'total_arc', '-99', '栏目下文档数量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1711942240', '1711942240', '0');
INSERT INTO `zan_channelfield` VALUES ('542', 'reason', '2', '退回原因', 'multitext', 'text', '0', '', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1725071522', '1725071522', '0');
INSERT INTO `zan_channelfield` VALUES ('543', 'editor_img_clear_link', '2', '清除非本站链接', 'switch', 'tinyint(1)', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1725071522', '1725071522', '0');
INSERT INTO `zan_channelfield` VALUES ('544', 'editor_remote_img_local', '2', '远程图片本地化', 'switch', 'tinyint(1)', '1', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1725071522', '1725071522', '0');
INSERT INTO `zan_channelfield` VALUES ('545', 'no_vip_pay', '2', 'restric_type = 2 时,会员专享,非会员可付费使用,0-关闭,1-开启', 'switch', 'tinyint(3)', '3', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1725071522', '1725071522', '0');
INSERT INTO `zan_channelfield` VALUES ('546', 'logistics_type', '2', '商品物流支持类型(1: 物流配送; 2: 到店核销)', 'text', 'varchar(100)', '100', '1', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1725071522', '1725071522', '0');
INSERT INTO `zan_channelfield` VALUES ('547', 'sales_all', '2', '虚拟总销量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1725071522', '1725071522', '0');
INSERT INTO `zan_channelfield` VALUES ('548', 'virtual_sales', '2', '商品虚拟销售量', 'int', 'int(10)', '10', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1725071522', '1725071522', '0');
INSERT INTO `zan_channelfield` VALUES ('549', 'users_discount_type', '2', '产品会员折扣类型(0:系统默认折扣; 1:指定会员级别; 2:不参与折扣;)', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1725071522', '1725071522', '0');
INSERT INTO `zan_channelfield` VALUES ('550', 'crossed_price', '2', '商品划线价', 'decimal', 'decimal(10,2) unsigned', '10', '0.00', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1725071522', '1725071522', '0');
INSERT INTO `zan_channelfield` VALUES ('551', 'free_shipping', '2', '商品是否包邮(1包邮(免运费)  0跟随系统)', 'switch', 'tinyint(1) unsigned', '1', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1725071522', '1725071522', '0');
INSERT INTO `zan_channelfield` VALUES ('552', 'merchant_id', '2', '多商家ID', 'datetime', 'int(11) unsigned', '11', '0', '', '', '0', '0', '1', '0', '1', '1', '1', '100', '1', '1725071522', '1725071522', '0');

-- -----------------------------
-- Table structure for `zan_channelfield_bind`
-- -----------------------------
DROP TABLE IF EXISTS `zan_channelfield_bind`;
CREATE TABLE `zan_channelfield_bind` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `typeid` int(10) DEFAULT '0' COMMENT '栏目ID',
  `field_id` int(10) DEFAULT '0' COMMENT '自定义字段ID',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='栏目与自定义字段绑定表';


-- -----------------------------
-- Table structure for `zan_channelfield_log`
-- -----------------------------
DROP TABLE IF EXISTS `zan_channelfield_log`;
CREATE TABLE `zan_channelfield_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT '' COMMENT '字段名称',
  `channel_id` int(10) DEFAULT '0' COMMENT '模型ID',
  `dtype` varchar(32) DEFAULT '' COMMENT '字段类型',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='自定义字段日志表';


-- -----------------------------
-- Table structure for `zan_channeltype`
-- -----------------------------
DROP TABLE IF EXISTS `zan_channeltype`;
CREATE TABLE `zan_channeltype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nid` varchar(50) NOT NULL DEFAULT '' COMMENT '识别id',
  `title` varchar(30) DEFAULT '' COMMENT '名称',
  `ntitle` varchar(30) DEFAULT '' COMMENT '左侧菜单名称',
  `table` varchar(50) DEFAULT '' COMMENT '表名',
  `ctl_name` varchar(50) DEFAULT '' COMMENT '控制器名称（区分大小写）',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态(1=启用，0=屏蔽)',
  `ifsystem` tinyint(1) DEFAULT '0' COMMENT '字段分类，1=系统(不可修改)，0=自定义',
  `is_repeat_title` tinyint(1) DEFAULT '1' COMMENT '文档标题重复，1=允许，0=不允许',
  `is_release` tinyint(1) DEFAULT '0' COMMENT '模型是否允许应用于会员投稿发布，1是，0否',
  `is_litpic_users_release` tinyint(1) DEFAULT '1' COMMENT '缩略图是否应用于会员投稿，1=允许，0=不允许',
  `data` text COMMENT '额外序列化存储数据',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '伪删除，1=是，0=否',
  `sort_order` smallint(6) DEFAULT '50' COMMENT '排序',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idention` (`nid`) USING BTREE,
  UNIQUE KEY `ctl_name` (`ctl_name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COMMENT='系统模型表';

-- -----------------------------
-- Records of `zan_channeltype`
-- -----------------------------
INSERT INTO `zan_channeltype` VALUES ('1', 'article', '文章模型', '文章', 'article', 'Article', '1', '1', '1', '1', '1', '', '0', '1', '1509197711', '1564532747');
INSERT INTO `zan_channeltype` VALUES ('4', 'download', '下载模型', '下载', 'download', 'Download', '0', '1', '1', '1', '1', '', '0', '4', '1509197711', '1564532747');
INSERT INTO `zan_channeltype` VALUES ('2', 'product', '产品模型', '产品', 'product', 'Product', '1', '1', '1', '1', '1', '', '0', '2', '1509197711', '1564532747');
INSERT INTO `zan_channeltype` VALUES ('8', 'guestbook', '留言模型', '留言', 'guestbook', 'Guestbook', '0', '1', '1', '1', '1', '', '0', '8', '1509197711', '1690181604');
INSERT INTO `zan_channeltype` VALUES ('6', 'single', '单页模型', '单页', 'single', 'Single', '1', '1', '1', '1', '1', '', '0', '6', '1509197711', '1564532747');
INSERT INTO `zan_channeltype` VALUES ('3', 'images', '案例模型', '案例', 'images', 'Images', '1', '1', '1', '1', '1', '', '0', '3', '1509197711', '1564532747');
INSERT INTO `zan_channeltype` VALUES ('5', 'media', '视频模型', '视频', 'media', 'Media', '0', '1', '1', '1', '1', '', '0', '5', '1509197711', '1564532747');
INSERT INTO `zan_channeltype` VALUES ('7', 'special', '专题模型', '专题', 'special', 'Special', '0', '1', '1', '1', '1', '', '0', '7', '1509197711', '1564532747');

-- -----------------------------
-- Table structure for `zan_citysite`
-- -----------------------------
DROP TABLE IF EXISTS `zan_citysite`;
CREATE TABLE `zan_citysite` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '表id',
  `name` varchar(32) DEFAULT '' COMMENT '地区名称',
  `level` tinyint(4) DEFAULT '0' COMMENT '地区等级 分省市县区',
  `parent_id` int(10) DEFAULT '0' COMMENT '父id',
  `topid` int(10) DEFAULT '0' COMMENT '顶级ID',
  `initial` varchar(5) DEFAULT '' COMMENT '首字母',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态（1：开启，0：隐藏）',
  `is_hot` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否热门',
  `domain` varchar(50) NOT NULL DEFAULT '' COMMENT '二级域名',
  `is_open` tinyint(1) DEFAULT '0' COMMENT '二级域名开启状态，0=否，1=是',
  `seoset` tinyint(1) DEFAULT '0' COMMENT 'SEO设置，0=使用主站，1=自定义',
  `seo_title` varchar(200) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(200) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `sort_order` int(6) unsigned NOT NULL DEFAULT '100' COMMENT '排序',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `showall` tinyint(3) DEFAULT '1' COMMENT '是否显示主站信息',
  PRIMARY KEY (`id`),
  KEY `domain` (`domain`) USING BTREE,
  KEY `level` (`level`,`status`) USING BTREE,
  KEY `initial` (`initial`,`sort_order`,`id`) USING BTREE,
  KEY `parent_id` (`parent_id`,`status`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='城市分站表';


-- -----------------------------
-- Table structure for `zan_common_pic`
-- -----------------------------
DROP TABLE IF EXISTS `zan_common_pic`;
CREATE TABLE `zan_common_pic` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '常用图片ID',
  `pic_path` varchar(255) NOT NULL DEFAULT '' COMMENT '图片地址',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '多语言',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='常用图片';

-- -----------------------------
-- Records of `zan_common_pic`
-- -----------------------------
INSERT INTO `zan_common_pic` VALUES ('10', '/uploads/allimg/20250221/1-25022111211M01.jpg', 'en', '1740108163', '1740108163');
INSERT INTO `zan_common_pic` VALUES ('8', '/uploads/allimg/20250221/1-25022111211UF.jpg', 'en', '1740108149', '1740108149');
INSERT INTO `zan_common_pic` VALUES ('7', '/uploads/allimg/20250221/1-25022111211UB.jpg', 'en', '1740108149', '1740108149');
INSERT INTO `zan_common_pic` VALUES ('6', '/uploads/allimg/20250221/1-25022111211R38.jpg', 'en', '1740108149', '1740108149');

-- -----------------------------
-- Table structure for `zan_config`
-- -----------------------------
DROP TABLE IF EXISTS `zan_config`;
CREATE TABLE `zan_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT '' COMMENT '配置的key键名',
  `value` text,
  `inc_type` varchar(64) DEFAULT '' COMMENT '配置分组',
  `desc` varchar(50) DEFAULT '' COMMENT '描述',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '是否已删除，0=否，1=是',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=733 DEFAULT CHARSET=utf8 COMMENT='系统配置表';

-- -----------------------------
-- Records of `zan_config`
-- -----------------------------
INSERT INTO `zan_config` VALUES ('76', 'basic_body_allowurls', '', 'web', '', 'en', '0', '1730428011');
INSERT INTO `zan_config` VALUES ('201', 'admin_logic_1623133485', '1', 'syn', '', 'en', '0', '1623322108');
INSERT INTO `zan_config` VALUES ('202', 'system_use_language', '0', 'system', '', 'en', '0', '1623322108');
INSERT INTO `zan_config` VALUES ('203', 'admin_logic_1623055490', '1', 'syn', '', 'en', '0', '1623322108');
INSERT INTO `zan_config` VALUES ('204', 'syn_admin_logic_1623036205', '1', 'syn', '', 'en', '0', '1623322108');
INSERT INTO `zan_config` VALUES ('205', 'syn_admin_logic_archives_1618279798', '1', 'syn', '', 'en', '0', '1623322108');
INSERT INTO `zan_config` VALUES ('206', 'syn_admin_logic_ask_answer_like', '1', 'syn', '', 'en', '0', '1623322108');
INSERT INTO `zan_config` VALUES ('207', 'syn_admin_logic_1614829121', '1', 'syn', '', 'en', '0', '1623322108');
INSERT INTO `zan_config` VALUES ('208', 'syn_admin_logic_1616123192', '1', 'syn', '', 'en', '0', '1616460912');
INSERT INTO `zan_config` VALUES ('209', 'syn_admin_logic_1614829120', '1', 'syn', '', 'en', '0', '1616460912');
INSERT INTO `zan_config` VALUES ('210', 'syn_admin_logic_1610086648', '1', 'syn', '', 'en', '0', '1616460912');
INSERT INTO `zan_config` VALUES ('211', 'syn_admin_logic_balance_pay', '1', 'syn', '', 'en', '0', '1616460912');
INSERT INTO `zan_config` VALUES ('212', 'other_arcdownload', '100|500', 'other', '', 'en', '0', '1614152874');
INSERT INTO `zan_config` VALUES ('213', 'other_arcclick', '500|1000', 'other', '', 'en', '0', '1614152874');
INSERT INTO `zan_config` VALUES ('214', 'max_sizeunit', 'MB', 'basic', '', 'en', '0', '1614152874');
INSERT INTO `zan_config` VALUES ('215', 'max_filesize', '100', 'basic', '', 'en', '0', '1614152874');
INSERT INTO `zan_config` VALUES ('216', 'basic_img_style_wh', '0', 'basic', '', 'en', '0', '1614152874');
INSERT INTO `zan_config` VALUES ('217', 'web_login_expiretime', '36000', 'web', '', 'en', '0', '1725085304');
INSERT INTO `zan_config` VALUES ('218', 'web_tpl_theme', '', 'web', '', 'en', '0', '1730797078');
INSERT INTO `zan_config` VALUES ('219', 'syn_admin_logic_video_addfields_2', '1', 'syn', '', 'en', '0', '1614152870');
INSERT INTO `zan_config` VALUES ('220', 'syn_admin_logic_1608884981_2', '1', 'syn', '', 'en', '0', '1614152870');
INSERT INTO `zan_config` VALUES ('221', 'basic_indexname', '首页', 'basic', '', 'en', '0', '1614152874');
INSERT INTO `zan_config` VALUES ('222', 'web_mobile_domain_open', '0', 'web', '', 'en', '0', '1610585089');
INSERT INTO `zan_config` VALUES ('223', 'admin_logic_1610086647', '1', 'syn', '', 'en', '0', '1610334638');
INSERT INTO `zan_config` VALUES ('224', 'syn_admin_logic_1609291091', '1', 'syn', '', 'en', '0', '1610334638');
INSERT INTO `zan_config` VALUES ('225', 'syn_admin_logic_1609039608', '1', 'syn', '', 'en', '0', '1610334638');
INSERT INTO `zan_config` VALUES ('226', 'web_assist_color', '#2189be', 'web', '', 'en', '0', '1610357887');
INSERT INTO `zan_config` VALUES ('227', 'web_theme_color', '#3398cc', 'web', '', 'en', '0', '1610357887');
INSERT INTO `zan_config` VALUES ('228', 'system_paginate_pagesize', '50', 'system', '', 'en', '0', '1729039076');
INSERT INTO `zan_config` VALUES ('229', 'syn_admin_logic_1608191377', '1', 'syn', '', 'en', '0', '1610334638');
INSERT INTO `zan_config` VALUES ('230', 'download_select_servername', 'a:6:{i:0;s:12:\"立即下载\";i:1;s:15:\"本地服务器\";i:2;s:15:\"远程服务器\";i:3;s:12:\"百度网盘\";i:4;s:15:\"七牛云存储\";i:5;s:12:\"腾讯网盘\";}', 'download', '', 'en', '0', '1610439420');
INSERT INTO `zan_config` VALUES ('231', 'syn_admin_logic_1608189503', '1', 'syn', '', 'en', '0', '1610334638');
INSERT INTO `zan_config` VALUES ('232', 'sms_type', '1', 'sms', '', 'en', '0', '1610334638');
INSERT INTO `zan_config` VALUES ('233', 'syn_admin_logic_links_group', '1', 'syn', '', 'en', '0', '1610334638');
INSERT INTO `zan_config` VALUES ('234', 'syn_admin_logic_check_oneself', '1', 'syn', '', 'en', '0', '1610334638');
INSERT INTO `zan_config` VALUES ('235', 'php_servicecode', '84fafe641e8a8cb2f7aa82fda39e489b', 'php', '', 'en', '0', '1740369342');
INSERT INTO `zan_config` VALUES ('236', 'php_servicemeal', '2', 'php', '', 'en', '0', '1740369342');
INSERT INTO `zan_config` VALUES ('237', 'web_status_text', '网站暂时关闭，维护中……', 'web', '', 'en', '0', '1730852030');
INSERT INTO `zan_config` VALUES ('238', 'web_status_mode', '0', 'web', '', 'en', '0', '1730864424');
INSERT INTO `zan_config` VALUES ('239', 'syn_admin_logic_unlink', '1', 'syn', '', 'en', '0', '1591262356');
INSERT INTO `zan_config` VALUES ('240', 'syn_admin_logic_update_basic', '1', 'syn', '', 'en', '0', '1591262356');
INSERT INTO `zan_config` VALUES ('241', 'syn_admin_logic_update_tag', '1', 'syn', '', 'en', '0', '1591262356');
INSERT INTO `zan_config` VALUES ('242', 'syn_admin_logic_update_arctype', '1', 'syn', '', 'en', '0', '1591262356');
INSERT INTO `zan_config` VALUES ('243', 'syn_admin_logic_users_download', '1', 'syn', '', 'en', '0', '1602320126');
INSERT INTO `zan_config` VALUES ('244', 'syn_admin_logic_special_addfields', '5', 'syn', '', 'en', '0', '1614152870');
INSERT INTO `zan_config` VALUES ('245', 'syn_admin_logic_session_conf', '1', 'syn', '', 'en', '0', '1602320145');
INSERT INTO `zan_config` VALUES ('246', 'syn_admin_logic_arctype_topid', '2', 'syn', '', 'en', '0', '1610334638');
INSERT INTO `zan_config` VALUES ('247', 'syn_admin_logic_arctype_topid2', '1', 'syn', '', 'en', '0', '1609929250');
INSERT INTO `zan_config` VALUES ('248', 'web_attr_2', 'demo@admin.com', 'web', '', 'en', '0', '1729326881');
INSERT INTO `zan_config` VALUES ('249', 'web_attr_3', 'Moumou Science and Technology Park, Tianhe District, Guangzhou City, Guangdong Province', 'web', '', 'en', '0', '1730767146');
INSERT INTO `zan_config` VALUES ('250', 'web_attr_4', 'XX Clothing Company', 'web', '', 'en', '0', '1730767146');
INSERT INTO `zan_config` VALUES ('251', 'web_recordnum_mode', '0', 'web', '', 'en', '0', '1609930161');
INSERT INTO `zan_config` VALUES ('252', 'thumb_open', '0', 'thumb', '', 'en', '0', '1609985492');
INSERT INTO `zan_config` VALUES ('253', 'thumb_mode', '2', 'thumb', '', 'en', '0', '1609985492');
INSERT INTO `zan_config` VALUES ('254', 'thumb_color', '#FFFFFF', 'thumb', '', 'en', '0', '1609985492');
INSERT INTO `zan_config` VALUES ('255', 'thumb_width', '300', 'thumb', '', 'en', '0', '1609985492');
INSERT INTO `zan_config` VALUES ('256', 'thumb_height', '300', 'thumb', '', 'en', '0', '1609985492');
INSERT INTO `zan_config` VALUES ('257', 'system_usecodelist', '4acfVQdUVQUFBlYEBFAKBARVUlRdW1FaBAYAXQpoFQtfUQowBjYyY3RRJHZYLW9wZhwyN156Mm8zW3wlY3Z2egh6fyd2JShjZEU3cUwqYXlhCyMga2Inew0Fcjdzenx7CHVpMnEqBmMFZDBydQRuaVxdByRSTCV6J192PHRqfmlsBmo3YQcucWd8NmViKnVnASIvIVVxLmFUfXAhdERzfn9ieiFhUT1gZF4kYF8tb2BiVTgzb0I1SF0DYhRDUWFXdkVkDUYoMkdWXylcDBpxAlQFLA4MbDUONVJiV0ZkfQtLQVUfbgIGRmxyME1/FWhDXwo5GAFgBkEQUXdXQWdlS3Jkf1VtHScHQVcoXUVSenV2Azs1fHEgbzRHUjN3ZmB+UnFRMXIXN3AFDgBgdSp1ZFcDMDF4fj5uDgV1MmdLc3BBcVIwB1wAZGRZMXB1KnRwcSo7OAhyPnsSdkE1WX5keQlhYicHNSB9WA81d1gpYGRIBzEKXGsvUSpgUg5GRl8KdXtFMmVQIG1jRihhWFdsdVdGPA', 'system', '', 'en', '0', '1740124207');
INSERT INTO `zan_config` VALUES ('258', 'web_shopcomment_switch', '1', 'web', '', 'en', '0', '1727430728');
INSERT INTO `zan_config` VALUES ('259', 'web_theme_color_model', '1', 'web', '', 'en', '0', '1610357887');
INSERT INTO `zan_config` VALUES ('260', 'web_adminlogo', '/public/static/admin/images/logo_ey.png', 'web', '', 'en', '0', '1610357887');
INSERT INTO `zan_config` VALUES ('261', 'web_loginlogo', '/public/static/admin/images/login-logo_ey.png', 'web', '', 'en', '0', '1610357887');
INSERT INTO `zan_config` VALUES ('262', 'web_loginbgimg_model', '1', 'web', '', 'en', '0', '1610352403');
INSERT INTO `zan_config` VALUES ('263', 'web_loginbgimg', '/public/static/admin/images/login-bg.png', 'web', '', 'en', '0', '1730704386');
INSERT INTO `zan_config` VALUES ('264', 'syn_admin_logic_1608884981', '1', 'syn', '', 'en', '0', '1610352406');
INSERT INTO `zan_config` VALUES ('265', 'web_users_tpl_theme', '', 'web', '', 'en', '0', '1610352449');
INSERT INTO `zan_config` VALUES ('266', 'php_serviceinfo', 'f0feVAhTVVUGAQkEBwZWVgFYUVFSBAFUBlEEBAMaF0BSBEQBVhAMEV9HXBYNFlQCUEFQe1k3VCxgfQ9FY1hEb00NQi5aDQk8TFxXVQ4MVAJqWlBVRT5ULF4CCH9jL1hZTQtZFUoOCS4PCQ9VeHtUE0gJA3B+EGsNTV4LQk4MRgFfXngdYQkDIn5fUG1TDFQCaldQA1kuVCxWQBIbUUpfWUAJAihRF1A/QwhybE1CFypTUhB8BwpfVARFFHlYWQBuBS0CBnMBEhdQWk9uZ1sGEXAERxsWFVcRQVYERVoCWV5EEhVeGgUiCUNSCmZfViYbX10tfQU8ahsGUCVUTThiZVsAdlkFQUlHV0RNXFhGBwpVXAhEU0QIQWtGWlJSVmlCAlQEVGQWUAcPCWVBAFJUUmVMUVIEBG4WD1VVVGgUAABTAGsRDVdVAWpEDwcPDD0WDw5RBGgTBFYPBD5FAARTAWsTUQIIUkdJFFBMQF9bEw5KXlQVDkRuFg9RBwVoFAAFDgBrEQBTAwFqRA1RBFU9Fg1cAQ9oEwoHBAo+RQNTAQ9rEwFTCgA5EAMCXFJrQVZWCwFHGxYHRxdfXBBdRwYHFQ1EaxEAAQBQakQMBg5SPRYBCQNTaBMGBgRSPkUBVAEBaxMCU1sGORABAw0Ma0FXVAtaOUIBVVcFa0ZVBQZZFxsVB0IQUAwXCEVWCBoCFltBZUxdVVFTbhYCAVtWaBQNB1ECaxEMBlYEakQMAQMCPRYMDgZSaBMFUQMLPkUCVgdUaxMCV10FORABBAsMFRhDAkxNDVhGC0EEAhFYEmgUDVVSU2sRDVFcA2pEAQRRUD0WDVxWVnUvbhYAAVYIaBQDAAUFaxENUAADakQOAQUMQ08bWBFGQQNAGkVWE0VREkEVDURSHXEULA9GBnBZYQACJFVAP2ENVlM0Bl8rWltQeHNcVXkOeRQDNkFYdGd+AgQac1UAf3YWUQ5hVQZ3WBVvZH5QeCBhUyghdAh1d35MLQlsUCpZRw9oO19EA2h+DW0EZRZVM20KKg9nRndedgAsJ3sAKXR9H3sJRwQrXWJVVnBbH20yAVMEMgddcF5YTC8ZcA0oc3ZffiB+AitaRFZ8WmFSVCNUGj8zDwFYYwZYKAlWQStNfVJ/J3UKBGEJXBcbFQ9TRgJQSUdUREBdUxZbQXQLMQYDVQJVDgFWAgEzew8EXxVIGgcKCFdYVxYNFhsCVxcNXBZKEABYVwcSDkMNA1EHUQEOV1QADlABV1UGB1RYWF0FUgJTUA5WVggNAxcbFQNPFFERABZpWFcWDQRNQU1LHFhBEm0XXl4HEg5RGRVUClgXXTwSAFQTAwQbFhQTXVYIVl0IbQ1CXkAKBU0XXlkSRQsaWUdHGhNMXVMWW1EVGxBEURRbBxUJQFVNUQUHB1YFRhRBBwRfVUxrVFsUDU0bXwcYREUGVkMSb0QNQFBeCGgLSAYLRwwAFRZHXQVBAwtJFV0VbQxbV0AKBE0XQkcBRQVcBjoWQlhUURUOUFQKCVMDDVACUxsRF0BTE1RTUjlSEFEOAEcMARUWREAAF0xKRw0FShAKRGwGVVhDDwcbRF4XZxAcCxQLCRgVVQUHZk0MWlFECFIAAFIGDVMBAAJKFRFIBwQRU25NXVpRQ1kIDlYCBl8BUQ4FThJECUVoVgpbC088FgBER1BXUmsOEBsDR1JNLFgBBWEOeV4OTXt0LEMHCgAMKl97WlBjbVU6Q3sGU2A8WS1weQFUYDRMek0kVABsOlQ8XHNaUGNXGC19UQZTYD8BLlp+C3x3K0FUBQVPLVIMDD1+ZAh6Y2VTO3FsVnlgLwY7f2ZRfV4wAW9/MwUqQikPPX5kC3pjfgw7cWxXek4nSjt/ZlN+TigBb38zBD5vKQg9fmQLelptUTtxbFd5Yy9FKl5EC1JsL1t6Xi8BLVIbCAcEBAl9cHoXAX4AHGdnAks5YGIMYFgZBHljKwcqCRtUKwRnUXoGTFAtU1oSbXIeAy1jeQp9YhkEeWMoWz5UG1QrBGdTe3FMUCx+bw1uWB4DLXBlCmlYGQR5YyhcKgkbVChMcE55XUwCLwtjE1VaNxkqWQNfEkk', 'php', '', 'en', '0', '1740369351');
INSERT INTO `zan_config` VALUES ('267', 'php_weapp_plugin_open', '1', 'php', '', 'en', '0', '1740369342');
INSERT INTO `zan_config` VALUES ('268', 'syn_admin_logic_sms_template', '1', 'syn', '', 'en', '0', '1591262356');
INSERT INTO `zan_config` VALUES ('269', 'system_smtp_tpl_5', '1', 'system', '', 'en', '0', '1587364685');
INSERT INTO `zan_config` VALUES ('270', 'syn_gb_attribute_showlist', '1', 'syn', '', 'en', '0', '1576764161');
INSERT INTO `zan_config` VALUES ('271', 'system_robots_edit', '1', 'system', '', 'en', '0', '1571038279');
INSERT INTO `zan_config` VALUES ('272', 'system_synleveldata', '1', 'system', '', 'en', '0', '1564532901');
INSERT INTO `zan_config` VALUES ('273', 'system_correctarctypedirpath', '1', 'system', '', 'en', '0', '1563503940');
INSERT INTO `zan_config` VALUES ('274', 'web_users_switch', '1', 'web', '', 'en', '0', '1563498413');
INSERT INTO `zan_config` VALUES ('275', 'system_version', 'v2.0.6', 'system', '', 'en', '0', '1740102337');
INSERT INTO `zan_config` VALUES ('276', 'seo_force_inlet', '0', 'seo', '', 'en', '0', '1740123902');
INSERT INTO `zan_config` VALUES ('277', 'seo_html_pagename', '2', 'seo', '', 'en', '0', '1567578996');
INSERT INTO `zan_config` VALUES ('278', 'seo_html_listname', '2', 'seo', '', 'en', '0', '1567578996');
INSERT INTO `zan_config` VALUES ('279', 'seo_html_arcdir', '/html', 'seo', '', 'en', '0', '1725071407');
INSERT INTO `zan_config` VALUES ('280', 'syn_admin_logic_users_parameter', '1', 'syn', '', 'en', '0', '1591957363');
INSERT INTO `zan_config` VALUES ('281', 'syn_admin_logic_add_tag', '1', 'syn', '', 'en', '0', '1591957363');
INSERT INTO `zan_config` VALUES ('282', 'syn_admin_logic_video_addfields', '5', 'syn', '', 'en', '0', '1614152870');
INSERT INTO `zan_config` VALUES ('283', 'other_pcwapjs', '0', 'other', '', 'en', '0', '1636442096');
INSERT INTO `zan_config` VALUES ('284', 'php_websensitive', '5aix5LmQfOWNmuW9qXzkuJbnlYzmna985aSc5bqXfOi1jOWNmnzmnqrmlK986aOO5pq0fGJvYnzmirzms6h8OyYjfGHniYd85aSn54mHfOasp+e+jnwo5Lit5Zu9KXzvvIjkuK3lm73vvIl85Y2K5bKbwrfkvZPogrI=', 'php', '', 'en', '0', '1721637118');
INSERT INTO `zan_config` VALUES ('285', 'web_recycle_switch', '1', 'web', '', 'en', '0', '1701045570');
INSERT INTO `zan_config` VALUES ('286', 'web_exception', '0', 'web', '', 'en', '0', '1546477337');
INSERT INTO `zan_config` VALUES ('287', 'web_language_switch', '1', 'web', '', 'en', '0', '1725071308');
INSERT INTO `zan_config` VALUES ('288', 'web_is_https', '0', 'web', '', 'en', '0', '1552968816');
INSERT INTO `zan_config` VALUES ('289', 'smtp_syn_weapp', '1', 'smtp', '', 'en', '0', '1553566547');
INSERT INTO `zan_config` VALUES ('290', 'php_eyou_blacklist', '', 'php', '', 'en', '0', '1553654429');
INSERT INTO `zan_config` VALUES ('291', 'system_auth_code', '$2y$11$5e4def0b7303a9d74573376', 'system', '', 'en', '0', '1557733856');
INSERT INTO `zan_config` VALUES ('292', 'system_upgrade_filelist', 'Y29yZS9saWJyYXJ5L3RoaW5rL1JlcXVlc3QucGhwPGJyPmNvcmUvbGlicmFyeS90aGluay90ZW1wbGF0ZS90YWdsaWIvZXlvdS9UYWdMaXN0LnBocDxicj5jb3JlL2xpYnJhcnkvdGhpbmsvdGVtcGxhdGUvdGFnbGliL2V5b3UvVGFnU3BzdWJtaXRvcmRlci5waHA8YnI+Y29yZS9saWJyYXJ5L3RoaW5rL3RlbXBsYXRlL3RhZ2xpYi9leW91L1RhZ0NoYW5uZWwucGhwPGJyPmNvcmUvbGlicmFyeS90aGluay90ZW1wbGF0ZS90YWdsaWIvZXlvdS9UYWdBcmN2aWV3LnBocDxicj5jb3JlL2xpYnJhcnkvdGhpbmsvdGVtcGxhdGUvdGFnbGliL2V5b3UvQmFzZS5waHA8YnI+Y29yZS9saWJyYXJ5L3RoaW5rL3RlbXBsYXRlL3RhZ2xpYi9leW91L1RhZ0FyY2xpc3QucGhwPGJyPmNvcmUvbGlicmFyeS90aGluay90ZW1wbGF0ZS90YWdsaWIvZXlvdS9UYWdMYW5ndWFnZS5waHA8YnI+Y29yZS9saWJyYXJ5L3RoaW5rL0Nvb2tpZS5waHA8YnI+Y29yZS9saWJyYXJ5L3RoaW5rL2RiL2RyaXZlci9Ecml2ZXIucGhwPGJyPmNvcmUvbGlicmFyeS90aGluay9kYi9Db25uZWN0aW9uLnBocDxicj5hcHBsaWNhdGlvbi9ob21lL2NvbnRyb2xsZXIvQnVpbGRodG1sLnBocDxicj5hcHBsaWNhdGlvbi9ob21lL2NvbnRyb2xsZXIvU2VhcmNoLnBocDxicj5hcHBsaWNhdGlvbi9ob21lL2NvbnRyb2xsZXIvTGlzdHMucGhwPGJyPmFwcGxpY2F0aW9uL2hvbWUvY29udHJvbGxlci9WaWV3LnBocDxicj5hcHBsaWNhdGlvbi9ob21lL2NvbnRyb2xsZXIvQmFzZS5waHA8YnI+YXBwbGljYXRpb24vZnVuY3Rpb24ucGhwPGJyPmFwcGxpY2F0aW9uL2FwaS9tb2RlbC92MS9Vc2VyLnBocDxicj5hcHBsaWNhdGlvbi9hcGkvbW9kZWwvdjEvU2hvcC5waHA8YnI+YXBwbGljYXRpb24vYXBpL21vZGVsL3YxL0FwaS5waHA8YnI+YXBwbGljYXRpb24vYXBpL2xvZ2ljL3YxL0FwaUxvZ2ljLnBocDxicj5hcHBsaWNhdGlvbi9hcGkvY29udHJvbGxlci92MS9BcGkucGhwPGJyPmFwcGxpY2F0aW9uL2FwaS9jb250cm9sbGVyL0FqYXgucGhwPGJyPmFwcGxpY2F0aW9uL2NvbW1vbi5waHA8YnI+YXBwbGljYXRpb24vY29tbW9uL21vZGVsL0FyY3R5cGUucGhwPGJyPmFwcGxpY2F0aW9uL2NvbW1vbi9tb2RlbC9FeW91VXNlcnMucGhwPGJyPmFwcGxpY2F0aW9uL2NvbW1vbi9tb2RlbC9TaG9wUHVibGljSGFuZGxlLnBocDxicj5hcHBsaWNhdGlvbi9jb21tb24vbW9kZWwvTGFuZ3VhZ2UucGhwPGJyPmFwcGxpY2F0aW9uL2NvbW1vbi9sb2dpYy9TaG9wQ29tbW9uTG9naWMucGhwPGJyPmFwcGxpY2F0aW9uL2NvbW1vbi9jb250cm9sbGVyL0NvbW1vbi5waHA8YnI+YXBwbGljYXRpb24vYWRtaW4vYmVoYXZpb3IvQWN0aW9uQmVnaW5CZWhhdmlvci5waHA8YnI+YXBwbGljYXRpb24vYWRtaW4vYmVoYXZpb3IvVmlld0ZpbHRlckJlaGF2aW9yLnBocDxicj5hcHBsaWNhdGlvbi9hZG1pbi9tb2RlbC9BcnRpY2xlLnBocDxicj5hcHBsaWNhdGlvbi9hZG1pbi9tb2RlbC9QYXlBcGkucGhwPGJyPmFwcGxpY2F0aW9uL2FkbWluL21vZGVsL0ltYWdlcy5waHA8YnI+YXBwbGljYXRpb24vYWRtaW4vbW9kZWwvRmllbGQucGhwPGJyPmFwcGxpY2F0aW9uL2FkbWluL21vZGVsL1Nob3BPcmRlclNlcnZpY2UucGhwPGJyPmFwcGxpY2F0aW9uL2FkbWluL21vZGVsL01lZGlhLnBocDxicj5hcHBsaWNhdGlvbi9hZG1pbi9tb2RlbC9DdXN0b20ucGhwPGJyPmFwcGxpY2F0aW9uL2FkbWluL21vZGVsL1Byb2R1Y3QucGhwPGJyPmFwcGxpY2F0aW9uL2FkbWluL21vZGVsL1NwZWNpYWwucGhwPGJyPmFwcGxpY2F0aW9uL2FkbWluL21vZGVsL0Rvd25sb2FkRmlsZS5waHA8YnI+YXBwbGljYXRpb24vYWRtaW4vbW9kZWwvSW1hZ2VzVXBsb2FkLnBocDxicj5hcHBsaWNhdGlvbi9hZG1pbi9tb2RlbC9Eb3dubG9hZC5waHA8YnI+YXBwbGljYXRpb24vYWRtaW4vbW9kZWwvUGF5LnBocDxicj5hcHBsaWNhdGlvbi9hZG1pbi9tb2RlbC9Qcm9kdWN0SW1nLnBocDxicj5hcHBsaWNhdGlvbi9hZG1pbi90ZW1wbGF0ZS9zaG9wX3NlcnZpY2UvYWZ0ZXJfc2VydmljZS5odG08YnI+YXBwbGljYXRpb24vYWRtaW4vdGVtcGxhdGUvc2hvcF9zZXJ2aWNlL2FmdGVyX3NlcnZpY2VfcmVmdW5kLmh0bTxicj5hcHBsaWNhdGlvbi9hZG1pbi90ZW1wbGF0ZS9zaG9wX3NlcnZpY2UvYWZ0ZXJfc2VydmljZV9pbnF1aXJlLmh0bTxicj5hcHBsaWNhdGlvbi9hZG1pbi90ZW1wbGF0ZS9zaG9wX3NlcnZpY2UvYWZ0ZXJfc2VydmljZV9kZXRhaWxzLmh0bTxicj5hcHBsaWNhdGlvbi9hZG1pbi90ZW1wbGF0ZS9pbmRleC9pbmRleC5odG08YnI+YXBwbGljYXRpb24vYWRtaW4vdGVtcGxhdGUvaW5kZXgvdGhlbWVfY29uZi5odG08YnI+YXBwbGljYXRpb24vYWRtaW4vdGVtcGxhdGUvaW5kZXgvd2VsY29tZS5odG08YnI+YXBwbGljYXRpb24vYWRtaW4vdGVtcGxhdGUvaW5kZXgvdGhlbWVfd2VsY29tZV9jb25mLmh0bTxicj5hcHBsaWNhdGlvbi9hZG1pbi90ZW1wbGF0ZS9zaG9wX2NvbW1lbnQvY29tbWVudF9hZGQuaHRt', 'system', '', 'en', '0', '1725269233');
INSERT INTO `zan_config` VALUES ('293', 'system_langnum', '1', 'system', '', 'en', '0', '1740369360');
INSERT INTO `zan_config` VALUES ('294', 'system_home_default_lang', 'en', 'system', '', 'en', '0', '1740104476');
INSERT INTO `zan_config` VALUES ('295', 'system_sql_mode', 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION', 'system', '', 'en', '0', '1740369342');
INSERT INTO `zan_config` VALUES ('296', 'web_htmlcache_expires_in', '0', 'web', '', 'en', '0', '1546477337');
INSERT INTO `zan_config` VALUES ('297', 'web_show_popup_upgrade', '-1', 'web', '', 'en', '0', '1730428638');
INSERT INTO `zan_config` VALUES ('298', 'web_weapp_switch', '1', 'web', '', 'en', '0', '1563498417');
INSERT INTO `zan_config` VALUES ('299', 'seo_dynamic_format', '1', 'seo', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('300', 'web_cmsmode', '2', 'web', '', 'en', '0', '1730182582');
INSERT INTO `zan_config` VALUES ('301', 'seo_rewrite_format', '1', 'seo', '', 'en', '0', '1740104003');
INSERT INTO `zan_config` VALUES ('302', 'web_adminbasefile', '/login.php', 'web', '', 'en', '0', '1730430129');
INSERT INTO `zan_config` VALUES ('303', 'web_is_authortoken', '0', 'web', '', 'en', '0', '1730431576');
INSERT INTO `zan_config` VALUES ('304', 'web_status', '0', 'web', '', 'en', '0', '1730864424');
INSERT INTO `zan_config` VALUES ('305', 'seo_liststitle_format', '2', 'seo', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('306', '_cmscopyright', 'cbQ1AmriPQ7LHyth9xeHH6Lj', 'php', '', 'en', '0', '1571040555');
INSERT INTO `zan_config` VALUES ('307', 'web_eyoucms', 'http://www.zancms.com', 'web', '', 'en', '0', '1730797078');
INSERT INTO `zan_config` VALUES ('308', 'web_templets_m', '/template/mobile', 'web', '', 'en', '0', '1730797078');
INSERT INTO `zan_config` VALUES ('309', 'web_templets_pc', '/template/pc', 'web', '', 'en', '0', '1730797078');
INSERT INTO `zan_config` VALUES ('310', 'web_templeturl', '/template', 'web', '', 'en', '0', '1730797078');
INSERT INTO `zan_config` VALUES ('311', 'web_templets_dir', '/template', 'web', '', 'en', '0', '1730797078');
INSERT INTO `zan_config` VALUES ('312', 'web_cmsurl', '', 'web', '', 'en', '0', '1729241561');
INSERT INTO `zan_config` VALUES ('313', 'web_sqldatapath', '/data/sqldata_s15P8L65mK2lMcFPbDJ7', 'web', '', 'en', '0', '1740369346');
INSERT INTO `zan_config` VALUES ('314', 'web_cmspath', '', 'web', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('315', 'seo_inlet', '1', 'seo', '', 'en', '0', '1740123904');
INSERT INTO `zan_config` VALUES ('316', 'web_attr_1', '400-12345-67890', 'web', '', 'en', '0', '1667183895');
INSERT INTO `zan_config` VALUES ('317', 'web_authortoken', '446f50af7a76660a2957e48eda235f03', 'web', '', 'en', '0', '1733388455');
INSERT INTO `zan_config` VALUES ('318', 'web_title', 'A clothing company', 'web', '', 'en', '0', '1730767163');
INSERT INTO `zan_config` VALUES ('319', 'seo_expires_in', '7200', 'seo', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('320', 'sitemap_zzbaidutoken', '', 'sitemap', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('321', 'sitemap_txt', '0', 'sitemap', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('322', 'sitemap_xml', '1', 'sitemap', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('323', 'sitemap_not2', '1', 'sitemap', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('324', 'sitemap_not1', '0', 'sitemap', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('325', 'sitemap_auto', '1', 'sitemap', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('326', 'list_symbol', '&gt;', 'basic', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('327', 'seo_pseudo', '3', 'seo', '', 'en', '0', '1725071407');
INSERT INTO `zan_config` VALUES ('328', 'seo_arcdir', '/html', 'seo', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('329', 'web_thirdcode_wap', '', 'web', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('330', 'web_thirdcode_pc', '', 'web', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('331', 'web_copyright', 'Copyright © 2012-2022 XX Company All rights reserved', 'web', '', 'en', '0', '1730769255');
INSERT INTO `zan_config` VALUES ('332', 'web_recordnum', '', 'web', '', 'en', '0', '1729241561');
INSERT INTO `zan_config` VALUES ('333', 'web_description', 'We travel through the fashion capitals of the world, drawing on cutting-edge design concepts and blending multiculturalism with unique aesthetics. The release of new products every season is a visual feast, the perfect collision of fashion and art. From elegant dresses to everyday casual wear, from exquisite accessories to personalized trendy clothes, our product line is rich and diverse to meet the needs of different occasions and different groups of people.', 'web', '', 'en', '0', '1730767163');
INSERT INTO `zan_config` VALUES ('334', 'web_basehost', 'http://z2.zan.hk', 'web', '', 'en', '0', '1740104476');
INSERT INTO `zan_config` VALUES ('335', 'web_ico', '/favicon.ico', 'web', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('336', 'oss_switch', '0', 'oss', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('337', 'web_name', 'My website', 'web', '', 'en', '0', '1730767114');
INSERT INTO `zan_config` VALUES ('338', 'web_logo', '/uploads/allimg/20241015/1-241015151426421.png', 'web', '', 'en', '0', '1729241561');
INSERT INTO `zan_config` VALUES ('339', 'seo_viewtitle_format', '2', 'seo', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('340', 'mark_type', 'text', 'water', '', 'en', '0', '1730772420');
INSERT INTO `zan_config` VALUES ('341', 'mark_txt_size', '30', 'water', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('342', 'mark_txt_color', '#000000', 'water', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('343', 'sms_platform', '1', 'sms', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('344', 'web_keywords', 'Clothing, fashion, ready-to-wear', 'web', '', 'en', '0', '1730767163');
INSERT INTO `zan_config` VALUES ('345', 'media_type', 'swf|mpg|mp3|rm|rmvb|wmv|wma|wav|mid|mov|mp4', 'basic', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('346', 'file_type', 'zip|gz|rar|iso|doc|xls|ppt|wps|docx|xlsx|pptx', 'basic', '', 'en', '0', '1675389691');
INSERT INTO `zan_config` VALUES ('347', 'image_type', 'jpg|gif|png|bmp|jpeg|ico|webp', 'basic', '', 'en', '0', '1675389691');
INSERT INTO `zan_config` VALUES ('348', 'file_size', '50', 'basic', '', 'en', '0', '1727745262');
INSERT INTO `zan_config` VALUES ('349', 'theme_style', '1', 'basic', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('350', 'sms_time_out', '120', 'sms', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('351', 'mark_sel', '9', 'water', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('352', 'mark_quality', '56', 'water', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('353', 'mark_degree', '54', 'water', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('354', 'mark_width', '200', 'water', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('355', 'mark_height', '50', 'water', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('356', 'basic_update_seo_description', '0', 'basic', '', 'en', '0', '1725332124');
INSERT INTO `zan_config` VALUES ('357', 'web_xss_filter', '0', 'web', '', 'en', '0', '1725085304');
INSERT INTO `zan_config` VALUES ('358', 'web_login_errexpire', '600', 'web', '', 'en', '0', '1725085304');
INSERT INTO `zan_config` VALUES ('359', 'web_login_errtotal', '5', 'web', '', 'en', '0', '1725085304');
INSERT INTO `zan_config` VALUES ('360', 'web_login_lockopen', '1', 'web', '', 'en', '0', '1725085304');
INSERT INTO `zan_config` VALUES ('361', 'php_allow_service_os', 'eyJjb2RlIjoxLCJtc2ciOiJcdTY4YzBcdTZkNGJcdTUyMzBcdTY1YjBcdTcyNDhcdTY3MmMiLCJtc2cxIjoiXHU1NTQ2XHU3NTI4XHU3MjQ4XHU2NzJjXHU2NTJmXHU2MzAxXHU1NzI4XHU3ZWJmXHU2NmY0XHU2NWIwIiwibXNnMiI6Ijxmb250IGNvbG9yPSdyZWQnPlx1NTM0N1x1N2VhN1x1NjcwZFx1NTJhMVx1NTNlZlx1N2VjOFx1OGVhYlx1NGVhYlx1NTNkN1x1MzAwMjxcL2ZvbnQ+In0=', 'php', '', 'en', '0', '1730882445');
INSERT INTO `zan_config` VALUES ('362', 'absolute_path_open', '0', 'web', '', 'en', '0', '1701048818');
INSERT INTO `zan_config` VALUES ('363', 'php_upgradelist', '', 'php', '', 'en', '0', '1690161726');
INSERT INTO `zan_config` VALUES ('364', 'php_atqueryrequest', 'eyIwIjp7ImV4cGlyZV90aW1lIjo1MDk3NjAwfSwiMSI6eyJleHBpcmVfdGltZSI6ODY0MDB9LCIxLjUiOnsiZXhwaXJlX3RpbWUiOjQwNjA4MDB9LCIyIjp7ImV4cGlyZV90aW1lIjoxNzI4MDB9LCI1Ijp7ImV4cGlyZV90aW1lIjoxNzI4MDB9fQ==', 'php', '', 'en', '0', '1740369351');
INSERT INTO `zan_config` VALUES ('365', 'php_atqueryrequest_time', '0', 'php', '', 'en', '0', '1740369383');
INSERT INTO `zan_config` VALUES ('366', 'search_tabu_words', '<\r\n>\r\n\"\r\n;\r\n,\r\n@\r\n&\r\n#\r\n\\\r\n*', 'search', '', 'en', '0', '1686877656');
INSERT INTO `zan_config` VALUES ('367', 'web_anti_brushing', '0', 'web', '', 'en', '0', '1686877656');
INSERT INTO `zan_config` VALUES ('368', 'php_atqueryrequest_time2', '0', 'php', '', 'en', '0', '1740369383');
INSERT INTO `zan_config` VALUES ('369', 'seo_uphtml_after_home13', '0', 'seo', '', 'en', '0', '1740104003');
INSERT INTO `zan_config` VALUES ('370', 'seo_uphtml_after_channel13', '0', 'seo', '', 'en', '0', '1740104003');
INSERT INTO `zan_config` VALUES ('371', 'seo_uphtml_after_pernext13', '0', 'seo', '', 'en', '0', '1740104003');
INSERT INTO `zan_config` VALUES ('372', 'seo_uphtml_editafter_home', '0', 'seo', '', 'en', '0', '1706510953');
INSERT INTO `zan_config` VALUES ('373', 'seo_uphtml_editafter_channel', '0', 'seo', '', 'en', '0', '1706510953');
INSERT INTO `zan_config` VALUES ('374', 'seo_uphtml_editafter_pernext', '1', 'seo', '', 'en', '0', '1706510953');
INSERT INTO `zan_config` VALUES ('375', 'wechat_push_notice_open', '0', 'wechat', '', 'en', '0', '1721637131');
INSERT INTO `zan_config` VALUES ('376', 'seo_title_symbol', '-', 'seo', '', 'en', '0', '1740104007');
INSERT INTO `zan_config` VALUES ('377', 'editor_select', '1', 'basic', '', 'en', '0', '1675389691');
INSERT INTO `zan_config` VALUES ('378', 'web_garecordnum_mode', '0', 'web', '', 'en', '0', '1653359786');
INSERT INTO `zan_config` VALUES ('379', 'web_garecordnum', '', 'web', '', 'en', '0', '1653359786');
INSERT INTO `zan_config` VALUES ('380', 'web_status_tpl', '', 'web', '', 'en', '0', '1729326755');
INSERT INTO `zan_config` VALUES ('381', 'web_status_url', '', 'web', '', 'en', '0', '1653359786');
INSERT INTO `zan_config` VALUES ('382', 'web_stypeid_open', '1', 'web', '', 'en', '0', '1724055806');
INSERT INTO `zan_config` VALUES ('383', 'system_crypt_auth_code', '$2y$11$5e4def0b7303a9d74573376', 'system', '', 'en', '0', '1728441033');
INSERT INTO `zan_config` VALUES ('384', 'web_citysite_open', '0', 'web', '', 'en', '0', '1703142363');
INSERT INTO `zan_config` VALUES ('385', 'admin_logic_1_1648775669', '1', 'syn', '', 'en', '0', '1650263716');
INSERT INTO `zan_config` VALUES ('386', 'basic_img_title', '0', 'basic', '', 'en', '0', '1641949807');
INSERT INTO `zan_config` VALUES ('387', 'basic_img_alt', '0', 'basic', '', 'en', '0', '1641949807');
INSERT INTO `zan_config` VALUES ('388', 'basic_img_auto_wh', '0', 'basic', '', 'en', '0', '1641949807');
INSERT INTO `zan_config` VALUES ('389', 'seo_pagesize', '20', 'seo', '', 'en', '0', '1641949807');
INSERT INTO `zan_config` VALUES ('390', 'seo_upnext', '1', 'seo', '', 'en', '0', '1641949807');
INSERT INTO `zan_config` VALUES ('391', 'seo_maxpagesize', '50', 'seo', '', 'en', '0', '1641949807');
INSERT INTO `zan_config` VALUES ('392', 'seo_showmod', '1', 'seo', '', 'en', '0', '1641949807');
INSERT INTO `zan_config` VALUES ('393', 'seo_html_position', '../index.html', 'seo', '', 'en', '0', '1641949807');
INSERT INTO `zan_config` VALUES ('394', 'seo_html_templet', 'index.htm', 'seo', '', 'en', '0', '1641949807');
INSERT INTO `zan_config` VALUES ('395', 'seo_uphtml_after_pernext', '1', 'seo', '', 'en', '0', '1641949807');
INSERT INTO `zan_config` VALUES ('396', 'seo_uphtml_after_channel', '1', 'seo', '', 'en', '0', '1641949807');
INSERT INTO `zan_config` VALUES ('397', 'seo_uphtml_after_home', '0', 'seo', '', 'en', '0', '1641949807');
INSERT INTO `zan_config` VALUES ('398', 'seo_rewrite_view_format', '1', 'seo', '', 'en', '0', '1623809665');
INSERT INTO `zan_config` VALUES ('399', 'recycle_switch', '1', 'web', '', 'en', '0', '1623809302');
INSERT INTO `zan_config` VALUES ('423', 'mark_img_is_remote', '0', 'water', '', 'en', '0', '1730768986');
INSERT INTO `zan_config` VALUES ('596', 'mark_img', '', 'water', '', 'en', '0', '1730772414');
INSERT INTO `zan_config` VALUES ('597', 'is_thumb_mark', '0', 'water', '', 'en', '0', '1730768986');
INSERT INTO `zan_config` VALUES ('598', 'mark_txt', '我的网站', 'water', '', 'en', '0', '1730772436');
INSERT INTO `zan_config` VALUES ('605', 'is_mark', '0', 'water', '', 'en', '0', '1730772402');
INSERT INTO `zan_config` VALUES ('614', 'smtp_port', '', 'smtp', '', 'en', '0', '1730797128');
INSERT INTO `zan_config` VALUES ('615', 'smtp_user', '', 'smtp', '', 'en', '0', '1730797128');
INSERT INTO `zan_config` VALUES ('616', 'smtp_pwd', '', 'smtp', '', 'en', '0', '1730797128');
INSERT INTO `zan_config` VALUES ('617', 'smtp_from_eamil', '', 'smtp', '', 'en', '0', '1730797128');
INSERT INTO `zan_config` VALUES ('621', 'smtp_server', '', 'smtp', '', 'en', '0', '1730797128');
INSERT INTO `zan_config` VALUES ('622', 'cookieagrem_content', '&lt;div class=&quot;cookies-popup-box-con&quot; style=&quot;font-family: Heebo-Light; outline: 0px; margin: 0px; padding: 0px; color: rgb(51, 51, 51); font-size: 14px; white-space: normal;&quot;&gt;Please read our Terms and Conditions and this Policy before accessing or using our Services. If you cannot agree with this Policy or the Terms and Conditions, please do not access or use our Services. If you are located in a jurisdiction outside the European Economic Area, by using our Services, you accept the Terms and Conditions and accept our privacy practices described in this Policy.&lt;br/&gt;We may modify this Policy at any time, without prior notice, and changes may apply to any Personal Information we already hold about you, as well as any new Personal Information collected after the Policy is modified. If we make changes, we will notify you by revising the date at the top of this Policy. We will provide you with advanced notice if we make any material changes to how we collect, use or disclose your Personal Information that impact your rights under this Policy. If you are located in a jurisdiction other than the European Economic Area, the United Kingdom or Switzerland (collectively “European Countries”), your continued access or use of our Services after receiving the notice of changes, constitutes your acknowledgement that you accept the updated Policy. In addition, we may provide you with real time disclosures or additional information about the Personal Information handling practices of specific parts of our Services. Such notices may supplement this Policy or provide you with additional choices about how we process your Personal Information.&lt;br/&gt;&lt;br/&gt;&lt;br/&gt;&lt;strong style=&quot;font-size: 22px;&quot;&gt;Cookies&lt;/strong&gt;&lt;br/&gt;&lt;br/&gt;Cookies are small text files stored on your device when you access most Websites on the internet or open certain emails. Among other things, Cookies allow a Website to recognize your device and remember if you&amp;#39;ve been to the Website before. Examples of information collected by Cookies include your browser type and the address of the Website from which you arrived at our Website as well as IP address and clickstream behavior (that is the pages you view and the links you click).We use the term cookie to refer to Cookies and technologies that perform a similar function to Cookies (e.g., tags, pixels, web beacons, etc.). Cookies can be read by the originating Website on each subsequent visit and by any other Website that recognizes the cookie. The Website uses Cookies in order to make the Website easier to use, to support a better user experience, including the provision of information and functionality to you, as well as to provide us with information about how the Website is used so that we can make sure it is as up to date, relevant, and error free as we can. Cookies on the Website We use Cookies to personalize your experience when you visit the Site, uniquely identify your computer for security purposes, and enable us and our third-party service providers to serve ads on our behalf across the internet.&lt;br/&gt;&lt;br/&gt;We classify Cookies in the following categories:&lt;br/&gt;&amp;nbsp;● &amp;nbsp;Strictly Necessary Cookies&lt;br/&gt;&amp;nbsp;● &amp;nbsp;Performance Cookies&lt;br/&gt;&amp;nbsp;● &amp;nbsp;Functional Cookies&lt;br/&gt;&amp;nbsp;● &amp;nbsp;Targeting Cookies&lt;br/&gt;&lt;br/&gt;&lt;br/&gt;&lt;strong style=&quot;line-height: 37.4px; font-size: 22px;&quot;&gt;Cookie List&lt;/strong&gt;&lt;br/&gt;A cookie is a small piece of data (text file) that a website – when visited by a user – asks your browser to store on your device in order to remember information about you, such as your language preference or login information. Those cookies are set by us and called first-party cookies. We also use third-party cookies – which are cookies from a domain different than the domain of the website you are visiting – for our advertising and marketing efforts. More specifically, we use cookies and other tracking technologies for the following purposes:&lt;br/&gt;&lt;br/&gt;&lt;strong style=&quot;line-height: 30.6px; font-size: 18px;&quot;&gt;Strictly Necessary Cookies&lt;/strong&gt;&lt;br/&gt;These cookies are necessary for the website to function and cannot be switched off in our systems. They are usually only set in response to actions made by you which amount to a request for services, such as setting your privacy preferences, logging in or filling in forms. You can set your browser to block or alert you about these cookies, but some parts of the site will not then work. These cookies do not store any personally identifiable information.&lt;br/&gt;&lt;br/&gt;&lt;strong style=&quot;line-height: 30.6px; font-size: 18px;&quot;&gt;Functional Cookies&lt;/strong&gt;&lt;br/&gt;These cookies enable the website to provide enhanced functionality and personalisation. They may be set by us or by third party providers whose services we have added to our pages. If you do not allow these cookies then some or all of these services may not function properly.&lt;br/&gt;&lt;br/&gt;&lt;strong style=&quot;line-height: 30.6px; font-size: 18px;&quot;&gt;Performance Cookies&lt;/strong&gt;&lt;br/&gt;These cookies allow us to count visits and traffic sources so we can measure and improve the performance of our site. They help us to know which pages are the most and least popular and see how visitors move around the site. All information these cookies collect is aggregated and therefore anonymous. If you do not allow these cookies we will not know when you have visited our site, and will not be able to monitor its performance.&lt;br/&gt;&lt;br/&gt;&lt;strong style=&quot;line-height: 30.6px; font-size: 18px;&quot;&gt;Targeting Cookies&lt;/strong&gt;&lt;br/&gt;These cookies may be set through our site by our advertising partners. They may be used by those companies to build a profile of your interests and show you relevant adverts on other sites. They do not store directly personal information, but are based on uniquely identifying your browser and internet device. If you do not allow these cookies, you will experience less targeted advertising.&lt;br/&gt;&lt;br/&gt;&lt;strong style=&quot;line-height: 37.4px; font-size: 22px;&quot;&gt;How To Turn Off Cookies&lt;/strong&gt;&lt;br/&gt;You can choose to restrict or block Cookies through your browser settings at any time. Please note that certain Cookies may be set as soon as you visit the Website, but you can remove them using your browser settings. However, please be aware that restricting or blocking Cookies set on the Website may impact the functionality or performance of the Website or prevent you from using certain services provided through the Website. It will also affect our ability to update the Website to cater for user preferences and improve performance. Cookies within Mobile Applications&lt;br/&gt;&lt;br/&gt;We only use Strictly Necessary Cookies on our mobile applications. These Cookies are critical to the functionality of our applications, so if you block or delete these Cookies you may not be able to use the application. These Cookies are not shared with any other application on your mobile device. We never use the Cookies from the mobile application to store personal information about you.&lt;br/&gt;&lt;br/&gt;If you have questions or concerns regarding any information in this Privacy Policy, please contact us by email at . You can also contact us via our customer service at our Site.&lt;/div&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', 'cookieagrem', '', 'en', '0', '1729218212');
INSERT INTO `zan_config` VALUES ('623', 'cookieagrem_title', 'We use &lt;a href=&quot;javascript:void(0);&quot; class=&quot;opencookies&quot;&gt;cookie&lt;/a&gt; to improve your online experience. By continuing to browse this website, you agree to our use of &lt;a href=&quot;javascript:void(0);&quot; class=&quot;opencookies&quot;&gt;cookie&lt;/a&gt;.', 'cookieagrem', '', 'en', '0', '1729215513');
INSERT INTO `zan_config` VALUES ('624', 'cookieagrem_position', '0', 'cookieagrem', '', 'en', '0', '1730707218');
INSERT INTO `zan_config` VALUES ('625', 'cookieagrem_status', '0', 'cookieagrem', '', 'en', '0', '1730797171');
INSERT INTO `zan_config` VALUES ('636', 'web_currency_unit', 'USD', 'web', '', 'en', '0', '1730510451');
INSERT INTO `zan_config` VALUES ('649', 'web_theme_css_tplname', 'css_1.css', 'web', '', 'en', '0', '1730713528');
INSERT INTO `zan_config` VALUES ('650', 'web_theme_styleid', '1', 'web', '', 'en', '0', '1730713528');
INSERT INTO `zan_config` VALUES ('653', 'sitemap_open', '1', 'sitemap', '', 'en', '0', '1730797194');
INSERT INTO `zan_config` VALUES ('655', 'sitemap_archives_num', '5000', 'sitemap', '', 'en', '0', '0');
INSERT INTO `zan_config` VALUES ('657', 'sitemap_priority_view', '0.5', 'sitemap', '', 'en', '0', '1670383032');
INSERT INTO `zan_config` VALUES ('661', 'sitemap_priority_list', '0.8', 'sitemap', '', 'en', '0', '1670383032');
INSERT INTO `zan_config` VALUES ('664', 'sitemap_priority_index', '1.0', 'sitemap', '', 'en', '0', '1670383032');
INSERT INTO `zan_config` VALUES ('667', 'sitemap_changefreq_view', 'daily', 'sitemap', '', 'en', '0', '1670383032');
INSERT INTO `zan_config` VALUES ('670', 'sitemap_changefreq_list', 'hourly', 'sitemap', '', 'en', '0', '1670383032');
INSERT INTO `zan_config` VALUES ('672', 'sitemap_changefreq_index', 'always', 'sitemap', '', 'en', '0', '1670383032');
INSERT INTO `zan_config` VALUES ('677', 'robots_mode', '2', 'robots', '', 'en', '0', '1730282238');
INSERT INTO `zan_config` VALUES ('686', 'web_langdetect', '0', 'web', '', 'en', '0', '1730336648');
INSERT INTO `zan_config` VALUES ('687', 'web_langchange', '1', 'web', '', 'en', '0', '1730368475');
INSERT INTO `zan_config` VALUES ('688', 'web_imgconvert', '1', 'web', '', 'en', '0', '1730339237');
INSERT INTO `zan_config` VALUES ('689', 'web_imgconvert_size', '50', 'web', '', 'en', '0', '1730797078');
INSERT INTO `zan_config` VALUES ('693', 'web_imgconvert_quality', '80', 'web', '', 'en', '0', '1730368284');
INSERT INTO `zan_config` VALUES ('696', 'php_servefunclist', 'fGluc3RhbGxfdHJ1ZXx1cGdyYWRlfA==', 'php', '', 'en', '0', '1733388273');
INSERT INTO `zan_config` VALUES ('699', 'web_theme_style_uptime', '1730797453', 'web', '', 'en', '0', '1730797453');
INSERT INTO `zan_config` VALUES ('702', 'editor_remote_img_local', '1', 'web', '', 'en', '0', '1730510964');
INSERT INTO `zan_config` VALUES ('705', 'editor_img_clear_link', '1', 'web', '', 'en', '0', '1730510964');
INSERT INTO `zan_config` VALUES ('716', 'search_model', 'intellect', 'search', '', 'en', '0', '1730797428');
INSERT INTO `zan_config` VALUES ('717', 'search_second', '60', 'search', '', 'en', '0', '1730797428');
INSERT INTO `zan_config` VALUES ('718', 'search_maxnum', '5', 'search', '', 'en', '0', '1730797428');
INSERT INTO `zan_config` VALUES ('719', 'search_locking', '120', 'search', '', 'en', '0', '1730797428');
INSERT INTO `zan_config` VALUES ('720', 'title_word_model', '0', 'search', '', 'en', '0', '1730797428');
INSERT INTO `zan_config` VALUES ('731', 'web_xss_words', 'union\r\ndelete\r\noutfile\r\nchar\r\nconcat\r\ntruncate\r\ninsert\r\nrevoke\r\ngrant\r\nreplace\r\nrename\r\ndeclare\r\nexec\r\ndelimiter\r\nphar\r\neval\r\nonerror\r\nscript', 'web', '', 'en', '0', '1733388334');
INSERT INTO `zan_config` VALUES ('732', 'web_anti_words', 'wd', 'web', '', 'en', '0', '1733388334');

-- -----------------------------
-- Table structure for `zan_config_attribute`
-- -----------------------------
DROP TABLE IF EXISTS `zan_config_attribute`;
CREATE TABLE `zan_config_attribute` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `attr_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '表单id',
  `inc_type` varchar(20) DEFAULT '' COMMENT '变量分组',
  `type_id` int(11) unsigned DEFAULT '1',
  `attr_name` varchar(60) DEFAULT '' COMMENT '变量标题',
  `attr_var_name` varchar(50) DEFAULT '' COMMENT '变量名',
  `attr_input_type` tinyint(1) unsigned DEFAULT '0' COMMENT ' 0=文本框，1=下拉框，2=多行文本框，3=上传图片',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `attr_id` (`attr_id`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='自定义变量表';

-- -----------------------------
-- Records of `zan_config_attribute`
-- -----------------------------
INSERT INTO `zan_config_attribute` VALUES ('5', '1', 'web', '1', 'Contact Number', 'web_attr_1', '0', 'en', '1525962574', '1667183895');
INSERT INTO `zan_config_attribute` VALUES ('6', '2', 'web', '1', 'Contact Email', 'web_attr_2', '0', 'en', '1609930141', '1667183901');
INSERT INTO `zan_config_attribute` VALUES ('7', '3', 'web', '1', 'Company address', 'web_attr_3', '0', 'en', '1609930141', '1609930141');
INSERT INTO `zan_config_attribute` VALUES ('8', '4', 'web', '1', 'Company name', 'web_attr_4', '0', 'en', '1609930141', '1609930141');

-- -----------------------------
-- Table structure for `zan_config_type`
-- -----------------------------
DROP TABLE IF EXISTS `zan_config_type`;
CREATE TABLE `zan_config_type` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id` int(11) unsigned NOT NULL DEFAULT '0',
  `type_name` varchar(255) DEFAULT '' COMMENT '分组名称',
  `status` tinyint(1) DEFAULT '1',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  `sort_order` int(11) DEFAULT '100' COMMENT '排序',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `id` (`id`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='自定义变量分组表';

-- -----------------------------
-- Records of `zan_config_type`
-- -----------------------------
INSERT INTO `zan_config_type` VALUES ('2', '1', '默认分组', '1', 'en', '1650271499', '1650271499', '100');

-- -----------------------------
-- Table structure for `zan_country`
-- -----------------------------
DROP TABLE IF EXISTS `zan_country`;
CREATE TABLE `zan_country` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '编码',
  `continent` varchar(50) NOT NULL DEFAULT '' COMMENT '所属大洲',
  `sort_order` int(11) unsigned DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态(0:禁用; 1:启用;)',
  `add_time` int(11) unsigned DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=251 DEFAULT CHARSET=utf8 COMMENT='国家列表';

-- -----------------------------
-- Records of `zan_country`
-- -----------------------------
INSERT INTO `zan_country` VALUES ('1', '中国', 'CN', 'AS', '1', '1', '1704038400', '1732173305');
INSERT INTO `zan_country` VALUES ('2', 'Afghanistan', 'AF', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('3', 'Albania', 'AL', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('4', 'Algeria', 'DZ', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('5', 'American Samoa', 'AS', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('6', 'Andorra', 'AD', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('7', 'Angola', 'AO', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('8', 'Anguilla', 'AI', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('9', 'Antarctica', 'AQ', 'AN', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('10', 'Antigua and Barbuda', 'AG', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('11', 'Argentina', 'AR', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('12', 'Armenia', 'AM', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('13', 'Aruba', 'AW', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('14', 'Australia', 'AU', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('15', 'Austria', 'AT', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('16', 'Azerbaijan', 'AZ', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('17', 'Bahamas', 'BS', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('18', 'Bahrain', 'BH', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('19', 'Bangladesh', 'BD', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('20', 'Barbados', 'BB', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('21', 'Belarus', 'BY', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('22', 'Belgium', 'BE', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('23', 'Belize', 'BZ', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('24', 'Benin', 'BJ', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('25', 'Bermuda', 'BM', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('26', 'Bhutan', 'BT', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('27', 'Bolivia', 'BO', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('28', 'Bosnia and Herzegovina', 'BA', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('29', 'Botswana', 'BW', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('30', 'Bouvet Island', 'BV', 'AN', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('31', 'Brazil', 'BR', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('32', 'British Indian Ocean Territory', 'IO', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('33', 'Brunei Darussalam', 'BN', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('34', 'Bulgaria', 'BG', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('35', 'Burkina Faso', 'BF', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('36', 'Burundi', 'BI', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('37', 'Cambodia', 'KH', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('38', 'Cameroon', 'CM', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('39', 'Canada', 'CA', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('40', 'Cape Verde', 'CV', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('41', 'Cayman Islands', 'KY', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('42', 'Central African Republic', 'CF', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('43', 'Chad', 'TD', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('44', 'Chile', 'CL', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('45', 'Christmas Island', 'CX', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('46', 'Cocos (Keeling) Islands', 'CC', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('47', 'Colombia', 'CO', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('48', 'Comoros', 'KM', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('49', 'Congo', 'CG', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('50', 'Cook Islands', 'CK', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('51', 'Costa Rica', 'CR', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('52', 'Cote D\'Ivoire', 'CI', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('53', 'Croatia', 'HR', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('54', 'Cuba', 'CU', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('55', 'Cyprus', 'CY', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('56', 'Czech Republic', 'CZ', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('57', 'Denmark', 'DK', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('58', 'Djibouti', 'DJ', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('59', 'Dominica', 'DM', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('60', 'Dominican Republic', 'DO', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('61', 'East Timor', 'TL', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('62', 'Ecuador', 'EC', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('63', 'Egypt', 'EG', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('64', 'El Salvador', 'SV', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('65', 'Equatorial Guinea', 'GQ', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('66', 'Eritrea', 'ER', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('67', 'Estonia', 'EE', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('68', 'Ethiopia', 'ET', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('69', 'Falkland Islands (Malvinas)', 'FK', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('70', 'Faroe Islands', 'FO', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('71', 'Fiji', 'FJ', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('72', 'Finland', 'FI', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('73', 'France, Metropolitan', 'FR', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('74', 'French Guiana', 'GF', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('75', 'French Polynesia', 'PF', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('76', 'French Southern Territories', 'TF', 'AN', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('77', 'Gabon', 'GA', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('78', 'Gambia', 'GM', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('79', 'Georgia', 'GE', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('80', 'Germany', 'DE', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('81', 'Ghana', 'GH', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('82', 'Gibraltar', 'GI', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('83', 'Greece', 'GR', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('84', 'Greenland', 'GL', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('85', 'Grenada', 'GD', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('86', 'Guadeloupe', 'GP', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('87', 'Guam', 'GU', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('88', 'Guatemala', 'GT', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('89', 'Guinea', 'GN', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('90', 'Guinea-Bissau', 'GW', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('91', 'Guyana', 'GY', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('92', 'Haiti', 'HT', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('93', 'Heard and Mc Donald Islands', 'HM', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('94', 'Honduras', 'HN', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('95', 'Hungary', 'HU', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('96', 'Iceland', 'IS', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('97', 'India', 'IN', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('98', 'Indonesia', 'ID', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('99', 'Iran (Islamic Republic of)', 'IR', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('100', 'Iraq', 'IQ', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('101', 'Ireland', 'IE', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('102', 'Israel', 'IL', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('103', 'Italy', 'IT', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('104', 'Jamaica', 'JM', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('105', 'Japan', 'JP', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('106', 'Jordan', 'JO', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('107', 'Kazakhstan', 'KZ', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('108', 'Kenya', 'KE', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('109', 'Kiribati', 'KI', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('110', 'North Korea', 'KP', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('111', 'South Korea', 'KR', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('112', 'Kuwait', 'KW', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('113', 'Kyrgyzstan', 'KG', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('114', 'Lao People\'s Democratic Republic', 'LA', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('115', 'Latvia', 'LV', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('116', 'Lebanon', 'LB', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('117', 'Lesotho', 'LS', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('118', 'Liberia', 'LR', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('119', 'Libyan Arab Jamahiriya', 'LY', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('120', 'Liechtenstein', 'LI', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('121', 'Lithuania', 'LT', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('122', 'Luxembourg', 'LU', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('123', 'FYROM', 'MK', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('124', 'Madagascar', 'MG', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('125', 'Malawi', 'MW', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('126', 'Malaysia', 'MY', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('127', 'Maldives', 'MV', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('128', 'Mali', 'ML', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('129', 'Malta', 'MT', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('130', 'Marshall Islands', 'MH', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('131', 'Martinique', 'MQ', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('132', 'Mauritania', 'MR', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('133', 'Mauritius', 'MU', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('134', 'Mayotte', 'YT', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('135', 'Mexico', 'MX', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('136', 'Micronesia, Federated States of', 'FM', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('137', 'Moldova, Republic of', 'MD', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('138', 'Monaco', 'MC', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('139', 'Mongolia', 'MN', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('140', 'Montserrat', 'MS', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('141', 'Morocco', 'MA', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('142', 'Mozambique', 'MZ', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('143', 'Myanmar', 'MM', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('144', 'Namibia', 'NA', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('145', 'Nauru', 'NR', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('146', 'Nepal', 'NP', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('147', 'Netherlands', 'NL', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('148', 'Netherlands Antilles', 'AN', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('149', 'New Caledonia', 'NC', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('150', 'New Zealand', 'NZ', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('151', 'Nicaragua', 'NI', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('152', 'Niger', 'NE', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('153', 'Nigeria', 'NG', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('154', 'Niue', 'NU', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('155', 'Norfolk Island', 'NF', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('156', 'Northern Mariana Islands', 'MP', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('157', 'Norway', 'NO', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('158', 'Oman', 'OM', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('159', 'Pakistan', 'PK', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('160', 'Palau', 'PW', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('161', 'Panama', 'PA', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('162', 'Papua New Guinea', 'PG', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('163', 'Paraguay', 'PY', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('164', 'Peru', 'PE', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('165', 'Philippines', 'PH', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('166', 'Pitcairn', 'PN', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('167', 'Poland', 'PL', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('168', 'Portugal', 'PT', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('169', 'Puerto Rico', 'PR', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('170', 'Qatar', 'QA', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('171', 'Reunion', 'RE', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('172', 'Romania', 'RO', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('173', 'Russian Federation', 'RU', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('174', 'Rwanda', 'RW', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('175', 'Saint Kitts and Nevis', 'KN', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('176', 'Saint Lucia', 'LC', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('177', 'Saint Vincent and the Grenadines', 'VC', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('178', 'Samoa', 'WS', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('179', 'San Marino', 'SM', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('180', 'Sao Tome and Principe', 'ST', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('181', 'Saudi Arabia', 'SA', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('182', 'Senegal', 'SN', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('183', 'Seychelles', 'SC', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('184', 'Sierra Leone', 'SL', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('185', 'Singapore', 'SG', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('186', 'Slovak Republic', 'SK', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('187', 'Slovenia', 'SI', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('188', 'Solomon Islands', 'SB', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('189', 'Somalia', 'SO', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('190', 'South Africa', 'ZA', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('191', 'South Georgia &amp; South Sandwich Islands', 'GS', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('192', 'Spain', 'ES', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('193', 'Sri Lanka', 'LK', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('194', 'St. Helena', 'SH', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('195', 'St. Pierre and Miquelon', 'PM', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('196', 'Sudan', 'SD', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('197', 'Suriname', 'SR', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('198', 'Svalbard and Jan Mayen Islands', 'SJ', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('199', 'Swaziland', 'SZ', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('200', 'Sweden', 'SE', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('201', 'Switzerland', 'CH', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('202', 'Syrian Arab Republic', 'SY', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('203', 'Tajikistan', 'TJ', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('204', 'Tanzania, United Republic of', 'TZ', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('205', 'Thailand', 'TH', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('206', 'Togo', 'TG', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('207', 'Tokelau', 'TK', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('208', 'Tonga', 'TO', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('209', 'Trinidad and Tobago', 'TT', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('210', 'Tunisia', 'TN', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('211', 'Turkey', 'TR', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('212', 'Turkmenistan', 'TM', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('213', 'Turks and Caicos Islands', 'TC', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('214', 'Tuvalu', 'TV', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('215', 'Uganda', 'UG', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('216', 'Ukraine', 'UA', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('217', 'United Arab Emirates', 'AE', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('218', 'United Kingdom', 'GB', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('219', 'United States', 'US', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('220', 'United States Minor Outlying Islands', 'UM', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('221', 'Uruguay', 'UY', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('222', 'Uzbekistan', 'UZ', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('223', 'Vanuatu', 'VU', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('224', 'Vatican City State (Holy See)', 'VA', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('225', 'Venezuela', 'VE', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('226', 'Viet Nam', 'VN', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('227', 'Virgin Islands (British)', 'VG', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('228', 'Virgin Islands (U.S.)', 'VI', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('229', 'Wallis and Futuna Islands', 'WF', 'OA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('230', 'Western Sahara', 'EH', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('231', 'Yemen', 'YE', 'AS', '100', '1', '1704038400', '1732173279');
INSERT INTO `zan_country` VALUES ('232', 'Democratic Republic of Congo', 'CD', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('233', 'Zambia', 'ZM', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('234', 'Zimbabwe', 'ZW', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('235', 'Montenegro', 'ME', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('236', 'Serbia', 'RS', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('237', 'Aaland Islands', 'AX', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('238', 'Bonaire, Sint Eustatius and Saba', 'BQ', 'SA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('239', 'Curacao', 'CW', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('240', 'Palestinian Territory, Occupied', 'PS', 'AS', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('241', 'South Sudan', 'SS', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('242', 'St. Barthelemy', 'BL', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('243', 'St. Martin (French part)', 'MF', 'NA', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('244', 'Canary Islands', 'IC', 'AF', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('245', 'Ascension Island (British)', 'AC', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('246', 'Kosovo, Republic of', 'XK', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('247', 'Isle of Man', 'IM', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('248', 'Tristan da Cunha', 'TA', 'NULL', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('249', 'Guernsey', 'GG', 'EU', '100', '1', '1704038400', '1704038400');
INSERT INTO `zan_country` VALUES ('250', 'Jersey', 'JE', 'EU', '100', '1', '1704038400', '1704038400');

-- -----------------------------
-- Table structure for `zan_currency`
-- -----------------------------
DROP TABLE IF EXISTS `zan_currency`;
CREATE TABLE `zan_currency` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT '' COMMENT '货币名称',
  `code` varchar(20) DEFAULT '' COMMENT '货币标识',
  `unit` varchar(20) DEFAULT '' COMMENT '货币单位',
  `sort_order` int(10) DEFAULT '0' COMMENT '排序号',
  `status` tinyint(1) DEFAULT '0' COMMENT '状态：0=无效，1=有效',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8 COMMENT='货币单位表';

-- -----------------------------
-- Records of `zan_currency`
-- -----------------------------
INSERT INTO `zan_currency` VALUES ('1', '美元', 'USD', '$', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('2', '欧元', 'EUR', '€', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('3', '英镑', 'GBP', '￡', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('4', '加拿大元', 'CAD', 'CA$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('5', '澳大利亚元', 'AUD', 'AU$', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('6', '瑞士法郎', 'CHF', 'CHF', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('7', '港元', 'HKD', 'HK$', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('8', '日圆', 'JPY', '￥', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('9', '俄罗斯卢布', 'RUB', 'RUB', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('10', '巴西雷亚尔', 'BRL', 'R$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('11', '智利比索', 'CLP', '$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('12', '挪威克朗', 'NOK', 'kr.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('13', '丹麦克朗', 'DKK', 'kr.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('14', '瑞典克朗', 'SEK', 'Kr.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('15', '韩圆', 'KRW', '₩', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('16', '以色列新谢克尔', 'ILS', '₪', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('17', '墨西哥比索', 'MXN', '$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('18', '人民币元', 'CNY', '￥', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('19', '沙特里亚尔', 'SAR', 'ريال', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('20', '新加坡元', 'SGD', 'S$', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('21', '新西兰元', 'NZD', '$', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('22', '阿根廷比索', 'ARS', '$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('23', '印度卢比', 'INR', 'Rs', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('24', '哥伦比亚比索', 'COP', '$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('25', '阿联酋迪拉姆', 'AED', 'AED', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('26', '', 'UUU', '$￥', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('27', '阿富汗尼', 'AFN', 'AFA', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('28', '阿尔巴尼亚列克', 'ALL', 'Lek', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('29', '亚美尼亚德拉姆', 'AMD', '֏', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('30', '荷属安的列斯盾', 'ANG', 'ƒ', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('31', '安哥拉宽扎', 'AOA', 'Kz', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('32', '阿鲁巴弗罗林', 'AWG', 'Afl', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('33', '阿塞拜疆马纳特', 'AZN', 'man.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('34', '马克', 'BAM', 'KM', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('35', '巴巴多斯元', 'BBD', 'BDS.$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('36', '孟加拉塔卡', 'BDT', '৳', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('37', '保加利亚列弗', 'BGN', 'Лв.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('38', '布隆迪法郎', 'BIF', 'FBu', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('39', '百慕大元', 'BMD', '$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('40', '文莱元', 'BND', 'B$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('41', '玻利维亚诺', 'BOB', 'Bs.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('42', 'Mvdol（资金代码）', 'BOV', 'BOV', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('43', '巴哈马元', 'BSD', 'B$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('44', '不丹努尔特鲁姆', 'BTN', 'Nu.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('45', '博茨瓦纳普拉', 'BWP', 'P', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('46', '白俄罗斯卢布', 'BYN', 'Br.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('47', '伯利兹元', 'BZD', 'BZ$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('48', '刚果法郎', 'CDF', 'FC', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('49', '哥斯达黎加科朗', 'CRC', '₡', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('50', '古巴可兑换比索', 'CUC', 'CUC$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('51', '古巴比索', 'CUP', '$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('52', '佛得角埃斯库多', 'CVE', '$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('53', '捷克克朗', 'CZK', 'Kč', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('54', '吉布提法郎', 'DJF', 'Fdj', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('55', '多米尼加比索', 'DOP', '$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('56', '阿尔及利亚第纳尔', 'DZD', 'دج', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('57', '埃及镑', 'EGP', 'E£', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('58', '厄立特里亚纳克法', 'ERN', 'Nfk', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('59', '埃塞俄比亚比尔', 'ETB', 'Br', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('60', '斐济元', 'FJD', 'FJ$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('61', '福克兰群岛镑', 'FKP', '£', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('62', '格鲁吉亚拉里', 'GEL', '₾', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('63', '加纳塞地', 'GHS', 'GH¢', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('64', '直布罗陀镑', 'GIP', '£', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('65', '冈比亚达拉西', 'GMD', 'D', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('66', '几内亚法郎', 'GNF', 'GFr', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('67', '危地马拉格查尔', 'GTQ', 'Q', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('68', '圭亚那元', 'GYD', 'GY$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('69', '洪都拉斯伦皮拉', 'HNL', 'L', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('70', '克罗地亚库纳', 'HRK', 'kn', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('71', '海地古德', 'HTG', 'G', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('72', '匈牙利福林', 'HUF', 'Ft', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('73', '印尼盾', 'IDR', 'Rp', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('74', '伊朗里亚尔', 'IRR', '﷼', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('75', '冰岛克朗', 'ISK', 'kr', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('76', '牙买加元', 'JMD', '$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('77', '肯尼亚先令', 'KES', 'Ksh', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('78', '吉尔吉斯斯坦索姆', 'KGS', 'Лв', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('79', '柬埔寨瑞尔', 'KHR', '៛', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('80', '科摩罗法郎', 'KMF', 'CF', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('81', '朝鲜圆', 'KPW', '₩', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('82', '开曼群岛元', 'KYD', '$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('83', '哈萨克斯坦坚戈', 'KZT', '₸', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('84', '老挝基普', 'LAK', '₭', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('85', '黎巴嫩镑', 'LBP', 'ل.ل.&lrm;', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('86', '斯里兰卡卢比', 'LKR', 'Sr', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('87', '利比里亚元', 'LRD', 'L$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('88', '莱索托洛蒂', 'LSL', 'L', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('89', '摩洛哥迪尔汗', 'MAD', 'د.م.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('90', '摩尔多瓦列伊', 'MDL', 'L', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('91', '马其顿代纳尔', 'MKD', 'ден', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('92', '缅元', 'MMK', 'K', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('93', '蒙古图格里克', 'MNT', '₮', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('94', '澳门币', 'MOP', 'MOP$', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('95', '毛里求斯卢比', 'MUR', 'R', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('96', '马尔代夫拉菲亚', 'MVR', 'MVR', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('97', '马拉维克瓦查', 'MWK', 'MK', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('98', '马来西亚令吉', 'MYR', 'RM', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('99', '莫桑比克梅蒂卡尔', 'MZN', 'MT', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('100', '纳米比亚元', 'NAD', 'N$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('101', '尼日利亚奈拉', 'NGN', '₦', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('102', '尼加拉瓜科多巴', 'NIO', 'C$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('103', '尼泊尔卢比', 'NPR', '₨', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('104', '巴拿马巴波亚', 'PAB', 'B/.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('105', '秘鲁索尔', 'PEN', 'S/.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('106', '巴布亚新几内亚基那', 'PGK', 'K', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('107', '菲律宾比索', 'PHP', '₱', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('108', '巴基斯坦卢比', 'PKR', '₨', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('109', '波兰兹罗提', 'PLN', 'zł', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('110', '巴拉圭瓜拉尼', 'PYG', 'Guars.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('111', '卡塔尔里亚尔', 'QAR', 'QR.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('112', '罗马尼亚列伊', 'RON', 'L', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('113', '塞尔维亚第纳尔', 'RSD', 'din', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('114', '卢旺达法郎', 'RWF', 'RF', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('115', '所罗门群岛元', 'SBD', 'SL.$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('116', '塞舌尔卢比', 'SCR', '₨', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('117', '苏丹镑', 'SDG', 'SD', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('118', '圣赫勒拿镑', 'SHP', '£', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('119', '塞拉利昂利昂', 'SLL', 'Le', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('120', '索马里先令', 'SOS', 'Sh.so.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('121', '苏里南元', 'SRD', 'S.Fl.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('122', '南苏丹镑', 'SSP', '£', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('123', '圣多美和普林西比多布拉', 'STN', 'Db', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('124', '叙利亚镑', 'SYP', 'LS', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('125', '斯威士兰里兰吉尼', 'SZL', 'L', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('126', '泰铢', 'THB', '฿', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('127', '塔吉克斯坦索莫尼', 'TJS', 'SM', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('128', '土库曼斯坦马纳特', 'TMT', 'T', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('129', '汤加潘加', 'TOP', 'T$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('130', '土耳其里拉', 'TRY', '₺', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('131', '特立尼达和多巴哥元', 'TTD', 'TT$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('132', '新台币', 'TWD', 'NT$', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('133', '坦桑尼亚先令', 'TZS', 'TSh', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('134', '乌克兰格里夫纳', 'UAH', '₴', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('135', '乌干达先令', 'UGX', 'USh', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('136', '乌拉圭比索', 'UYU', 'N.$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('137', '乌兹别克斯坦索姆', 'UZS', 'so\'m', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('138', '委内瑞拉玻利瓦尔', 'VES', 'Bs.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('139', '越南盾', 'VND', '₫', '100', '1', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('140', '瓦努阿图瓦图', 'VUV', 'VT', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('141', '萨摩亚塔拉', 'WST', 'WS$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('142', '中非法郎', 'XAF', 'FCFA', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('143', '东加勒比元', 'XCD', '$', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('144', '西非法郎', 'XOF', 'CFA', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('145', '太平洋法郎（francPacifique）', 'XPF', '₣', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('146', '也门里亚尔', 'YER', 'ر.ي', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('147', '南非兰特', 'ZAR', 'R.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('148', '赞比亚克瓦查', 'ZMW', 'ZK', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('149', '科威特第纳尔', 'KWD', 'ك', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('150', '阿曼里亚尔', 'OMR', 'RO.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('151', '巴林第纳尔', 'BHD', 'BD.', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('152', '泽西镑', 'JEP', '£', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('153', '约旦第纳尔', 'JOD', 'د.ا', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('154', '拉特', 'LVL', 'Ls', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('155', '马达加斯加阿里亚里', 'MGA', 'Ar', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('156', '圣多美和普林西比多布拉', 'STD', 'Db', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('157', '突尼斯第纳尔', 'TND', 'DT', '100', '0', '1728464463', '1728464463');
INSERT INTO `zan_currency` VALUES ('158', '委内瑞拉玻利瓦尔', 'VEF', 'Bs', '100', '0', '1728464463', '1728464463');

-- -----------------------------
-- Table structure for `zan_ddos_log`
-- -----------------------------
DROP TABLE IF EXISTS `zan_ddos_log`;
CREATE TABLE `zan_ddos_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `md5key` varchar(50) DEFAULT '' COMMENT 'md5值',
  `file_name` text COMMENT '文件名',
  `file_num` int(10) DEFAULT '0' COMMENT '已扫描数',
  `file_total` int(10) DEFAULT '0' COMMENT '总文件数',
  `file_doubt_total` int(10) DEFAULT '0' COMMENT '可疑恶意文件数',
  `file_excess` int(5) DEFAULT '0' COMMENT '是否多余',
  `file_grade` int(10) DEFAULT '0' COMMENT '文件级别，0=正常，100=异常文件，200=疑似木马，970=低危，980=中危，990=高危',
  `html` longtext,
  `admin_id` int(11) DEFAULT '0',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='ddos查杀进度记录表';


-- -----------------------------
-- Table structure for `zan_ddos_setting`
-- -----------------------------
DROP TABLE IF EXISTS `zan_ddos_setting`;
CREATE TABLE `zan_ddos_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT '' COMMENT '配置的key键名',
  `value` longtext,
  `inc_type` varchar(50) DEFAULT 'ddos',
  `admin_id` int(11) DEFAULT '0',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='ddos业务存储表';


-- -----------------------------
-- Table structure for `zan_ddos_whitelist`
-- -----------------------------
DROP TABLE IF EXISTS `zan_ddos_whitelist`;
CREATE TABLE `zan_ddos_whitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `md5key` varchar(50) DEFAULT '' COMMENT 'md5值',
  `file_name` text COMMENT '文件名',
  `admin_id` int(11) DEFAULT '0',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='ddos扫描白名单列表';


-- -----------------------------
-- Table structure for `zan_discount_active`
-- -----------------------------
DROP TABLE IF EXISTS `zan_discount_active`;
CREATE TABLE `zan_discount_active` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `active_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动会场ID',
  `active_name` varchar(255) DEFAULT '' COMMENT '活动名称',
  `start_date` int(11) unsigned DEFAULT '0' COMMENT '活动开始时间',
  `end_date` int(11) DEFAULT '0' COMMENT '活动结束时间',
  `limit_type` tinyint(3) unsigned DEFAULT '1' COMMENT '限购类型 1-不限购,2-活动期内每人最多购买n件,3-活动期内每人每天最多购买n件',
  `limit` int(11) unsigned DEFAULT '0' COMMENT '限购数量',
  `preheat` tinyint(3) DEFAULT '0' COMMENT '是否开启预热 0-关闭 1-开启',
  `preheat_time` int(11) DEFAULT '0' COMMENT '预热时间,不能大于开启时间',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '活动状态(0禁用 1启用)',
  `is_del` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `active_id` (`active_id`,`lang`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='限时折扣-活动会场表';


-- -----------------------------
-- Table structure for `zan_discount_active_goods`
-- -----------------------------
DROP TABLE IF EXISTS `zan_discount_active_goods`;
CREATE TABLE `zan_discount_active_goods` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `active_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动ID',
  `aid` int(11) NOT NULL DEFAULT '0' COMMENT '文档id',
  `discount_goods_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '秒杀商品ID',
  `sales_actual` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '实际销量',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='限时折扣-活动会场与商品关联表';


-- -----------------------------
-- Table structure for `zan_discount_goods`
-- -----------------------------
DROP TABLE IF EXISTS `zan_discount_goods`;
CREATE TABLE `zan_discount_goods` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `discount_gid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '限时折扣商品ID',
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID->aid',
  `discount_stock` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '限时折扣商品库存总量',
  `discount_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '限时折扣价格',
  `sales` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '累积销量',
  `virtual_sales` int(11) NOT NULL DEFAULT '0' COMMENT '虚拟销量',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '100' COMMENT '商品排序(数字越小越靠前)',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '商品状态(0下架 1上架)',
  `is_del` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `is_sku` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1-多规格商品',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `discount_gid` (`discount_gid`,`lang`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='限时折扣-商品表';


-- -----------------------------
-- Table structure for `zan_download_attr_field`
-- -----------------------------
DROP TABLE IF EXISTS `zan_download_attr_field`;
CREATE TABLE `zan_download_attr_field` (
  `field_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `field_name` varchar(32) DEFAULT '' COMMENT '字段名称',
  `field_title` varchar(32) DEFAULT '' COMMENT '字段标题',
  `field_use` tinyint(1) DEFAULT '0' COMMENT '字段是否使用，0未使用，1为使用',
  `sort_order` smallint(5) DEFAULT '0' COMMENT '排序',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned DEFAULT '0' COMMENT '上传时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`field_id`),
  UNIQUE KEY `field_name` (`field_name`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='上传文件属性表';

-- -----------------------------
-- Records of `zan_download_attr_field`
-- -----------------------------
INSERT INTO `zan_download_attr_field` VALUES ('3', 'extract_code', '提取码', '1', '1', 'en', '1561001807', '1561024954');
INSERT INTO `zan_download_attr_field` VALUES ('4', 'server_name', '服务器名称', '1', '2', 'en', '1561001807', '1561078673');
INSERT INTO `zan_download_attr_field` VALUES ('5', 'extract_code', '提取码', '1', '1', 'fr', '1561001807', '1561024954');
INSERT INTO `zan_download_attr_field` VALUES ('6', 'server_name', '服务器名称', '1', '2', 'fr', '1561001807', '1561078673');
INSERT INTO `zan_download_attr_field` VALUES ('7', 'extract_code', '提取码', '1', '1', 'de', '1561001807', '1561024954');
INSERT INTO `zan_download_attr_field` VALUES ('8', 'server_name', '服务器名称', '1', '2', 'de', '1561001807', '1561078673');

-- -----------------------------
-- Table structure for `zan_download_content`
-- -----------------------------
DROP TABLE IF EXISTS `zan_download_content`;
CREATE TABLE `zan_download_content` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `aid` int(10) DEFAULT '0' COMMENT '文档ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `news_id` (`aid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='下载附加表';


-- -----------------------------
-- Table structure for `zan_download_file`
-- -----------------------------
DROP TABLE IF EXISTS `zan_download_file`;
CREATE TABLE `zan_download_file` (
  `file_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `aid` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '产品ID',
  `title` varchar(200) DEFAULT '' COMMENT '产品标题',
  `file_url` varchar(255) DEFAULT '' COMMENT '文件存储路径',
  `extract_code` varchar(20) DEFAULT '' COMMENT '文件提取码',
  `file_size` varchar(255) DEFAULT '' COMMENT '文件大小',
  `file_ext` varchar(50) DEFAULT '' COMMENT '文件后缀名',
  `file_name` varchar(200) DEFAULT '' COMMENT '文件名',
  `server_name` varchar(200) DEFAULT '' COMMENT '服务器名称',
  `file_mime` varchar(200) DEFAULT '' COMMENT '文件类型',
  `uhash` varchar(200) DEFAULT '' COMMENT '自定义的一种加密方式，用于文件下载权限验证',
  `md5file` varchar(200) DEFAULT '' COMMENT 'md5_file加密，可以检测上传/下载的文件包是否损坏',
  `is_remote` tinyint(1) DEFAULT '0' COMMENT '是否远程',
  `downcount` int(10) DEFAULT '0' COMMENT '下载次数',
  `sort_order` smallint(5) DEFAULT '0' COMMENT '排序',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(10) unsigned DEFAULT '0' COMMENT '上传时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`file_id`),
  KEY `arcid` (`aid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='下载附件表';


-- -----------------------------
-- Table structure for `zan_download_log`
-- -----------------------------
DROP TABLE IF EXISTS `zan_download_log`;
CREATE TABLE `zan_download_log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `users_id` int(10) DEFAULT '0' COMMENT '用户ID',
  `aid` int(10) DEFAULT '0' COMMENT '文档ID',
  `file_id` int(10) DEFAULT '0' COMMENT '附件ID',
  `ip` varchar(20) DEFAULT '' COMMENT 'ip',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '编辑时间',
  PRIMARY KEY (`log_id`),
  KEY `file_id` (`file_id`,`aid`,`users_id`) USING BTREE,
  KEY `aid` (`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='下载记录表';


-- -----------------------------
-- Table structure for `zan_download_order`
-- -----------------------------
DROP TABLE IF EXISTS `zan_download_order`;
CREATE TABLE `zan_download_order` (
  `order_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文章订单ID',
  `order_code` varchar(50) NOT NULL DEFAULT '' COMMENT '媒体订单编号',
  `users_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `order_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单状态：0未付款，1已付款',
  `order_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单应付总金额',
  `pay_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `pay_name` varchar(20) NOT NULL DEFAULT '' COMMENT '支付方式名称',
  `wechat_pay_type` varchar(20) NOT NULL DEFAULT '' COMMENT '微信支付时，标记使用的支付类型（扫码支付，微信内部，微信H5页面）',
  `pay_details` text COMMENT '支付时返回的数据，以serialize序列化后存入，用于后续查询。',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '视频文档ID',
  `product_name` varchar(100) DEFAULT '' COMMENT '视频文档名称',
  `product_litpic` varchar(500) DEFAULT '' COMMENT '视频文档封面图片',
  `lang` varchar(30) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned DEFAULT '0' COMMENT '下单时间',
  `update_time` int(11) unsigned DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `order_code` (`order_code`) USING BTREE,
  KEY `users_id` (`users_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='下载订单表';


-- -----------------------------
-- Table structure for `zan_faq_asklist`
-- -----------------------------
DROP TABLE IF EXISTS `zan_faq_asklist`;
CREATE TABLE `zan_faq_asklist` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `group_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '分组ID',
  `asklist_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '问题ID',
  `asklist_title` varchar(255) NOT NULL DEFAULT '' COMMENT '问题标题',
  `asklist_content` text NOT NULL COMMENT '问题回答',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '多语言',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `asklist_id` (`asklist_id`,`lang`),
  KEY `group_id` (`group_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='常见问题问答列表';

-- -----------------------------
-- Records of `zan_faq_asklist`
-- -----------------------------
INSERT INTO `zan_faq_asklist` VALUES ('1', '1', '1', '你们能按中国离岸价交货吗？', '是的，我们可以，但我们更喜欢并始终建议使用FCA、CFR/CIF和DAP国际贸易术语解释通则，以实现更顺畅、更具成本效益的交货；我们也可以帮助货运组织。', '1', 'cn', '1740104463', '1740104535');
INSERT INTO `zan_faq_asklist` VALUES ('2', '1', '1', '你們能按中國離岸價交貨嗎？', '是的，我們可以，但我們更喜歡並始終建議使用FCA、CFR/CIF和DAP國際貿易術語解釋通則，以實現更順暢、更具成本效益的交貨；我們也可以幫助貨運組織。', '1', 'zh', '1740104463', '1740104535');
INSERT INTO `zan_faq_asklist` VALUES ('3', '1', '1', 'Can you deliver the goods FOB China?', 'Yes, we can, but we prefer and always recommend using FCA, CFR/CIF, and DAP Incoterms for smoother, more cost-effective deliveries; we can also assist freight organizations.', '1', 'en', '1740104463', '1740104535');
INSERT INTO `zan_faq_asklist` VALUES ('4', '1', '2', '你能提供相关的留档吗？', '是的，我们可以提供大部分留档，包括分析一致性证书、保险、原产地证书和其他需要的出口文件。', '2', 'cn', '1740104463', '1740104535');
INSERT INTO `zan_faq_asklist` VALUES ('5', '1', '2', '你能提供相關的留檔嗎？', '是的，我們可以提供大部分留檔，包括分析一致性證書、保險、原產地證書和其他需要的出口文件。', '2', 'zh', '1740104463', '1740104535');
INSERT INTO `zan_faq_asklist` VALUES ('6', '1', '2', 'Can you provide relevant documentation?', 'Yes, we can provide most documentation, including certificates of analytical conformity, insurance, certificates of origin, and other required export documents.', '2', 'en', '1740104463', '1740104535');
INSERT INTO `zan_faq_asklist` VALUES ('7', '1', '3', '平均交货时间是多少？', '对于样品，交货期约为7天。对于批量生产，交货期为收到定金后20.30天。交货期在我们收到您的定金后生效，并且我们获得您对您产品的最终批准。如果我们的交货期不符合您的截止日期，请在销售时检查您的要求。在所有情况下，我们都会尽量满足您的需求。在大多数情况下，我们能够做到这一点。', '3', 'cn', '1740104463', '1740104535');
INSERT INTO `zan_faq_asklist` VALUES ('8', '1', '3', '平均交貨時間是多少？', '對於樣品，交貨期約爲7天。對於批量生產，交貨期爲收到定金後20.30天。交貨期在我們收到您的定金後生效，並且我們獲得您對您產品的最終批准。如果我們的交貨期不符合您的截止日期，請在銷售時檢查您的要求。在所有情況下，我們都會盡量滿足您的需求。在大多數情況下，我們能夠做到這一點。', '3', 'zh', '1740104463', '1740104535');
INSERT INTO `zan_faq_asklist` VALUES ('9', '1', '3', 'What is the average delivery time?', 'For samples, the lead time is about 7 days. For mass production, the lead time is 20.30 days after receiving the deposit. The lead time takes effect after we receive your deposit and we obtain your final approval for your product. If our lead time does not meet your deadline, please check your requirements at the time of sale. In all cases, we will try our best to meet your needs. In most cases, we are able to do this.', '3', 'en', '1740104463', '1740104535');

-- -----------------------------
-- Table structure for `zan_faq_group`
-- -----------------------------
DROP TABLE IF EXISTS `zan_faq_group`;
CREATE TABLE `zan_faq_group` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `group_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '分组ID',
  `group_title` varchar(60) NOT NULL DEFAULT '' COMMENT '分组标题',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '启用状态(0:否; 1:是;)',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '多语言',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `group_id` (`group_id`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='常见问题分组列表';

-- -----------------------------
-- Records of `zan_faq_group`
-- -----------------------------
INSERT INTO `zan_faq_group` VALUES ('1', '1', '常见问题', '1', 'cn', '1740104463', '1740104535');
INSERT INTO `zan_faq_group` VALUES ('2', '1', '常见问题', '1', 'zh', '1740104463', '1740104535');
INSERT INTO `zan_faq_group` VALUES ('3', '1', '常见问题', '1', 'en', '1740104463', '1740104535');

-- -----------------------------
-- Table structure for `zan_field_type`
-- -----------------------------
DROP TABLE IF EXISTS `zan_field_type`;
CREATE TABLE `zan_field_type` (
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT '字段类型',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT '中文类型名',
  `ifoption` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否需要设置选项',
  `sort_order` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`name`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='字段类型表';

-- -----------------------------
-- Records of `zan_field_type`
-- -----------------------------
INSERT INTO `zan_field_type` VALUES ('text', '单行文本', '0', '1', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('checkbox', '多选项', '1', '5', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('multitext', '多行文本', '0', '2', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('radio', '单选项', '1', '4', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('switch', '开关', '0', '13', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('select', '下拉框', '1', '6', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('img', '单张图', '0', '10', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('int', '整数类型', '0', '7', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('datetime', '日期和时间', '0', '12', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('htmltext', 'HTML文本', '0', '3', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('imgs', '多张图', '0', '11', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('decimal', '金额类型', '0', '9', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('float', '小数类型', '0', '8', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('region', '区域类型', '1', '6', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('file', '附件类型', '0', '11', '1532485708', '1532485708');
INSERT INTO `zan_field_type` VALUES ('media', '多媒体类型', '0', '11', '1532485708', '1532485708');

-- -----------------------------
-- Table structure for `zan_foreign_pack`
-- -----------------------------
DROP TABLE IF EXISTS `zan_foreign_pack`;
CREATE TABLE `zan_foreign_pack` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type` int(4) DEFAULT '0' COMMENT '分类：1=列表，2=留言',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '变量名',
  `value` text NOT NULL COMMENT '变量值',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `sort_order` int(10) DEFAULT '0' COMMENT '排序号',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='外贸助手语言包变量';


-- -----------------------------
-- Table structure for `zan_form`
-- -----------------------------
DROP TABLE IF EXISTS `zan_form`;
CREATE TABLE `zan_form` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '自增表单ID',
  `form_name` varchar(255) NOT NULL DEFAULT '' COMMENT '表单名称',
  `intro` text NOT NULL COMMENT '表单描述，预留',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '表单状态，0关闭，1开启',
  `attr_auto` tinyint(1) DEFAULT '0' COMMENT '自动标签：0=否，1=是',
  `lang` varchar(10) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `open_reply` tinyint(1) DEFAULT '0' COMMENT '是否开启回复 0-未开启,1-开启',
  `open_examine` tinyint(1) DEFAULT '0' COMMENT '是否开启审核 0-不审核,1-审核',
  `open_validate` tinyint(1) unsigned DEFAULT '0' COMMENT '是否开启验证码(0:否; 1:是;)',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `form_id` (`form_id`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='表单管理表';

-- -----------------------------
-- Records of `zan_form`
-- -----------------------------
INSERT INTO `zan_form` VALUES ('2', '1', 'Product Inquiry', '', '1', '0', 'en', '1728459329', '1730771543', '0', '0', '1');
INSERT INTO `zan_form` VALUES ('5', '2', 'message online', 'If you have any suggestions or question for us.Please contact us.', '1', '0', 'en', '1728459329', '1730771498', '0', '0', '0');
INSERT INTO `zan_form` VALUES ('8', '3', 'Subscription', 'Subscribe to our newsletter and don\'t miss anything from us.', '1', '0', 'en', '1728459329', '1730771606', '0', '0', '0');

-- -----------------------------
-- Table structure for `zan_guestbook`
-- -----------------------------
DROP TABLE IF EXISTS `zan_guestbook`;
CREATE TABLE `zan_guestbook` (
  `aid` int(11) NOT NULL AUTO_INCREMENT,
  `form_type` tinyint(1) DEFAULT '0' COMMENT '数据分类：0=留言模型，1=自由表单',
  `typeid` int(11) DEFAULT '0' COMMENT '栏目ID/表单ID',
  `channel` smallint(5) DEFAULT '0' COMMENT '模型ID',
  `goods_id` int(11) DEFAULT '0' COMMENT '留言的商品ID',
  `users_id` int(11) DEFAULT '0' COMMENT '用户id',
  `md5data` varchar(50) DEFAULT '' COMMENT '数据序列化之后的MD5加密，提交内容的唯一性',
  `ip` varchar(255) DEFAULT '' COMMENT 'ip地址',
  `is_read` tinyint(1) DEFAULT '0' COMMENT '0=未读，1=已读',
  `is_star` tinyint(1) DEFAULT '0' COMMENT '标记星号',
  `source` tinyint(1) DEFAULT '0' COMMENT '提交来源：1=电脑端，2=手机端',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  `reply` varchar(1000) DEFAULT '' COMMENT '留言回复内容',
  `admin_id` int(11) DEFAULT '0' COMMENT '回复管理员ID',
  `reply_time` int(11) DEFAULT '0' COMMENT '回复时间',
  `examine` tinyint(1) DEFAULT '1' COMMENT '0-未审核 1-审核通过 2-审核不通过',
  `submit_url` varchar(255) DEFAULT '' COMMENT '提交留言时的页面URL',
  PRIMARY KEY (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='留言主表';


-- -----------------------------
-- Table structure for `zan_guestbook_attr`
-- -----------------------------
DROP TABLE IF EXISTS `zan_guestbook_attr`;
CREATE TABLE `zan_guestbook_attr` (
  `guest_attr_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '留言表单id自增',
  `aid` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '留言id',
  `form_type` tinyint(1) DEFAULT '0' COMMENT '数据分类：0=留言模型，1=自由表单',
  `attr_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '表单id',
  `attr_value` text COMMENT '表单值',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`guest_attr_id`),
  KEY `attr_id` (`attr_id`) USING BTREE,
  KEY `guest_id` (`aid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='留言表单属性值';


-- -----------------------------
-- Table structure for `zan_guestbook_attribute`
-- -----------------------------
DROP TABLE IF EXISTS `zan_guestbook_attribute`;
CREATE TABLE `zan_guestbook_attribute` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `attr_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '表单id',
  `attr_name` varchar(60) DEFAULT '' COMMENT '表单名称',
  `typeid` int(11) unsigned DEFAULT '0' COMMENT '栏目ID/表单ID',
  `form_type` tinyint(1) DEFAULT '0' COMMENT '数据分类：0=留言模型，1=自由表单',
  `attr_input_type` tinyint(1) unsigned DEFAULT '0' COMMENT ' 0=文本框，1=下拉框，2=多行文本框',
  `attr_values` text COMMENT '可选值列表',
  `is_showlist` tinyint(1) DEFAULT '0' COMMENT '在列表显示 0=隐藏，1=显示',
  `required` tinyint(1) DEFAULT '0' COMMENT '必填 0=否，1=是',
  `validate_type` smallint(5) DEFAULT '0' COMMENT '验证格式，0=不验证，1=手机，2=Email',
  `real_validate` tinyint(1) unsigned DEFAULT '0' COMMENT '是否进行真实验证，0=不验证，1=真实验证',
  `sort_order` int(11) unsigned DEFAULT '0' COMMENT '表单排序',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '是否已删除，0=否，1=是',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  `placeholder` varchar(60) DEFAULT '' COMMENT '框内提示语',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `attr_id` (`attr_id`,`lang`),
  KEY `guest_id` (`typeid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COMMENT='留言表单属性';

-- -----------------------------
-- Records of `zan_guestbook_attribute`
-- -----------------------------
INSERT INTO `zan_guestbook_attribute` VALUES ('2', '1', 'name', '1', '1', '0', '', '1', '1', '0', '0', '100', 'en', '0', '1690166772', '1730771543', 'Please enter your name');
INSERT INTO `zan_guestbook_attribute` VALUES ('8', '3', 'email', '1', '1', '7', '', '1', '1', '0', '0', '100', 'en', '0', '1690166772', '1730771543', 'Please enter your email address.');
INSERT INTO `zan_guestbook_attribute` VALUES ('11', '4', 'information', '1', '1', '2', '', '1', '0', '0', '0', '100', 'en', '0', '1690166772', '1730771543', 'Please enter your message');
INSERT INTO `zan_guestbook_attribute` VALUES ('14', '5', 'Your Name', '2', '1', '0', '', '1', '1', '0', '0', '100', 'en', '0', '1690166772', '1730771498', 'Please enter your name');
INSERT INTO `zan_guestbook_attribute` VALUES ('20', '7', 'Email', '2', '1', '7', '', '1', '1', '0', '0', '100', 'en', '0', '1690166772', '1730771498', 'Please enter your email');
INSERT INTO `zan_guestbook_attribute` VALUES ('23', '8', 'Message', '2', '1', '2', '', '1', '0', '0', '0', '100', 'en', '0', '1690166772', '1730771498', 'Please enter message');
INSERT INTO `zan_guestbook_attribute` VALUES ('26', '9', 'Email', '3', '1', '7', '', '1', '1', '0', '0', '100', 'en', '0', '1690166772', '1730771606', 'Please enter your email');

-- -----------------------------
-- Table structure for `zan_guestbook_goods`
-- -----------------------------
DROP TABLE IF EXISTS `zan_guestbook_goods`;
CREATE TABLE `zan_guestbook_goods` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '留言表(guestbook的aid)ID',
  `users_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID或临时记录ID',
  `goods_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '产品表(archives的aid)ID',
  `goods_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '数量',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否提交的真实数据(0:否，未提交，数据保留一天; 1:是，已提交记录的真实数据;)',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '多语言',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='留言询盘商品列表';

-- -----------------------------
-- Records of `zan_guestbook_goods`
-- -----------------------------
INSERT INTO `zan_guestbook_goods` VALUES ('2', '0', '902212867', '41', '3', '0', 'cn', '1740102619', '0');
INSERT INTO `zan_guestbook_goods` VALUES ('3', '0', '902212867', '35', '2', '0', 'cn', '1740102621', '0');
INSERT INTO `zan_guestbook_goods` VALUES ('4', '1', '902218346', '35', '1', '1', 'en', '1740103231', '1740103265');
INSERT INTO `zan_guestbook_goods` VALUES ('5', '1', '902218346', '34', '1', '1', 'en', '1740103233', '1740103265');

-- -----------------------------
-- Table structure for `zan_hooks`
-- -----------------------------
DROP TABLE IF EXISTS `zan_hooks`;
CREATE TABLE `zan_hooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '钩子名称',
  `description` text COMMENT '描述',
  `module` varchar(50) DEFAULT '' COMMENT '钩子挂载的插件',
  `status` tinyint(1) unsigned DEFAULT '1' COMMENT '状态：0=无效，1=有效',
  `add_time` int(10) DEFAULT NULL,
  `update_time` int(10) unsigned DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `name` (`name`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='插件钩子表';


-- -----------------------------
-- Table structure for `zan_images_content`
-- -----------------------------
DROP TABLE IF EXISTS `zan_images_content`;
CREATE TABLE `zan_images_content` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='文档主表 -- (图集)内容数据表';

-- -----------------------------
-- Records of `zan_images_content`
-- -----------------------------
INSERT INTO `zan_images_content` VALUES ('1', '66', '', '', '', '', '', '', '1740108090', '1740108090');
INSERT INTO `zan_images_content` VALUES ('2', '67', '', '', '', '', '', '', '1740108165', '1740108165');

-- -----------------------------
-- Table structure for `zan_images_content_cn`
-- -----------------------------
DROP TABLE IF EXISTS `zan_images_content_cn`;
CREATE TABLE `zan_images_content_cn` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='文档主表 -- (图集)内容数据表';


-- -----------------------------
-- Table structure for `zan_images_content_en`
-- -----------------------------
DROP TABLE IF EXISTS `zan_images_content_en`;
CREATE TABLE `zan_images_content_en` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='文档主表 -- (图集)内容数据表';

-- -----------------------------
-- Records of `zan_images_content_en`
-- -----------------------------
INSERT INTO `zan_images_content_en` VALUES ('1', '66', '', '', '', '', '', '', '1740108090', '1740108231');
INSERT INTO `zan_images_content_en` VALUES ('2', '67', '', '', '', '', '', '', '1740108165', '1740108199');

-- -----------------------------
-- Table structure for `zan_images_content_zh`
-- -----------------------------
DROP TABLE IF EXISTS `zan_images_content_zh`;
CREATE TABLE `zan_images_content_zh` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='文档主表 -- (图集)内容数据表';


-- -----------------------------
-- Table structure for `zan_images_upload`
-- -----------------------------
DROP TABLE IF EXISTS `zan_images_upload`;
CREATE TABLE `zan_images_upload` (
  `img_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '产品图片自增ID',
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `title` varchar(255) DEFAULT '' COMMENT '图片标题',
  `image_url` varchar(255) DEFAULT '' COMMENT '图片存储路径',
  `intro` varchar(255) DEFAULT '' COMMENT '图片描述',
  `width` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '图片宽度',
  `height` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '图片高度',
  `filesize` varchar(255) DEFAULT '' COMMENT '文件大小',
  `mime` varchar(50) DEFAULT '' COMMENT '图片类型',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`img_id`),
  KEY `arcid` (`aid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='图集图片表';

-- -----------------------------
-- Records of `zan_images_upload`
-- -----------------------------
INSERT INTO `zan_images_upload` VALUES ('24', '66', 'Cross-seasonal wear: skillfully use stacking to make your women\'s clothing evergreen', '/uploads/allimg/20250221/1-25022111211R38.jpg', '', '277', '335', '17327', 'image/jpeg', '4', '1740108231', '1740108231');
INSERT INTO `zan_images_upload` VALUES ('22', '66', 'Cross-seasonal wear: skillfully use stacking to make your women\'s clothing evergreen', '/uploads/allimg/20250221/1-25022111211UF.jpg', '', '277', '335', '15898', 'image/jpeg', '2', '1740108231', '1740108231');
INSERT INTO `zan_images_upload` VALUES ('23', '66', 'Cross-seasonal wear: skillfully use stacking to make your women\'s clothing evergreen', '/uploads/allimg/20250221/1-25022111211UB.jpg', '', '277', '335', '13367', 'image/jpeg', '3', '1740108231', '1740108231');
INSERT INTO `zan_images_upload` VALUES ('21', '66', 'Cross-seasonal wear: skillfully use stacking to make your women\'s clothing evergreen', '/uploads/allimg/20250221/1-25022111211M01.jpg', '', '277', '335', '29543', 'image/jpeg', '1', '1740108231', '1740108231');
INSERT INTO `zan_images_upload` VALUES ('20', '67', 'The new favorite in the workplace: simple women\'s clothing helps you win business negotiations efficiently', '/uploads/allimg/20250221/1-25022111211M01.jpg', '', '277', '335', '29543', 'image/jpeg', '4', '1740108199', '1740108199');
INSERT INTO `zan_images_upload` VALUES ('18', '67', 'The new favorite in the workplace: simple women\'s clothing helps you win business negotiations efficiently', '/uploads/allimg/20250221/1-25022111211UB.jpg', '', '277', '335', '13367', 'image/jpeg', '2', '1740108199', '1740108199');
INSERT INTO `zan_images_upload` VALUES ('19', '67', 'The new favorite in the workplace: simple women\'s clothing helps you win business negotiations efficiently', '/uploads/allimg/20250221/1-25022111211UF.jpg', '', '277', '335', '15898', 'image/jpeg', '3', '1740108199', '1740108199');
INSERT INTO `zan_images_upload` VALUES ('17', '67', 'The new favorite in the workplace: simple women\'s clothing helps you win business negotiations efficiently', '/uploads/allimg/20250221/1-25022111211R38.jpg', '', '277', '335', '17327', 'image/jpeg', '1', '1740108199', '1740108199');

-- -----------------------------
-- Table structure for `zan_language`
-- -----------------------------
DROP TABLE IF EXISTS `zan_language`;
CREATE TABLE `zan_language` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '信息ID，自增',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '语言名称',
  `mark` varchar(50) NOT NULL DEFAULT '' COMMENT '语言标识（唯一）',
  `domain` varchar(50) DEFAULT '' COMMENT '二级域名',
  `url` varchar(200) DEFAULT '' COMMENT '二级域名',
  `is_open` tinyint(1) DEFAULT '0' COMMENT '二级域名开启状态，0=否，1=是',
  `target` tinyint(1) NOT NULL DEFAULT '0' COMMENT '新窗口打开，0=否，1=是',
  `is_home_default` tinyint(1) DEFAULT '0' COMMENT '默认前台语言，1=是，0=否',
  `is_admin_default` tinyint(1) DEFAULT '0' COMMENT '默认后台语言，1=是，0=否',
  `translate_mode` tinyint(1) DEFAULT '0' COMMENT '翻译方式，0=翻译，1=直译',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '语言状态，0=关闭，1=开启',
  `sort_order` int(10) DEFAULT '0' COMMENT '排序号',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='多语言主表';

-- -----------------------------
-- Records of `zan_language`
-- -----------------------------
INSERT INTO `zan_language` VALUES ('3', 'English', 'en', 'en', '', '0', '0', '1', '1', '0', '1', '12', '1725071375', '1740104476');

-- -----------------------------
-- Table structure for `zan_language_mark`
-- -----------------------------
DROP TABLE IF EXISTS `zan_language_mark`;
CREATE TABLE `zan_language_mark` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '国家语言名称',
  `cn_title` varchar(50) NOT NULL DEFAULT '' COMMENT '中文名称',
  `mark` varchar(50) NOT NULL DEFAULT '' COMMENT '多语言标识',
  `pinyin` varchar(100) NOT NULL DEFAULT '' COMMENT '拼音',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '语言状态，0=关闭，1=开启',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '排序号',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COMMENT='国家语言表';

-- -----------------------------
-- Records of `zan_language_mark`
-- -----------------------------
INSERT INTO `zan_language_mark` VALUES ('1', '简体中文', '简体中文', 'cn', 'zhongwenjianti', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('2', 'Vietnamese', '越南语', 'vi', 'yuenanyu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('3', '繁体中文', '繁体中文', 'zh', 'zhongwenfanti', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('4', 'English', '英语', 'en', 'yingyu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('5', 'Indonesian', '印尼语', 'id', 'yinniyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('6', 'Urdu', '乌尔都语', 'ur', 'wuerduyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('7', 'Yiddish', '意第绪语', 'yi', 'yidixuyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('8', 'Italian', '意大利语', 'it', 'yidaliyu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('9', 'Greek', '希腊语', 'el', 'xilayu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('10', 'Spanish Basque', '西班牙的巴斯克语', 'eu', 'xibanyadebasikeyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('11', 'Spanish', '西班牙语', 'es', 'xibanyayu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('12', 'Hungarian', '匈牙利语', 'hu', 'xiongyaliyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('13', 'Hebrew', '希伯来语', 'iw', 'xibolaiyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('14', 'Ukrainian', '乌克兰语', 'uk', 'wukelanyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('15', 'Welsh', '威尔士语', 'cy', 'weiershiyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('16', 'Thai', '泰语', 'th', 'taiyu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('17', 'Turkish', '土耳其语', 'tr', 'tuerqiyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('18', 'Swahili', '斯瓦希里语', 'sw', 'siwaxiliyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('19', 'Japanese', '日语', 'ja', 'riyu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('20', 'Swedish', '瑞典语', 'sv', 'ruidianyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('21', 'Serbian', '塞尔维亚语', 'sr', 'saierweiyayu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('22', 'Slovak', '斯洛伐克语', 'sk', 'siluofakeyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('23', 'Slovenian', '斯洛文尼亚语', 'sl', 'siluowenniyayu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('24', 'Portuguese', '葡萄牙语', 'pt', 'putaoyayu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('25', 'Norwegian', '挪威语', 'no', 'nuoweiyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('26', 'Macedonian', '马其顿语', 'mk', 'maqidunyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('27', 'Malay', '马来语', 'ms', 'malaiyu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('28', 'Maltese', '马耳他语', 'mt', 'maertayu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('29', 'Romanian', '罗马尼亚语', 'ro', 'luomaniyayu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('30', 'Lithuanian', '立陶宛语', 'lt', 'litaowanyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('31', 'Latvian', '拉脱维亚语', 'lv', 'latuoweiyayu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('32', 'Latin', '拉丁语', 'la', 'ladingyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('33', 'Croatian', '克罗地亚语', 'hr', 'keluodiyayu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('34', 'Czech', '捷克语', 'cs', 'jiekeyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('35', 'Catalan', '加泰罗尼亚语', 'ca', 'jiatailuoniyayu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('36', 'Galician', '加利西亚语', 'gl', 'jialixiyayu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('37', 'Dutch', '荷兰语', 'nl', 'helanyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('38', 'Korean', '韩语', 'ko', 'hanyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('39', 'Haitian Creole', '海地克里奥尔语', 'ht', 'haidikeliaoeryu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('40', 'Finnish', '芬兰语', 'fi', 'fenlanyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('41', 'Filipino', '菲律宾语', 'tl', 'feilvbinyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('42', 'Russian', '俄语', 'ru', 'eyu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('43', 'Boolean (Afrikaans)', '布尔语(南非荷兰语)', 'af', 'bueryunanfeihelanyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('44', 'French', '法语', 'fr', 'fayu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('45', 'Danish', '丹麦语', 'da', 'danmaiyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('46', 'German', '德语', 'de', 'deyu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('47', 'Azerbaijani', '阿塞拜疆语', 'az', 'asaibaijiangyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('48', 'Irish', '爱尔兰语', 'ga', 'aierlanyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('49', 'Estonian', '爱沙尼亚语', 'et', 'aishaniyayu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('50', 'Belarusian', '白俄罗斯语', 'be', 'baieluosiyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('51', 'Bulgarian', '保加利亚语', 'bg', 'baojialiyayu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('52', 'Icelandic', '冰岛语', 'is', 'bingdaoyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('53', 'Polish', '波兰语', 'pl', 'bolanyu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('54', 'Persian', '波斯语', 'fa', 'bosiyu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('55', 'Arabic', '阿拉伯语', 'ar', 'alaboyu', '1', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('56', 'Albanian', '阿尔巴尼亚语', 'sq', 'aerbaniyayu', '0', '100', '0', '1541583096');
INSERT INTO `zan_language_mark` VALUES ('57', 'Uyghur', '维吾尔族语', 'ug', 'weiwuerzuyu', '0', '100', '0', '1541583096');

-- -----------------------------
-- Table structure for `zan_language_pack`
-- -----------------------------
DROP TABLE IF EXISTS `zan_language_pack`;
CREATE TABLE `zan_language_pack` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pack_id` int(11) unsigned DEFAULT '0' COMMENT '变量ID',
  `type` int(5) DEFAULT '1' COMMENT '分类：1=公共，2=搜索，3=询盘，4=面包屑',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '变量名',
  `value` text NOT NULL COMMENT '变量值',
  `is_system` tinyint(1) DEFAULT '1' COMMENT '是否内置',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `sort_order` int(10) DEFAULT '0' COMMENT '排序号',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  KEY `pack_⁯id` (`pack_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1168 DEFAULT CHARSET=utf8 COMMENT='模板语言包变量';

-- -----------------------------
-- Records of `zan_language_pack`
-- -----------------------------
INSERT INTO `zan_language_pack` VALUES ('1', '1', '1', 'sys1', '首页', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('2', '2', '1', 'sys2', '上一页', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('3', '3', '1', 'sys3', '下一页', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('4', '4', '1', 'sys4', '末页', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('5', '5', '1', 'sys5', '共<strong>%s</strong>页 <strong>%s</strong>条', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('6', '51', '2', 'sys51', '全部', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('7', '7', '2', 'sys7', '搜索', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('8', '8', '1', 'sys8', '查看详情', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('9', '9', '1', 'sys9', '网站首页', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('10', '10', '1', 'sys10', '没有了', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('11', '11', '1', 'sys11', '上一篇', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('12', '12', '1', 'sys12', '下一篇', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('13', '39', '3', 'gbook39', 'Page automatically %s Jump to %s Waiting time:', '1', 'en', '100', '1729130893', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('14', '39', '3', 'gbook39', '頁面自動 %s跳轉%s 等待時間：', '1', 'zh', '100', '1729130893', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('15', '40', '3', 'gbook40', '%s至少选择一项！', '1', 'cn', '100', '1729130972', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('16', '40', '3', 'gbook40', '%s Choose at least one!', '1', 'en', '100', '1729130972', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('17', '41', '3', 'gbook41', '請選擇%s', '1', 'zh', '100', '1729131276', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('18', '40', '3', 'gbook40', '%s至少選擇一項！', '1', 'zh', '100', '1729130972', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('19', '41', '3', 'gbook41', '请选择%s', '1', 'cn', '100', '1729131276', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('20', '41', '3', 'gbook41', 'Please select %s.', '1', 'en', '100', '1729131276', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('21', '35', '3', 'gbook35', '%s格式不正確！', '1', 'zh', '100', '1729130372', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('22', '36', '3', 'gbook36', '图片验证码不能为空！', '1', 'cn', '100', '1729130828', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('23', '36', '3', 'gbook36', 'The image verification code cannot be empty!', '1', 'en', '100', '1729130828', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('24', '36', '3', 'gbook36', '圖片驗證碼不能爲空！', '1', 'zh', '100', '1729130828', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('25', '37', '3', 'gbook37', '图片验证码不正确！', '1', 'cn', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('26', '37', '3', 'gbook37', 'The picture verification code is incorrect!', '1', 'en', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('27', '37', '3', 'gbook37', '圖片驗證碼不正確！', '1', 'zh', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('28', '39', '3', 'gbook39', '页面自动 %s跳转%s 等待时间：', '1', 'cn', '100', '1729130893', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('29', '1', '1', 'sys1', 'Home', '1', 'en', '100', '1725071376', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('30', '2', '1', 'sys2', 'previous page', '1', 'en', '100', '1725071376', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('31', '3', '1', 'sys3', 'Next page', '1', 'en', '100', '1725071376', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('32', '4', '1', 'sys4', 'last page', '1', 'en', '100', '1725071376', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('33', '5', '1', 'sys5', 'A total of <strong>%s</strong> pages <strong>%s</strong>', '1', 'en', '100', '1725071376', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('34', '51', '2', 'sys51', 'all', '1', 'en', '100', '1725071376', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('35', '7', '2', 'sys7', 'Search', '1', 'en', '100', '1725071376', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('36', '8', '1', 'sys8', 'View details', '1', 'en', '100', '1725071376', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('37', '9', '1', 'sys9', 'Home', '1', 'en', '100', '1725071376', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('38', '10', '1', 'sys10', 'No.', '1', 'en', '100', '1725071376', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('39', '11', '1', 'sys11', 'Previous', '1', 'en', '100', '1725071376', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('40', '12', '1', 'sys12', 'Next', '1', 'en', '100', '1725071376', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('41', '35', '3', 'gbook35', '%s The format is incorrect!', '1', 'en', '100', '1729130372', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('42', '35', '3', 'gbook35', '%s格式不正确！', '1', 'cn', '100', '1729130372', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('43', '34', '3', 'gbook34', '%s不能爲空！', '1', 'zh', '100', '1729130334', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('44', '34', '3', 'gbook34', '%s cannot be empty!', '1', 'en', '100', '1729130334', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('45', '12', '1', 'sys12', '下一篇', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('46', '34', '3', 'gbook34', '%s不能为空！', '1', 'cn', '100', '1729130334', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('47', '11', '1', 'sys11', '上一篇', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('48', '10', '1', 'sys10', '沒有了', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('49', '9', '1', 'sys9', '網站首頁', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('50', '8', '1', 'sys8', '查看詳情', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('51', '7', '2', 'sys7', '搜索', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('52', '51', '2', 'sys51', '全部', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('53', '5', '1', 'sys5', '共<strong>%s</strong>頁 <strong>%s</strong>條', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('54', '4', '1', 'sys4', '末頁', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('55', '3', '1', 'sys3', '下一頁', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('56', '2', '1', 'sys2', '上一頁', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('57', '1', '1', 'sys1', '首頁', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('58', '22', '1', 'sys22', '提示', '1', 'zh', '100', '1729132134', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('59', '22', '1', 'sys22', 'hint', '1', 'en', '100', '1729132134', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('60', '22', '1', 'sys22', '提示', '1', 'cn', '100', '1729132134', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('61', '21', '1', 'sys21', '取消', '1', 'zh', '100', '1729132111', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('62', '21', '1', 'sys21', 'cancel', '1', 'en', '100', '1729132111', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('63', '21', '1', 'sys21', '取消', '1', 'cn', '100', '1729132111', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('64', '20', '1', 'sys20', '確定', '1', 'zh', '100', '1729132065', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('65', '20', '1', 'sys20', 'OK', '1', 'en', '100', '1729132065', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('66', '20', '1', 'sys20', '确定', '1', 'cn', '100', '1729132065', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('67', '45', '3', 'gbook45', '看不清？%s點擊更換%s', '1', 'zh', '100', '1729131676', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('68', '45', '3', 'gbook45', 'Can\'t see clearly? %s Click to replace %s', '1', 'en', '100', '1729131676', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('69', '45', '3', 'gbook45', '看不清？%s点击更换%s', '1', 'cn', '100', '1729131676', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('70', '44', '3', 'gbook44', '看不清？點擊更換驗證碼', '1', 'zh', '100', '1729131654', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('71', '44', '3', 'gbook44', 'Can\'t see clearly? Click to change the verification code.', '1', 'en', '100', '1729131654', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('72', '44', '3', 'gbook44', '看不清？点击更换验证码', '1', 'cn', '100', '1729131654', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('73', '43', '3', 'gbook43', 'Get verification code', '1', 'en', '100', '1729131602', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('74', '43', '3', 'gbook43', '獲取驗證碼', '1', 'zh', '100', '1729131602', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('75', '43', '3', 'gbook43', '获取验证码', '1', 'cn', '100', '1729131602', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('76', '42', '3', 'gbook42', 'image verification code', '1', 'en', '100', '1729131416', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('77', '42', '3', 'gbook42', '图片验证码', '1', 'cn', '100', '1729131416', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('78', '42', '3', 'gbook42', '圖片驗證碼', '1', 'zh', '100', '1729131416', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('79', '32', '3', 'gbook32', '操作成功', '1', 'cn', '100', '1729130224', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('80', '32', '3', 'gbook32', 'Operation successful', '1', 'en', '100', '1729130224', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('81', '32', '3', 'gbook32', '操作成功', '1', 'zh', '100', '1729130224', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('82', '33', '3', 'gbook33', '同一个IP在%s秒之内不能重复提交！', '1', 'cn', '100', '1729130303', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('83', '33', '3', 'gbook33', 'The same IP cannot be submitted repeatedly within %s seconds!', '1', 'en', '100', '1729130303', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('84', '33', '3', 'gbook33', '同一個IP在%s秒之內不能重複提交！', '1', 'zh', '100', '1729130303', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('85', '27', '1', 'sys27', '请勿刷新页面', '1', 'cn', '100', '1729155836', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('86', '28', '1', 'sys28', '我接受', '1', 'cn', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('87', '26', '1', 'sys26', '正在處理', '1', 'zh', '100', '1729155810', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('88', '26', '1', 'sys26', 'Processing', '1', 'en', '100', '1729155810', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('89', '26', '1', 'sys26', '正在处理', '1', 'cn', '100', '1729155810', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('90', '25', '1', 'sys25', '請至少選擇一項！', '1', 'zh', '100', '1729155788', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('91', '15', '2', 'sys15', '关键词不能为空！', '1', 'cn', '100', '1729133998', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('92', '15', '2', 'sys15', 'Keywords cannot be empty!', '1', 'en', '100', '1729133998', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('93', '15', '2', 'sys15', '關鍵詞不能爲空！', '1', 'zh', '100', '1729133998', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('94', '25', '1', 'sys25', 'Please choose at least one item!', '1', 'en', '100', '1729155788', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('95', '25', '1', 'sys25', '请至少选择一项！', '1', 'cn', '100', '1729155788', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('96', '24', '1', 'sys24', '否', '1', 'zh', '100', '1729155746', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('97', '24', '1', 'sys24', 'No', '1', 'en', '100', '1729155746', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('98', '24', '1', 'sys24', '否', '1', 'cn', '100', '1729155746', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('99', '46', '3', 'gbook46', 'Abnormal (%s)', '1', 'en', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('100', '23', '1', 'sys23', '是', '1', 'zh', '100', '1729155667', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('101', '23', '1', 'sys23', 'Yes', '1', 'en', '100', '1729155667', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('102', '23', '1', 'sys23', '是', '1', 'cn', '100', '1729155667', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('103', '46', '3', 'gbook46', '異常（%s）', '1', 'zh', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('104', '46', '3', 'gbook46', '异常（%s）', '1', 'cn', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('105', '16', '1', 'sys16', '圖', '1', 'zh', '100', '1729155469', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('106', '16', '1', 'sys16', 'figure', '1', 'en', '100', '1729155469', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('107', '16', '1', 'sys16', '图', '1', 'cn', '100', '1729155469', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('108', '38', '3', 'gbook38', '表單缺少標籤屬性', '1', 'zh', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('109', '38', '3', 'gbook38', 'The form is missing a label attribute', '1', 'en', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('110', '38', '3', 'gbook38', '表单缺少标签属性', '1', 'cn', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('111', '27', '1', 'sys27', '請勿刷新頁面', '1', 'zh', '100', '1729155836', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('112', '27', '1', 'sys27', 'Do not refresh', '1', 'en', '100', '1729155836', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('113', '17', '1', 'sys17', '上传成功', '1', 'cn', '100', '1729155862', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('114', '17', '1', 'sys17', 'Upload successful', '1', 'en', '100', '1729155862', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('115', '17', '1', 'sys17', '上傳成功', '1', 'zh', '100', '1729155862', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('116', '18', '1', 'sys18', '操作失败', '1', 'cn', '100', '1729155886', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('117', '18', '1', 'sys18', 'Operation failed', '1', 'en', '100', '1729155886', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('118', '18', '1', 'sys18', '操作失敗', '1', 'zh', '100', '1729155886', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('119', '19', '1', 'sys19', '操作成功', '1', 'cn', '100', '1729155907', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('120', '19', '1', 'sys19', 'Operation successful', '1', 'en', '100', '1729155907', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('121', '19', '1', 'sys19', '操作成功', '1', 'zh', '100', '1729155907', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('122', '13', '2', 'sys13', '含有敏感词（%s），禁止搜索！', '1', 'cn', '100', '1729155959', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('123', '13', '2', 'sys13', 'Contains sensitive words (%s), search is prohibited!', '1', 'en', '100', '1729155959', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('124', '13', '2', 'sys13', '含有敏感詞（%s），禁止搜索！', '1', 'zh', '100', '1729155959', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('125', '14', '2', 'sys14', '过度频繁搜索，离解禁还有%s分钟！', '1', 'cn', '100', '1729155994', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('126', '14', '2', 'sys14', 'Excessive frequent searches, there are still %s minutes before the ban is lifted!', '1', 'en', '100', '1729155994', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('127', '14', '2', 'sys14', '過度頻繁搜索，離解禁還有%s分鐘！', '1', 'zh', '100', '1729155994', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('128', '28', '1', 'sys28', '我接受', '1', 'zh', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('129', '28', '1', 'sys28', 'I accept.', '1', 'en', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('130', '29', '1', 'sys29', '关闭', '1', 'cn', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('131', '29', '1', 'sys29', 'close', '1', 'en', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('132', '29', '1', 'sys29', '關閉', '1', 'zh', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('133', '49', '4', 'crumb49', '全部新聞', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('134', '47', '4', 'crumb47', '首頁', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('135', '48', '4', 'crumb48', '全部產品', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('136', '52', '1', 'sys52', '暂无数据', '1', 'cn', '100', '1730182577', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('137', '6', '1', 'sys6', '第%s页', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('138', '31', '1', 'sys31', '更新時間', '1', 'zh', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('139', '31', '1', 'sys31', 'update time', '1', 'en', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('140', '31', '1', 'sys31', '更新时间', '1', 'cn', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('141', '47', '4', 'crumb47', '首页', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('142', '47', '4', 'crumb47', 'Home', '1', 'en', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('143', '49', '4', 'crumb49', '全部新闻', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('144', '49', '4', 'crumb49', 'All news', '1', 'en', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('145', '48', '4', 'crumb48', 'All products', '1', 'en', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('146', '48', '4', 'crumb48', '全部产品', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('147', '50', '4', 'crumb50', '>', '1', 'cn', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('148', '50', '4', 'crumb50', '>', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('149', '50', '4', 'crumb50', '>', '1', 'en', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('150', '30', '1', 'sys30', '瀏覽量', '1', 'zh', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('151', '30', '1', 'sys30', 'page views', '1', 'en', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('152', '30', '1', 'sys30', '浏览量', '1', 'cn', '100', '1729130859', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('153', '52', '1', 'sys52', '暫無數據', '1', 'zh', '100', '1730182577', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('154', '52', '1', 'sys52', 'No data yet', '1', 'en', '100', '1730182577', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('155', '6', '1', 'sys6', 'Page %s', '1', 'en', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('156', '6', '1', 'sys6', '第%s頁', '1', 'zh', '100', '1543890216', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('157', '53', '4', 'crumb53', '热门产品', '1', 'cn', '100', '1730939211', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('158', '53', '4', 'crumb53', '熱門產品', '1', 'zh', '100', '1730939211', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('159', '53', '4', 'crumb53', 'Hot Products', '1', 'en', '100', '1730939211', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('160', '54', '4', 'crumb54', '相关新闻', '1', 'cn', '100', '1730939292', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('161', '54', '4', 'crumb54', '相關新聞', '1', 'zh', '100', '1730939292', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('162', '54', '4', 'crumb54', 'Related News', '1', 'en', '100', '1730939292', '1730947684');
INSERT INTO `zan_language_pack` VALUES ('163', '55', '4', 'crumb55', '产品详情', '1', 'cn', '100', '1732245160', '1732245160');
INSERT INTO `zan_language_pack` VALUES ('164', '56', '3', 'gbook56', '提交', '1', 'cn', '100', '1732245160', '1732245160');
INSERT INTO `zan_language_pack` VALUES ('165', '57', '4', 'crumb57', '全部案例', '1', 'cn', '100', '1732245160', '1732245160');
INSERT INTO `zan_language_pack` VALUES ('166', '55', '4', 'crumb55', 'Product Details', '1', 'en', '100', '1732245160', '1732245160');
INSERT INTO `zan_language_pack` VALUES ('167', '56', '3', 'gbook56', 'Submit', '1', 'en', '100', '1732245160', '1732245160');
INSERT INTO `zan_language_pack` VALUES ('168', '57', '4', 'crumb57', 'All cases', '1', 'en', '100', '1732245160', '1732245160');
INSERT INTO `zan_language_pack` VALUES ('169', '55', '4', 'crumb55', '產品詳情', '1', 'zh', '100', '1732245160', '1732245160');
INSERT INTO `zan_language_pack` VALUES ('170', '56', '3', 'gbook56', '提交', '1', 'zh', '100', '1732245160', '1732245160');
INSERT INTO `zan_language_pack` VALUES ('171', '57', '4', 'crumb57', '全部案例', '1', 'zh', '100', '1732245160', '1732245160');
INSERT INTO `zan_language_pack` VALUES ('172', '313', '1', 'sys313', '数量', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('173', '314', '1', 'sys314', '立即购买', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('174', '315', '1', 'sys315', '加入购物车', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('175', '316', '1', 'sys316', '库存', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('176', '317', '1', 'sys317', '销量', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('177', '318', '1', 'sys318', '总销量', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('178', '319', '1', 'sys319', '评分', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('179', '320', '1', 'sys320', '非常不满', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('180', '321', '1', 'sys321', '不满意', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('181', '322', '1', 'sys322', '一般', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('182', '323', '1', 'sys323', '满意', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('183', '324', '1', 'sys324', '非常满意', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('184', '325', '1', 'sys325', '评论数', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('185', '342', '1', 'sys342', '哎呀！找不到页面了！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('186', '343', '1', 'sys343', '不要伤心，可能是网址错了呢，重新核对一下吧。', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('187', '344', '1', 'sys344', '回到上一页', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('188', '345', '1', 'sys345', '回到首页', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('189', '313', '1', 'sys313', 'Quantity', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('190', '314', '1', 'sys314', 'Buy Now', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('191', '315', '1', 'sys315', 'Add To Cart', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('192', '316', '1', 'sys316', 'Stock', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('193', '317', '1', 'sys317', 'Sales Volume', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('194', '318', '1', 'sys318', 'Total Sales', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('195', '319', '1', 'sys319', 'Score', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('196', '320', '1', 'sys320', 'Bad', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('197', '321', '1', 'sys321', 'Dissatisfied', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('198', '322', '1', 'sys322', 'General', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('199', '323', '1', 'sys323', 'Satisfied', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('200', '324', '1', 'sys324', 'Good', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('201', '325', '1', 'sys325', 'Quantity', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('202', '342', '1', 'sys342', 'Can\'t find the page!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('203', '343', '1', 'sys343', 'Don\'t be sad, maybe the website address is wrong, please double check it.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('204', '344', '1', 'sys344', 'Return to the previous page', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('205', '345', '1', 'sys345', 'Return to the homepage', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('206', '313', '1', 'sys313', '數量', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('207', '314', '1', 'sys314', '立即購買', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('208', '315', '1', 'sys315', '加入購物車', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('209', '316', '1', 'sys316', '庫存', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('210', '317', '1', 'sys317', '銷量', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('211', '318', '1', 'sys318', '總銷量', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('212', '319', '1', 'sys319', '評分', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('213', '320', '1', 'sys320', '非常不满', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('214', '321', '1', 'sys321', '不滿意', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('215', '322', '1', 'sys322', '一般', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('216', '323', '1', 'sys323', '满意', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('217', '324', '1', 'sys324', '非常滿意', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('218', '325', '1', 'sys325', '評論數', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('219', '342', '1', 'sys342', '哎呀！找不到頁面了！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('220', '343', '1', 'sys343', '不要傷心，可能是網址錯了呢，重新核對一下吧。', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('221', '344', '1', 'sys344', '回到上一頁', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('222', '345', '1', 'sys345', '回到首頁', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('223', '58', '5', 'users58', '您的购物车还没有商品！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('224', '59', '5', 'users59', '%s不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('225', '60', '5', 'users60', '%s格式不正确！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('226', '61', '5', 'users61', '邮箱验证码已被使用或超时，请重新发送！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('227', '62', '5', 'users62', '邮箱验证码不正确，请重新输入！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('228', '63', '5', 'users63', '短信验证码不正确，请重新输入！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('229', '64', '5', 'users64', '%s已存在！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('230', '65', '5', 'users65', '签到成功', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('231', '66', '5', 'users66', '今日已签过到', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('232', '67', '5', 'users67', '是否删除该收藏？', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('233', '68', '5', 'users68', '确认批量删除收藏？', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('234', '69', '5', 'users69', '每日签到', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('235', '70', '5', 'users70', '充值金额不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('236', '71', '5', 'users71', '请输入正确的充值金额！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('237', '72', '5', 'users72', '请选择支付方式！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('238', '73', '5', 'users73', '用户名不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('239', '74', '5', 'users74', '用户名不正确！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('240', '75', '5', 'users75', '密码不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('241', '76', '5', 'users76', '图片验证码不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('242', '77', '5', 'users77', '图片验证码错误', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('243', '78', '5', 'users78', '前台禁止管理员登录！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('244', '79', '5', 'users79', '该会员尚未激活，请联系管理员！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('245', '80', '5', 'users80', '管理员审核中，请稍等！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('246', '81', '5', 'users81', '登录成功', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('247', '82', '5', 'users82', '密码不正确！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('248', '83', '5', 'users83', '该用户名不存在，请注册！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('249', '84', '5', 'users84', '看不清？点击更换验证码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('250', '85', '5', 'users85', '手机号码不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('251', '86', '5', 'users86', '手机号码格式不正确！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('252', '87', '5', 'users87', '手机验证码不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('253', '88', '5', 'users88', '手机验证码已失效！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('254', '89', '5', 'users89', '手机号码已经注册！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('255', '90', '5', 'users90', '用户名为系统禁止注册！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('256', '91', '5', 'users91', '请输入2-30位的汉字、英文、数字、下划线等组合', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('257', '92', '5', 'users92', '登录密码不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('258', '93', '5', 'users93', '重复密码不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('259', '94', '5', 'users94', '用户名已存在', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('260', '95', '5', 'users95', '两次密码输入不一致！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('261', '96', '5', 'users96', '注册成功，正在跳转中……', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('262', '97', '5', 'users97', '注册成功，等管理员激活才能登录！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('263', '98', '5', 'users98', '注册成功，请登录！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('264', '99', '5', 'users99', '昵称不可为纯空格', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('265', '100', '5', 'users100', '原密码不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('266', '101', '5', 'users101', '新密码不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('267', '102', '5', 'users102', '手机号码不存在，不能找回密码！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('268', '103', '5', 'users103', '手机号码未绑定，不能找回密码！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('269', '104', '5', 'users104', '手机验证码已被使用或超时，请重新发送！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('270', '105', '5', 'users105', '晚上好～', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('271', '106', '5', 'users106', '早上好～', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('272', '107', '5', 'users107', '下午好～', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('273', '108', '5', 'users108', '用户名', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('274', '109', '5', 'users109', '邮箱地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('275', '110', '5', 'users110', '密码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('276', '111', '5', 'users111', '确认密码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('277', '112', '5', 'users112', '邮箱验证码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('278', '113', '5', 'users113', '点击发送', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('279', '114', '5', 'users114', '邮箱地址不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('280', '115', '5', 'users115', '该会员尚未激活，不能找回密码！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('281', '116', '5', 'users116', '邮箱地址未绑定，不能找回密码！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('282', '117', '5', 'users117', '邮箱地址不存在！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('283', '118', '5', 'users118', '邮箱已绑定，无需重新绑定！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('284', '119', '5', 'users119', '邮箱已经存在，不可以绑定！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('285', '120', '5', 'users120', '必填', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('286', '121', '5', 'users121', '请正确输入邮箱地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('287', '122', '5', 'users122', '发送中…', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('288', '123', '5', 'users123', '图片验证码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('289', '124', '5', 'users124', '登录', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('290', '125', '5', 'users125', '邮箱验证码不能为空', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('291', '126', '5', 'users126', '邮箱不存在，不能找回密码！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('292', '127', '5', 'users127', '会员邮箱属性已关闭，请联系网站管理员！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('293', '128', '5', 'users128', '请传入必填项字段', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('294', '129', '5', 'users129', '请传入验证token名称', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('295', '130', '5', 'users130', '请传入提交验证的数组', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('296', '131', '5', 'users131', '数据不存在！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('297', '132', '5', 'users132', '令牌数据无效', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('298', '133', '5', 'users133', '表单校验失败，请检查站点权限问题', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('299', '134', '5', 'users134', '发送失败', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('300', '135', '5', 'users135', '发送成功', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('301', '136', '5', 'users136', '新密码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('302', '137', '5', 'users137', '确认新密码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('303', '138', '5', 'users138', '确认密码不能为空！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('304', '139', '5', 'users139', '新客户？', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('305', '140', '5', 'users140', '从这里开始', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('306', '141', '5', 'users141', '忘记密码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('307', '142', '5', 'users142', '账号登录', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('308', '143', '5', 'users143', '创建账号', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('309', '144', '5', 'users144', '已有账号!', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('310', '145', '5', 'users145', '找回密码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('311', '146', '5', 'users146', '下一步', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('312', '147', '5', 'users147', '返回登录', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('313', '148', '5', 'users148', '重置密码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('314', '149', '5', 'users149', '确认提交', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('315', '150', '5', 'users150', '个人中心', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('316', '151', '5', 'users151', '我的信息', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('317', '152', '5', 'users152', '我的收藏', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('318', '153', '5', 'users153', '收货地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('319', '154', '5', 'users154', '我的订单', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('320', '155', '5', 'users155', '会员中心', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('321', '156', '5', 'users156', '安全退出', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('322', '157', '5', 'users157', '您可以去看看有哪些想买的', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('323', '158', '5', 'users158', '去逛逛', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('324', '159', '5', 'users159', '购物车', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('325', '160', '5', 'users160', '结账', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('326', '161', '5', 'users161', '付款', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('327', '162', '5', 'users162', '待支付', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('328', '163', '5', 'users163', '未付款', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('329', '164', '5', 'users164', '已付款', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('330', '165', '5', 'users165', '商品', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('331', '166', '5', 'users166', '全选', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('332', '167', '5', 'users167', '数量', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('333', '168', '5', 'users168', '小计', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('334', '169', '5', 'users169', '操作', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('335', '170', '5', 'users170', '删除', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('336', '171', '5', 'users171', '商品总计', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('337', '172', '5', 'users172', '已选', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('338', '173', '5', 'users173', '继续结账', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('339', '174', '5', 'users174', '件', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('340', '175', '5', 'users175', '配送地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('341', '176', '5', 'users176', '已选择', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('342', '177', '5', 'users177', '编辑', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('343', '178', '5', 'users178', '选择其他地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('344', '179', '5', 'users179', '添加新地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('345', '180', '5', 'users180', '支付方式', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('346', '181', '5', 'users181', '配送方式', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('347', '182', '5', 'users182', '固定运费', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('348', '183', '5', 'users183', '订单备注', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('349', '184', '5', 'users184', '购物车总数', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('350', '185', '5', 'users185', '运费', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('351', '186', '5', 'users186', '总计', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('352', '187', '5', 'users187', '提交订单', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('353', '188', '5', 'users188', '订单提交成功，请付款', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('354', '189', '5', 'users189', '订单编号', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('355', '190', '5', 'users190', '订单总金额', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('356', '191', '5', 'users191', '欢迎', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('357', '192', '5', 'users192', '待付款的订单', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('358', '193', '5', 'users193', '查看待付款订单', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('359', '194', '5', 'users194', '待发货的订单', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('360', '195', '5', 'users195', '查看待发货订单', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('361', '196', '5', 'users196', '待收货的订单', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('362', '197', '5', 'users197', '查看待收货订单', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('363', '198', '5', 'users198', '待评价商品', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('364', '199', '5', 'users199', '查看待评价商品', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('365', '200', '5', 'users200', '待发货', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('366', '201', '5', 'users201', '待收货', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('367', '202', '5', 'users202', '待评价', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('368', '203', '5', 'users203', '已评价', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('369', '204', '5', 'users204', '地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('370', '205', '5', 'users205', '收藏', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('371', '206', '5', 'users206', '足迹', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('372', '207', '5', 'users207', '头像', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('373', '208', '5', 'users208', '昵称', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('374', '209', '5', 'users209', '修改密码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('375', '210', '5', 'users210', '留空时默认不修改密码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('376', '211', '5', 'users211', '账号注销', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('377', '212', '5', 'users212', '保存', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('378', '213', '5', 'users213', '更改', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('379', '214', '5', 'users214', '新的邮箱地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('380', '215', '5', 'users215', '秒', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('381', '216', '5', 'users216', '绑定邮箱', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('382', '217', '5', 'users217', '标题', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('383', '218', '5', 'users218', '分类', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('384', '219', '5', 'users219', '批量删除', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('385', '220', '5', 'users220', '添加地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('386', '221', '5', 'users221', '编辑地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('387', '222', '5', 'users222', '确定要删除地址吗？', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('388', '223', '5', 'users223', '确定要设置为默认地址?', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('389', '224', '5', 'users224', '电话号码', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('390', '225', '5', 'users225', '邮编', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('391', '226', '5', 'users226', '城市', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('392', '227', '5', 'users227', '国家/地区', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('393', '228', '5', 'users228', '省份', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('394', '229', '5', 'users229', '详细地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('395', '230', '5', 'users230', '详细地址，路名或街道名称，门牌号', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('396', '231', '5', 'users231', '请输入联系人', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('397', '232', '5', 'users232', '请输入联系电话', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('398', '233', '5', 'users233', '请选择完整省市区', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('399', '234', '5', 'users234', '请输入详细地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('400', '235', '5', 'users235', '设为默认', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('401', '236', '5', 'users236', '默认地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('402', '237', '5', 'users237', '修改成功', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('403', '238', '5', 'users238', '全部订单', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('404', '239', '5', 'users239', '已完成', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('405', '240', '5', 'users240', '输入商品名称、订单号', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('406', '241', '5', 'users241', '马上去购物', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('407', '242', '5', 'users242', '已关闭', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('408', '243', '5', 'users243', '等待付款', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('409', '244', '5', 'users244', '已完成', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('410', '245', '5', 'users245', '订单号', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('411', '246', '5', 'users246', '立即付款', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('412', '247', '5', 'users247', '提醒发货', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('413', '248', '5', 'users248', '物流查询', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('414', '249', '5', 'users249', '确认收货', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('415', '250', '5', 'users250', '订单详情', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('416', '251', '5', 'users251', '评价商品', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('417', '252', '5', 'users252', '取消订单', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('418', '253', '5', 'users253', '下单', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('419', '254', '5', 'users254', '付款', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('420', '255', '5', 'users255', '发货', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('421', '256', '5', 'users256', '完成', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('422', '257', '5', 'users257', '订购商品', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('423', '258', '5', 'users258', '订单过期', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('424', '259', '5', 'users259', '订单关闭', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('425', '260', '5', 'users260', '已发货', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('426', '261', '5', 'users261', '商品总价', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('427', '262', '5', 'users262', '配送地址', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('428', '263', '5', 'users263', '买家留言', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('429', '264', '5', 'users264', '快递配送', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('430', '265', '5', 'users265', '买家留言', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('431', '266', '5', 'users266', '商家回复', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('432', '267', '5', 'users267', '快递信息', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('433', '268', '5', 'users268', '快递公司', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('434', '269', '5', 'users269', '物流单号', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('435', '270', '5', 'users270', '海外商直发', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('436', '271', '5', 'users271', '请填写 %s', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('437', '272', '5', 'users272', '添加成功', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('438', '273', '5', 'users273', '删除成功', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('439', '274', '5', 'users274', '删除失败', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('440', '275', '5', 'users275', '收藏成功', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('441', '276', '5', 'users276', '取消成功', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('442', '277', '5', 'users277', '全名', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('443', '278', '5', 'users278', '商品数量最少为1', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('444', '279', '5', 'users279', '确定删除购物车商品: ', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('445', '280', '5', 'users280', '确定要取消订单?', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('446', '281', '5', 'users281', '提醒管理员发货？', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('447', '282', '5', 'users282', '确认已收到货物？', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('448', '283', '5', 'users283', '评价晒单', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('449', '284', '5', 'users284', '下单时间', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('450', '285', '5', 'users285', '实付金额', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('451', '286', '5', 'users286', '共 ', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('452', '287', '5', 'users287', ' 种商品', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('453', '288', '5', 'users288', '输入订单号查询', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('454', '289', '5', 'users289', '立即评价', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('455', '290', '5', 'users290', '评价服务', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('456', '291', '5', 'users291', '订单创建成功', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('457', '292', '5', 'users292', '支付订单完成！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('458', '293', '5', 'users293', '支付成功，处理订单完成！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('459', '294', '5', 'users294', '支付成功，处理订单失败！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('460', '295', '5', 'users295', '已支付', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('461', '296', '5', 'users296', '该订单已过期！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('462', '297', '5', 'users297', '该订单不存在或已关闭！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('463', '298', '5', 'users298', '描述相符', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('464', '299', '5', 'users299', '请在此处输入您的评价', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('465', '300', '5', 'users300', '上传图片', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('466', '301', '5', 'users301', '限6张', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('467', '302', '5', 'users302', '请选择全部商品评价分', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('468', '303', '5', 'users303', '请填写全部商品评价内容', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('469', '304', '5', 'users304', '订单已评价过', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('470', '305', '5', 'users305', '评价成功', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('471', '306', '5', 'users306', '评价失败，请重试', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('472', '307', '5', 'users307', '我的评价', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('473', '308', '5', 'users308', '评价时间', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('474', '309', '5', 'users309', '差评', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('475', '310', '5', 'users310', '中评', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('476', '311', '5', 'users311', '好评', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('477', '312', '5', 'users312', '查看评价', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('478', '326', '5', 'users326', '我的足迹', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('479', '327', '5', 'users327', '访问时间', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('480', '328', '5', 'users328', '确认批量删除浏览记录？', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('481', '329', '5', 'users329', '确认删除该浏览记录？', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('482', '330', '5', 'users330', '提醒成功！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('483', '331', '5', 'users331', '[商品已停售]', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('484', '332', '5', 'users332', '订单不存在', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('485', '333', '5', 'users333', '未支付', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('486', '334', '5', 'users334', '在线支付', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('487', '335', '5', 'users335', '订单已取消', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('488', '336', '5', 'users336', '该商品不存在或已下架！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('489', '337', '5', 'users337', '订单支付异常，请刷新重新下单~', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('490', '338', '5', 'users338', '商品已售罄', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('491', '339', '5', 'users339', '超出商品库存', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('492', '340', '5', 'users340', '退出登录', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('493', '341', '5', 'users341', '注册账号', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('494', '346', '5', 'users346', '订单已支付，即将跳转', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('495', '347', '5', 'users347', '订单已过期，即将跳转', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('496', '348', '5', 'users348', '订单已关闭，即将跳转', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('497', '349', '5', 'users349', '订单不存在或已变更', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('498', '350', '5', 'users350', '订单处理中', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('499', '351', '5', 'users351', '订单支付中', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('500', '352', '5', 'users352', '价格', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('501', '353', '5', 'users353', '最多允许上传6张图片', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('502', '354', '5', 'users354', '或将文件拖到这里，本次最多可选 %s 个', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('503', '355', '5', 'users355', '点击选择图片', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('504', '356', '5', 'users356', '共%s张（%s），已上传%s张', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('505', '357', '5', 'users357', '继续添加', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('506', '358', '5', 'users358', '确定使用', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('507', '359', '5', 'users359', '邮箱地址为系统禁止注册！', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('508', '360', '5', 'users360', '关于您的订单的说明，例如交货的特殊说明。', '1', 'cn', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('509', '58', '5', 'users58', 'Your shopping cart doesn&apos;t have any products yet!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('510', '59', '5', 'users59', '%s cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('511', '60', '5', 'users60', '%s Incorrect format!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('512', '61', '5', 'users61', 'The email verification code has been used or timed out. Please resend it!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('513', '62', '5', 'users62', 'The email verification code is incorrect, please re-enter!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('514', '63', '5', 'users63', 'The SMS verification code is incorrect, please re-enter!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('515', '64', '5', 'users64', '%s already exists!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('516', '65', '5', 'users65', 'Successful check-in', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('517', '66', '5', 'users66', 'Signed in today', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('518', '67', '5', 'users67', 'Do you want to delete this collection?', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('519', '68', '5', 'users68', 'Confirm bulk deletion of favorites?', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('520', '69', '5', 'users69', 'Daily Attendance', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('521', '70', '5', 'users70', 'Recharge amount cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('522', '71', '5', 'users71', 'Please enter the correct recharge amount!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('523', '72', '5', 'users72', 'Please choose a payment method!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('524', '73', '5', 'users73', 'The username cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('525', '74', '5', 'users74', 'The username is incorrect!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('526', '75', '5', 'users75', 'Password cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('527', '76', '5', 'users76', 'The image verification code cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('528', '77', '5', 'users77', 'Image verification code error', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('529', '78', '5', 'users78', 'The front desk prohibits administrators from logging in!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('530', '79', '5', 'users79', 'This member has not been activated yet. Please contact the administrator!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('531', '80', '5', 'users80', 'Administrator review in progress, please wait!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('532', '81', '5', 'users81', 'Login succeeded', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('533', '82', '5', 'users82', 'The password is incorrect!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('534', '83', '5', 'users83', 'The username does not exist, please register!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('535', '84', '5', 'users84', 'Can&apos;t see clearly? Click to change the verification code', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('536', '85', '5', 'users85', 'Mobile phone number cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('537', '86', '5', 'users86', 'The phone number format is incorrect!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('538', '87', '5', 'users87', 'Mobile verification code cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('539', '88', '5', 'users88', 'The mobile verification code has expired!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('540', '89', '5', 'users89', 'The phone number has been registered!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('541', '90', '5', 'users90', 'The username is prohibited from registration by the system!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('542', '91', '5', 'users91', 'Please enter a combination of Chinese characters, English characters, numbers, underscores, etc. that are 2-30 digits long', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('543', '92', '5', 'users92', 'Login password cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('544', '93', '5', 'users93', 'The duplicate password cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('545', '94', '5', 'users94', 'The username already exists', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('546', '95', '5', 'users95', 'The two password inputs are inconsistent!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('547', '96', '5', 'users96', 'Registration successful, jumping in progress……', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('548', '97', '5', 'users97', 'Registration successful, wait for administrator activation before logging in!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('549', '98', '5', 'users98', 'Registration successful, please log in!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('550', '99', '5', 'users99', 'Nicknames cannot be pure spaces', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('551', '100', '5', 'users100', 'The original password cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('552', '101', '5', 'users101', 'The new password cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('553', '102', '5', 'users102', 'Mobile phone number does not exist, password cannot be retrieved!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('554', '103', '5', 'users103', 'Mobile phone number is not bound, password cannot be retrieved!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('555', '104', '5', 'users104', 'The mobile verification code has been used or timed out. Please resend it!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('556', '105', '5', 'users105', 'Good evening~', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('557', '106', '5', 'users106', 'Good morning~', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('558', '107', '5', 'users107', 'Good afternoon~', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('559', '108', '5', 'users108', 'User name', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('560', '109', '5', 'users109', 'Email', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('561', '110', '5', 'users110', 'Password', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('562', '111', '5', 'users111', 'Re-enter Password', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('563', '112', '5', 'users112', 'Email verification code', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('564', '113', '5', 'users113', 'To send', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('565', '114', '5', 'users114', 'Email address cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('566', '115', '5', 'users115', 'The member has not been activated yet and cannot retrieve the password!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('567', '116', '5', 'users116', 'Email address not bound, password cannot be retrieved!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('568', '117', '5', 'users117', 'The email address does not exist!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('569', '118', '5', 'users118', 'Email already bound, no need to rebind!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('570', '119', '5', 'users119', 'The email already exists and cannot be bound!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('571', '120', '5', 'users120', 'Required', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('572', '121', '5', 'users121', 'Please enter your email address correctly', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('573', '122', '5', 'users122', 'Sending…', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('574', '123', '5', 'users123', 'Image verification code', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('575', '124', '5', 'users124', 'Login', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('576', '125', '5', 'users125', 'Email verification code cannot be empty', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('577', '126', '5', 'users126', 'Email does not exist, password cannot be retrieved!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('578', '127', '5', 'users127', 'The member email attribute has been disabled. Please contact the website administrator!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('579', '128', '5', 'users128', 'Please enter the required fields', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('580', '129', '5', 'users129', 'Please pass in the verification token name', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('581', '130', '5', 'users130', 'Please pass in the array for submitting verification', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('582', '131', '5', 'users131', 'The data does not exist!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('583', '132', '5', 'users132', 'Token data is invalid', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('584', '133', '5', 'users133', 'Form verification failed, please check site permission issues', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('585', '134', '5', 'users134', 'Fail in send', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('586', '135', '5', 'users135', 'Sent successfully', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('587', '136', '5', 'users136', 'New password', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('588', '137', '5', 'users137', 'Confirm new password', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('589', '138', '5', 'users138', 'Confirm password cannot be empty!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('590', '139', '5', 'users139', 'New Customer ？', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('591', '140', '5', 'users140', 'Start here.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('592', '141', '5', 'users141', 'Forgot Password', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('593', '142', '5', 'users142', 'Login', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('594', '143', '5', 'users143', 'Register', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('595', '144', '5', 'users144', 'Already have an account!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('596', '145', '5', 'users145', 'password recovery', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('597', '146', '5', 'users146', 'Next step', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('598', '147', '5', 'users147', 'Back to login', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('599', '148', '5', 'users148', 'Reset password', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('600', '149', '5', 'users149', 'Submit', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('601', '150', '5', 'users150', 'Account', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('602', '151', '5', 'users151', 'Message', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('603', '152', '5', 'users152', 'Collection', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('604', '153', '5', 'users153', 'Address', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('605', '154', '5', 'users154', 'Order', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('606', '155', '5', 'users155', 'Member', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('607', '156', '5', 'users156', 'Safe exit', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('608', '157', '5', 'users157', 'You can go and see what you want to buy.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('609', '158', '5', 'users158', 'Go for a walk', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('610', '159', '5', 'users159', 'Cart', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('611', '160', '5', 'users160', 'Checkout', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('612', '161', '5', 'users161', 'Payment', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('613', '162', '5', 'users162', 'Unpaid', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('614', '163', '5', 'users163', 'Unpaid', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('615', '164', '5', 'users164', 'Paid', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('616', '165', '5', 'users165', 'Product', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('617', '166', '5', 'users166', 'Select All', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('618', '167', '5', 'users167', 'Quantity', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('619', '168', '5', 'users168', 'Subtotal', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('620', '169', '5', 'users169', 'Operation', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('621', '170', '5', 'users170', 'Delete', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('622', '171', '5', 'users171', 'Total Merchandise', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('623', '172', '5', 'users172', 'Selected', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('624', '173', '5', 'users173', 'Go to checkout', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('625', '174', '5', 'users174', 'Piece', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('626', '175', '5', 'users175', 'Address', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('627', '176', '5', 'users176', 'Chosen', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('628', '177', '5', 'users177', 'Edit', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('629', '178', '5', 'users178', 'Choose Another Address', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('630', '179', '5', 'users179', 'Add New Address', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('631', '180', '5', 'users180', 'Payment Method', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('632', '181', '5', 'users181', 'Delivery Method', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('633', '182', '5', 'users182', 'Fixed freight', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('634', '183', '5', 'users183', 'Order notes (optional)', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('635', '184', '5', 'users184', 'Cart Totals', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('636', '185', '5', 'users185', 'Shipping Fee', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('637', '186', '5', 'users186', 'Total', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('638', '187', '5', 'users187', 'Submit Order', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('639', '188', '5', 'users188', 'Order placed successfully, please pay', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('640', '189', '5', 'users189', 'Order number', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('641', '190', '5', 'users190', 'Order Total', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('642', '191', '5', 'users191', 'Welcome', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('643', '192', '5', 'users192', 'Unpaid Order', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('644', '193', '5', 'users193', 'View Unpaid Order', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('645', '194', '5', 'users194', 'Shipped Order', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('646', '195', '5', 'users195', 'View Shipped Order', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('647', '196', '5', 'users196', 'Pending Order', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('648', '197', '5', 'users197', 'View Pending Orders', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('649', '198', '5', 'users198', 'To Be Evaluated', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('650', '199', '5', 'users199', 'View To Be Evaluated', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('651', '200', '5', 'users200', 'Unshipped', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('652', '201', '5', 'users201', 'Shipped', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('653', '202', '5', 'users202', 'Unevaluated', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('654', '203', '5', 'users203', 'Evaluated', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('655', '204', '5', 'users204', 'Address', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('656', '205', '5', 'users205', 'Collection', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('657', '206', '5', 'users206', 'Footprint', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('658', '207', '5', 'users207', 'Avatar', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('659', '208', '5', 'users208', 'Nickname', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('660', '209', '5', 'users209', 'Password', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('661', '210', '5', 'users210', 'Do not change the password by default when leaving blank', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('662', '211', '5', 'users211', 'Account Cancellation', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('663', '212', '5', 'users212', 'Save', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('664', '213', '5', 'users213', 'Change', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('665', '214', '5', 'users214', 'New Email Address', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('666', '215', '5', 'users215', 'Second', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('667', '216', '5', 'users216', 'Bind Email', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('668', '217', '5', 'users217', 'Title', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('669', '218', '5', 'users218', 'Category', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('670', '219', '5', 'users219', 'Batch Deletion', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('671', '220', '5', 'users220', 'Add Address', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('672', '221', '5', 'users221', 'Edit Address', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('673', '222', '5', 'users222', 'Are you sure you want to delete the address?', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('674', '223', '5', 'users223', 'Are you sure you want to set it as the default address?', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('675', '224', '5', 'users224', 'Phone', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('676', '225', '5', 'users225', 'zip Code', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('677', '226', '5', 'users226', 'City', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('678', '227', '5', 'users227', 'Country/Region', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('679', '228', '5', 'users228', 'Province', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('680', '229', '5', 'users229', 'Detailed Address', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('681', '230', '5', 'users230', 'Detailed address, road or street name, house number', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('682', '231', '5', 'users231', 'Please enter a contact person', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('683', '232', '5', 'users232', 'Please enter a contact number', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('684', '233', '5', 'users233', 'Please select the complete province or city', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('685', '234', '5', 'users234', 'Please enter the detailed address.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('686', '235', '5', 'users235', 'Default', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('687', '236', '5', 'users236', 'Default', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('688', '237', '5', 'users237', 'Modified Successfully', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('689', '238', '5', 'users238', 'All Orders', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('690', '239', '5', 'users239', 'Completed', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('691', '240', '5', 'users240', 'Product and Order ', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('692', '241', '5', 'users241', 'Go Shopping Now', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('693', '242', '5', 'users242', 'Closed', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('694', '243', '5', 'users243', 'Waiting For Payment', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('695', '244', '5', 'users244', 'Completed', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('696', '245', '5', 'users245', 'Order Number', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('697', '246', '5', 'users246', 'Pay', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('698', '247', '5', 'users247', 'Remind To Ship', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('699', '248', '5', 'users248', 'Logistics Inquiry', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('700', '249', '5', 'users249', 'Confirm Receipt', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('701', '250', '5', 'users250', 'Details', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('702', '251', '5', 'users251', 'Evaluate The Product', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('703', '252', '5', 'users252', 'Cancel', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('704', '253', '5', 'users253', 'Place An Order', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('705', '254', '5', 'users254', 'Payment', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('706', '255', '5', 'users255', 'Delivery', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('707', '256', '5', 'users256', 'Complete', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('708', '257', '5', 'users257', 'Order Items', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('709', '258', '5', 'users258', 'Order Expires', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('710', '259', '5', 'users259', 'Order Closed', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('711', '260', '5', 'users260', 'Shipped', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('712', '261', '5', 'users261', 'Product Total', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('713', '262', '5', 'users262', 'Shipping Address', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('714', '263', '5', 'users263', 'Buyer&apos;s Message', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('715', '264', '5', 'users264', 'Express Delivery', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('716', '265', '5', 'users265', 'Buyer&apos;s Message', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('717', '266', '5', 'users266', 'Merchant Reply', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('718', '267', '5', 'users267', 'Courier Information', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('719', '268', '5', 'users268', 'Courier Company', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('720', '269', '5', 'users269', 'Logistics Tracking Number', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('721', '270', '5', 'users270', 'Overseas business direct hair', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('722', '271', '5', 'users271', 'Please fill in %s', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('723', '272', '5', 'users272', 'Added successfully', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('724', '273', '5', 'users273', 'Deleted successfully', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('725', '274', '5', 'users274', 'Delete failed', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('726', '275', '5', 'users275', 'Favorite Successfully', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('727', '276', '5', 'users276', 'Cancellation Successful', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('728', '277', '5', 'users277', 'Full name', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('729', '278', '5', 'users278', 'The minimum quantity of goods is 1.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('730', '279', '5', 'users279', 'Delete shopping cart items: ', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('731', '280', '5', 'users280', 'Are you sure you want to cancel the order?', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('732', '281', '5', 'users281', 'Remind the administrator to ship?', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('733', '282', '5', 'users282', 'Confirm receipt of the goods?', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('734', '283', '5', 'users283', 'Evaluation and order posting', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('735', '284', '5', 'users284', 'Time', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('736', '285', '5', 'users285', 'Amount', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('737', '286', '5', 'users286', 'A total of ', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('738', '287', '5', 'users287', ' Products', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('739', '288', '5', 'users288', 'Enter the order number to inquire.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('740', '289', '5', 'users289', 'Evaluation', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('741', '290', '5', 'users290', 'Evaluation', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('742', '291', '5', 'users291', 'Order created successfully', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('743', '292', '5', 'users292', 'The payment order is completed!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('744', '293', '5', 'users293', 'The payment is successful and the order processing is completed!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('745', '294', '5', 'users294', 'The payment was successful, but the order processing failed!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('746', '295', '5', 'users295', 'Paid', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('747', '296', '5', 'users296', 'The order has expired!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('748', '297', '5', 'users297', 'The order does not exist or has been closed!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('749', '298', '5', 'users298', 'Description match', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('750', '299', '5', 'users299', 'Please enter your review here', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('751', '300', '5', 'users300', 'Upload image', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('752', '301', '5', 'users301', 'Limited to 6 sheets', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('753', '302', '5', 'users302', 'Please select all product evaluation points', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('754', '303', '5', 'users303', 'Please fill in all product reviews', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('755', '304', '5', 'users304', 'The order has been evaluated.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('756', '305', '5', 'users305', 'Evaluation Success', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('757', '306', '5', 'users306', 'Evaluation failed, please try again', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('758', '307', '5', 'users307', 'My Evaluation', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('759', '308', '5', 'users308', 'Evaluation Time', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('760', '309', '5', 'users309', 'Bad Review', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('761', '310', '5', 'users310', 'Medium Review', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('762', '311', '5', 'users311', 'Praise', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('763', '312', '5', 'users312', 'View Reviews', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('764', '326', '5', 'users326', 'My Footsteps', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('765', '327', '5', 'users327', 'Access Time', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('766', '328', '5', 'users328', 'Confirm batch deletion of browsing history?', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('767', '329', '5', 'users329', 'Are you sure you want to delete this browsing history?', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('768', '330', '5', 'users330', 'Reminder of success!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('769', '331', '5', 'users331', '[Discontinued]', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('770', '332', '5', 'users332', 'The order does not exist.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('771', '333', '5', 'users333', 'Unpaid', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('772', '334', '5', 'users334', 'Online payment', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('773', '335', '5', 'users335', 'The order has been cancelled.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('774', '336', '5', 'users336', 'The product does not exist or has been removed from the shelves!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('775', '337', '5', 'users337', 'The order payment is abnormal, please refresh and place a new order~', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('776', '338', '5', 'users338', 'The item has been sold out.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('777', '339', '5', 'users339', 'Exceeds commodity inventory', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('778', '340', '5', 'users340', 'Sign out', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('779', '341', '5', 'users341', 'Register', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('780', '346', '5', 'users346', 'The order has been paid and will be redirected soon.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('781', '347', '5', 'users347', 'The order has expired and will be redirected soon.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('782', '348', '5', 'users348', 'The order has been closed and will be redirected soon.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('783', '349', '5', 'users349', 'The order does not exist or has been changed', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('784', '350', '5', 'users350', 'Order processing is in progress.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('785', '351', '5', 'users351', 'Order payment is in progress.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('786', '352', '5', 'users352', 'Price', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('787', '353', '5', 'users353', 'A maximum of 6 images are allowed to be uploaded', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('788', '354', '5', 'users354', 'Or drag files here, up to %s can be selected this time', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('789', '355', '5', 'users355', 'Click to select picture', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('790', '356', '5', 'users356', 'Total %s (%s), %s uploaded', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('791', '357', '5', 'users357', 'Keep Adding', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('792', '358', '5', 'users358', 'Confirm To Use', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('793', '359', '5', 'users359', 'The email address is prohibited from registration by the system!', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('794', '360', '5', 'users360', 'Notes about your order, e.g. special notes for delivery.', '1', 'en', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('795', '58', '5', 'users58', '您的購物車還沒有商品！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('796', '59', '5', 'users59', '%s不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('797', '60', '5', 'users60', '%s格式不正確！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('798', '61', '5', 'users61', '郵箱驗證碼已被使用或超時，請重新發送！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('799', '62', '5', 'users62', '郵箱驗證碼不正確，請重新輸入！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('800', '63', '5', 'users63', '簡訊驗證碼不正確，請重新輸入！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('801', '64', '5', 'users64', '%s已存在！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('802', '65', '5', 'users65', '簽到成功', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('803', '66', '5', 'users66', '今日已簽過到', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('804', '67', '5', 'users67', '是否删除該收藏？', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('805', '68', '5', 'users68', '確認批量删除收藏？', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('806', '69', '5', 'users69', '每日簽到', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('807', '70', '5', 'users70', '充值金額不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('808', '71', '5', 'users71', '請輸入正確的充值金額！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('809', '72', '5', 'users72', '請選擇支付方式！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('810', '73', '5', 'users73', '用戶名不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('811', '74', '5', 'users74', '用戶名不正確！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('812', '75', '5', 'users75', '密碼不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('813', '76', '5', 'users76', '圖片驗證碼不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('814', '77', '5', 'users77', '圖片驗證碼錯誤', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('815', '78', '5', 'users78', '前臺禁止管理員登錄！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('816', '79', '5', 'users79', '該會員尚未啟動，請聯系管理員！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('817', '80', '5', 'users80', '管理員稽核中，請稍等！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('818', '81', '5', 'users81', '登錄成功', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('819', '82', '5', 'users82', '密碼不正確！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('820', '83', '5', 'users83', '該用戶名不存在，請註冊！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('821', '84', '5', 'users84', '看不清？點擊更換驗證碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('822', '85', '5', 'users85', '手機號碼不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('823', '86', '5', 'users86', '手機號碼格式不正確！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('824', '87', '5', 'users87', '手機驗證碼不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('825', '88', '5', 'users88', '手機驗證碼已失效！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('826', '89', '5', 'users89', '手機號碼已經注册！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('827', '90', '5', 'users90', '用戶名為系統禁止注册！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('828', '91', '5', 'users91', '請輸入2-30位的漢字、英文、數字、下劃線等組合', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('829', '92', '5', 'users92', '登錄密碼不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('830', '93', '5', 'users93', '重複密碼不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('831', '94', '5', 'users94', '用戶名已存在', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('832', '95', '5', 'users95', '兩次密碼輸入不一致！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('833', '96', '5', 'users96', '注册成功，正在跳轉中……', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('834', '97', '5', 'users97', '注册成功，等管理員啟動才能登錄！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('835', '98', '5', 'users98', '注册成功，請登錄！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('836', '99', '5', 'users99', '昵稱不可為純空格', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('837', '100', '5', 'users100', '原密碼不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('838', '101', '5', 'users101', '新密碼不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('839', '102', '5', 'users102', '手機號碼不存在，不能找回密碼！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('840', '103', '5', 'users103', '手機號碼未綁定，不能找回密碼！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('841', '104', '5', 'users104', '手機驗證碼已被使用或超時，請重新發送！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('842', '105', '5', 'users105', '晚上好～', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('843', '106', '5', 'users106', '早上好～', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('844', '107', '5', 'users107', '下午好～', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('845', '108', '5', 'users108', '用戶名', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('846', '109', '5', 'users109', '郵箱地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('847', '110', '5', 'users110', '密碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('848', '111', '5', 'users111', '確認密碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('849', '112', '5', 'users112', '郵箱驗證碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('850', '113', '5', 'users113', '點擊發送', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('851', '114', '5', 'users114', '郵箱地址不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('852', '115', '5', 'users115', '該會員尚未啟動，不能找回密碼！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('853', '116', '5', 'users116', '郵箱地址未綁定，不能找回密碼！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('854', '117', '5', 'users117', '郵箱地址不存在！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('855', '118', '5', 'users118', '郵箱已綁定，無需重新綁定！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('856', '119', '5', 'users119', '郵箱已經存在，不可以綁定！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('857', '120', '5', 'users120', '必填', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('858', '121', '5', 'users121', '請正確輸入郵箱地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('859', '122', '5', 'users122', '發送中…', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('860', '123', '5', 'users123', '圖片驗證碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('861', '124', '5', 'users124', '登錄', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('862', '125', '5', 'users125', '郵箱驗證碼不能為空', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('863', '126', '5', 'users126', '郵箱不存在，不能找回密碼！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('864', '127', '5', 'users127', '會員郵箱内容已關閉，請聯系網站管理員！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('865', '128', '5', 'users128', '請傳入必填項欄位', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('866', '129', '5', 'users129', '請傳入驗證token名稱', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('867', '130', '5', 'users130', '請傳入提交驗證的數組', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('868', '131', '5', 'users131', '數據不存在！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('869', '132', '5', 'users132', '權杖數據無效', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('870', '133', '5', 'users133', '表單校驗失敗，請檢查網站許可權問題', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('871', '134', '5', 'users134', '發送失敗', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('872', '135', '5', 'users135', '發送成功', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('873', '136', '5', 'users136', '新密碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('874', '137', '5', 'users137', '確認新密碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('875', '138', '5', 'users138', '確認密碼不能為空！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('876', '139', '5', 'users139', '新客户？', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('877', '140', '5', 'users140', '從這裏開始', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('878', '141', '5', 'users141', '忘記密碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('879', '142', '5', 'users142', '賬號登錄', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('880', '143', '5', 'users143', '創建賬號', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('881', '144', '5', 'users144', '已有賬號!', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('882', '145', '5', 'users145', '找回密碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('883', '146', '5', 'users146', '下一步', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('884', '147', '5', 'users147', '返回登錄', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('885', '148', '5', 'users148', '重置密碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('886', '149', '5', 'users149', '確認提交', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('887', '150', '5', 'users150', '個人中心', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('888', '151', '5', 'users151', '我的信息', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('889', '152', '5', 'users152', '我的收藏', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('890', '153', '5', 'users153', '收貨地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('891', '154', '5', 'users154', '我的訂單', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('892', '155', '5', 'users155', '會員中心', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('893', '156', '5', 'users156', '安全退出', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('894', '157', '5', 'users157', '您可以去看看有哪些想買的', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('895', '158', '5', 'users158', '去逛逛', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('896', '159', '5', 'users159', '購物車', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('897', '160', '5', 'users160', '結賬', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('898', '161', '5', 'users161', '付款', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('899', '162', '5', 'users162', '待支付', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('900', '163', '5', 'users163', '未付款', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('901', '164', '5', 'users164', '已付款', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('902', '165', '5', 'users165', '商品', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('903', '166', '5', 'users166', '全選', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('904', '167', '5', 'users167', '數量', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('905', '168', '5', 'users168', '小計', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('906', '169', '5', 'users169', '操作', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('907', '170', '5', 'users170', '刪除', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('908', '171', '5', 'users171', '商品總計', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('909', '172', '5', 'users172', '已選', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('910', '173', '5', 'users173', '继续結賬', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('911', '174', '5', 'users174', '件', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('912', '175', '5', 'users175', '配送地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('913', '176', '5', 'users176', '已選擇', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('914', '177', '5', 'users177', '編輯', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('915', '178', '5', 'users178', '選擇其他地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('916', '179', '5', 'users179', '添加新地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('917', '180', '5', 'users180', '支付方式', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('918', '181', '5', 'users181', '配送方式', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('919', '182', '5', 'users182', '固定運費', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('920', '183', '5', 'users183', '訂單備註', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('921', '184', '5', 'users184', '購物車總數', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('922', '185', '5', 'users185', '運費', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('923', '186', '5', 'users186', '总计', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('924', '187', '5', 'users187', '提交訂單', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('925', '188', '5', 'users188', '訂單提交成功，請付款', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('926', '189', '5', 'users189', '訂單編號', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('927', '190', '5', 'users190', '訂單總金額', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('928', '191', '5', 'users191', '歡迎', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('929', '192', '5', 'users192', '待付款的訂單', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('930', '193', '5', 'users193', '查看待付款訂單', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('931', '194', '5', 'users194', '待發貨的訂單', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('932', '195', '5', 'users195', '查看待發貨訂單', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('933', '196', '5', 'users196', '待收貨的訂單', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('934', '197', '5', 'users197', '查看待收貨訂單', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('935', '198', '5', 'users198', '待評價商品', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('936', '199', '5', 'users199', '查看待評價商品', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('937', '200', '5', 'users200', '待發貨', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('938', '201', '5', 'users201', '待收貨', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('939', '202', '5', 'users202', '待評價', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('940', '203', '5', 'users203', '已評價', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('941', '204', '5', 'users204', '地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('942', '205', '5', 'users205', '收藏', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('943', '206', '5', 'users206', '足跡', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('944', '207', '5', 'users207', '頭像', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('945', '208', '5', 'users208', '暱稱', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('946', '209', '5', 'users209', '修改密碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('947', '210', '5', 'users210', '留空時默認不修改密碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('948', '211', '5', 'users211', '賬號註銷', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('949', '212', '5', 'users212', '保存', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('950', '213', '5', 'users213', '更改', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('951', '214', '5', 'users214', '新的邮箱地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('952', '215', '5', 'users215', '秒', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('953', '216', '5', 'users216', '綁定郵箱', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('954', '217', '5', 'users217', '標題', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('955', '218', '5', 'users218', '分類', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('956', '219', '5', 'users219', '批量刪除', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('957', '220', '5', 'users220', '添加地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('958', '221', '5', 'users221', '編輯地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('959', '222', '5', 'users222', '确定要删除地址吗？', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('960', '223', '5', 'users223', '确定要設置爲默認地址?', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('961', '224', '5', 'users224', '電話號碼', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('962', '225', '5', 'users225', '郵編', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('963', '226', '5', 'users226', '城市', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('964', '227', '5', 'users227', '國家/地區', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('965', '228', '5', 'users228', '省份', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('966', '229', '5', 'users229', '詳細地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('967', '230', '5', 'users230', '詳細地址，路名或街道名稱，門牌號', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('968', '231', '5', 'users231', '請輸入聯繫人', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('969', '232', '5', 'users232', '請輸入聯繫電話', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('970', '233', '5', 'users233', '請選擇完整省市區', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('971', '234', '5', 'users234', '請輸入詳細地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('972', '235', '5', 'users235', '設爲默認', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('973', '236', '5', 'users236', '默認地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('974', '237', '5', 'users237', '修改成功', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('975', '238', '5', 'users238', '全部訂單', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('976', '239', '5', 'users239', '已完成', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('977', '240', '5', 'users240', '輸入商品名稱、訂單號', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('978', '241', '5', 'users241', '馬上去購物', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('979', '242', '5', 'users242', '已關閉', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('980', '243', '5', 'users243', '等待付款', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('981', '244', '5', 'users244', '已完成', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('982', '245', '5', 'users245', '訂單號', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('983', '246', '5', 'users246', '立即付款', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('984', '247', '5', 'users247', '提醒發貨', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('985', '248', '5', 'users248', '物流查詢', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('986', '249', '5', 'users249', '確認收貨', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('987', '250', '5', 'users250', '訂單詳情', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('988', '251', '5', 'users251', '評價商品', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('989', '252', '5', 'users252', '取消訂單', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('990', '253', '5', 'users253', '下單', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('991', '254', '5', 'users254', '付款', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('992', '255', '5', 'users255', '發貨', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('993', '256', '5', 'users256', '完成', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('994', '257', '5', 'users257', '訂購商品', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('995', '258', '5', 'users258', '訂單過期', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('996', '259', '5', 'users259', '訂單關閉', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('997', '260', '5', 'users260', '已發貨', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('998', '261', '5', 'users261', '商品總價', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('999', '262', '5', 'users262', '配送地址', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1000', '263', '5', 'users263', '買家留言', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1001', '264', '5', 'users264', '快遞配送', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1002', '265', '5', 'users265', '買家留言', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1003', '266', '5', 'users266', '商家回覆', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1004', '267', '5', 'users267', '快遞信息', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1005', '268', '5', 'users268', '快遞公司', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1006', '269', '5', 'users269', '物流單號', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1007', '270', '5', 'users270', '海外商直髮', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1008', '271', '5', 'users271', '請填寫%s', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1009', '272', '5', 'users272', '添加成功', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1010', '273', '5', 'users273', '刪除成功', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1011', '274', '5', 'users274', '刪除失敗', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1012', '275', '5', 'users275', '收藏成功', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1013', '276', '5', 'users276', '取消成功', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1014', '277', '5', 'users277', '全名', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1015', '278', '5', 'users278', '商品數量最少爲1', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1016', '279', '5', 'users279', '確定刪除購物車商品: ', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1017', '280', '5', 'users280', '確定要取消訂單?', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1018', '281', '5', 'users281', '提醒管理員發貨？', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1019', '282', '5', 'users282', '確認已收到貨物？', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1020', '283', '5', 'users283', '評價曬單', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1021', '284', '5', 'users284', '下單時間', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1022', '285', '5', 'users285', '實付金額', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1023', '286', '5', 'users286', '共 ', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1024', '287', '5', 'users287', ' 種商品', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1025', '288', '5', 'users288', '輸入訂單號查詢', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1026', '289', '5', 'users289', '立即評價', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1027', '290', '5', 'users290', '評價服務', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1028', '291', '5', 'users291', '訂單創建成功', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1029', '292', '5', 'users292', '支付訂單完成！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1030', '293', '5', 'users293', '支付成功，處理訂單完成！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1031', '294', '5', 'users294', '支付成功，處理訂單失敗！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1032', '295', '5', 'users295', '已支付', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1033', '296', '5', 'users296', '該訂單已過期！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1034', '297', '5', 'users297', '該訂單不存在或已關閉！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1035', '298', '5', 'users298', '描述相符', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1036', '299', '5', 'users299', '請在此處輸入您的評價', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1037', '300', '5', 'users300', '上傳圖片', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1038', '301', '5', 'users301', '限6張', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1039', '302', '5', 'users302', '請選擇全部商品評價分', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1040', '303', '5', 'users303', '請填寫全部商品評價內容', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1041', '304', '5', 'users304', '訂單已評價過', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1042', '305', '5', 'users305', '評價成功', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1043', '306', '5', 'users306', '評價失敗，請重試', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1044', '307', '5', 'users307', '我的评价', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1045', '308', '5', 'users308', '评价时间', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1046', '309', '5', 'users309', '差评', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1047', '310', '5', 'users310', '中评', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1048', '311', '5', 'users311', '好评', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1049', '312', '5', 'users312', '查看評價', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1050', '326', '5', 'users326', '我的足跡', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1051', '327', '5', 'users327', '訪問時間', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1052', '328', '5', 'users328', '確認批量刪除瀏覽記錄？', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1053', '329', '5', 'users329', '確認刪除該瀏覽記錄？', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1054', '330', '5', 'users330', '提醒成功！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1055', '331', '5', 'users331', '[商品已停售]', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1056', '332', '5', 'users332', '訂單不存在', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1057', '333', '5', 'users333', '未支付', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1058', '334', '5', 'users334', '在線支付', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1059', '335', '5', 'users335', '訂單已取消', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1060', '336', '5', 'users336', '該商品不存在或已下架！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1061', '337', '5', 'users337', '訂單支付異常，請刷新重新下單~', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1062', '338', '5', 'users338', '商品已售罄', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1063', '339', '5', 'users339', '超出商品庫存', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1064', '340', '5', 'users340', '退出登錄', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1065', '341', '5', 'users341', '註冊賬號', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1066', '346', '5', 'users346', '訂單已支付，即將跳轉', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1067', '347', '5', 'users347', '訂單已過期，即將跳轉', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1068', '348', '5', 'users348', '訂單已關閉，即將跳轉', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1069', '349', '5', 'users349', '訂單不存在或已變更', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1070', '350', '5', 'users350', '訂單處理中', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1071', '351', '5', 'users351', '訂單支付中', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1072', '352', '5', 'users352', '價格', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1073', '353', '5', 'users353', '最多允許上傳6張圖片', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1074', '354', '5', 'users354', '或將文件拖到這裏，本次最多可選%s個', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1075', '355', '5', 'users355', '點擊選擇圖片', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1076', '356', '5', 'users356', '共%s張（%s），已上傳%s張', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1077', '357', '5', 'users357', '繼續添加', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1078', '358', '5', 'users358', '確定使用', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1079', '359', '5', 'users359', '郵箱地址為系統禁止注册！', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1080', '360', '5', 'users360', '關於您的訂單的說明，例如交貨的特殊說明。', '1', 'zh', '100', '1733388335', '1733388335');
INSERT INTO `zan_language_pack` VALUES ('1081', '361', '5', 'users361', '信息', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1082', '362', '5', 'users362', '清空购物车', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1083', '363', '5', 'users363', '继续购物', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1084', '364', '5', 'users364', '联系信息', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1085', '365', '5', 'users365', '已经有一个帐户？', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1086', '366', '5', 'users366', '您的订单', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1087', '367', '5', 'users367', '查看购物车', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1088', '368', '5', 'users368', '付款方式', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1089', '369', '5', 'users369', '订单完成', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1090', '370', '5', 'users370', '谢谢你。你的订单已经收到了。', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1091', '371', '5', 'users371', '商家未配置支付信息', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1092', '372', '5', 'users372', '不可连续提交订单！', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1093', '373', '5', 'users373', '条评论', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1094', '374', '5', 'users374', '添加评论', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1095', '375', '5', 'users375', '您的电子邮件地址不会被公开。必填字段已标记', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1096', '376', '5', 'users376', '您的评分', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1097', '377', '5', 'users377', '您的评价', '1', 'cn', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1098', '361', '5', 'users361', 'information', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1099', '362', '5', 'users362', 'CLEAR SHOPPING CART', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1100', '363', '5', 'users363', 'CONTINUE SHOPPING', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1101', '364', '5', 'users364', 'Contact Information', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1102', '365', '5', 'users365', 'Already have an account ?', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1103', '366', '5', 'users366', 'Your Order', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1104', '367', '5', 'users367', 'View cart', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1105', '368', '5', 'users368', 'PAYMENT METHOD', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1106', '369', '5', 'users369', 'Order Complete', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1107', '370', '5', 'users370', 'Thank you. Your order has been received.', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1108', '371', '5', 'users371', 'The merchant has not configured payment information.', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1109', '372', '5', 'users372', 'Orders cannot be submitted continuously!', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1110', '373', '5', 'users373', 'review', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1111', '374', '5', 'users374', 'Add a review', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1112', '375', '5', 'users375', 'Your email address will not be published. Required fields are marked', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1113', '376', '5', 'users376', 'Your rating', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1114', '377', '5', 'users377', 'Your review', '1', 'en', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1115', '361', '5', 'users361', '信息', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1116', '362', '5', 'users362', '清空購物車', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1117', '363', '5', 'users363', '繼續購物', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1118', '364', '5', 'users364', '聯繫信息', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1119', '365', '5', 'users365', '已經有一個帳戶？', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1120', '366', '5', 'users366', '您的訂單', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1121', '367', '5', 'users367', '查看購物車', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1122', '368', '5', 'users368', '付款方式', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1123', '369', '5', 'users369', '訂單完成', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1124', '370', '5', 'users370', '謝謝你。你的訂單已經收到了。', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1125', '371', '5', 'users371', '商家未配寘支付信息', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1126', '372', '5', 'users372', '不可連續提交訂單！', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1127', '373', '5', 'users373', '條評論', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1128', '374', '5', 'users374', '添加評論', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1129', '375', '5', 'users375', '您的電子郵件地址不會被公開。必填字段已標記', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1130', '376', '5', 'users376', '您的評分', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1131', '377', '5', 'users377', '您的評價', '1', 'zh', '100', '1734915986', '1734915986');
INSERT INTO `zan_language_pack` VALUES ('1132', '378', '5', 'users378', '确定删除选中的商品？', '1', 'cn', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1133', '379', '5', 'users379', '部分商品库存数量不足，是否确认提交？', '1', 'cn', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1134', '380', '5', 'users380', '请至少选择一个商品', '1', 'cn', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1135', '381', '5', 'users381', '评价成功，需管理员审核后显示', '1', 'cn', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1136', '382', '1', 'sys382', '查看报价列表', '1', 'cn', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1137', '383', '1', 'sys383', '继续浏览', '1', 'cn', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1138', '384', '1', 'sys384', '确认执行删除操作?', '1', 'cn', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1139', '378', '5', 'users378', 'Are you sure you want to delete the selected item?', '1', 'en', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1140', '379', '5', 'users379', 'The stock quantity of some products is insufficient. Do you want to confirm the submission?', '1', 'en', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1141', '380', '5', 'users380', 'Please select at least one product', '1', 'en', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1142', '381', '5', 'users381', 'The evaluation is successful and needs to be displayed after review by the administrator.', '1', 'en', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1143', '382', '1', 'sys382', 'View Quote List', '1', 'en', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1144', '383', '1', 'sys383', 'Continue to Visit', '1', 'en', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1145', '384', '1', 'sys384', 'Confirm the deletion operation?', '1', 'en', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1146', '378', '5', 'users378', '確定刪除選中的商品？', '1', 'zh', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1147', '379', '5', 'users379', '部分商品庫存數量不足，是否確認提交？', '1', 'zh', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1148', '380', '5', 'users380', '請至少選擇一個商品', '1', 'zh', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1149', '381', '5', 'users381', '評價成功，需管理員審覈後顯示', '1', 'zh', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1150', '382', '1', 'sys382', '查看報價列表', '1', 'zh', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1151', '383', '1', 'sys383', '繼續瀏覽', '1', 'zh', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1152', '384', '1', 'sys384', '確認執行刪除操作?', '1', 'zh', '100', '1740102340', '1740102340');
INSERT INTO `zan_language_pack` VALUES ('1153', '1', '99', 'diy1', '获取报价', '0', 'cn', '100', '1740102464', '1740102464');
INSERT INTO `zan_language_pack` VALUES ('1154', '1', '99', 'diy1', '獲取報價', '0', 'zh', '100', '1740102464', '1740102464');
INSERT INTO `zan_language_pack` VALUES ('1155', '1', '99', 'diy1', 'Get a quote', '0', 'en', '100', '1740102464', '1740102464');
INSERT INTO `zan_language_pack` VALUES ('1156', '2', '99', 'diy2', '如果您对我们的产品系列或服务有任何疑问，请填写下面的联系表格，我们会立即与您联系。', '0', 'cn', '100', '1740102504', '1740102504');
INSERT INTO `zan_language_pack` VALUES ('1157', '2', '99', 'diy2', '如果您對我們的產品系列或服務有任何疑問，請填寫下面的聯繫表格，我們會立即與您聯繫。', '0', 'zh', '100', '1740102504', '1740102504');
INSERT INTO `zan_language_pack` VALUES ('1158', '2', '99', 'diy2', 'If you have a query regarding our product range or services, please complete the contact form below and we\'ll contact you straight away.', '0', 'en', '100', '1740102504', '1740102504');
INSERT INTO `zan_language_pack` VALUES ('1159', '3', '99', 'diy3', '您的报价列表是空的。', '0', 'cn', '100', '1740102546', '1740102546');
INSERT INTO `zan_language_pack` VALUES ('1160', '3', '99', 'diy3', '您的報價列表是空的。', '0', 'zh', '100', '1740102546', '1740102546');
INSERT INTO `zan_language_pack` VALUES ('1161', '3', '99', 'diy3', 'Your quote list is empty.', '0', 'en', '100', '1740102546', '1740102546');
INSERT INTO `zan_language_pack` VALUES ('1162', '4', '99', 'diy4', '返回商店', '0', 'cn', '100', '1740102558', '1740102558');
INSERT INTO `zan_language_pack` VALUES ('1163', '4', '99', 'diy4', '返回商店', '0', 'zh', '100', '1740102558', '1740102558');
INSERT INTO `zan_language_pack` VALUES ('1164', '4', '99', 'diy4', 'Return to shop', '0', 'en', '100', '1740102558', '1740102558');
INSERT INTO `zan_language_pack` VALUES ('1165', '5', '99', 'diy5', '添加到报价列表', '0', 'cn', '100', '1740102570', '1740102570');
INSERT INTO `zan_language_pack` VALUES ('1166', '5', '99', 'diy5', '添加到報價列表', '0', 'zh', '100', '1740102570', '1740102570');
INSERT INTO `zan_language_pack` VALUES ('1167', '5', '99', 'diy5', 'Add to Quote List', '0', 'en', '100', '1740102570', '1740102570');

-- -----------------------------
-- Table structure for `zan_links`
-- -----------------------------
DROP TABLE IF EXISTS `zan_links`;
CREATE TABLE `zan_links` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL DEFAULT '0',
  `typeid` tinyint(1) DEFAULT '1' COMMENT '类型：1=文字链接，2=图片链接',
  `groupid` int(11) unsigned NOT NULL DEFAULT '1' COMMENT '分组id， 默认分组值为1',
  `title` varchar(50) DEFAULT '' COMMENT '网站标题',
  `url` varchar(100) DEFAULT '' COMMENT '网站地址',
  `logo` varchar(255) DEFAULT '' COMMENT '网站LOGO',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序号',
  `target` tinyint(1) DEFAULT '0' COMMENT '是否开启浏览器新窗口',
  `nofollow` tinyint(1) DEFAULT '0',
  `email` varchar(50) DEFAULT '',
  `intro` text COMMENT '网站简况',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态(1=显示，0=屏蔽)',
  `province_id` int(10) DEFAULT '0' COMMENT '省份',
  `city_id` int(10) DEFAULT '0' COMMENT '所在城市',
  `area_id` int(10) DEFAULT '0' COMMENT '所在区域',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `delete_time` int(11) DEFAULT '0' COMMENT '软删除时间',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `id` (`id`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='友情链接表';

-- -----------------------------
-- Records of `zan_links`
-- -----------------------------
INSERT INTO `zan_links` VALUES ('6', '1', '1', '1', '百度', 'http://www.baidu.com', '', '1', '1', '1', '', '', '1', '0', '0', '0', 'en', '0', '1524975826', '1730433357');
INSERT INTO `zan_links` VALUES ('7', '2', '1', '1', '腾讯', 'http://www.qq.com', '', '3', '1', '0', '', '', '1', '0', '0', '0', 'en', '0', '1524976095', '1610702997');
INSERT INTO `zan_links` VALUES ('8', '3', '1', '1', '新浪', 'http://www.sina.com.cn', '', '5', '1', '0', '', '', '1', '0', '0', '0', 'en', '0', '1532414285', '1730451865');
INSERT INTO `zan_links` VALUES ('9', '4', '1', '1', '淘宝', 'http://www.taobao.com', '', '7', '1', '0', '', '', '1', '0', '0', '0', 'en', '0', '1532414529', '1610703002');
INSERT INTO `zan_links` VALUES ('10', '5', '1', '1', '微博', 'http://www.weibo.com', '', '100', '1', '0', '', '', '1', '0', '0', '0', 'en', '0', '1532414726', '1610334638');

-- -----------------------------
-- Table structure for `zan_links_group`
-- -----------------------------
DROP TABLE IF EXISTS `zan_links_group`;
CREATE TABLE `zan_links_group` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `group_name` varchar(255) NOT NULL DEFAULT '' COMMENT '分组名称',
  `status` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '状态(1=显示，0=屏蔽)',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '排序号',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `id` (`id`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='友情链接分组';

-- -----------------------------
-- Records of `zan_links_group`
-- -----------------------------
INSERT INTO `zan_links_group` VALUES ('2', '1', '默认分组', '1', '100', 'en', '1610334638', '1610334638');

-- -----------------------------
-- Table structure for `zan_media_content`
-- -----------------------------
DROP TABLE IF EXISTS `zan_media_content`;
CREATE TABLE `zan_media_content` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `aid` int(10) NOT NULL DEFAULT '0' COMMENT '文档ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `courseware` varchar(200) NOT NULL DEFAULT '' COMMENT '课件地址',
  `courseware_free` enum('免费','收费') NOT NULL DEFAULT '免费' COMMENT '课件收费',
  `total_duration` int(10) NOT NULL DEFAULT '0' COMMENT '视频总时长',
  `total_video` int(10) NOT NULL DEFAULT '0' COMMENT '视频数',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `aid` (`aid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='视频附加表';


-- -----------------------------
-- Table structure for `zan_media_file`
-- -----------------------------
DROP TABLE IF EXISTS `zan_media_file`;
CREATE TABLE `zan_media_file` (
  `file_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '视频模型文件表',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档ID',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '文档标题',
  `file_name` varchar(200) NOT NULL DEFAULT '' COMMENT '文件名称',
  `file_title` varchar(200) NOT NULL DEFAULT '' COMMENT '选集标题',
  `file_url` text NOT NULL COMMENT '存储路径',
  `file_time` int(8) NOT NULL DEFAULT '0' COMMENT '文件时长',
  `file_ext` varchar(50) NOT NULL DEFAULT '' COMMENT '文件后缀名',
  `file_size` varchar(255) NOT NULL DEFAULT '' COMMENT '文件大小',
  `file_mime` varchar(200) NOT NULL DEFAULT '' COMMENT '文件类型',
  `uhash` varchar(200) NOT NULL DEFAULT '' COMMENT '自定义的一种加密方式，用于视频播放的权限验证',
  `md5file` varchar(200) NOT NULL DEFAULT '' COMMENT 'md5_file加密，可以检测上传/播放的视频文件是否损坏',
  `is_remote` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否远程 1-远程',
  `playcount` int(10) NOT NULL DEFAULT '0' COMMENT '播放次数',
  `gratis` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否试看，0不试看，1试看',
  `sort_order` smallint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上传时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`file_id`) USING BTREE,
  KEY `aid` (`aid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='视频附件表';


-- -----------------------------
-- Table structure for `zan_media_log`
-- -----------------------------
DROP TABLE IF EXISTS `zan_media_log`;
CREATE TABLE `zan_media_log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `users_id` int(10) DEFAULT '0' COMMENT '用户ID',
  `aid` int(10) DEFAULT '0' COMMENT '文档ID',
  `file_id` int(10) DEFAULT '0' COMMENT '视频ID',
  `ip` varchar(20) DEFAULT '' COMMENT 'ip',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '编辑时间',
  PRIMARY KEY (`log_id`),
  KEY `file_id` (`file_id`,`aid`,`users_id`) USING BTREE,
  KEY `aid` (`aid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='视频日志表';


-- -----------------------------
-- Table structure for `zan_media_order`
-- -----------------------------
DROP TABLE IF EXISTS `zan_media_order`;
CREATE TABLE `zan_media_order` (
  `order_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '媒体订单ID',
  `order_code` varchar(50) NOT NULL DEFAULT '' COMMENT '媒体订单编号',
  `users_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `mobile` varchar(20) DEFAULT '' COMMENT '手机',
  `order_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单状态：0未付款，1已付款',
  `order_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单应付总金额',
  `pay_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `pay_name` varchar(20) NOT NULL DEFAULT '' COMMENT '支付方式名称',
  `wechat_pay_type` varchar(20) NOT NULL DEFAULT '' COMMENT '微信支付时，标记使用的支付类型（扫码支付，微信内部，微信H5页面）',
  `pay_details` text COMMENT '支付时返回的数据，以serialize序列化后存入，用于后续查询。',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '视频文档ID',
  `product_name` varchar(100) DEFAULT '' COMMENT '视频文档名称',
  `product_litpic` varchar(500) DEFAULT '' COMMENT '视频文档封面图片',
  `lang` varchar(30) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned DEFAULT '0' COMMENT '下单时间',
  `update_time` int(11) unsigned DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `order_code` (`order_code`) USING BTREE,
  KEY `users_id` (`users_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='视频订单表';


-- -----------------------------
-- Table structure for `zan_media_play_record`
-- -----------------------------
DROP TABLE IF EXISTS `zan_media_play_record`;
CREATE TABLE `zan_media_play_record` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `users_id` int(10) DEFAULT '0' COMMENT '用户id',
  `aid` int(10) DEFAULT '0' COMMENT '课程id',
  `file_id` int(10) DEFAULT '0' COMMENT '文件id',
  `play_time` int(10) DEFAULT '0' COMMENT '播放时间',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(10) DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='视频播放时长表';


-- -----------------------------
-- Table structure for `zan_memgift`
-- -----------------------------
DROP TABLE IF EXISTS `zan_memgift`;
CREATE TABLE `zan_memgift` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `gift_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '礼品列表',
  `type` tinyint(3) NOT NULL DEFAULT '1' COMMENT '-1-实物,2-会员产品',
  `type_id` int(10) DEFAULT '0' COMMENT '类型为会员产品时的会员产品类型(users_type_manage)type_id',
  `score` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '所需积分',
  `litpic` varchar(250) NOT NULL DEFAULT '',
  `giftname` varchar(60) NOT NULL DEFAULT '',
  `num` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '兑换次数',
  `content` longtext COMMENT '礼品详情',
  `stock` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '库存总数',
  `lang` varchar(20) DEFAULT 'cn' COMMENT '语言标识',
  `is_del` tinyint(3) NOT NULL DEFAULT '0' COMMENT '0-正常,1-删除',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '礼品状态：1=显示，0=隐藏',
  `add_time` int(10) DEFAULT '0',
  `update_time` int(10) DEFAULT '0',
  `sort_order` int(10) DEFAULT '100' COMMENT '排序',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `gift_id` (`gift_id`,`lang`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='礼品兑换表';


-- -----------------------------
-- Table structure for `zan_memgiftget`
-- -----------------------------
DROP TABLE IF EXISTS `zan_memgiftget`;
CREATE TABLE `zan_memgiftget` (
  `gid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `giftname` char(60) NOT NULL DEFAULT '',
  `gift_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '礼品ID',
  `score` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '积分',
  `users_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态,0-待发货,1-已发货,2-退回,3-重发',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '姓名',
  `mobile` varchar(55) NOT NULL DEFAULT '' COMMENT '手机',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '地址',
  `lang` varchar(20) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(10) DEFAULT '0',
  `update_time` int(10) DEFAULT '0',
  `type_id` int(11) DEFAULT '0' COMMENT '兑换会员产品时,会员产品套餐(表::users_type_manage)type_id',
  PRIMARY KEY (`gid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='礼品兑换记录表';


-- -----------------------------
-- Table structure for `zan_nav_list`
-- -----------------------------
DROP TABLE IF EXISTS `zan_nav_list`;
CREATE TABLE `zan_nav_list` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nav_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '导航ID',
  `nav_name` varchar(200) NOT NULL DEFAULT '' COMMENT '导航名称',
  `parent_id` int(10) NOT NULL DEFAULT '0' COMMENT '上级菜单id',
  `topid` int(10) NOT NULL DEFAULT '0' COMMENT '顶级菜单id',
  `en_name` varchar(200) NOT NULL DEFAULT '' COMMENT '英文名称',
  `nav_url` varchar(200) NOT NULL DEFAULT '' COMMENT '导航链接',
  `position_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '导航位置',
  `host_id` int(11) unsigned NOT NULL DEFAULT '1' COMMENT '链接分组ID(1:基础链接; 2:分类链接; 3:文档链接)',
  `arctype_sync` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否与栏目同步',
  `type_id` int(10) NOT NULL DEFAULT '0' COMMENT '同步栏目的ID',
  `nav_pic` varchar(255) NOT NULL DEFAULT '' COMMENT '导航图片',
  `is_remote` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否远程图片',
  `target` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否打开新窗口，1=是，0=否',
  `nofollow` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否使用nofollow，1=是，0=否',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '启用 (1=正常，0=停用)',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '伪删除，1=是，0=否',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '100' COMMENT '排序号',
  `lang` varchar(20) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `nav_id` (`nav_id`,`lang`),
  KEY `position_id` (`position_id`) USING BTREE,
  KEY `type_id` (`type_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COMMENT='导航列表';

-- -----------------------------
-- Records of `zan_nav_list`
-- -----------------------------
INSERT INTO `zan_nav_list` VALUES ('2', '22', 'Contact Us', '0', '0', '', '', '1', '2', '1', '16', '', '0', '0', '0', '1', '0', '100', 'en', '1729156463', '1730773755');
INSERT INTO `zan_nav_list` VALUES ('5', '21', 'About Us', '0', '0', '', '', '1', '2', '1', '15', '', '0', '0', '0', '1', '0', '2', 'en', '1729156423', '1729244575');
INSERT INTO `zan_nav_list` VALUES ('8', '15', 'Product', '0', '0', '', '/product/', '1', '1', '1', '-2', '', '0', '0', '0', '1', '0', '3', 'en', '1728608636', '1730943306');
INSERT INTO `zan_nav_list` VALUES ('11', '16', 'News', '0', '0', '', '/article/', '1', '1', '1', '-3', '', '0', '1', '0', '1', '0', '4', 'en', '1728608910', '1730443390');
INSERT INTO `zan_nav_list` VALUES ('14', '14', 'Home', '0', '0', '', '/', '1', '1', '0', '-1', '', '0', '0', '0', '1', '0', '1', 'en', '1728551585', '1729241105');
INSERT INTO `zan_nav_list` VALUES ('17', '31', 'T-shirt', '23', '23', '', '', '2', '2', '1', '2', '', '0', '0', '0', '1', '0', '100', 'en', '1729214755', '1729480936');
INSERT INTO `zan_nav_list` VALUES ('20', '30', 'dress', '23', '23', '', '', '2', '2', '1', '1', '', '0', '0', '0', '1', '0', '100', 'en', '1729214747', '1729480934');
INSERT INTO `zan_nav_list` VALUES ('23', '24', 'News', '0', '0', '', '/article/', '2', '1', '0', '-3', '', '0', '0', '0', '1', '0', '100', 'en', '1729158021', '1730943312');
INSERT INTO `zan_nav_list` VALUES ('26', '23', 'Product', '0', '0', '', '/product/', '2', '1', '0', '-2', '', '0', '0', '0', '1', '0', '100', 'en', '1729158000', '1730943310');
INSERT INTO `zan_nav_list` VALUES ('29', '25', 'dress', '15', '15', '', '', '1', '2', '1', '1', '', '0', '0', '0', '1', '0', '100', 'en', '1729158798', '1729244621');
INSERT INTO `zan_nav_list` VALUES ('32', '26', 'T-shirt', '15', '15', '', '', '1', '2', '1', '2', '', '0', '0', '0', '1', '0', '100', 'en', '1729158815', '1729244587');
INSERT INTO `zan_nav_list` VALUES ('35', '27', 'sweater', '15', '15', '', '', '1', '2', '1', '7', '', '0', '0', '0', '1', '0', '100', 'en', '1729158826', '1729244618');
INSERT INTO `zan_nav_list` VALUES ('38', '28', 'skirt', '15', '15', '', '', '1', '2', '1', '8', '', '0', '0', '0', '1', '0', '100', 'en', '1729158836', '1729244615');
INSERT INTO `zan_nav_list` VALUES ('41', '29', 'trousers', '15', '15', '', '', '1', '2', '1', '9', '', '0', '0', '0', '1', '0', '100', 'en', '1729158847', '1729244612');
INSERT INTO `zan_nav_list` VALUES ('44', '32', 'sweater', '23', '23', '', '', '2', '2', '1', '7', '', '0', '0', '0', '1', '0', '100', 'en', '1729214770', '1729480938');
INSERT INTO `zan_nav_list` VALUES ('47', '33', 'Company News', '24', '24', '', '', '2', '2', '1', '5', '', '0', '0', '0', '1', '0', '100', 'en', '1730447857', '1730447857');
INSERT INTO `zan_nav_list` VALUES ('50', '34', 'Industry information', '24', '24', '', '', '2', '2', '1', '14', '', '0', '0', '0', '1', '0', '100', 'en', '1730447867', '1730447867');
INSERT INTO `zan_nav_list` VALUES ('53', '35', 'Case', '0', '0', '', '/all-images/', '1', '1', '1', '-4', '', '0', '0', '0', '1', '0', '5', 'en', '1740104175', '1740104198');
INSERT INTO `zan_nav_list` VALUES ('56', '36', 'FAQ', '0', '0', '', '', '1', '2', '1', '17', '', '0', '0', '0', '1', '0', '6', 'en', '1740104388', '1740104403');

-- -----------------------------
-- Table structure for `zan_nav_position`
-- -----------------------------
DROP TABLE IF EXISTS `zan_nav_position`;
CREATE TABLE `zan_nav_position` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `position_id` int(10) NOT NULL DEFAULT '0' COMMENT '导航列表ID',
  `position_name` varchar(200) DEFAULT '' COMMENT '导航列表名称',
  `sort_order` int(10) DEFAULT '0' COMMENT '排序号',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '伪删除，1=是，0=否',
  `lang` varchar(20) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `position_id` (`position_id`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='导航位置表';


-- -----------------------------
-- Table structure for `zan_other_pages`
-- -----------------------------
DROP TABLE IF EXISTS `zan_other_pages`;
CREATE TABLE `zan_other_pages` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '页面ID',
  `title` varchar(60) NOT NULL DEFAULT '' COMMENT '页面标题',
  `seo_title` varchar(200) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(200) DEFAULT '' COMMENT 'seo关键字',
  `seo_description` text COMMENT 'seo描述',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '多语言',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `id` (`id`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='TKD管理-其他页面列表';

-- -----------------------------
-- Records of `zan_other_pages`
-- -----------------------------
INSERT INTO `zan_other_pages` VALUES ('1', '1', '全部新闻', '', '', '', 'cn', '1740103146', '1740103146');
INSERT INTO `zan_other_pages` VALUES ('2', '1', '全部新闻', '', '', '', 'zh', '1740103146', '1740103146');
INSERT INTO `zan_other_pages` VALUES ('3', '1', '全部新闻', '', '', '', 'en', '1740103146', '1740103146');
INSERT INTO `zan_other_pages` VALUES ('4', '2', '全部产品', '', '', '', 'cn', '1740103146', '1740103146');
INSERT INTO `zan_other_pages` VALUES ('5', '2', '全部产品', '', '', '', 'zh', '1740103146', '1740103146');
INSERT INTO `zan_other_pages` VALUES ('6', '2', '全部产品', '', '', '', 'en', '1740103146', '1740103146');
INSERT INTO `zan_other_pages` VALUES ('7', '3', '全部案例', '', '', '', 'cn', '1740103146', '1740103146');
INSERT INTO `zan_other_pages` VALUES ('8', '3', '全部案例', '', '', '', 'zh', '1740103146', '1740103146');
INSERT INTO `zan_other_pages` VALUES ('9', '3', '全部案例', '', '', '', 'en', '1740103146', '1740103146');

-- -----------------------------
-- Table structure for `zan_pay_api_config`
-- -----------------------------
DROP TABLE IF EXISTS `zan_pay_api_config`;
CREATE TABLE `zan_pay_api_config` (
  `pay_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '支付接口配置ID，自增',
  `pay_name` varchar(64) NOT NULL DEFAULT '' COMMENT '支付接口配置名称，微信支付，支付宝支付...',
  `pay_mark` varchar(64) NOT NULL DEFAULT '' COMMENT '支付接口配置标识，wechat，alipay...',
  `pay_info` text NOT NULL COMMENT '支付接口配置信息，数组以序列化存储',
  `pay_terminal` varchar(100) NOT NULL DEFAULT '' COMMENT '支付时的终端，暂时预留',
  `system_built` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否属于系统内置，0否，1是',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0=关闭，1=开启)',
  `lang` varchar(30) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`pay_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='支付接口配置表';

-- -----------------------------
-- Records of `zan_pay_api_config`
-- -----------------------------
INSERT INTO `zan_pay_api_config` VALUES ('1', '微信支付', 'wechat', 'a:4:{s:14:\"is_open_wechat\";s:1:\"1\";s:5:\"appid\";s:0:\"\";s:5:\"mchid\";s:0:\"\";s:3:\"key\";s:0:\"\";}', 'a:3:{i:0;s:1:\"1\";i:1;s:1:\"2\";i:2;s:1:\"3\";}', '1', '1', 'cn', '1590111253', '1616490076');
INSERT INTO `zan_pay_api_config` VALUES ('2', '支付宝支付', 'alipay', 'a:8:{s:14:\"is_open_alipay\";s:1:\"1\";s:7:\"version\";s:1:\"0\";s:6:\"app_id\";s:0:\"\";s:20:\"merchant_private_key\";s:0:\"\";s:17:\"alipay_public_key\";s:0:\"\";s:7:\"account\";s:0:\"\";s:4:\"code\";s:0:\"\";s:2:\"id\";s:0:\"\";}', 'a:4:{s:8:\"computer\";i:0;s:6:\"c_mark\";i:0;s:6:\"mobile\";i:0;s:6:\"m_mark\";i:0;}', '1', '1', 'cn', '1590111253', '1636441870');
INSERT INTO `zan_pay_api_config` VALUES ('3', 'Paypal支付', 'Paypal', 'a:2:{s:8:\"business\";s:0:\"\";s:11:\"is_open_pay\";s:1:\"0\";}', '', '0', '1', 'cn', '1733272466', '1733361269');

-- -----------------------------
-- Table structure for `zan_product_attr`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_attr`;
CREATE TABLE `zan_product_attr` (
  `product_attr_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '产品属性id自增',
  `aid` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '产品id',
  `attr_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '属性id',
  `attr_value` text COMMENT '属性值',
  `attr_price` varchar(255) DEFAULT '' COMMENT '属性价格',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`product_attr_id`),
  KEY `aid` (`aid`) USING BTREE,
  KEY `attr_id` (`attr_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='产品表单属性值';


-- -----------------------------
-- Table structure for `zan_product_attribute`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_attribute`;
CREATE TABLE `zan_product_attribute` (
  `attr_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '属性id',
  `attr_name` varchar(60) DEFAULT '' COMMENT '属性名称',
  `typeid` int(11) unsigned DEFAULT '0' COMMENT '栏目id',
  `attr_index` tinyint(1) unsigned DEFAULT '0' COMMENT '0不需要检索 1关键字检索 2范围检索',
  `attr_input_type` tinyint(1) unsigned DEFAULT '0' COMMENT ' 0=文本框，1=下拉框，2=多行文本框',
  `attr_values` text COMMENT '可选值列表',
  `sort_order` int(11) unsigned DEFAULT '0' COMMENT '属性排序',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '是否已删除，0=否，1=是',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`attr_id`),
  KEY `cat_id` (`typeid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='产品表单属性表';


-- -----------------------------
-- Table structure for `zan_product_content`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_content`;
CREATE TABLE `zan_product_content` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COMMENT='文档主表 -- (产品)内容数据表';

-- -----------------------------
-- Records of `zan_product_content`
-- -----------------------------
INSERT INTO `zan_product_content` VALUES ('16', '33', '&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160S044T7.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160S044950.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160S045419.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160S045226.jpg&quot;/&gt;&lt;/p&gt;', '', '法式过膝蝴蝶结系带中长款高腰百褶雪纺复古连衣裙', '', '这条法式过膝蝴蝶结系带中长款高腰百褶雪纺复古连衣裙简直美炸了！它的设计超级精致，蝴蝶结系带增添了一份甜美感。中长款的长度很优雅，过膝的设计更是显得气质十足。高腰的款式能够很好地拉长腿部线条，让你瞬间拥有大长腿。百褶雪纺的材质，轻盈飘逸，走起路来仙气满满。', '这条法式过膝蝴蝶结系带中长款高腰百褶雪纺复古连衣裙简直美炸了！它的设计超级精致，蝴蝶结系带增添了一份甜美感。中长款的长度很优雅，过膝的设计更是显得气质十足。高腰的款式能够很好地拉长腿部线条，让你瞬间拥有大长腿。百褶雪纺的材质，轻盈飘逸，走起路来仙气满满。', '1729038643', '1729038643');
INSERT INTO `zan_product_content` VALUES ('7', '23', '&lt;p&gt;&lt;img class=&quot;desc-img-loaded&quot; src=&quot;/uploads/allimg/20241011/1-241011101Z03T.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-241011101Z03T.jpg&quot; usemap=&quot;#_sdmap_1&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); font-family: -apple-system, BlinkMacSystemFont, &amp;quot;Segoe UI&amp;quot;, Roboto, &amp;quot;Helvetica Neue&amp;quot;, Arial, &amp;quot;Noto Sans&amp;quot;, sans-serif, &amp;quot;Apple Color Emoji&amp;quot;, &amp;quot;Segoe UI Emoji&amp;quot;, &amp;quot;Segoe UI Symbol&amp;quot;, &amp;quot;Noto Color Emoji&amp;quot;; font-size: 12px; text-wrap: wrap; background-color: rgb(255, 255, 255); display: block; width: 790px;&quot;/&gt;&lt;img class=&quot;desc-img-loaded&quot; src=&quot;/uploads/allimg/20241011/1-241011101Z1561.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-241011101Z1561.jpg&quot; usemap=&quot;#_sdmap_2&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); font-family: -apple-system, BlinkMacSystemFont, &amp;quot;Segoe UI&amp;quot;, Roboto, &amp;quot;Helvetica Neue&amp;quot;, Arial, &amp;quot;Noto Sans&amp;quot;, sans-serif, &amp;quot;Apple Color Emoji&amp;quot;, &amp;quot;Segoe UI Emoji&amp;quot;, &amp;quot;Segoe UI Symbol&amp;quot;, &amp;quot;Noto Color Emoji&amp;quot;; font-size: 12px; text-wrap: wrap; background-color: rgb(255, 255, 255); display: block; width: 790px;&quot;/&gt;&lt;img class=&quot;desc-img-loaded&quot; src=&quot;/uploads/allimg/20241011/1-241011101Z1337.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-241011101Z1337.jpg&quot; usemap=&quot;#_sdmap_3&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); font-family: -apple-system, BlinkMacSystemFont, &amp;quot;Segoe UI&amp;quot;, Roboto, &amp;quot;Helvetica Neue&amp;quot;, Arial, &amp;quot;Noto Sans&amp;quot;, sans-serif, &amp;quot;Apple Color Emoji&amp;quot;, &amp;quot;Segoe UI Emoji&amp;quot;, &amp;quot;Segoe UI Symbol&amp;quot;, &amp;quot;Noto Color Emoji&amp;quot;; font-size: 12px; text-wrap: wrap; background-color: rgb(255, 255, 255); display: block; width: 790px;&quot;/&gt;&lt;img class=&quot;desc-img-loaded&quot; src=&quot;/uploads/allimg/20241011/1-241011101Z2423.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-241011101Z2423.jpg&quot; usemap=&quot;#_sdmap_4&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); font-family: -apple-system, BlinkMacSystemFont, &amp;quot;Segoe UI&amp;quot;, Roboto, &amp;quot;Helvetica Neue&amp;quot;, Arial, &amp;quot;Noto Sans&amp;quot;, sans-serif, &amp;quot;Apple Color Emoji&amp;quot;, &amp;quot;Segoe UI Emoji&amp;quot;, &amp;quot;Segoe UI Symbol&amp;quot;, &amp;quot;Noto Color Emoji&amp;quot;; font-size: 12px; text-wrap: wrap; background-color: rgb(255, 255, 255); display: block; width: 790px;&quot;/&gt;&lt;img class=&quot;desc-img-loaded&quot; src=&quot;/uploads/allimg/20241011/1-241011101Z29D.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-241011101Z29D.jpg&quot; usemap=&quot;#_sdmap_5&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); font-family: -apple-system, BlinkMacSystemFont, &amp;quot;Segoe UI&amp;quot;, Roboto, &amp;quot;Helvetica Neue&amp;quot;, Arial, &amp;quot;Noto Sans&amp;quot;, sans-serif, &amp;quot;Apple Color Emoji&amp;quot;, &amp;quot;Segoe UI Emoji&amp;quot;, &amp;quot;Segoe UI Symbol&amp;quot;, &amp;quot;Noto Color Emoji&amp;quot;; font-size: 12px; text-wrap: wrap; background-color: rgb(255, 255, 255); display: block; width: 790px;&quot;/&gt;&lt;/p&gt;&lt;br/&gt;', '', '纯色翻领收腰系带气质开叉连衣长裙', '', '', '', '1728613140', '1728613140');
INSERT INTO `zan_product_content` VALUES ('8', '24', '&lt;p&gt;&lt;img class=&quot;desc-img-loaded&quot; src=&quot;/uploads/allimg/20241011/1-2410111531013W.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-2410111531013W.jpg&quot; alt=&quot;主图&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); font-family: &amp;quot;Hiragino Sans GB&amp;quot;, Tahoma, Arial, 宋体, sans-serif; font-size: 12px; text-align: center; text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;br class=&quot;img-brk&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; color: rgb(51, 51, 51); font-family: &amp;quot;Hiragino Sans GB&amp;quot;, Tahoma, Arial, 宋体, sans-serif; font-size: 12px; text-align: center; text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;br class=&quot;img-brk&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; color: rgb(51, 51, 51); font-family: &amp;quot;Hiragino Sans GB&amp;quot;, Tahoma, Arial, 宋体, sans-serif; font-size: 12px; text-align: center; text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;img class=&quot;desc-img-loaded&quot; src=&quot;/uploads/allimg/20241011/1-2410111531011Z.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-2410111531011Z.jpg&quot; alt=&quot;DM_20240809162205_004&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); font-family: &amp;quot;Hiragino Sans GB&amp;quot;, Tahoma, Arial, 宋体, sans-serif; font-size: 12px; text-align: center; text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;br class=&quot;img-brk&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; color: rgb(51, 51, 51); font-family: &amp;quot;Hiragino Sans GB&amp;quot;, Tahoma, Arial, 宋体, sans-serif; font-size: 12px; text-align: center; text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;br class=&quot;img-brk&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; color: rgb(51, 51, 51); font-family: &amp;quot;Hiragino Sans GB&amp;quot;, Tahoma, Arial, 宋体, sans-serif; font-size: 12px; text-align: center; text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;img class=&quot;desc-img-loaded&quot; src=&quot;/uploads/allimg/20241011/1-2410111531023S.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-2410111531023S.jpg&quot; alt=&quot;DM_20240809162205_001&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); font-family: &amp;quot;Hiragino Sans GB&amp;quot;, Tahoma, Arial, 宋体, sans-serif; font-size: 12px; text-align: center; text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;/p&gt;', '', '长袖纯色长裙纯色收腰连衣裙', '', '', '', '1728631860', '1728631860');
INSERT INTO `zan_product_content` VALUES ('9', '25', '', '', '气质优雅提花宽松长袖连衣裙', '', '', '', '1728633459', '1728633459');
INSERT INTO `zan_product_content` VALUES ('10', '26', '&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20241011/1-241011162105c9.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-241011162105c9.jpg&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); text-align: center; text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20241011/1-24101116210E92.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-24101116210E92.jpg&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); text-align: center; text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20241011/1-241011162106127.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-241011162106127.jpg&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); text-align: center; text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;/p&gt;', '', '修身包臀一字肩针织鱼尾裙连衣裙', '', '', '', '1728634864', '1728634864');
INSERT INTO `zan_product_content` VALUES ('11', '27', '&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20241011/1-2410111F2063S.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-2410111F2063S.jpg&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20241011/1-2410111F20OG.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-2410111F20OG.jpg&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20241011/1-2410111F20S28.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-2410111F20S28.jpg&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20241011/1-2410111F20UN.jpg&quot; data-lazyload-src=&quot;/uploads/allimg/20241011/1-2410111F20UN.jpg&quot; style=&quot;box-sizing: border-box; text-size-adjust: 100%; -webkit-tap-highlight-color: transparent; margin: 0px; padding: 0px; outline: none; border: 0px; vertical-align: bottom; max-width: 790px; color: rgb(51, 51, 51); text-wrap: wrap; background-color: rgb(255, 255, 255);&quot;/&gt;&lt;/p&gt;', '', '西装领黑白拼接七分袖收腰包臀连衣裙', '', '', '', '1728637325', '1728637325');
INSERT INTO `zan_product_content` VALUES ('17', '34', '&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160S6164B.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160S616233.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160S616396.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '', '撞色大翻领收腰开衩牛仔A字裙', '', '这条撞色大翻领收腰开衩牛仔 A 字裙真的太绝啦！首先，撞色大翻领的设计超级吸睛，让你在人群中瞬间脱颖而出。收腰的设计能够很好地展现身材曲线，凸显小蛮腰。而开衩的元素则增添了一份小性感，走起路来更加灵动。A 字裙的版型非常百搭，无论是搭配简约的 T 恤还是精致的衬衫，都能轻松打造出不同的风格。', '这条撞色大翻领收腰开衩牛仔 A 字裙真的太绝啦！首先，撞色大翻领的设计超级吸睛，让你在人群中瞬间脱颖而出。收腰的设计能够很好地展现身材曲线，凸显小蛮腰。而开衩的元素则增添了一份小性感，走起路来更加灵动。A 字裙的版型非常百搭，无论是搭配简约的 T 恤还是精致的衬衫，都能轻松打造出不同的风格。', '1729038975', '1729038975');
INSERT INTO `zan_product_content` VALUES ('18', '35', '&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160T309626.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160T310N5.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160T310423.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160T310296.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160T311121.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20241016/1-2410160T311W7.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '', '雪纺拼接假两件套溜肩拼接收腰显瘦包臀裙', '', '雪纺材质，轻盈飘逸，触感超棒。假两件的设计，独特又时尚，让你瞬间脱颖而出。溜肩拼接的款式，巧妙地修饰了肩部线条。收腰设计，显瘦效果一绝，凸显你的小蛮腰。包臀裙的版型，展现迷人曲线，性感又优雅。', '雪纺材质，轻盈飘逸，触感超棒。假两件的设计，独特又时尚，让你瞬间脱颖而出。溜肩拼接的款式，巧妙地修饰了肩部线条。收腰设计，显瘦效果一绝，凸显你的小蛮腰。包臀裙的版型，展现迷人曲线，性感又优雅。', '1729039389', '1729039389');
INSERT INTO `zan_product_content` VALUES ('23', '40', '', '', 'sdfdsfsfdsfsa', '', '', '', '1729041908', '1729041908');
INSERT INTO `zan_product_content` VALUES ('24', '41', '&lt;p&gt;\r\n    &lt;img src=&quot;https://cbu01.alicdn.com/img/ibank/O1CN01jAVjkI28VevRN7gMo_!!1665777938-0-cib.jpg&quot; /&gt;\r\n&lt;/p&gt;\r\n&lt;p&gt;\r\n    &lt;img src=&quot;https://cbu01.alicdn.com/img/ibank/O1CN01lxRqI628VevRN7Ttw_!!1665777938-0-cib.jpg&quot;/&gt;\r\n&lt;/p&gt;\r\n&lt;p&gt;\r\n    &lt;img src=&quot;https://cbu01.alicdn.com/img/ibank/O1CN015VJkPN28VevVOtbH1_!!1665777938-0-cib.jpg&quot;/&gt;\r\n&lt;/p&gt;\r\n&lt;p&gt;\r\n    &lt;img src=&quot;https://cbu01.alicdn.com/img/ibank/O1CN01fznkvB28VevRR99K5_!!1665777938-0-cib.jpg&quot;/&gt;\r\n&lt;/p&gt;\r\n&lt;p&gt;\r\n    &lt;br/&gt;\r\n&lt;/p&gt;', '', '法式衬衫设计感一字领上衣夏季小衫', '', '法式衬衫设计感一字领上衣，真的是夏季的宝藏小衫！第一眼看到它，就被那优雅的设计所吸引。一字领的设计，恰到好处地展现出迷人的锁骨和肩线，尽显女性的柔美与性感。这款上衣的材质也非常舒适，透气又轻薄，在炎热的夏天穿起来也不会觉得闷热。而且它的颜色选择也很多，无论是清新的白色、温柔的粉色还是经典的黑色，都能轻松搭配出不同的风格。搭配一条短裙，瞬间变身甜美少女；搭配牛仔裤，则显得时尚又休闲。无论是约会、逛街还是度假，这件上衣都能让你成为焦点。', '法式衬衫设计感一字领上衣，真的是夏季的宝藏小衫！第一眼看到它，就被那优雅的设计所吸引。一字领的设计，恰到好处地展现出迷人的锁骨和肩线，尽显女性的柔美与性感。这款上衣的材质也非常舒适，透气又轻薄，在炎热的夏天穿起来也不会觉得闷热。而且它的颜色选择也很多，无论是清新的白色、温柔的粉色还是经典的黑色，都能轻松搭配出不同的风格。搭配一条短裙，瞬间变身甜美少女；搭配牛仔裤，则显得时尚又休闲。无论是约会、逛街还是度假，这件上衣都能让你成为焦点。', '1729070729', '1729070729');

-- -----------------------------
-- Table structure for `zan_product_content_cn`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_content_cn`;
CREATE TABLE `zan_product_content_cn` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COMMENT='文档主表 -- (产品)内容数据表';


-- -----------------------------
-- Table structure for `zan_product_content_en`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_content_en`;
CREATE TABLE `zan_product_content_en` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='文档主表 -- (产品)内容数据表';

-- -----------------------------
-- Records of `zan_product_content_en`
-- -----------------------------
INSERT INTO `zan_product_content_en` VALUES ('3', '23', '&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20241011/1-241011154542133.jpg&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20241011/1-241011154543S8.jpg&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20241011/1-241011154544R5.jpg&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20241011/1-241011154545913.jpg&quot;/&gt;&lt;/p&gt;', '', 'Spring and summer new solid color crew neck pleated lace-up dress', '', '', 'This is a new dress launched in spring and summer. It is characterized by a solid color design without complex patterns. Crew neck style with a round neckline. There are pleated elements, which may have pleated decoration on the skirt or other parts, adding a sense of three-dimensional and layered. With a tie, you can adjust the tightness of the waist or other parts by lacing.', '1728613215', '1728639292');
INSERT INTO `zan_product_content_en` VALUES ('4', '24', '&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154S4U8.webp&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154S5S8.webp&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align: center;&quot;&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154S6434.webp&quot;/&gt;&lt;/p&gt;', '', 'Solid color waist V-neck sleeveless party dress skirt', '', 'This dress is designed in a solid color, which is simple and atmospheric, without too much decoration, showing an elegant temperament. The V-neck design can lengthen the neck line and highlight the sexy charm of women. The sleeveless style is more refreshing and neat, suitable for showing vitality and confidence in parties and other occasions. The waist design can highlight the curves of women\'s bodies and make the wearer more attractive. At the same time, the waist design can also improve the o', 'This dress is designed in a solid color, which is simple and atmospheric, without too much decoration, showing an elegant temperament. The V-neck design can lengthen the neck line and highlight the sexy charm of women. The sleeveless style is more refreshing and neat, suitable for showing vitality and confidence in parties and other occasions. The waist design can highlight the curves of women\'s bodies and make the wearer more attractive. At the same time, the waist design can also improve the o', '1728633173', '1740124113');
INSERT INTO `zan_product_content_en` VALUES ('9', '33', '&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154920W2.webp&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154922N7.webp&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154924130.webp&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-25022115492D10.webp&quot;/&gt;&lt;/p&gt;', '', 'French over-knee bow strap medium and long high-waisted pleated chiffon retro dress', '', 'This French knee-length bow-tie mid-length high-waisted pleated chiffon vintage dress is simply beautiful! Its design is super delicate, and the bow-tie adds a sweet touch. The length of the mid-length style is very elegant, and the knee-length design is full of temperament. The high-waisted style can elongate the leg lines well, allowing you to instantly have long legs. The pleated chiffon material is light and elegant, and it is full of fairy energy when walking.', 'This French knee-length bow-tie mid-length high-waisted pleated chiffon vintage dress is simply beautiful! Its design is super delicate, and the bow-tie adds a sweet touch. The length of the mid-length style is very elegant, and the knee-length design is full of temperament. The high-waisted style can elongate the leg lines well, allowing you to instantly have long legs. The pleated chiffon material is light and elegant, and it is full of fairy energy when walking.', '1729038726', '1740124157');
INSERT INTO `zan_product_content_en` VALUES ('10', '34', '&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-25022115493C17.webp&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-25022115493H53.webp&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-25022115493Y48.webp&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '', 'Contrast color large lapel waist slit denim A-shaped skirt', '', 'This contrasting large lapel neck waist slit denim A-shaped skirt is really amazing! First of all, the contrasting large lapel collar design is super eye-catching, making you stand out in the crowd instantly. The waist design can well show the curve of the figure and highlight the small waist. The slit element adds a little sexiness and makes it more agile to walk. The version of the A-shaped skirt is very versatile, whether it is matched with a simple T-shirt or a delicate shirt, it can easily', 'This contrasting large lapel neck waist slit denim A-shaped skirt is really amazing! First of all, the contrasting large lapel collar design is super eye-catching, making you stand out in the crowd instantly. The waist design can well show the curve of the figure and highlight the small waist. The slit element adds a little sexiness and makes it more agile to walk. The version of the A-shaped skirt is very versatile, whether it is matched with a simple T-shirt or a delicate shirt, it can easily', '1729038975', '1740124175');
INSERT INTO `zan_product_content_en` VALUES ('7', '27', '&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154Z4T6.webp&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154Z5238.webp&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154Z63b.webp&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154ZO21.webp&quot;/&gt;&lt;/p&gt;', '', 'suit collar black and white splicing seven-quarter sleeve waist and hip dress', '', 'This is a dress with a unique design. It uses a suit collar design, which looks very neat. The color is black and white splicing, which is classic and fashionable. The seven-quarter sleeve design adds a bit of elegance and a certain practicality. At the same time, this dress also has a waist design, which can highlight the wearer\'s slender waist. The hip wrap style shows the curvature of women.', 'This is a dress with a unique design. It uses a suit collar design, which looks very neat. The color is black and white splicing, which is classic and fashionable. The seven-quarter sleeve design adds a bit of elegance and a certain practicality. At the same time, this dress also has a waist design, which can highlight the wearer\'s slender waist. The hip wrap style shows the curvature of women.', '1728637484', '1740124143');
INSERT INTO `zan_product_content_en` VALUES ('5', '25', '&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154P9323.webp&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154Q0964.webp&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154Q1208.jpg&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154Q33E.webp&quot;/&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center&quot;&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154QM58.webp&quot;/&gt;&lt;/p&gt;', '', 'Elegant Jacquard Loose Long Sleeve Dress', '', 'This dress features a jacquard design that adds texture and three-dimensionality to the outfit. The loose long-sleeved design is both comfortable and stylish, covering the fat on the arms. The overall style is elegant and generous, suitable for all occasions.', 'This dress features a jacquard design that adds texture and three-dimensionality to the outfit. The loose long-sleeved design is both comfortable and stylish, covering the fat on the arms. The overall style is elegant and generous, suitable for all occasions.', '1728634536', '1740124087');
INSERT INTO `zan_product_content_en` VALUES ('6', '26', '&lt;p&gt;{/zanCms}{/zanCms}{/zanCms}&lt;/p&gt;', '', 'Slim-fit hip-wrapped shoulder-knitted fishtail dress dress', '', 'This dress uses a one-word shoulder design, which can show the beautiful shoulder line and collarbone of women. The slim-fitting hip-wrapping style can highlight the curves of women\'s bodies, and the fishtail skirt adds a sense of dynamics and elegance to the skirt.', 'This dress uses a one-word shoulder design, which can show the beautiful shoulder line and collarbone of women. The slim-fitting hip-wrapping style can highlight the curves of women\'s bodies, and the fishtail skirt adds a sense of dynamics and elegance to the skirt.', '1728634895', '1740124127');
INSERT INTO `zan_product_content_en` VALUES ('13', '35', '&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-25022115494bU.webp&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154951412.webp&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154952335.webp&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154953116.webp&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-2502211549554H.webp&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/uploads/allimg/20250221/1-250221154956496.webp&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '', 'Chiffon splicing fake two-piece set, shoulder-slipping splicing waist and thin hip skirt', '', 'Chiffon material, light and elegant, great touch. The design of the fake two pieces is unique and fashionable, making you stand out in an instant. The style of shoulder-slipping splicing cleverly modifies the shoulder lines. The waist design shows a slimming effect, highlighting your small waist. The version of the hip skirt shows attractive curves, sexy and elegant.', 'Chiffon material, light and elegant, great touch. The design of the fake two pieces is unique and fashionable, making you stand out in an instant. The style of shoulder-slipping splicing cleverly modifies the shoulder lines. The waist design shows a slimming effect, highlighting your small waist. The version of the hip skirt shows attractive curves, sexy and elegant.', '1729128655', '1740124188');
INSERT INTO `zan_product_content_en` VALUES ('12', '40', '', '', 'sdfdsfsfdsfsa', '', '', '', '1729068955', '1729068955');
INSERT INTO `zan_product_content_en` VALUES ('14', '41', '&lt;p&gt;\r\n    &lt;img src=&quot;/uploads/allimg/20241017/1-24101F93425446.jpg&quot;/&gt;\r\n&lt;/p&gt;\r\n&lt;p&gt;\r\n    &lt;img src=&quot;/uploads/allimg/20241017/1-24101F93425252.jpg&quot;/&gt;\r\n&lt;/p&gt;\r\n&lt;p&gt;\r\n    &lt;img src=&quot;/uploads/allimg/20241017/1-24101F93424602.jpg&quot;/&gt;\r\n&lt;/p&gt;\r\n&lt;p&gt;\r\n    &lt;img src=&quot;/uploads/allimg/20241017/1-24101F934245G.jpg&quot;/&gt;\r\n&lt;/p&gt;\r\n&lt;p&gt;\r\n    &lt;br/&gt;\r\n&lt;/p&gt;', '', 'French shirt design one-letter collar top summer shirt', 'shirt', 'The French shirt design with a one-word collar top is really a treasure shirt for summer! At first sight, I was attracted by the elegant design. The one-word collar design just shows the charming collarbone and shoulder', 'French shirt design with a one-word collar top, it is really a summer treasure shirt! At first sight, I was attracted by the elegant design. The one-word collar design just shows the charming collarbone and shoulder line, showing the femininity and sexiness. The material of this top is also very comfortable, breathable and light, and it will not feel stuffy to wear in the hot summer.\r\nAnd there are many color options, whether it is fresh white, gentle pink or classic black, it can be easily matched with different styles. With a short skirt, it instantly transforms into a sweet girl; with jeans, it looks stylish and casual. Whether it is a date, shopping or vacation, this top can make you the center of attention.', '1729128864', '1730886258');

-- -----------------------------
-- Table structure for `zan_product_content_zh`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_content_zh`;
CREATE TABLE `zan_product_content_zh` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='文档主表 -- (产品)内容数据表';


-- -----------------------------
-- Table structure for `zan_product_img`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_img`;
CREATE TABLE `zan_product_img` (
  `img_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `title` varchar(255) DEFAULT '' COMMENT '图片标题',
  `image_url` varchar(255) DEFAULT '' COMMENT '图片存储路径',
  `intro` varchar(255) DEFAULT '' COMMENT '图片描述',
  `width` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '图片宽度',
  `height` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '图片高度',
  `filesize` varchar(255) DEFAULT '' COMMENT '文件大小',
  `mime` varchar(50) DEFAULT '' COMMENT '图片类型',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`img_id`),
  KEY `arcid` (`aid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=61 DEFAULT CHARSET=utf8 COMMENT='产品图片表';

-- -----------------------------
-- Records of `zan_product_img`
-- -----------------------------
INSERT INTO `zan_product_img` VALUES ('1', '23', '春夏新款纯色圆领褶皱系带连衣裙', '/uploads/allimg/20241011/1-24101115450Lc.jpg', '', '1200', '1200', '352521', 'image/jpeg', '4', '1730766606', '1730766606');
INSERT INTO `zan_product_img` VALUES ('2', '23', '春夏新款纯色圆领褶皱系带连衣裙', '/uploads/allimg/20241011/1-24101115450G41.jpg', '', '1200', '1200', '329555', 'image/jpeg', '3', '1730766606', '1730766606');
INSERT INTO `zan_product_img` VALUES ('3', '23', '春夏新款纯色圆领褶皱系带连衣裙', '/uploads/allimg/20241011/1-24101115450NX.jpg', '', '1200', '1200', '433059', 'image/jpeg', '2', '1730766606', '1730766606');
INSERT INTO `zan_product_img` VALUES ('41', '24', 'Solid color waist V-neck sleeveless party dress skirt', '/uploads/allimg/20241011/1-241011155032A8.jpg', '', '0', '0', '0', '', '4', '1740124113', '1740124113');
INSERT INTO `zan_product_img` VALUES ('40', '24', 'Solid color waist V-neck sleeveless party dress skirt', '/uploads/allimg/20241011/1-241011155032P5.jpg', '', '0', '0', '0', '', '3', '1740124113', '1740124113');
INSERT INTO `zan_product_img` VALUES ('39', '24', 'Solid color waist V-neck sleeveless party dress skirt', '/uploads/allimg/20241011/1-241011155032234.jpg', '', '0', '0', '0', '', '2', '1740124113', '1740124113');
INSERT INTO `zan_product_img` VALUES ('38', '24', 'Solid color waist V-neck sleeveless party dress skirt', '/uploads/allimg/20241011/1-241011155033592.jpg', '', '0', '0', '0', '', '1', '1740124113', '1740124113');
INSERT INTO `zan_product_img` VALUES ('37', '25', 'Elegant Jacquard Loose Long Sleeve Dress', '/uploads/allimg/20241011/1-241011155AJI.jpg', '', '0', '0', '0', '', '3', '1740124087', '1740124087');
INSERT INTO `zan_product_img` VALUES ('36', '25', 'Elegant Jacquard Loose Long Sleeve Dress', '/uploads/allimg/20241011/1-241011155AJ19.jpg', '', '0', '0', '0', '', '2', '1740124087', '1740124087');
INSERT INTO `zan_product_img` VALUES ('35', '25', 'Elegant Jacquard Loose Long Sleeve Dress', '/uploads/allimg/20241011/1-241011155AH15.jpg', '', '0', '0', '0', '', '1', '1740124087', '1740124087');
INSERT INTO `zan_product_img` VALUES ('45', '26', 'Slim-fit hip-wrapped shoulder-knitted fishtail dress dress', '/uploads/allimg/20241011/1-241011162054918.jpg', '', '0', '0', '0', '', '4', '1740124127', '1740124127');
INSERT INTO `zan_product_img` VALUES ('44', '26', 'Slim-fit hip-wrapped shoulder-knitted fishtail dress dress', '/uploads/allimg/20241011/1-2410111620531I.jpg', '', '0', '0', '0', '', '3', '1740124127', '1740124127');
INSERT INTO `zan_product_img` VALUES ('43', '26', 'Slim-fit hip-wrapped shoulder-knitted fishtail dress dress', '/uploads/allimg/20241011/1-241011162053Z2.jpg', '', '0', '0', '0', '', '2', '1740124127', '1740124127');
INSERT INTO `zan_product_img` VALUES ('42', '26', 'Slim-fit hip-wrapped shoulder-knitted fishtail dress dress', '/uploads/allimg/20241011/1-241011162053330.jpg', '', '0', '0', '0', '', '1', '1740124127', '1740124127');
INSERT INTO `zan_product_img` VALUES ('49', '27', 'Suit Collar Black And White Splicing Seven-quarter Sleeve Waist And Hip Dress', '/uploads/allimg/20241011/1-2410111F145203.jpg', '', '0', '0', '0', '', '4', '1740124143', '1740124143');
INSERT INTO `zan_product_img` VALUES ('48', '27', 'Suit Collar Black And White Splicing Seven-quarter Sleeve Waist And Hip Dress', '/uploads/allimg/20241011/1-2410111F145427.jpg', '', '0', '0', '0', '', '3', '1740124143', '1740124143');
INSERT INTO `zan_product_img` VALUES ('47', '27', 'Suit Collar Black And White Splicing Seven-quarter Sleeve Waist And Hip Dress', '/uploads/allimg/20241011/1-2410111F1455I.jpg', '', '0', '0', '0', '', '2', '1740124143', '1740124143');
INSERT INTO `zan_product_img` VALUES ('46', '27', 'Suit Collar Black And White Splicing Seven-quarter Sleeve Waist And Hip Dress', '/uploads/allimg/20241011/1-2410111F145953.jpg', '', '0', '0', '0', '', '1', '1740124143', '1740124143');
INSERT INTO `zan_product_img` VALUES ('52', '33', 'French over-knee bow strap medium and long high-waisted pleated chiffon retro dress', '/uploads/allimg/20241016/1-2410160R944930.jpg', '', '0', '0', '0', '', '3', '1740124157', '1740124157');
INSERT INTO `zan_product_img` VALUES ('51', '33', 'French over-knee bow strap medium and long high-waisted pleated chiffon retro dress', '/uploads/allimg/20241016/1-2410160R944647.jpg', '', '0', '0', '0', '', '2', '1740124157', '1740124157');
INSERT INTO `zan_product_img` VALUES ('50', '33', 'French over-knee bow strap medium and long high-waisted pleated chiffon retro dress', '/uploads/allimg/20241016/1-2410160R944S8.jpg', '', '0', '0', '0', '', '1', '1740124157', '1740124157');
INSERT INTO `zan_product_img` VALUES ('56', '34', 'Contrast color large lapel waist slit denim A-shaped skirt', '/uploads/allimg/20241016/1-2410160S53G26.jpg', '', '0', '0', '0', '', '4', '1740124175', '1740124175');
INSERT INTO `zan_product_img` VALUES ('55', '34', 'Contrast color large lapel waist slit denim A-shaped skirt', '/uploads/allimg/20241016/1-2410160S53L01.jpg', '', '0', '0', '0', '', '3', '1740124175', '1740124175');
INSERT INTO `zan_product_img` VALUES ('54', '34', 'Contrast color large lapel waist slit denim A-shaped skirt', '/uploads/allimg/20241016/1-2410160S53HX.jpg', '', '0', '0', '0', '', '2', '1740124175', '1740124175');
INSERT INTO `zan_product_img` VALUES ('53', '34', 'Contrast color large lapel waist slit denim A-shaped skirt', '/uploads/allimg/20241016/1-2410160S5361C.jpg', '', '0', '0', '0', '', '1', '1740124175', '1740124175');
INSERT INTO `zan_product_img` VALUES ('60', '35', 'Chiffon splicing fake two-piece set, shoulder-slipping splicing waist and thin hip skirt', '/uploads/allimg/20241016/1-2410160T13TF.jpg', '', '0', '0', '0', '', '4', '1740124188', '1740124188');
INSERT INTO `zan_product_img` VALUES ('59', '35', 'Chiffon splicing fake two-piece set, shoulder-slipping splicing waist and thin hip skirt', '/uploads/allimg/20241016/1-2410160T13W09.jpg', '', '0', '0', '0', '', '3', '1740124188', '1740124188');
INSERT INTO `zan_product_img` VALUES ('58', '35', 'Chiffon splicing fake two-piece set, shoulder-slipping splicing waist and thin hip skirt', '/uploads/allimg/20241016/1-2410160T13G54.jpg', '', '0', '0', '0', '', '2', '1740124188', '1740124188');
INSERT INTO `zan_product_img` VALUES ('57', '35', 'Chiffon splicing fake two-piece set, shoulder-slipping splicing waist and thin hip skirt', '/uploads/allimg/20241016/1-2410160T13S03.jpg', '', '0', '0', '0', '', '1', '1740124188', '1740124188');
INSERT INTO `zan_product_img` VALUES ('34', '41', '法式衬衫设计感一字领上衣夏季小衫', '/uploads/allimg/20241016/1-2410161H51BX.jpg', '', '800', '800', '66751', 'image/jpeg', '2', '1730886232', '1730886232');
INSERT INTO `zan_product_img` VALUES ('33', '41', '法式衬衫设计感一字领上衣夏季小衫', '/uploads/allimg/20241016/1-2410161H516496.jpg', '', '800', '800', '68652', 'image/jpeg', '1', '1730886232', '1730886232');
INSERT INTO `zan_product_img` VALUES ('32', '23', '春夏新款纯色圆领褶皱系带连衣裙', '/uploads/allimg/20241011/1-24101115450G40.jpg', '', '1200', '1200', '325324', 'image/jpeg', '1', '1730766606', '1730766606');

-- -----------------------------
-- Table structure for `zan_product_netdisk`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_netdisk`;
CREATE TABLE `zan_product_netdisk` (
  `nd_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '网盘商品id',
  `aid` int(10) DEFAULT '0' COMMENT '产品ID',
  `netdisk_url` varchar(255) NOT NULL DEFAULT '' COMMENT '网盘地址',
  `netdisk_pwd` varchar(50) NOT NULL DEFAULT '' COMMENT '提取码',
  `unzip_pwd` varchar(50) NOT NULL DEFAULT '' COMMENT '解压密码',
  `text_content` text NOT NULL COMMENT '文本内容',
  `lang` varchar(10) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`nd_id`) USING BTREE,
  KEY `aid` (`aid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='产品虚拟表';


-- -----------------------------
-- Table structure for `zan_product_param`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_param`;
CREATE TABLE `zan_product_param` (
  `param_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '产品参数自增ID',
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `param_name` varchar(60) NOT NULL DEFAULT '' COMMENT '参数名称',
  `param_value` varchar(200) NOT NULL DEFAULT '' COMMENT '参数值',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '属性排序',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`param_id`),
  KEY `aid` (`aid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='产品参数表';


-- -----------------------------
-- Table structure for `zan_product_param_cn`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_param_cn`;
CREATE TABLE `zan_product_param_cn` (
  `param_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '产品参数自增ID',
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `param_name` varchar(60) NOT NULL DEFAULT '' COMMENT '参数名称',
  `param_value` varchar(200) NOT NULL DEFAULT '' COMMENT '参数值',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '属性排序',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`param_id`),
  KEY `aid` (`aid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='产品参数表';


-- -----------------------------
-- Table structure for `zan_product_param_en`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_param_en`;
CREATE TABLE `zan_product_param_en` (
  `param_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '产品参数自增ID',
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `param_name` varchar(60) NOT NULL DEFAULT '' COMMENT '参数名称',
  `param_value` varchar(200) NOT NULL DEFAULT '' COMMENT '参数值',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '属性排序',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`param_id`),
  KEY `aid` (`aid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='产品参数表';


-- -----------------------------
-- Table structure for `zan_product_param_zh`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_param_zh`;
CREATE TABLE `zan_product_param_zh` (
  `param_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '产品参数自增ID',
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `param_name` varchar(60) NOT NULL DEFAULT '' COMMENT '参数名称',
  `param_value` varchar(200) NOT NULL DEFAULT '' COMMENT '参数值',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '属性排序',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`param_id`),
  KEY `aid` (`aid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='产品参数表';


-- -----------------------------
-- Table structure for `zan_product_spec_data`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_spec_data`;
CREATE TABLE `zan_product_spec_data` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `spec_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '规格ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `spec_mark_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '规格名称标记ID',
  `spec_name` varchar(255) NOT NULL DEFAULT '' COMMENT '规格名称',
  `spec_value_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '规格值标记ID',
  `spec_value` varchar(255) NOT NULL DEFAULT '' COMMENT '规格值',
  `open_image` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '开启规格图片(0:未开启; 1:已开启;)',
  `spec_image` varchar(255) NOT NULL DEFAULT '' COMMENT '规格图片',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `spec_is_select` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否选中(0:否; 1:是;)',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `spec_id` (`spec_id`,`lang`),
  KEY `aid` (`aid`) USING BTREE,
  KEY `spec_mark_id` (`spec_mark_id`) USING BTREE,
  KEY `spec_value_id` (`spec_value_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='商品多规格名称、值表';


-- -----------------------------
-- Table structure for `zan_product_spec_data_handle`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_spec_data_handle`;
CREATE TABLE `zan_product_spec_data_handle` (
  `handle_id` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '处理表自增ID',
  `auto_id` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '对应 product_spec_data 表 自增ID',
  `spec_id` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '对应 product_spec_data 表 规格ID',
  `aid` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '对应 product_spec_data 表 文档主表自增ID',
  `spec_mark_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '对应 product_spec_data 表 规格名称标记ID',
  `spec_name` varchar(255) NOT NULL DEFAULT '' COMMENT '对应 product_spec_data 表 规格名称',
  `spec_value_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '对应 product_spec_data 表 规格值标记ID',
  `spec_value` varchar(255) NOT NULL DEFAULT '' COMMENT '对应 product_spec_data 表 规格值',
  `open_image` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '对应 product_spec_data 表 开启规格图片(0:未开启; 1:已开启;)',
  `spec_image` varchar(255) NOT NULL DEFAULT '' COMMENT '对应 product_spec_data 表 规格图片',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '对应 product_spec_data 表 语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `spec_is_select` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '对应 product_spec_data 表 是否选中(0:否; 1:是;)',
  PRIMARY KEY (`handle_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='商品多规格名称、值表(product_spec_data)的预处理表';


-- -----------------------------
-- Table structure for `zan_product_spec_preset`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_spec_preset`;
CREATE TABLE `zan_product_spec_preset` (
  `preset_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `preset_mark_id` int(10) DEFAULT '0' COMMENT '预设参数标记ID',
  `preset_name` varchar(100) DEFAULT '' COMMENT '规格名称',
  `preset_value` varchar(100) DEFAULT '' COMMENT '规格值',
  `spec_sync` tinyint(1) unsigned DEFAULT '0' COMMENT '是否同步到已发布的商品规格：0否，1是。',
  `sort_order` int(10) DEFAULT '100' COMMENT '排序号',
  `merchant_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '多商家ID',
  `product_add` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否在商品添加或编辑页添加的规格信息，0否，1是，默认0',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`preset_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='产品规格预设表';


-- -----------------------------
-- Table structure for `zan_product_spec_value`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_spec_value`;
CREATE TABLE `zan_product_spec_value` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `value_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '规格价ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `spec_value_id` varchar(100) NOT NULL DEFAULT '' COMMENT '规格值组合ID',
  `spec_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '规格售价',
  `spec_crossed_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '规格划线价',
  `spec_stock` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '规格库存',
  `spec_sales_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '规格销售量',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `value_id` (`value_id`,`lang`),
  KEY `aid` (`aid`) USING BTREE,
  KEY `spec_value_id` (`spec_value_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='商品多规格组合价格表';


-- -----------------------------
-- Table structure for `zan_product_spec_value_handle`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_spec_value_handle`;
CREATE TABLE `zan_product_spec_value_handle` (
  `handle_id` int(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '处理表自增ID',
  `auto_id` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '对应 product_spec_value 表 自增ID',
  `value_id` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '对应 product_spec_value 表 规格价ID',
  `aid` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '对应 product_spec_value 表 文档主表自增ID',
  `spec_value_id` varchar(100) NOT NULL DEFAULT '' COMMENT '对应 product_spec_value 表 规格值组合ID',
  `spec_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '对应 product_spec_value 表 规格售价',
  `spec_crossed_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '对应 product_spec_value 表 规格划线价',
  `spec_stock` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '对应 product_spec_value 表 规格库存',
  `spec_sales_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '对应 product_spec_value 表 规格销售量',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '对应 product_spec_value 表 语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`handle_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='商品多规格组合价格表(product_spec_value)的预处理表';


-- -----------------------------
-- Table structure for `zan_product_users_discount`
-- -----------------------------
DROP TABLE IF EXISTS `zan_product_users_discount`;
CREATE TABLE `zan_product_users_discount` (
  `users_discount_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '产品ID',
  `level_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员等级ID',
  `users_discount_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '会员等级价格',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '下单时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`users_discount_id`),
  KEY `aid` (`aid`) USING BTREE,
  KEY `level_id` (`level_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='产品指定会员等级折扣列表';


-- -----------------------------
-- Table structure for `zan_quickentry`
-- -----------------------------
DROP TABLE IF EXISTS `zan_quickentry`;
CREATE TABLE `zan_quickentry` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(20) DEFAULT '' COMMENT '名称',
  `laytext` varchar(50) DEFAULT '' COMMENT '完整标题',
  `type` smallint(5) DEFAULT '0' COMMENT '归类，1=快捷入口，2=内容统计',
  `controller` varchar(50) DEFAULT '' COMMENT '控制器名',
  `action` varchar(20) DEFAULT '' COMMENT '操作名',
  `vars` varchar(100) DEFAULT '' COMMENT 'URL参数字符串',
  `groups` smallint(5) DEFAULT '0' COMMENT '分组，1=模型',
  `checked` tinyint(4) DEFAULT '0' COMMENT '选中，0=否，1=是',
  `litpic` varchar(100) DEFAULT '',
  `statistics_type` int(5) DEFAULT '0' COMMENT 'statistics_data表对应的type值',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态，1=有效，0=无效',
  `sort_order` int(10) DEFAULT '0' COMMENT '排序',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `type` (`type`,`status`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=69 DEFAULT CHARSET=utf8 COMMENT='快捷入口表';

-- -----------------------------
-- Records of `zan_quickentry`
-- -----------------------------
INSERT INTO `zan_quickentry` VALUES ('1', '产品', '产品列表', '1', 'Product', 'index', 'channel=2', '1', '0', '', '0', '1', '3', '1569232484', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('2', '下载', '下载列表', '1', 'Download', 'index', 'channel=4', '1', '0', '', '0', '0', '4', '1569232484', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('3', '文章', '文章列表', '1', 'Article', 'index', 'channel=1', '1', '0', '', '0', '1', '6', '1569232484', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('4', '图集', '图集列表', '1', 'Images', 'index', 'channel=3', '1', '0', '', '0', '1', '7', '1569232484', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('5', '内容管理', '内容列表', '1', 'Archives', 'index', '', '0', '0', '', '0', '1', '13', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('7', '回收站', '回收站', '1', 'RecycleBin', 'archives_index', '', '0', '1', '', '0', '1', '4', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('8', '栏目管理', '栏目管理', '1', 'Arctype', 'index', '', '0', '0', '', '0', '1', '5', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('9', '留言', '留言管理', '1', 'Form', 'index', '', '1', '0', '', '0', '1', '6', '1569232484', '1680508811');
INSERT INTO `zan_quickentry` VALUES ('10', '网站信息', '网站信息', '1', 'System', 'web', '', '0', '0', '', '0', '1', '7', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('11', '水印配置', '水印配置', '1', 'System', 'water', '', '0', '1', '', '0', '1', '8', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('12', '缩略图配置', '缩略图配置', '1', 'System', 'thumb', '', '0', '1', '', '0', '1', '9', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('13', '数据备份', '数据备份', '1', 'Tools', 'index', '', '0', '0', '', '0', '1', '11', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('14', 'URL配置', 'URL配置', '1', 'Seo', 'seo', '', '0', '1', '', '0', '1', '1', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('15', '模板管理', '模板管理', '1', 'Filemanager', 'index', '', '0', '1', '', '0', '1', '6', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('16', 'SiteMap', 'SiteMap', '1', 'Sitemap', 'index', '', '0', '1', '', '0', '1', '12', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('17', '频道模型', '频道模型', '1', 'Channeltype', 'index', '', '0', '1', '', '0', '1', '2', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('18', '广告管理', '广告管理', '1', 'AdPosition', 'index', '', '0', '0', '', '0', '1', '3', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('19', '友情链接', '友情链接', '1', 'Links', 'index', '', '0', '0', '', '0', '1', '10', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('20', 'Tags管理', 'Tags管理', '1', 'Tags', 'index', '', '0', '1', '', '0', '1', '14', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('21', '管理员管理', '管理员管理', '1', 'Admin', 'index', '', '0', '0', '', '0', '1', '15', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('22', '接口配置', '接口配置', '1', 'System', 'api_conf', '', '0', '1', '', '0', '1', '16', '1569232484', '1571893529');
INSERT INTO `zan_quickentry` VALUES ('23', '文章', '文章列表', '2', 'Article', 'index', 'channel=1', '1', '1', '', '0', '1', '1', '1569310798', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('24', '产品', '产品列表', '2', 'Product', 'index', 'channel=2', '1', '0', '', '0', '1', '2', '1569310798', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('25', '下载', '下载列表', '2', 'Download', 'index', 'channel=4', '1', '0', '', '0', '0', '4', '1569310798', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('26', '图集', '图集列表', '2', 'Images', 'index', 'channel=3', '1', '0', '', '0', '1', '3', '1569310798', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('27', '留言', '留言管理', '2', 'Form', 'index', '', '1', '0', '', '0', '1', '5', '1569310798', '1680508811');
INSERT INTO `zan_quickentry` VALUES ('28', '广告', '广告管理', '2', 'AdPosition', 'index', '', '0', '1', '', '0', '1', '8', '1569232484', '1571898872');
INSERT INTO `zan_quickentry` VALUES ('29', '友情链接', '友情链接', '2', 'Links', 'index', '', '0', '1', '', '0', '1', '9', '1569232484', '1571898872');
INSERT INTO `zan_quickentry` VALUES ('30', 'Tags标签', 'Tags管理', '2', 'Tags', 'index', '', '0', '1', '', '0', '1', '10', '1569232484', '1571898872');
INSERT INTO `zan_quickentry` VALUES ('31', '会员', '会员管理', '2', 'Member', 'users_index', '', '0', '0', '', '0', '1', '7', '1569232484', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('32', '插件应用', '插件应用', '1', 'Weapp', 'index', '', '0', '0', '', '0', '1', '17', '1569232484', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('33', '会员中心', '会员中心', '1', 'Member', 'users_index', '', '0', '0', '', '0', '1', '18', '1569232484', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('34', '商城中心', '商城中心', '1', 'Shop', 'index', '', '0', '0', '', '0', '0', '19', '1569232484', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('35', '订单', '订单管理', '2', 'Shop', 'index', '', '0', '0', '', '0', '0', '6', '1569232484', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('39', '专题', '专题列表', '2', 'Special', 'index', 'channel=7', '1', '0', '', '0', '0', '7', '1600078966', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('41', '视频', '视频列表', '2', 'Media', 'index', 'channel=5', '1', '0', '', '0', '0', '4', '1569310798', '1740123896');
INSERT INTO `zan_quickentry` VALUES ('42', '商品数', '商品总数', '21', 'ShopProduct', 'index', '', '1', '1', '', '6', '1', '1', '1569232484', '1733307056');
INSERT INTO `zan_quickentry` VALUES ('43', '充值金额', '充值总额', '21', 'Member', 'money_index', 'status=2', '1', '0', '', '5', '0', '6', '1569232484', '1681436771');
INSERT INTO `zan_quickentry` VALUES ('44', '客户数', '客户总数', '21', 'Member', 'users_index', '', '1', '1', '', '4', '1', '4', '1569232484', '1733307056');
INSERT INTO `zan_quickentry` VALUES ('45', '销售额', '销售总额', '21', 'Statistics', 'index', 'conceal=1', '1', '1', '', '3', '1', '3', '1569232484', '1733307056');
INSERT INTO `zan_quickentry` VALUES ('46', '订单数', '订单总数', '21', 'Order', 'index', '', '1', '1', '', '2', '1', '2', '1569232484', '1733307056');
INSERT INTO `zan_quickentry` VALUES ('47', '浏览量', '总浏览量', '21', '', '', '', '1', '0', '', '1', '1', '5', '1569232484', '1733307056');
INSERT INTO `zan_quickentry` VALUES ('48', '浏览量', '总浏览量', '31', '', '', '', '1', '1', '', '1', '1', '5', '1569232484', '1681461467');
INSERT INTO `zan_quickentry` VALUES ('49', '订单数', '订单总数', '31', 'Order', 'index', '', '1', '1', '', '2', '1', '3', '1569232484', '1681461467');
INSERT INTO `zan_quickentry` VALUES ('50', '销售额', '销售总额', '31', 'Statistics', 'index', 'conceal=1', '1', '1', '', '3', '1', '4', '1569232484', '1681461467');
INSERT INTO `zan_quickentry` VALUES ('51', '会员数', '会员总数', '31', 'Member', 'users_index', '', '1', '1', '', '4', '1', '1', '1569232484', '1681461467');
INSERT INTO `zan_quickentry` VALUES ('52', '充值金额', '充值总额', '31', 'Member', 'money_index', 'status=2', '1', '1', '', '5', '1', '6', '1569232484', '1681461467');
INSERT INTO `zan_quickentry` VALUES ('53', '商品数', '商品总数', '31', 'ShopProduct', 'index', '', '1', '1', '', '6', '1', '2', '1569232484', '1681461467');
INSERT INTO `zan_quickentry` VALUES ('54', '文章数', '文章总数', '31', 'Article', 'index', '', '1', '1', '', '7', '1', '7', '1569232484', '1681461467');
INSERT INTO `zan_quickentry` VALUES ('55', 'TAG标签数', 'TAG标签总数', '31', 'Tags', 'index', '', '1', '1', '', '8', '1', '8', '1569232484', '1681461467');
INSERT INTO `zan_quickentry` VALUES ('56', '待审文档', '待审总数', '31', 'Archives', 'index_draft', 'menu=1', '1', '1', '', '9', '1', '9', '1569232484', '1681461467');
INSERT INTO `zan_quickentry` VALUES ('57', '充值订单', '充值订单', '11', 'Member', 'money_index', 'status=2', '0', '0', '/public/static/admin/images/theme/survey_chongzhi.png', '0', '1', '7', '1569232484', '1733196317');
INSERT INTO `zan_quickentry` VALUES ('58', '订单查询', '订单查询', '11', 'Shop', 'index', '', '0', '1', '/public/static/admin/images/theme/survey_dingdan.png', '0', '1', '2', '1569232484', '1733196317');
INSERT INTO `zan_quickentry` VALUES ('59', '发布商品', '发布商品', '11', 'ShopProduct', 'add', 'firstrun=1', '0', '1', '/public/static/admin/images/theme/survey_fabu.png', '0', '1', '1', '1569232484', '1733196317');
INSERT INTO `zan_quickentry` VALUES ('60', '前往发货', '前往发货', '11', 'Shop', 'index', 'order_status=1', '0', '1', '/public/static/admin/images/theme/survey_fahuo.png', '0', '1', '2', '1569232484', '1669604332');
INSERT INTO `zan_quickentry` VALUES ('61', '客户管理', '客户管理', '11', 'Member', 'users_index', '', '0', '1', '/public/static/admin/images/theme/survey_huiyuan.png', '0', '1', '5', '1569232484', '1733196317');
INSERT INTO `zan_quickentry` VALUES ('62', '主题风格', '主题风格', '11', 'Index', 'theme_index', '', '0', '0', '/public/static/admin/images/theme/survey_pifu.png', '0', '1', '10', '1569232484', '1733196317');
INSERT INTO `zan_quickentry` VALUES ('63', '评价管理', '评价管理', '11', 'ShopComment', 'comment_index', '', '0', '1', '/public/static/admin/images/theme/survey_pingjia.png', '0', '1', '4', '1569232484', '1733196317');
INSERT INTO `zan_quickentry` VALUES ('64', '售后维权', '售后维权', '11', 'ShopService', 'after_service', '', '0', '0', '/public/static/admin/images/theme/survey_weiquan.png', '0', '1', '3', '1569232484', '1733196317');
INSERT INTO `zan_quickentry` VALUES ('65', '优惠券', '优惠券', '11', 'Coupon', 'index', '', '0', '0', '/public/static/admin/images/theme/survey_youhuiquan.png', '0', '1', '9', '1569232484', '1733196317');
INSERT INTO `zan_quickentry` VALUES ('66', '运费模板', '运费模板', '11', 'Shop', 'shipping_template', '', '0', '0', '/public/static/admin/images/theme/survey_yunfei.png', '0', '1', '8', '1569232484', '1733196317');
INSERT INTO `zan_quickentry` VALUES ('67', '支付设置', '支付设置', '11', 'System', 'api_conf', '', '0', '0', '/public/static/admin/images/theme/survey_zhifu.png', '0', '1', '6', '1569232484', '1733196317');
INSERT INTO `zan_quickentry` VALUES ('68', '提货设置', '提货设置', '11', 'OrderVerify', 'drive_list', '', '0', '0', '/public/static/admin/images/theme/survey_ziti.png', '0', '1', '11', '1569232484', '1733196317');

-- -----------------------------
-- Table structure for `zan_region`
-- -----------------------------
DROP TABLE IF EXISTS `zan_region`;
CREATE TABLE `zan_region` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '表id',
  `name` varchar(32) DEFAULT '' COMMENT '地区名称',
  `level` tinyint(4) DEFAULT '0' COMMENT '地区等级 分省市县区',
  `parent_id` int(10) DEFAULT '0' COMMENT '父id',
  `initial` varchar(5) DEFAULT '' COMMENT '首字母',
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`) USING BTREE,
  KEY `level` (`level`) USING BTREE,
  KEY `initial` (`initial`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='区域表';


-- -----------------------------
-- Table structure for `zan_search_locking`
-- -----------------------------
DROP TABLE IF EXISTS `zan_search_locking`;
CREATE TABLE `zan_search_locking` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `users_id` int(10) DEFAULT '0' COMMENT '用户ID',
  `ip` varchar(20) DEFAULT '' COMMENT 'ip',
  `locking_time` int(11) DEFAULT '0' COMMENT '锁定时间',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='搜索记录锁定表';


-- -----------------------------
-- Table structure for `zan_search_word`
-- -----------------------------
DROP TABLE IF EXISTS `zan_search_word`;
CREATE TABLE `zan_search_word` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `word` varchar(255) DEFAULT '' COMMENT '关键词',
  `searchNum` int(10) DEFAULT '1' COMMENT '搜索次数',
  `resultNum` int(10) DEFAULT '0' COMMENT '搜索结果数量',
  `sort_order` int(10) DEFAULT '0' COMMENT '排序号',
  `users_id` int(11) DEFAULT '0' COMMENT '用户id',
  `ip` varchar(20) DEFAULT '' COMMENT 'ip',
  `is_hot` tinyint(1) DEFAULT '0' COMMENT '是否热搜',
  `lang` varchar(30) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `word` (`word`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='搜索词统计表';


-- -----------------------------
-- Table structure for `zan_setting`
-- -----------------------------
DROP TABLE IF EXISTS `zan_setting`;
CREATE TABLE `zan_setting` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT '' COMMENT '配置的key键名',
  `value` text,
  `inc_type` varchar(64) DEFAULT '' COMMENT '配置分组',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `inc_type` (`inc_type`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=361 DEFAULT CHARSET=utf8 COMMENT='系统非全局配置表';

-- -----------------------------
-- Records of `zan_setting`
-- -----------------------------
INSERT INTO `zan_setting` VALUES ('106', 'ask_ques_steps', '1、写问题标题，描述具体现象。杜绝 “求救，大佬，小白…” 等和问题无关的词汇。\r\n2、选择问题的分类，选择正确的内容分类，能更快的得到其他人的回复。\r\n3、遇到的问题比较急需解决，可以给问题悬赏一定的金额报酬，能让更多同行参与进来出谋策划，从中选择自己心仪的答案。\r\n4、写问题内容详细描述你碰到的困难，写清楚你尝试了什么方法，错误代码，软件的版本等，更容易得到答案。\r\n5、点击发布。', 'ask', 'en', '1623322108');
INSERT INTO `zan_setting` VALUES ('109', 'recycle_switch', '1', 'recycle', 'en', '1623809302');
INSERT INTO `zan_setting` VALUES ('112', 'system_old_product_attr', '0', 'system', 'en', '1623813369');
INSERT INTO `zan_setting` VALUES ('113', 'syn_admin_logic_1623377269', '1', 'syn', 'en', '1623813369');
INSERT INTO `zan_setting` VALUES ('114', 'syn_admin_logic_1625725290', '1', 'syn', 'en', '1636441870');
INSERT INTO `zan_setting` VALUES ('115', 'syn_admin_logic_1629252424', '1', 'syn', 'en', '1636441870');
INSERT INTO `zan_setting` VALUES ('116', 'admin_logic_1634204189', '1', 'syn', 'en', '1636442096');
INSERT INTO `zan_setting` VALUES ('117', 'admin_logic_1634280892', '1', 'syn', 'en', '1636442096');
INSERT INTO `zan_setting` VALUES ('118', 'admin_logic_1635326854', '1', 'syn', 'en', '1636442096');
INSERT INTO `zan_setting` VALUES ('119', 'admin_logic_1635389623', '1', 'syn', 'en', '1636442096');
INSERT INTO `zan_setting` VALUES ('120', 'admin_logic_1636875693', '1', 'syn', 'en', '1641949807');
INSERT INTO `zan_setting` VALUES ('121', 'admin_logic_1637033990', '1', 'syn', 'en', '1641949807');
INSERT INTO `zan_setting` VALUES ('122', 'admin_logic_1640918327', '1', 'syn', 'en', '1641949807');
INSERT INTO `zan_setting` VALUES ('123', 'admin_logic_1638857408', '1', 'syn', 'en', '1641949807');
INSERT INTO `zan_setting` VALUES ('124', 'admin_logic_1643352860', '2', 'syn', 'en', '1650263640');
INSERT INTO `zan_setting` VALUES ('125', 'admin_logic_1643352862', '1', 'syn', 'en', '1650263640');
INSERT INTO `zan_setting` VALUES ('126', 'admin_logic_1649299958', '1', 'syn', 'en', '1650263716');
INSERT INTO `zan_setting` VALUES ('127', 'admin_logic_1643352863', '1', 'syn', 'en', '1650263717');
INSERT INTO `zan_setting` VALUES ('128', 'security_askanswer_list', '[\"\\u60a8\\u5e38\\u7528\\u7684\\u624b\\u673a\\u53f7\\u7801\\u662f\\uff1f\",\"\\u60a8\\u5e38\\u7528\\u7684\\u7535\\u5b50\\u90ae\\u7bb1\\u662f\\uff1f\",\"\\u60a8\\u771f\\u5b9e\\u7684\\u59d3\\u540d\\u662f\\uff1f\",\"\\u60a8\\u521d\\u4e2d\\u5b66\\u6821\\u540d\\u662f\\uff1f\",\"\\u60a8\\u7684\\u51fa\\u751f\\u5730\\u540d\\u662f\\uff1f\",\"\\u60a8\\u914d\\u5076\\u7684\\u59d3\\u540d\\u662f\\uff1f\",\"\\u60a8\\u7684\\u8eab\\u4efd\\u8bc1\\u53f7\\u540e\\u516b\\u4f4d\\u662f\\uff1f\",\"\\u60a8\\u9ad8\\u4e2d\\u73ed\\u4e3b\\u4efb\\u7684\\u540d\\u5b57\\u662f\\uff1f\",\"\\u60a8\\u521d\\u4e2d\\u73ed\\u4e3b\\u4efb\\u7684\\u540d\\u5b57\\u662f\\uff1f\",\"\\u60a8\\u6700\\u559c\\u6b22\\u7684\\u660e\\u661f\\u540d\\u5b57\\u662f\\uff1f\",\"\\u5bf9\\u60a8\\u5f71\\u54cd\\u6700\\u5927\\u7684\\u4eba\\u540d\\u5b57\\u662f\\uff1f\"]', 'security', 'en', '1650263717');
INSERT INTO `zan_setting` VALUES ('129', 'admin_logic_1643352864', '1', 'syn', 'en', '1650263717');
INSERT INTO `zan_setting` VALUES ('130', 'admin_logic_1647918733', '1', 'syn', 'en', '1650263717');
INSERT INTO `zan_setting` VALUES ('131', 'system_originlist', '[\"\\u7f51\\u7edc\"]', 'system', 'en', '1650263717');
INSERT INTO `zan_setting` VALUES ('132', 'admin_logic_1648435161', '1', 'syn', 'en', '1650263717');
INSERT INTO `zan_setting` VALUES ('133', 'admin_logic_1648882158', '1', 'syn', 'en', '1650263717');
INSERT INTO `zan_setting` VALUES ('134', 'admin_logic_1649399344', '1', 'syn', 'en', '1650263717');
INSERT INTO `zan_setting` VALUES ('135', 'syn_admin_logic_1616123194', '1', 'syn', 'en', '1653359669');
INSERT INTO `zan_setting` VALUES ('136', 'admin_logic_1655453263', '1', 'syn', 'en', '1658916485');
INSERT INTO `zan_setting` VALUES ('137', 'admin_logic_1652254594', '1', 'syn', 'en', '1658916485');
INSERT INTO `zan_setting` VALUES ('138', 'designated_column_1657069673', '1', 'syn', 'en', '1658916485');
INSERT INTO `zan_setting` VALUES ('139', 'admin_logic_1652771782', '1', 'syn', 'en', '1658916485');
INSERT INTO `zan_setting` VALUES ('140', 'syn_admin_logic_1616123195', '1', 'syn', 'en', '1658916485');
INSERT INTO `zan_setting` VALUES ('141', 'admin_logic_1651114275', '1', 'syn', 'en', '1658916485');
INSERT INTO `zan_setting` VALUES ('142', 'syn_admin_logic_1658220528', '1', 'syn', 'en', '1667183769');
INSERT INTO `zan_setting` VALUES ('143', 'syn_admin_logic_1658799138', '1', 'syn', 'en', '1667183769');
INSERT INTO `zan_setting` VALUES ('144', 'syn_admin_logic_1661323010', '1', 'syn', 'en', '1667183769');
INSERT INTO `zan_setting` VALUES ('145', 'syn_admin_logic_1661483783', '1', 'syn', 'en', '1667183769');
INSERT INTO `zan_setting` VALUES ('146', 'admin_logic_1662518904', '1', 'syn', 'en', '1667183769');
INSERT INTO `zan_setting` VALUES ('147', 'syn_admin_logic_1660557712', '1', 'syn', 'en', '1667183769');
INSERT INTO `zan_setting` VALUES ('148', 'admin_logic_1663290997', '1', 'syn', 'en', '1667184483');
INSERT INTO `zan_setting` VALUES ('149', 'admin_logic_1667210674', '1', 'syn', 'en', '1667356308');
INSERT INTO `zan_setting` VALUES ('150', 'admin_logic_1667357946', '1', 'syn', 'en', '1673945387');
INSERT INTO `zan_setting` VALUES ('151', 'editor_select', '1', 'editor', 'en', '1675389691');
INSERT INTO `zan_setting` VALUES ('152', 'editor_remote_img_local', '1', 'editor', 'en', '1675389691');
INSERT INTO `zan_setting` VALUES ('153', 'editor_img_clear_link', '1', 'editor', 'en', '1675389691');
INSERT INTO `zan_setting` VALUES ('154', 'admin_logic_1673941712', '1', 'syn', 'en', '1680508400');
INSERT INTO `zan_setting` VALUES ('155', 'admin_logic_1676854942', '1', 'syn', 'en', '1680508882');
INSERT INTO `zan_setting` VALUES ('156', 'admin_logic_1675243579', '1', 'syn', 'en', '1680508882');
INSERT INTO `zan_setting` VALUES ('157', 'admin_logic_1677555001', '1', 'syn', 'en', '1680508882');
INSERT INTO `zan_setting` VALUES ('158', 'admin_logic_1678762367', '1', 'syn', 'en', '1680508882');
INSERT INTO `zan_setting` VALUES ('159', 'admin_logic_1685584104', '1', 'syn', 'en', '1686877656');
INSERT INTO `zan_setting` VALUES ('160', 'admin_logic_1682580429', '1', 'syn', 'en', '1686877656');
INSERT INTO `zan_setting` VALUES ('161', 'admin_logic_1680749290', '1', 'syn', 'en', '1686877656');
INSERT INTO `zan_setting` VALUES ('162', 'admin_logic_1687767523', '1', 'syn', 'en', '1692667932');
INSERT INTO `zan_setting` VALUES ('163', 'admin_logic_1689071584', '1', 'syn', 'en', '1692667932');
INSERT INTO `zan_setting` VALUES ('164', 'admin_logic_1681199467', '1', 'syn', 'en', '1692667955');
INSERT INTO `zan_setting` VALUES ('165', 'admin_logic_1687676445', '1', 'syn', 'en', '1692667955');
INSERT INTO `zan_setting` VALUES ('166', 'admin_logic_1685094852', '1', 'syn', 'en', '1692667955');
INSERT INTO `zan_setting` VALUES ('167', 'admin_logic_1687687709', '1', 'syn', 'en', '1692667955');
INSERT INTO `zan_setting` VALUES ('168', 'admin_logic_1692067658', '1', 'syn', 'en', '1692667957');
INSERT INTO `zan_setting` VALUES ('169', 'admin_logic_1697156935', 'v2.0.1', 'syn', 'en', '1730430128');
INSERT INTO `zan_setting` VALUES ('170', 'admin_logic_1698388181', '1', 'syn', 'en', '1699840479');
INSERT INTO `zan_setting` VALUES ('171', 'admin_logic_1698716726', '1', 'syn', 'en', '1699840479');
INSERT INTO `zan_setting` VALUES ('172', 'admin_logic_1700638990', '1', 'syn', 'en', '1701045570');
INSERT INTO `zan_setting` VALUES ('173', 'admin_logic_1700789211', '1', 'syn', 'en', '1701045570');
INSERT INTO `zan_setting` VALUES ('174', 'admin_logic_1700645198', '1', 'syn', 'en', '1701045570');
INSERT INTO `zan_setting` VALUES ('175', 'admin_logic_1698733259', '1', 'syn', 'en', '1701045570');
INSERT INTO `zan_setting` VALUES ('176', 'admin_logic_1698799687', '1', 'syn', 'en', '1701045570');
INSERT INTO `zan_setting` VALUES ('177', 'syn_admin_logic_1700016487', '1', 'syn', 'en', '1701045570');
INSERT INTO `zan_setting` VALUES ('178', 'syn_admin_logic_1700016488', '1', 'syn', 'en', '1701045570');
INSERT INTO `zan_setting` VALUES ('179', 'syn_admin_logic_1700016489', '1', 'syn', 'en', '1701045570');
INSERT INTO `zan_setting` VALUES ('180', 'syn_admin_logic_1700106425', '1', 'syn', 'en', '1701045570');
INSERT INTO `zan_setting` VALUES ('181', 'admin_logic_1700621159', '1', 'syn', 'en', '1701045570');
INSERT INTO `zan_setting` VALUES ('182', 'admin_logic_1701050542', '1', 'syn', 'en', '1703142160');
INSERT INTO `zan_setting` VALUES ('183', 'admin_logic_1693909371', '1', 'syn', 'en', '1703142193');
INSERT INTO `zan_setting` VALUES ('184', 'admin_logic_1701855768', '1', 'syn', 'en', '1706510953');
INSERT INTO `zan_setting` VALUES ('185', 'admin_logic_1682579646', '1', 'syn', 'en', '1713251003');
INSERT INTO `zan_setting` VALUES ('186', 'admin_logic_1707029785', '1', 'syn', 'en', '1713251003');
INSERT INTO `zan_setting` VALUES ('187', 'syn_admin_logic_1706842286', '1', 'syn', 'en', '1713251003');
INSERT INTO `zan_setting` VALUES ('188', 'syn_admin_logic_1703647730', '1', 'syn', 'en', '1713251003');
INSERT INTO `zan_setting` VALUES ('189', 'syn_admin_logic_1707201289', '1', 'syn', 'en', '1713251003');
INSERT INTO `zan_setting` VALUES ('190', 'admin_logic_1712548559', '1', 'syn', 'en', '1713251003');
INSERT INTO `zan_setting` VALUES ('191', 'admin_logic_1712548812', '1', 'syn', 'en', '1713251003');
INSERT INTO `zan_setting` VALUES ('192', 'syn_admin_logic_1716431013', '1', 'syn', 'en', '1721637131');
INSERT INTO `zan_setting` VALUES ('193', 'syn_admin_logic_1714458348', '1', 'syn', 'en', '1721637131');
INSERT INTO `zan_setting` VALUES ('194', 'syn_admin_logic_1716446109', '1', 'syn', 'en', '1721637131');
INSERT INTO `zan_setting` VALUES ('195', 'syn_admin_logic_1714458360', '1', 'syn', 'en', '1721637131');
INSERT INTO `zan_setting` VALUES ('196', 'syn_admin_logic_1719815413', '1', 'syn', 'en', '1721637131');
INSERT INTO `zan_setting` VALUES ('197', 'syn_admin_logic_1721179406', '1', 'syn', 'en', '1725071302');
INSERT INTO `zan_setting` VALUES ('198', 'system_optimizetabledata_time', '1730182574', 'system', 'en', '1730182574');
INSERT INTO `zan_setting` VALUES ('199', 'system_uploads_type_id_selected', '0', 'system', 'en', '1725357046');
INSERT INTO `zan_setting` VALUES ('200', 'system_codelogic_1638857408', '4acfVQdUVQUFBlYEBFAKBARVUlRdW1FaBAYAXQpoFQtfUQowBjYyY3RRJHZYLW9wZhwyN156Mm8zW3wlY3Z2egh6fyd2JShjZEU3cUwqYXlhCyMga2Inew0Fcjdzenx7CHVpMnEqBmMFZDBydQRuaVxdByRSTCV6J192PHRqfmlsBmo3YQcucWd8NmViKnVnASIvIVVxLmFUfXAhdERzfn9ieiFhUT1gZF4kYF8tb2BiVTgzb0I1SF0DYhRDUWFXdkVkDUYoMkdWXylcDBpxAlQFLA4MbDUONVJiV0ZkfQtLQVUfbgIGRmxyME1/FWhDXwo5GAFgBkEQUXdXQWdlS3Jkf1VtHScHQVcoXUVSenV2Azs1fHEgbzRHUjN3ZmB+UnFRMXIXN3AFDgBgdSp1ZFcDMDF4fj5uDgV1MmdLc3BBcVIwB1wAZGRZMXB1KnRwcSo7OAhyPnsSdkE1WX5keQlhYicHNSB9WA81d1gpYGRIBzEKXGsvUSpgUg5GRl8KdXtFMmVQIG1jRihhWFdsdVdGPA', 'system', 'en', '1740124207');
INSERT INTO `zan_setting` VALUES ('201', 'syn_admin_logic_1727423349', '1', 'syn', 'en', '1727750405');
INSERT INTO `zan_setting` VALUES ('202', 'syn_admin_logic_1727423350', '1', 'syn', 'en', '1727750405');
INSERT INTO `zan_setting` VALUES ('203', 'ddos_scan_range_files', '1', 'ddos', 'en', '1728605917');
INSERT INTO `zan_setting` VALUES ('204', 'ddos_scan_range_attachment', '0', 'ddos', 'en', '1728605917');
INSERT INTO `zan_setting` VALUES ('205', 'ddos_scan_range_uploads', '0', 'ddos', 'en', '1728605917');
INSERT INTO `zan_setting` VALUES ('206', 'ddos_scan_is_finish', '0', 'ddos', 'en', '1728605917');
INSERT INTO `zan_setting` VALUES ('207', 'ddos_scan_allscantotal', '0', 'ddos', 'en', '1728605917');
INSERT INTO `zan_setting` VALUES ('208', 'syn_admin_logic_1726216198', '1', 'syn', 'en', '1728605917');
INSERT INTO `zan_setting` VALUES ('209', 'ddos_feature_pattern', 'eyIxMDAwMDEiOnsidmFsdWUiOiJcL15cdTVjMGYtXHU4NjRlLVx1NTRlNSRcL2kifSwiNjAwMDAxIjp7InZhbHVlIjoiXC8ocGZzb2Nrb3Blbnxmc29ja29wZW4pXFwoXFxcIih1ZHB8dGNwKVwvaSJ9LCI2MDAwMDIiOnsidmFsdWUiOiJcL1BocChcXHMrKShcXGQrKShcXHMrKVRlcm1pbmF0b3JcL2kifSwiNjAwMDAzIjp7InZhbHVlIjoiXC9bXFwkX0dFVHxcXCRfUkVRVUVTVF1cXFtcXCdyYXRcXCddXC9pIn0sIjYwMDAwNCI6eyJ2YWx1ZSI6IlwvVGNwMyhcXHMrKUNDXFwuY2VudGVyXC9pIn0sIjYwMDAwNSI6eyJ2YWx1ZSI6IlwveGRvc1xcLnNcL2kifSwiNjAwMDA2Ijp7InZhbHVlIjoiXC9cdTUxMGZcdTY0NTNcdTcxNDFcdTY2NWNcdTZjZGZcL2kifSwiNjAwMDA3Ijp7InZhbHVlIjoiXC8oKEZpbGVtYW5hZ2VyTW9kZWxcXC5waHApfChcXCRxYXooXFxzKik9KFxccyopXFwkcXdlKXwoaW5jbHVkZShcXHMqKVxcKChcXHMqKShbXFxcIlxcJ10rKVxcXC90bXBcXFwvKXwoXFwkY29udGVudF9tYihcXHMqKT0oXFxzKikpfChmaWxlX2dldF9jb250ZW50cyhcXHMqKVxcKChcXHMqKVxcJGF1dGhfcm9sZV9hZG1pbihcXHMqKVxcKSkpXC9pIn0sIjYwMDAwOCI6eyJ2YWx1ZSI6Ilwve19fTk9MQVlPVVRfX31cXD9we19fTk9MQVlPVVRfX31oe19fTk9MQVlPVVRfX31wXC9pIn0sIjYwMDAwOSI6eyJ2YWx1ZSI6IlwvKFxcJ3xcXFwifFxcXC8pKGJ5dGV8b3RlbylcXC5waHAoXFwnfFxcXCIpXC9pIn0sIjYwMDAxMCI6eyJ2YWx1ZSI6IlwvbmV3KFxccyspKEc0SjgyNDU4fENBUUEpKFxccyopXFwoXC9pIn0sIjYwMDAxMSI6eyJ2YWx1ZSI6IlwvKChqcXVleXwzc3IzfGJhaXplNjY2fDlycnJyOSkuY2N8cGhwZGR0LmNvbXxiYWlkdWkuY298bWF0b21vLnBocHxtYXRvbW8uanN8KHNhbmR5bGN5MjAyNHxnbGppb2pnYW1nZikudG9wKShcXFwvfFxcXCJ8XFwnKVwvaSJ9LCI2MDAwMTIiOnsidmFsdWUiOiJcLyhAXFxeX1xcXkB8XFwkQF9AfEBfQFxcIXwoXHUwOTk1fFx1MDk5NnxcdTA5OTd8XHUwOTk4fGZvcm1hdFNpemVVbml0c3xcXCFpc1NlYXJjaEVuZ2luZSl8XFw8bm9zY3JpcHRcXD4oXFxzKilcXDx8KENyZWF0ZV9GdW5jdGlvbnxoZWxsb3dvcmRmdW5jdGlvbnxoZWxsb3dvcmRfZGVjb2RlKXxcXCR0aGlzLVxcPm00X2wyXFwoXFwpKVwvaSJ9LCI2MDAwMTMiOnsidmFsdWUiOiJcL2Z1bmN0aW9uKFxccyspKGh0dHBHZXRsYWl8c2V0X3dyaXRlYWJsZSkoXFxzKilcXChcL2kifSwiNjAwMDE0Ijp7InZhbHVlIjoiXC9mcm9tQ2hhckNvZGUoXFxzKilcXCgoXFxzKilcXGQrKFxccyopLChcXHMqKVxcZCsoXFxzKiksKFxccyopXFxkKyhcXHMqKSwoXFxzKilcXGQrKFxccyopLChcXHMqKVxcZCsoXFxzKiksKFxccyopXFxkKyhcXHMqKSwoXFxzKilcXGQrKFxccyopLChcXHMqKVxcZCsoXFxzKiksKFxccyopXFxkKyhcXHMqKSxcL2kifSwiNjAwMDE1Ijp7InZhbHVlIjoiXC9nemluZmxhdGUoXFxzKilcXCgoXFxzKiliYXNlNjRfZGVjb2RlKFxccyopXFwoXC9pIn0sIjYwMDAxNiI6eyJ2YWx1ZSI6IlwvKFteXFx3XFwtXSopZXZhbChcXHMqKVxcKChcXHMqKWNocihcXHMqKVxcKChcXHMqKShcXGQrKVwvaSJ9LCI2MDAwMTciOnsidmFsdWUiOiJcLyhbXlxcd1xcLV0qKWV2YWwoXFxzKilcXCgoXFxzKikoSmtJfHN0cl9pcmVwbGFjZSkoXFxzKilcXChcL2kifSwiNjAwMDE4Ijp7InZhbHVlIjoiXC8oW15cXHdcXC1dKilldmFsKFxccyopXFwoKFxccyopXFwkcGF5bG9hZChcXHMqKVxcKVwvaSJ9LCI2MDAwMTkiOnsidmFsdWUiOiJcL3BhY2soXFxzKilcXCgoW1xcXCJcXCddKylIXFwqKFtcXFwiXFwnXSspKFxccyopLChcXHMqKXN0cl9yb3QxMyhcXHMqKVxcKFwvaSJ9LCI2MDAwMjAiOnsidmFsdWUiOiJcL3BhY2soXFxzKilcXCgoW1xcXCJcXCddKylIXFwqKFtcXFwiXFwnXSspKFxccyopLChcXHMqKVxcJHN0clwvaSJ9LCI2MDAwMjEiOnsidmFsdWUiOiJcL3N0cl9yb3QxMyhcXHMqKVxcKFwvaSJ9LCI2MDAwMjIiOnsidmFsdWUiOiJcL2NobW9kKFxccyopXFwoKFxccyopXFwkdGhpcy1cXD51cGxvYWRfdGFyZ2V0X2RpclwvaSJ9LCI2MDAwMjMiOnsidmFsdWUiOiJcL1xcXFx4NjNcXFxceDcyXFxcXHg2NVxcXFx4NjFcXFxceDc0XFxcXHg2NVxcXFx4NWZcXFxceDY2XFxcXHg3NVxcXFx4NmVcXFxceDYzXFxcXHg3NFxcXFx4NjlcXFxceDZmXFxcXHg2ZVwvaSJ9LCI2MDAwMjUiOnsidmFsdWUiOiJcL1xcJF9TRVJWRVIoXFxzKilcXFsoXFxzKikoW1xcXCJcXCddKylfcmVmX1VTRVJfQUdFTlQoW1xcXCJcXCddKykoXFxzKilcXF0oXFxzKilcL2kifSwiOTkwMDAxIjp7InZhbHVlIjoiXC9qUXVlcnkoXFxzKikodik/KEApPygoWzAtMl0rKVxcLlxcZCtcXC5cXGQrKVwvaSJ9LCI5OTAwMDIiOnsidmFsdWUiOiJcL2pRdWVyeShcXHMrKUphdmFTY3JpcHQoXFxzKylMaWJyYXJ5KFxccyspdigoWzAtMl0rKVxcLlxcZCtcXC5cXGQrKVwvaSJ9LCI5OTAwMTAiOnsidmFsdWUiOiJcL2pRdWVyeS1cdTk4ODRcdTc1NTlcL2kifX0=', 'ddos', 'en', '1730367132');
INSERT INTO `zan_setting` VALUES ('210', 'ddos_feature_imgpattern', 'eyI2MDAwMDEiOnsidmFsdWUiOiIjZmlsZV9wdXRfY29udGVudHMjaSJ9LCI2MDAwMDIiOnsidmFsdWUiOiIjX19IQUxUX0NPTVBJTEVSKCkjaSJ9LCI2MDAwMDMiOnsidmFsdWUiOiIjXC9zY3JpcHQ+I2kifSwiNjAwMDA0Ijp7InZhbHVlIjoiIzwoW14/XSopXFw/cGhwI2kifSwiNjAwMDA1Ijp7InZhbHVlIjoiIzxcXD9cXD0oXFxzKykjaSJ9LCI2MDAwMDYiOnsidmFsdWUiOiIjKFxccyspbGFuZ3VhZ2UoXFxzKik9KFxccyopKFwifFxcJyk/cGhwKFwifFxcJyk/I2kifSwiNjAwMDA3Ijp7InZhbHVlIjoiI2ZpbGVzaXplXHU4ZmQ0XHU1NmRlXHU2NTg3XHU0ZWY2XHU1OTI3XHU1YzBmXHU1YjU3XHU4MjgyXHU2NTcwXHU0ZTNhZmFsc2UjaSJ9fQ==', 'ddos', 'en', '1728605917');
INSERT INTO `zan_setting` VALUES ('211', 'ddos_feature_msg', 'eyIxIjp7InZhbHVlIjoiXHU3YTBiXHU1ZThmXHU5MWNjXHU1ZGYyXHU1M2QxXHU3M2IwXHU2NzA5XHU2MzAyXHU5YTZjXHU2MGM1XHU1MWI1XHVmZjBjXHU1OTgyXHU2NzA5XHU5NzAwXHU4OTgxXHVmZjBjXHU4YmY3XHU2MzA5XHU2NTU5XHU3YTBiXHU4ZmRiXHUyMDE0XHU2YjY1XHU2ZGYxXHU1ZWE2XHU1OTA0XHU3NDA2ICg8YSBocmVmPVwiSmF2YVNjcmlwdDp2b2lkKDApO1wiIGRhdGEtaHJlZj1cImh0dHBzOlwvXC93d3cuZXlvdWNtcy5jb21cL3BsdXNcL3ZpZXcucGhwP2FpZD01OTQ2Jm9yaWdpbl9leWNtcz0xXCIgb25jbGljaz1cIm9wZW5GdWxsZnJhbWUodGhpcywnXHU2NjEzXHU0ZjE4Q01TXHU1OTgyXHU0ZjU1XHU2N2U1XHU2NzQwXHU3YTdhXHU5NWY0XHU2NzI4XHU5YTZjXHU2NTU5XHU3YTBiXHVmZjBjXHU0ZWM1XHU0ZjliXHU1M2MyXHU4MDAzJyk7XCI+XHU2N2U1XHU3NzBiXHU2NTU5XHU3YTBiPFwvYT4pICIsIm9wdCI6eyJldmVudCI6InRpcHMiLCJ2YWx1ZSI6Ilx1NjcwOVx1NjcyOFx1OWE2Y1x1NjNkMFx1NzkzYVx1NjU1OVx1N2EwYiJ9fSwiMTAwIjp7InZhbHVlIjoiXHU2OGMwXHU2ZDRiXHU1MjMwXHU1OTFhXHU0ZjU5XHU2NTg3XHU0ZWY2XHVmZjBjXHU1ZWZhXHU4YmFlXHU1MjIwXHU5NjY0XHUzMDAyIiwib3B0Ijp7ImV2ZW50IjoiZGVsIiwidmFsdWUiOiJcdTUyMjBcdTk2NjQifX0sIjEwMSI6eyJ2YWx1ZSI6Ilx1NjhjMFx1NmQ0Ylx1NTIzMFx1NTkxYVx1NGY1OVx1NjU4N1x1NGVmNlx1ZmYwY1x1NWVmYVx1OGJhZVx1NTIyMFx1OTY2NFx1MzAwMiIsIm9wdCI6eyJldmVudCI6ImRlbCIsInZhbHVlIjoiXHU1MjIwXHU5NjY0In19LCIxMTAiOnsidmFsdWUiOiJcdTY4YzBcdTZkNGJcdTUyMzBcdTViNThcdTU3MjhcdTViODlcdTg4YzVcdTc2ZWVcdTVmNTVcdWZmMGNcdTVlZmFcdThiYWVcdTUyMjBcdTk2NjRcdTMwMDIiLCJvcHQiOnsiZXZlbnQiOiJkZWwiLCJ2YWx1ZSI6Ilx1NTIyMFx1OTY2NCJ9fSwiMTExIjp7InZhbHVlIjoiXHU2OGMwXHU2ZDRiXHU1MjMwXHU1OTFhXHU0ZjU5XHU3NmVlXHU1ZjU1XHVmZjBjXHU1ZWZhXHU4YmFlXHU1MjIwXHU5NjY0XHUzMDAyIiwib3B0Ijp7ImV2ZW50IjoiZGVsIiwidmFsdWUiOiJcdTUyMjBcdTk2NjQifX0sIjYwMCI6eyJ2YWx1ZSI6Ilx1NjhjMFx1NmQ0Ylx1NTIzMFx1NzU5MVx1NGYzY1x1NjcyOFx1OWE2Y1x1NjU4N1x1NGVmNlx1ZmYwY1x1NWVmYVx1OGJhZVx1NGZlZVx1NTkwZFx1MzAwMiIsIm9wdCI6eyJldmVudCI6InJlcGxhY2UiLCJ2YWx1ZSI6Ilx1NGZlZVx1NTkwZCJ9fSwiNjAxIjp7InZhbHVlIjoiXHU2OGMwXHU2ZDRiXHU1MjMwXHU1OTFhXHU0ZjU5XHU3Njg0XHU3NTkxXHU0ZjNjXHU2NzI4XHU5YTZjXHU2NTg3XHU0ZWY2XHVmZjBjXHU1ZWZhXHU4YmFlXHU1MjIwXHU5NjY0XHUzMDAyIiwib3B0Ijp7ImV2ZW50IjoiZGVsIiwidmFsdWUiOiJcdTUyMjBcdTk2NjQifX0sIjYwMiI6eyJ2YWx1ZSI6Ilx1NjhjMFx1NmQ0Ylx1NTIzMFx1NzU5MVx1NGYzY1x1NjcyOFx1OWE2Y1x1NjU4N1x1NGVmNlx1ZmYwY1x1OGJmN1x1ODFlYVx1ODg0Y1x1NGZlZVx1NTkwZFx1MzAwMiIsIm9wdCI6eyJldmVudCI6InJlcGxhY2VfdGlwcyIsInZhbHVlIjoibGF5ZXItXHU4YmY3XHU3ZjE2XHU4ZjkxXHU4YmU1XHU2NTg3XHU0ZWY2XHVmZjBjXHU1M2JiXHU5NjY0XHU3NTkxXHU0ZjNjXHU2NzI4XHU5YTZjXHU3Njg0XHU0ZWUzXHU3ODAxIn19LCI5OTAiOnsidmFsdWUiOiJcdTY4YzBcdTZkNGJcdTUyMzBqUXVlcnlcdTRmNGVcdTcyNDhcdTY3MmNcdTlhZDhcdTUzNzFcdTZmMGZcdTZkMWVcdWZmMGNcdTVlZmFcdThiYWVcdTRmZWVcdTU5MGRcdWZmMDg8YSBocmVmPVwiaHR0cHM6XC9cL3d3dy5leW91Y21zLmNvbVwvcGx1c1wvdmlldy5waHA/YWlkPTMwMDkzJm9yaWdpbl9leWNtcz0xXCIgdGFyZ2V0PVwiX2JsYW5rXCI+XHU2N2U1XHU3NzBiPFwvYT5cdWZmMDlcdTMwMDIiLCJvcHQiOnsiZXZlbnQiOiJzZWUiLCJ2YWx1ZSI6Imh0dHBzOlwvXC93d3cuZXlvdWNtcy5jb21cL3BsdXNcL3ZpZXcucGhwP2FpZD0zMDA5MyZvcmlnaW5fZXljbXM9MSJ9fSwiOTkxIjp7InZhbHVlIjoiXHU2OGMwXHU2ZDRiXHU1MjMwXHU1OTFhXHU0ZjU5XHU3Njg0alF1ZXJ5XHU0ZjRlXHU3MjQ4XHU2NzJjXHU5YWQ4XHU1MzcxXHU2ZjBmXHU2ZDFlXHVmZjBjXHU1ZWZhXHU4YmFlXHU0ZmVlXHU1OTBkXHVmZjA4PGEgaHJlZj1cImh0dHBzOlwvXC93d3cuZXlvdWNtcy5jb21cL3BsdXNcL3ZpZXcucGhwP2FpZD0zMDA5MyZvcmlnaW5fZXljbXM9MVwiIHRhcmdldD1cIl9ibGFua1wiPlx1NjdlNVx1NzcwYjxcL2E+XHVmZjA5XHUzMDAyIiwib3B0Ijp7ImV2ZW50Ijoic2VlIiwidmFsdWUiOiJodHRwczpcL1wvd3d3LmV5b3VjbXMuY29tXC9wbHVzXC92aWV3LnBocD9haWQ9MzAwOTMmb3JpZ2luX2V5Y21zPTEifX19', 'ddos', 'en', '1728605917');
INSERT INTO `zan_setting` VALUES ('212', 'ddos_feature_msg_grade', 'eyIxIjp7ImdyYWRlIjoiMSIsInZhbHVlIjoiXHU2N2U1XHU3NzBiXHU2NTU5XHU3YTBiIn0sIjEwMCI6eyJncmFkZSI6IjEwMCIsInZhbHVlIjoiXHU1OTFhXHU0ZjU5XHU2NTg3XHU0ZWY2In0sIjEwMSI6eyJncmFkZSI6IjEwMSIsInZhbHVlIjoiXHU1OTFhXHU0ZjU5XHU2NTg3XHU0ZWY2In0sIjExMCI6eyJncmFkZSI6IjExMCIsInZhbHVlIjoiXHU1OTFhXHU0ZjU5XHU3NmVlXHU1ZjU1In0sIjExMSI6eyJncmFkZSI6IjExMSIsInZhbHVlIjoiXHU1OTFhXHU0ZjU5XHU3NmVlXHU1ZjU1In0sIjYwMCI6eyJncmFkZSI6IjYwMCIsInZhbHVlIjoiXHU3NTkxXHU0ZjNjXHU2NzI4XHU5YTZjIn0sIjYwMSI6eyJncmFkZSI6IjYwMSIsInZhbHVlIjoiXHU3NTkxXHU0ZjNjXHU2NzI4XHU5YTZjIn0sIjYwMiI6eyJncmFkZSI6IjYwMiIsInZhbHVlIjoiXHU3NTkxXHU0ZjNjXHU2NzI4XHU5YTZjIn0sIjk5MCI6eyJncmFkZSI6Ijk5MCIsInZhbHVlIjoiXHU5YWQ4XHU1MzcxXHU2ZjBmXHU2ZDFlIn0sIjk5MSI6eyJncmFkZSI6Ijk5MSIsInZhbHVlIjoiXHU5YWQ4XHU1MzcxXHU2ZjBmXHU2ZDFlIn19', 'ddos', 'en', '1728605917');
INSERT INTO `zan_setting` VALUES ('213', 'ddos_feature_other', 'eyIxMDAxMCI6eyJ2YWx1ZSI6InBocCxwaHBfcmVhZCxhc3AsanNwIn0sIjEwMDExIjp7InZhbHVlIjoiXC9eKHRlbXBsYXRlfHB1YmxpY3xzdGF0aWN8ZGF0YVxcXC8oYmFja3VwfGNvbmZ8c2Vzc2lvbnxzcWxkYXRhKShbXFx3XFwtXSopKVxcXC9cL2kifSwiMTAwMTIiOnsidmFsdWUiOiJcL15cdTk4ODRcdTc1NTkkXC9pIn0sIjEwMDEzIjp7InZhbHVlIjoicG5nLGdpZixqcGcsanBlZyxpY28sYm1wLHdlYnAifSwiMTAwMzAiOnsidmFsdWUiOiJwdWJsaWNcL3BsdWdpbnNcL2NrZWRpdG9yXC9ja2VkaXRvci5waHAscHVibGljXC9wbHVnaW5zXC9ja2VkaXRvclwvY2tlZGl0b3JfcGhwNC5waHAscHVibGljXC9wbHVnaW5zXC9ja2VkaXRvclwvY2tlZGl0b3JfcGhwNS5waHAifSwiMTAwMzEiOnsidmFsdWUiOiJcL14odGVtcGxhdGV8d2VhcHB8YXBwbGljYXRpb25cXFwvKHBsdWdpbnMpfGRhdGFcXFwvKGNvbmZ8c2NoZW1hfHJ1bnRpbWUpKFtcXHdcXC1dKikpXFxcL1wvaSJ9LCIxMDAzMiI6eyJ2YWx1ZSI6IlwvXih0ZW1wbGF0ZVxcXC8oLiopXFwuKHBocHxhc3B8anNwKSkkXC9pIn0sIjEwMDMzIjp7InZhbHVlIjoiXC9eKHB1YmxpY1xcXC9zdGF0aWNcXFwvYWRtaW5cXFwvKGljb3xsb2dpbnxsb2dpbmJnfGxvZ28pXFxcLyguKylcXC4ocG5nfGdpZnxqcGd8anBlZ3xpY298Ym1wfHdlYnApKVwvaSJ9LCIxMDAzNCI6eyJ2YWx1ZSI6IlwvXihhcHBsaWNhdGlvbnxjb3JlfGRhdGF8ZXh0ZW5kfGluc3RhbGwoXyhbXFx3XSspKT98cHVibGljfHRlbXBsYXRlfHVwbG9hZHN8dmVuZG9yfFx1OGZmZFx1NTJhMFx1NzI3OVx1NWI5YVx1NzZlZVx1NWY1NXx3ZWFwcClcXFwvXC9pIn0sIjEwMDM1Ijp7InZhbHVlIjoiYXBwbGljYXRpb25cL2FkbWluXC9jb250cm9sbGVyXC9XZWFwcC5waHAtLXBhdHRlcm4tLVwvKDIwMjQtMDctMTEoXFxzKykwOTo0NTowNilcL2kifSwiMTAwNDAiOnsidmFsdWUiOiJ3YXMgcmVtb3ZlZCBpbiBqUXVlcnkgMS4xMi4wIn0sIjEwMDQxIjp7InZhbHVlIjoiXC9eKFtcXHNcXFNdKykod2FzIHJlbW92ZWQgaW4galF1ZXJ5IDEuMTIuMHxyZXF1aXJlcyBqUXVlcnkgdjEuMy4yIG9yIGxhdGVyKShbXFxzXFxTXSspJFwvaSJ9LCIxMDA1MCI6eyJ2YWx1ZSI6IlwvXFwuKHBocHxwaHBfcmVhZHxodG18YXNwfGpzcHxiYWt8anN8Y3NzfGJhdHx6aXB8cmFyfGd6fHBuZ3xnaWZ8anBnfGpwZWd8aWNvfGJtcHx3ZWJwKSRcL2kifSwiMTAwNTEiOnsidmFsdWUiOiJwaHAscGhwX3JlYWQsaHRtLGFzcCxqc3AsYmFrLGpzLGNzcyxiYXQsemlwLHJhcixneixwbmcsZ2lmLGpwZyxqcGVnLGljbyxibXAsd2VicCJ9LCIxMDA2MCI6eyJ2YWx1ZSI6IioifSwiMTAwNzAiOnsidmFsdWUiOiJwbmcsZ2lmLGpwZyxqcGVnLGljbyxibXAsd2VicCJ9LCIxMDA3MSI6eyJ2YWx1ZSI6IlwvXihhcHBsaWNhdGlvbnxjb3JlfGV4dGVuZHxpbnN0YWxsKFtcXHdcXC1dKil8cHVibGljXFxcLyhodG1sKXxkYXRhXFxcLyhiYWNrdXB8Y29uZnxtb2RlbHxzY2hlbWF8c2Vzc2lvbnxzcWxkYXRhKShbXFx3XFwtXSopKVxcXC9cL2kifSwiMTAwNzIiOnsidmFsdWUiOiJcL15cdTk4ODRcdTc1NTkkXC9pIn0sIjEwMDgwIjp7InZhbHVlIjoicGhwLHBocF9yZWFkLGFzcCxqc3AsZXhlLGpzLGNzcyxqYXIsYmF0LGh0bWwsaHRtIn0sIjEwMDkwIjp7InZhbHVlIjoiemlwLHJhcixneixleGUifSwiMTAwOTEiOnsidmFsdWUiOiJcL14oLiopXFxcL1wvaSJ9LCIxMDA5MiI6eyJ2YWx1ZSI6IlwvXlx1OTg4NFx1NzU1OSRcL2kifX0=', 'ddos', 'en', '1728725656');
INSERT INTO `zan_setting` VALUES ('214', 'doubao_api', '0', 'doubao', 'en', '1730799492');
INSERT INTO `zan_setting` VALUES ('215', 'doubao_access_key_id', '', 'doubao', 'en', '1730799492');
INSERT INTO `zan_setting` VALUES ('216', 'doubao_secret_access_key', '', 'doubao', 'en', '1730799492');
INSERT INTO `zan_setting` VALUES ('218', 'system_vertify', '{\"captcha\":{\"admin_login\":{\"is_on\":\"1\",\"config\":{\"codeSet\":\"2345678abcdefhijkmnpqrstuvwxyz\",\"fontSize\":\"35\",\"useCurve\":\"0\",\"useNoise\":\"0\",\"length\":\"4\"}}}}', 'system', 'en', '1730707043');
INSERT INTO `zan_setting` VALUES ('336', 'adminlogin_bb7e531fe20f8dcc4485ceada88140d5', '0', 'adminlogin', 'en', '1732245148');

-- -----------------------------
-- Table structure for `zan_setting_syn`
-- -----------------------------
DROP TABLE IF EXISTS `zan_setting_syn`;
CREATE TABLE `zan_setting_syn` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT '' COMMENT '配置的key键名',
  `value` text,
  `inc_type` varchar(64) DEFAULT '' COMMENT '配置分组',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='不分语言的数据处理标记表';

-- -----------------------------
-- Records of `zan_setting_syn`
-- -----------------------------
INSERT INTO `zan_setting_syn` VALUES ('1', 'syn_admin_logic_1731034059', '1', 'syn', '1731057941');
INSERT INTO `zan_setting_syn` VALUES ('2', 'syn_admin_logic_1731034060', '1', 'syn', '1731057941');
INSERT INTO `zan_setting_syn` VALUES ('3', 'syn_admin_logic_1731034061', '1', 'syn', '1731057941');
INSERT INTO `zan_setting_syn` VALUES ('4', 'syn_admin_logic_1731034062', '1', 'syn', '1731057941');
INSERT INTO `zan_setting_syn` VALUES ('5', 'syn_admin_logic_1731034063', '1', 'syn', '1731057941');
INSERT INTO `zan_setting_syn` VALUES ('6', 'syn_admin_logic_1731317074', '1', 'syn', '1732245160');
INSERT INTO `zan_setting_syn` VALUES ('7', 'syn_admin_logic_1731319559', '1', 'syn', '1732245160');
INSERT INTO `zan_setting_syn` VALUES ('8', 'syn_admin_logic_1732092089', '1', 'syn', '1732245160');
INSERT INTO `zan_setting_syn` VALUES ('9', 'syn_admin_logic_1731574937', '1', 'syn', '1732245160');
INSERT INTO `zan_setting_syn` VALUES ('10', 'syn_admin_logic_1731574934', '1', 'syn', '1732245160');
INSERT INTO `zan_setting_syn` VALUES ('11', 'syn_admin_logic_1731382107', '1', 'syn', '1732245160');
INSERT INTO `zan_setting_syn` VALUES ('12', 'syn_admin_logic_1731480386', '1', 'syn', '1732245160');
INSERT INTO `zan_setting_syn` VALUES ('13', 'syn_admin_logic_1732069289', '1', 'syn', '1732245160');
INSERT INTO `zan_setting_syn` VALUES ('14', 'syn_admin_logic_1732092087', '1', 'syn', '1732245160');
INSERT INTO `zan_setting_syn` VALUES ('15', 'syn_admin_logic_1732171330', '1', 'syn', '1733388333');
INSERT INTO `zan_setting_syn` VALUES ('16', 'syn_admin_logic_1732153126', '1', 'syn', '1733388333');
INSERT INTO `zan_setting_syn` VALUES ('17', 'syn_admin_logic_1732153127', '1', 'syn', '1733388333');
INSERT INTO `zan_setting_syn` VALUES ('18', 'syn_admin_logic_1732517850', '1', 'syn', '1733388334');
INSERT INTO `zan_setting_syn` VALUES ('19', 'syn_admin_logic_1732586784', '1', 'syn', '1733388334');
INSERT INTO `zan_setting_syn` VALUES ('20', 'syn_admin_logic_1733129516', '1', 'syn', '1733388335');
INSERT INTO `zan_setting_syn` VALUES ('21', 'syn_admin_logic_1733131407', '1', 'syn', '1733388335');
INSERT INTO `zan_setting_syn` VALUES ('22', 'syn_admin_logic_1733130636', '1', 'syn', '1733388335');
INSERT INTO `zan_setting_syn` VALUES ('23', 'syn_admin_logic_1733819719', '1', 'syn', '1734915986');
INSERT INTO `zan_setting_syn` VALUES ('24', 'syn_admin_logic_1734594113', '1', 'syn', '1734915986');
INSERT INTO `zan_setting_syn` VALUES ('25', 'syn_admin_logic_1734921436', '1', 'syn', '1740102310');
INSERT INTO `zan_setting_syn` VALUES ('26', 'syn_admin_logic_1740018283', '1', 'syn', '1740102340');

-- -----------------------------
-- Table structure for `zan_sharp_active`
-- -----------------------------
DROP TABLE IF EXISTS `zan_sharp_active`;
CREATE TABLE `zan_sharp_active` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `active_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动会场ID',
  `active_date` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动日期',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '活动状态(0禁用 1启用)',
  `is_del` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `active_id` (`active_id`,`lang`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='整点秒杀-活动会场表';


-- -----------------------------
-- Table structure for `zan_sharp_active_goods`
-- -----------------------------
DROP TABLE IF EXISTS `zan_sharp_active_goods`;
CREATE TABLE `zan_sharp_active_goods` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `active_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动会场ID',
  `active_time_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动场次ID',
  `aid` int(11) NOT NULL DEFAULT '0' COMMENT '文档id',
  `sharp_goods_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '秒杀商品ID',
  `sales_actual` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '实际销量',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='整点秒杀-活动会场与商品关联表';


-- -----------------------------
-- Table structure for `zan_sharp_active_time`
-- -----------------------------
DROP TABLE IF EXISTS `zan_sharp_active_time`;
CREATE TABLE `zan_sharp_active_time` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `active_time_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场次ID',
  `active_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动会场ID',
  `active_time` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '场次时间(0点-23点)',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '活动状态(0禁用 1启用)',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `active_time_id` (`active_time_id`,`lang`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='整点秒杀-活动会场场次表';


-- -----------------------------
-- Table structure for `zan_sharp_goods`
-- -----------------------------
DROP TABLE IF EXISTS `zan_sharp_goods`;
CREATE TABLE `zan_sharp_goods` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sharp_goods_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '秒杀商品ID',
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID->aid',
  `limit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '限购数量',
  `seckill_stock` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '秒杀商品库存总量',
  `seckill_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '秒杀价格',
  `sales` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '累积销量',
  `virtual_sales` int(11) NOT NULL DEFAULT '0' COMMENT '虚拟销量',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '100' COMMENT '商品排序(数字越小越靠前)',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '商品状态(0下架 1上架)',
  `is_del` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `is_sku` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1-多规格商品',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `sharp_goods_id` (`sharp_goods_id`,`lang`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='整点秒杀-商品表';


-- -----------------------------
-- Table structure for `zan_sharp_setting`
-- -----------------------------
DROP TABLE IF EXISTS `zan_sharp_setting`;
CREATE TABLE `zan_sharp_setting` (
  `key` varchar(30) NOT NULL DEFAULT '' COMMENT '设置项标示',
  `describe` varchar(255) NOT NULL DEFAULT '' COMMENT '设置项描述',
  `values` mediumtext NOT NULL COMMENT '设置内容(json格式)',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  UNIQUE KEY `unique_key` (`key`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='整点秒杀设置表';


-- -----------------------------
-- Table structure for `zan_shop_address`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_address`;
CREATE TABLE `zan_shop_address` (
  `addr_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '地址id',
  `users_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `consignee` varchar(60) NOT NULL DEFAULT '' COMMENT '收货人',
  `country` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '国家',
  `province` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '省份',
  `province_name` varchar(100) NOT NULL DEFAULT '' COMMENT '省份名称',
  `city` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '城市',
  `city_name` varchar(100) NOT NULL DEFAULT '' COMMENT '城市名称',
  `district` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '县区',
  `district_name` varchar(100) NOT NULL DEFAULT '' COMMENT '县区名称',
  `address` varchar(500) NOT NULL DEFAULT '' COMMENT '详细地址',
  `zipcode` varchar(10) NOT NULL DEFAULT '' COMMENT '邮政编码',
  `mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '手机',
  `email` varchar(60) NOT NULL DEFAULT '' COMMENT '电子邮件(用于游客结账时写入)',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否默认，0否，1是。',
  `lang` varchar(30) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`addr_id`),
  KEY `users_id` (`users_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='收货地址表';


-- -----------------------------
-- Table structure for `zan_shop_cart`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_cart`;
CREATE TABLE `zan_shop_cart` (
  `cart_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '购物车表',
  `users_id` int(10) unsigned DEFAULT '0' COMMENT '会员id',
  `product_id` int(10) unsigned DEFAULT '0' COMMENT '产品id',
  `product_num` int(10) unsigned DEFAULT '0' COMMENT '购买数量',
  `spec_value_id` varchar(100) DEFAULT '' COMMENT '规格值ID',
  `selected` tinyint(1) DEFAULT '1' COMMENT '购物车选中状态：0未选中，1选中',
  `lang` varchar(30) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '加入购物车的时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  `discount_active_id` int(11) DEFAULT '0' COMMENT '限时折扣ID,用来区分购物车的商品哪些是限时折扣活动的',
  PRIMARY KEY (`cart_id`),
  KEY `users_id` (`users_id`,`product_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='购物车表';


-- -----------------------------
-- Table structure for `zan_shop_coupon`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_coupon`;
CREATE TABLE `zan_shop_coupon` (
  `coupon_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `coupon_code` varchar(100) NOT NULL DEFAULT '' COMMENT '优惠券编号',
  `coupon_name` varchar(100) NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `coupon_color` varchar(25) NOT NULL DEFAULT '' COMMENT '优惠券颜色',
  `coupon_form` tinyint(1) NOT NULL DEFAULT '1' COMMENT '优惠券类型 1-满减券',
  `coupon_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '可使用商品(1全站通用，2指定商品，3指定商品分类)',
  `product_id` varchar(255) NOT NULL DEFAULT '' COMMENT '指定商品ID，在coupon_type=2时使用',
  `arctype_id` varchar(255) NOT NULL DEFAULT '' COMMENT '指定商品分类ID，在coupon_type=3时使用',
  `coupon_price` decimal(10,0) NOT NULL DEFAULT '0' COMMENT '优惠券金额，例如10',
  `conditions_use` decimal(10,0) NOT NULL DEFAULT '0' COMMENT '优惠券使用条件，例如300',
  `coupon_stock` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '优惠券库存，例如100',
  `redeem_points` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '兑换优惠券所需积分，为0则表示免费兑换',
  `redeem_authority` varchar(10) NOT NULL DEFAULT '' COMMENT '兑换权限，存入多个会员等级组ID',
  `valid_days` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '有效天数，例如30',
  `start_date` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '优惠券开放领取时间',
  `end_date` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '优惠券结束领取时间',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '100' COMMENT '规格排序号',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '优惠券状态(0=关闭，1=开启)',
  `use_type` int(1) NOT NULL DEFAULT '1' COMMENT '使用期限 \r\n1-固定日期\r\n 2-领取后当天开始N(valid_days)天内有效\r\n 2-领取后次日开始N(valid_days)天内有效',
  `use_start_time` int(11) NOT NULL COMMENT '使用期限开始时间',
  `use_end_time` int(11) NOT NULL COMMENT '使用期限结束时间',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '0-未删除 1-已删除',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`coupon_id`),
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `arctype_id` (`arctype_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='优惠券主表';


-- -----------------------------
-- Table structure for `zan_shop_coupon_use`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_coupon_use`;
CREATE TABLE `zan_shop_coupon_use` (
  `use_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `users_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `coupon_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '优惠券ID',
  `coupon_code` varchar(100) NOT NULL DEFAULT '' COMMENT '优惠券编号',
  `get_ip` varchar(15) NOT NULL DEFAULT '' COMMENT '领取时的IP地址',
  `get_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '优惠券领取时的时间',
  `use_status` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '优惠券使用状态(0未使用，1已使用，2已过期，3已冻结)',
  `use_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '优惠券使用时的时间',
  `start_time` int(10) NOT NULL DEFAULT '0' COMMENT '优惠券有效开始时间',
  `end_time` int(10) NOT NULL DEFAULT '0' COMMENT '优惠券有效结束时间',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`use_id`),
  KEY `coupon_id` (`coupon_id`) USING BTREE,
  KEY `coupon_code` (`coupon_code`) USING BTREE,
  KEY `users_id` (`users_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='优惠券-领取记录表';


-- -----------------------------
-- Table structure for `zan_shop_express`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_express`;
CREATE TABLE `zan_shop_express` (
  `express_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `express_code` varchar(32) NOT NULL DEFAULT '' COMMENT '物流code（快递100）',
  `express_name` varchar(32) NOT NULL DEFAULT '' COMMENT '物流名称',
  `express_lnitials` varchar(5) NOT NULL DEFAULT '' COMMENT '首字母',
  `is_choose` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '快递公司是否选中(0=否，1=是)',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序号',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `wx_delivery_id` varchar(20) DEFAULT '' COMMENT '微信快递编码',
  PRIMARY KEY (`express_id`)
) ENGINE=MyISAM AUTO_INCREMENT=598 DEFAULT CHARSET=utf8 COMMENT='快递公司表';

-- -----------------------------
-- Records of `zan_shop_express`
-- -----------------------------
INSERT INTO `zan_shop_express` VALUES ('1', 'yuantong', '圆通快递', 'Y', '0', '97', '1553911076', '1733211563', 'YTO');
INSERT INTO `zan_shop_express` VALUES ('2', 'shentong', '申通快递', 'S', '0', '98', '1553911076', '1733211563', 'STO');
INSERT INTO `zan_shop_express` VALUES ('3', 'shunfeng', '顺丰快递', 'S', '0', '98', '1553911076', '1733211563', 'SF');
INSERT INTO `zan_shop_express` VALUES ('4', 'yunda', '韵达快递', 'Y', '0', '99', '1553911076', '1733211563', 'YD');
INSERT INTO `zan_shop_express` VALUES ('5', 'debangwuliu', '德邦快递', 'D', '1', '2', '1553911076', '1733212246', 'DBL');
INSERT INTO `zan_shop_express` VALUES ('6', 'zhongtong', '中通快递', 'Z', '0', '99', '1553911076', '1733211563', 'ZTO');
INSERT INTO `zan_shop_express` VALUES ('7', 'huitongkuaidi', '百世快递', 'B', '0', '99', '1553911076', '1733211563', 'HTKY');
INSERT INTO `zan_shop_express` VALUES ('8', 'youzhengguonei', '邮政包裹', 'Y', '0', '99', '1553911076', '1733211563', 'YZPY');
INSERT INTO `zan_shop_express` VALUES ('9', 'ems', 'EMS', 'E', '0', '99', '1553911076', '1733211563', 'EMS');
INSERT INTO `zan_shop_express` VALUES ('10', 'youzhengguoji', '邮政国际', 'Y', '1', '1', '1553911076', '1733211587', '');
INSERT INTO `zan_shop_express` VALUES ('11', 'aolau', 'AOL澳通速递', 'A', '0', '100', '1553911076', '1733211563', 'AOL');
INSERT INTO `zan_shop_express` VALUES ('12', 'a2u', 'A2U速递', 'A', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('13', 'aae', 'AAE快递', 'A', '0', '100', '1553911076', '1733211563', 'AAE');
INSERT INTO `zan_shop_express` VALUES ('14', 'annengwuliu', '安能物流', 'A', '0', '100', '1553911076', '1733211563', 'ANE');
INSERT INTO `zan_shop_express` VALUES ('15', 'anxl', '安迅物流', 'A', '0', '100', '1553911076', '1733211563', 'AX');
INSERT INTO `zan_shop_express` VALUES ('16', 'auexpress', '澳邮中国快运', 'A', '0', '100', '1553911076', '1733211563', 'AUEXPRESS');
INSERT INTO `zan_shop_express` VALUES ('17', 'exfresh', '安鲜达', 'A', '0', '100', '1553911076', '1733211563', 'AXD');
INSERT INTO `zan_shop_express` VALUES ('18', 'anjie88', '安捷物流', 'A', '0', '100', '1553911076', '1733211563', 'AJ');
INSERT INTO `zan_shop_express` VALUES ('19', 'adodoxm', '澳多多国际速递', 'A', '1', '3', '1553911076', '1733212252', 'ADD');
INSERT INTO `zan_shop_express` VALUES ('20', 'ariesfar', '艾瑞斯远', 'A', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('21', 'qdants', 'ANTS EXPRESS', 'A', '0', '100', '1553911076', '1733211563', 'QDANTS');
INSERT INTO `zan_shop_express` VALUES ('22', 'astexpress', '安世通快递', 'A', '0', '100', '1553911076', '1733211563', 'ASTEXPRESS');
INSERT INTO `zan_shop_express` VALUES ('23', 'gda', '安的快递', 'A', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('24', 'ausexpress', '澳世速递', 'A', '0', '100', '1553911076', '1733211563', 'ZY_AUSE');
INSERT INTO `zan_shop_express` VALUES ('25', 'ibuy8', '爱拜物流', 'A', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('26', 'aplusex', 'Aplus物流', 'A', '0', '100', '1553911076', '1733211563', 'APLUSEX');
INSERT INTO `zan_shop_express` VALUES ('27', 'adapost', '安达速递', 'A', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('28', 'adiexpress', '安达易国际速递', 'A', '1', '4', '1553911076', '1733212269', '');
INSERT INTO `zan_shop_express` VALUES ('29', 'maxeedexpress', '澳洲迈速快递', 'A', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('30', 'onway', '昂威物流', 'A', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('31', 'bcwelt', 'BCWELT', 'B', '0', '100', '1553911076', '1733211563', 'BCWELT');
INSERT INTO `zan_shop_express` VALUES ('32', 'balunzhi', '巴伦支快递', 'B', '0', '100', '1553911076', '1733211563', 'BALUNZHI');
INSERT INTO `zan_shop_express` VALUES ('33', 'xiaohongmao', '北青小红帽', 'B', '0', '100', '1553911076', '1733211563', 'BQXHM');
INSERT INTO `zan_shop_express` VALUES ('34', 'bfdf', '百福东方物流', 'B', '0', '100', '1553911076', '1733211563', 'BFDF');
INSERT INTO `zan_shop_express` VALUES ('35', 'bangsongwuliu', '邦送物流', 'B', '0', '100', '1553911076', '1733211563', 'BSWL');
INSERT INTO `zan_shop_express` VALUES ('36', 'lbbk', '宝凯物流', 'B', '0', '100', '1553911076', '1733211563', 'BKWL');
INSERT INTO `zan_shop_express` VALUES ('37', 'bqcwl', '百千诚物流', 'B', '0', '100', '1553911076', '1733211563', 'BQC');
INSERT INTO `zan_shop_express` VALUES ('38', 'idada', '百成大达物流', 'B', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('39', 'baishiwuliu', '百世快运', 'B', '0', '100', '1553911076', '1733211563', 'BTWL');
INSERT INTO `zan_shop_express` VALUES ('40', 'baitengwuliu', '百腾物流', 'B', '0', '100', '1553911076', '1733211563', 'BETWL');
INSERT INTO `zan_shop_express` VALUES ('41', 'birdex', '笨鸟海淘', 'B', '0', '100', '1553911076', '1733211563', 'BN');
INSERT INTO `zan_shop_express` VALUES ('42', 'bsht', '百事亨通', 'B', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('43', 'benteng', '奔腾物流', 'B', '0', '100', '1553911076', '1733211563', 'BNTWL');
INSERT INTO `zan_shop_express` VALUES ('44', 'cuckooexpess', '布谷鸟速递', 'B', '0', '100', '1553911076', '1733211563', 'CUCKOOEXPRESS');
INSERT INTO `zan_shop_express` VALUES ('45', 'bgky100', '邦工快运', 'B', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('46', 'bosind', '堡昕德速递', 'B', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('47', 'banma', '斑马物联网', 'B', '0', '100', '1553911076', '1733211563', '360ZEBRA');
INSERT INTO `zan_shop_express` VALUES ('48', 'polarisexpress', '北极星快运', 'B', '0', '100', '1553911076', '1733211563', 'BJXKY');
INSERT INTO `zan_shop_express` VALUES ('49', 'beijingfengyue', '北京丰越供应链', 'B', '0', '100', '1553911076', '1733211563', 'BEIJINGFENGYUE');
INSERT INTO `zan_shop_express` VALUES ('50', 'europe8', '败欧洲', 'B', '0', '100', '1553911076', '1733211563', 'BEUROPE');
INSERT INTO `zan_shop_express` VALUES ('51', 'bmlchina', '标杆物流', 'B', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('52', 'comexpress', '邦通国际', 'B', '1', '5', '1553911076', '1733212269', '');
INSERT INTO `zan_shop_express` VALUES ('53', 'baotongkd', '宝通快递', 'B', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('54', 'beckygo', '佰麒快递', 'B', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('55', 'boyol', '贝业物流', 'B', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('56', 'bdatong', '八达通快递', 'B', '0', '100', '1553911076', '1733211563', 'BDT');
INSERT INTO `zan_shop_express` VALUES ('57', 'bangbangpost', '帮帮发', 'B', '0', '100', '1553911076', '1733211563', 'BBFZY');
INSERT INTO `zan_shop_express` VALUES ('58', 'baoxianda', '报通快递', 'B', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('59', 'coe', '中国东方(COE)', 'Z', '0', '100', '1553911076', '1733211563', 'COE');
INSERT INTO `zan_shop_express` VALUES ('60', 'cloudexpress', 'CE易欧通国际速递', 'C', '1', '6', '1553911076', '1733212270', '');
INSERT INTO `zan_shop_express` VALUES ('61', 'city100', '城市100', 'C', '0', '100', '1553911076', '1733211563', 'CITY100');
INSERT INTO `zan_shop_express` VALUES ('62', 'chuanxiwuliu', '传喜物流', 'C', '0', '100', '1553911076', '1733211563', 'CXHY');
INSERT INTO `zan_shop_express` VALUES ('63', 'chengjisudi', '城际速递', 'C', '0', '100', '1553911076', '1733211563', 'CJKD');
INSERT INTO `zan_shop_express` VALUES ('64', 'lijisong', '立即送', 'L', '0', '100', '1553911076', '1733211563', 'LJS');
INSERT INTO `zan_shop_express` VALUES ('65', 'chukou1', '出口易', 'C', '0', '100', '1553911076', '1733211563', 'CKY');
INSERT INTO `zan_shop_express` VALUES ('66', 'nanjingshengbang', '晟邦物流', 'C', '0', '100', '1553911076', '1733211563', 'NJSBWL');
INSERT INTO `zan_shop_express` VALUES ('67', 'flyway', '程光快递', 'C', '0', '100', '1553911076', '1733211563', 'CG');
INSERT INTO `zan_shop_express` VALUES ('68', 'cbo56', '钏博物流', 'C', '0', '100', '1553911076', '1733211563', 'CBO');
INSERT INTO `zan_shop_express` VALUES ('69', 'cex', '城铁速递', 'C', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('70', 'cnup', 'CNUP 中联邮', 'C', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('71', 'clsp', 'CL日中速运', 'C', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('72', 'cnair', 'CNAIR', 'C', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('73', 'cangspeed', '仓鼠快递', 'C', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('74', 'spring56', '春风物流', 'C', '0', '100', '1553911076', '1733211563', 'CFWL');
INSERT INTO `zan_shop_express` VALUES ('75', 'cunto', '村通快递', 'C', '0', '100', '1553911076', '1733211563', 'CUNTO');
INSERT INTO `zan_shop_express` VALUES ('76', 'longvast', '长风物流', 'C', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('77', 'changjiang', '长江国际速递', 'C', '1', '7', '1553911076', '1733212271', '');
INSERT INTO `zan_shop_express` VALUES ('78', 'cncexp', 'C&C国际速递', 'C', '1', '8', '1553911076', '1733212271', '');
INSERT INTO `zan_shop_express` VALUES ('79', 'parcelchina', '诚一物流', 'C', '0', '100', '1553911076', '1733211563', 'PARCELCHINA');
INSERT INTO `zan_shop_express` VALUES ('80', 'chengtong', '城通物流', 'C', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('81', 'otpexpress', '承诺达', 'C', '0', '100', '1553911076', '1733211563', 'CND');
INSERT INTO `zan_shop_express` VALUES ('82', 'sfpost', '曹操到', 'C', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('83', 'changwooair', '昌宇国际', 'C', '1', '9', '1553911076', '1733212272', '');
INSERT INTO `zan_shop_express` VALUES ('84', 'dhl', 'DHL快递（中国件）', 'D', '0', '100', '1553911076', '1733211563', 'DHL_C');
INSERT INTO `zan_shop_express` VALUES ('85', 'dhlen', 'DHL（国际件）', 'D', '1', '10', '1553911076', '1733212275', 'DHL_GLB');
INSERT INTO `zan_shop_express` VALUES ('86', 'dhlde', 'DHL（德国件）', 'D', '0', '100', '1553911076', '1733211563', 'DHL_DE');
INSERT INTO `zan_shop_express` VALUES ('87', 'dtwl', '大田物流', 'D', '0', '100', '1553911076', '1733211563', 'DTWL');
INSERT INTO `zan_shop_express` VALUES ('88', 'disifang', '递四方', 'D', '0', '100', '1553911076', '1733211563', 'D4PX');
INSERT INTO `zan_shop_express` VALUES ('89', 'dayangwuliu', '大洋物流', 'D', '0', '100', '1553911076', '1733211563', 'DYWL');
INSERT INTO `zan_shop_express` VALUES ('90', 'dechuangwuliu', '德创物流', 'D', '0', '100', '1553911076', '1733211563', 'DCWL');
INSERT INTO `zan_shop_express` VALUES ('91', 'dskd', 'D速物流', 'D', '0', '100', '1553911076', '1733211563', 'DSWL');
INSERT INTO `zan_shop_express` VALUES ('92', 'donghanwl', '东瀚物流', 'D', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('93', 'dfpost', '达方物流', 'D', '0', '100', '1553911076', '1733211563', 'IDFWL');
INSERT INTO `zan_shop_express` VALUES ('94', 'dongjun', '东骏快捷物流', 'D', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('95', 'dindon', '叮咚澳洲转运', 'D', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('96', 'dazhong', '大众佐川急便', 'D', '0', '100', '1553911076', '1733211563', 'SAGAWA');
INSERT INTO `zan_shop_express` VALUES ('97', 'ahdf', '德方物流', 'D', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('98', 'dehaoyi', '德豪驿', 'D', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('99', 'dhlpaket', 'DHL Paket', 'D', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('100', 'ubuy', '德国优拜物流', 'D', '0', '100', '1553911076', '1733211563', 'YBWL');
INSERT INTO `zan_shop_express` VALUES ('101', 'adlerlogi', '德国雄鹰速递', 'D', '0', '100', '1553911076', '1733211563', 'XYGJSD');
INSERT INTO `zan_shop_express` VALUES ('102', 'yunexpress', '德国云快递', 'D', '0', '100', '1553911076', '1733211563', 'DGYKD');
INSERT INTO `zan_shop_express` VALUES ('103', 'di5pll', '递五方云仓', 'D', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('104', 'deguo8elog', '德国八易转运', 'D', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('105', 'camekong', '到了港', 'D', '0', '100', '1553911076', '1733211563', 'DLG');
INSERT INTO `zan_shop_express` VALUES ('106', 'dbstation', 'db-station', 'D', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('107', 'dadaoex', '大道物流', 'D', '0', '100', '1553911076', '1733211563', 'DDWL');
INSERT INTO `zan_shop_express` VALUES ('108', 'dekuncn', '德坤物流', 'D', '0', '100', '1553911076', '1733211563', 'DEKUN');
INSERT INTO `zan_shop_express` VALUES ('109', 'twkd56', '缔惠盛合', 'D', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('110', 'gslexpress', '德尚国际速递', 'D', '1', '11', '1553911076', '1733212277', '');
INSERT INTO `zan_shop_express` VALUES ('111', 'eucpost', '德国 EUC POST', 'D', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('112', 'est365', '东方汇', 'D', '0', '100', '1553911076', '1733211563', 'EST365');
INSERT INTO `zan_shop_express` VALUES ('113', 'ecotransite', '东西E全运', 'D', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('114', 'euexpress', 'EU-EXPRESS', 'E', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('115', 'emsguoji', 'EMS国际快递查询', 'E', '1', '2', '1553911076', '1733212293', 'EMS');
INSERT INTO `zan_shop_express` VALUES ('116', 'eshunda', '俄顺达', 'E', '0', '100', '1553911076', '1733211563', '007EX');
INSERT INTO `zan_shop_express` VALUES ('117', 'ewe', 'EWE全球快递', 'E', '0', '100', '1553911076', '1733211563', 'EWE');
INSERT INTO `zan_shop_express` VALUES ('118', 'easyexpress', 'EASYEXPRESS国际速递', 'E', '1', '13', '1553911076', '1733212282', 'EASYEX');
INSERT INTO `zan_shop_express` VALUES ('119', 'edtexpress', 'e直运', 'E', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('120', 'ecallturn', 'E跨通', 'E', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('121', 'fedex', 'FedEx快递查询', 'F', '0', '100', '1553911076', '1733211563', 'FEDEX');
INSERT INTO `zan_shop_express` VALUES ('122', 'fedexus', 'FedEx（美国）', 'F', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('123', 'fox', 'FOX国际速递', 'F', '1', '3', '1553911076', '1733212295', '');
INSERT INTO `zan_shop_express` VALUES ('124', 'rufengda', '如风达快递', 'R', '0', '100', '1553911076', '1733211563', 'RFD');
INSERT INTO `zan_shop_express` VALUES ('125', 'fkd', '飞康达物流', 'F', '0', '100', '1553911076', '1733211563', 'FKD');
INSERT INTO `zan_shop_express` VALUES ('126', 'feibaokuaidi', '飞豹快递', 'F', '0', '100', '1553911076', '1733211563', 'FBKD');
INSERT INTO `zan_shop_express` VALUES ('127', 'fandaguoji', '颿达国际', 'F', '1', '100', '1553911076', '1733212302', '');
INSERT INTO `zan_shop_express` VALUES ('128', 'feiyuanvipshop', '飞远配送', 'F', '0', '100', '1553911076', '1733211563', 'FYPS');
INSERT INTO `zan_shop_express` VALUES ('129', 'hnfy', '飞鹰物流', 'F', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('130', 'fengxingtianxia', '风行天下', 'F', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('131', 'flysman', '飞力士物流', 'F', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('132', 'fbkd', '飞邦快递', 'F', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('133', 'sccod', '丰程物流', 'F', '0', '100', '1553911076', '1733211563', 'FCWL');
INSERT INTO `zan_shop_express` VALUES ('134', 'crazyexpress', '疯狂快递', 'F', '0', '100', '1553911076', '1733211563', 'CRAZY');
INSERT INTO `zan_shop_express` VALUES ('135', 'ftlexpress', '法翔速运', 'F', '0', '100', '1553911076', '1733211563', 'FX');
INSERT INTO `zan_shop_express` VALUES ('136', 'ftd', '富腾达快递', 'F', '0', '100', '1553911076', '1733211563', 'FTD');
INSERT INTO `zan_shop_express` VALUES ('137', 'arkexpress', '方舟国际速递', 'F', '1', '100', '1553911076', '1733212303', 'FZGJ');
INSERT INTO `zan_shop_express` VALUES ('138', 'fedroad', 'FedRoad 联邦转运', 'F', '1', '100', '1553911076', '1733212042', 'ZY_LBZY');
INSERT INTO `zan_shop_express` VALUES ('139', 'freakyquick', 'FQ狂派速递', 'F', '0', '100', '1553911076', '1733211563', 'FREAKYQUICK');
INSERT INTO `zan_shop_express` VALUES ('140', 'fecobv', '丰客物流', 'F', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('141', 'fyex', '飞云快递系统', 'F', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('142', 'beebird', '锋鸟物流', 'F', '0', '100', '1553911076', '1733211563', 'BEEBIRD');
INSERT INTO `zan_shop_express` VALUES ('143', 'shipgce', '飞洋快递', 'F', '0', '100', '1553911076', '1733211563', 'ZY_FY');
INSERT INTO `zan_shop_express` VALUES ('144', 'koali', '番薯国际货运', 'F', '1', '100', '1553911076', '1733212303', '');
INSERT INTO `zan_shop_express` VALUES ('145', 'epanex', '泛捷国际速递', 'F', '1', '100', '1553911076', '1733212304', 'PANEX');
INSERT INTO `zan_shop_express` VALUES ('146', 'gaticn', 'GATI快递', 'G', '0', '100', '1553911076', '1733211563', 'GATICN');
INSERT INTO `zan_shop_express` VALUES ('147', 'gts', 'GTS快递', 'G', '0', '100', '1553911076', '1733211563', 'GTSEXPRESS');
INSERT INTO `zan_shop_express` VALUES ('148', 'guotongkuaidi', '国通快递', 'G', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('149', 'ndkd', '能达速递', 'N', '0', '100', '1553911076', '1733211563', 'NEDA');
INSERT INTO `zan_shop_express` VALUES ('150', 'gongsuda', '共速达', 'G', '0', '100', '1553911076', '1733211563', 'GSD');
INSERT INTO `zan_shop_express` VALUES ('151', 'gtongsudi', '广通速递（山东）', 'G', '0', '100', '1553911076', '1733211563', 'GTKD');
INSERT INTO `zan_shop_express` VALUES ('152', 'suteng', '速腾物流', 'S', '0', '100', '1553911076', '1733211563', 'STWL');
INSERT INTO `zan_shop_express` VALUES ('153', 'gdkd', '港快速递', 'G', '0', '100', '1553911076', '1733211563', 'GKSD');
INSERT INTO `zan_shop_express` VALUES ('154', 'hre', '高铁速递', 'G', '0', '100', '1553911076', '1733211563', 'GTSD');
INSERT INTO `zan_shop_express` VALUES ('155', 'gscq365', '哥士传奇速递', 'G', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('156', 'gjwl', '冠捷物流', 'G', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('157', 'xdshipping', '国晶物流', 'G', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('158', 'ge2d', 'GE2D跨境物流', 'G', '0', '100', '1553911076', '1733211563', 'GE2D');
INSERT INTO `zan_shop_express` VALUES ('159', 'gaotieex', '高铁快运', 'G', '0', '100', '1553911076', '1733211563', 'GTKY');
INSERT INTO `zan_shop_express` VALUES ('160', 'gansuandi', '甘肃安的快递', 'G', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('161', 'gdct56', '广东诚通物流', 'G', '0', '100', '1553911076', '1733211563', 'CHTWL');
INSERT INTO `zan_shop_express` VALUES ('162', 'ghtexpress', 'GHT物流', 'G', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('163', 'goldjet', '高捷快运', 'G', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('164', 'gtgogo', 'GT国际快运', 'G', '1', '100', '1553911076', '1733212305', '');
INSERT INTO `zan_shop_express` VALUES ('165', 'gxwl', '光线速递', 'G', '0', '100', '1553911076', '1733211563', 'SUNSHINE');
INSERT INTO `zan_shop_express` VALUES ('166', 'tdhy', '华宇物流', 'H', '0', '100', '1553911076', '1733211563', 'TDHY');
INSERT INTO `zan_shop_express` VALUES ('167', 'hl', '恒路物流', 'H', '0', '100', '1553911076', '1733211563', 'HLWL');
INSERT INTO `zan_shop_express` VALUES ('168', 'hlyex', '好来运快递', 'H', '0', '100', '1553911076', '1733211563', 'HLYSD');
INSERT INTO `zan_shop_express` VALUES ('169', 'hebeijianhua', '河北建华', 'H', '0', '100', '1553911076', '1733211563', 'HBJH');
INSERT INTO `zan_shop_express` VALUES ('170', 'huaqikuaiyun', '华企快运', 'H', '0', '100', '1553911076', '1733211563', 'HQKY');
INSERT INTO `zan_shop_express` VALUES ('171', 'haosheng', '昊盛物流', 'H', '0', '100', '1553911076', '1733211563', 'HSWL');
INSERT INTO `zan_shop_express` VALUES ('172', 'hutongwuliu', '户通物流', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('173', 'hzpl', '华航快递', 'H', '0', '100', '1553911076', '1733211563', 'HHKD');
INSERT INTO `zan_shop_express` VALUES ('174', 'huangmajia', '黄马甲快递', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('175', 'ucs', '合众速递（UCS）', 'H', '0', '100', '1553911076', '1733211563', 'ZY_UCS');
INSERT INTO `zan_shop_express` VALUES ('176', 'pfcexpress', '皇家物流', 'H', '0', '100', '1553911076', '1733211563', 'HJWL');
INSERT INTO `zan_shop_express` VALUES ('177', 'huoban', '伙伴物流', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('178', 'nedahm', '红马速递', 'H', '0', '100', '1553911076', '1733211563', 'SXHMJ');
INSERT INTO `zan_shop_express` VALUES ('179', 'huiwen', '汇文配送', 'H', '0', '100', '1553911076', '1733211563', 'HFHW');
INSERT INTO `zan_shop_express` VALUES ('180', 'nmhuahe', '华赫物流', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('181', 'hjs', '猴急送', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('182', 'hangyu', '航宇快递', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('183', 'huilian', '辉联物流', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('184', 'huanqiu', '环球速运', 'H', '0', '100', '1553911076', '1733211563', 'HQSY');
INSERT INTO `zan_shop_express` VALUES ('185', 'htwd', '华通务达物流', 'H', '0', '100', '1553911076', '1733211563', 'ZY_HTONG');
INSERT INTO `zan_shop_express` VALUES ('186', 'hipito', '海派通', 'H', '0', '100', '1553911076', '1733211563', 'HPTEX');
INSERT INTO `zan_shop_express` VALUES ('187', 'hqtd', '环球通达', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('188', 'airgtc', '航空快递', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('189', 'haoyoukuai', '好又快物流', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('190', 'ccd', '河南次晨达', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('191', 'hfwuxi', '和丰同城', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('192', 'higo', '黑狗物流', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('193', 'hyytes', '恒宇运通', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('194', 'hengrui56', '恒瑞物流', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('195', 'hangrui', '上海航瑞货运', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('196', 'ghl', '环创物流', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('197', 'hnqst', '河南全速通', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('198', 'hitaoe', 'Hi淘易快递', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('199', 'hhair56', '华瀚快递', 'H', '0', '100', '1553911076', '1733211563', 'HHAIR56');
INSERT INTO `zan_shop_express` VALUES ('200', 'haimibuy', '海米派物流', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('201', 'ht22', '海淘物流', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('202', 'hivewms', '海沧无忧', 'H', '0', '100', '1553911076', '1733211563', 'HIVEWMS');
INSERT INTO `zan_shop_express` VALUES ('203', 'hnht56', '鸿泰物流', 'H', '0', '100', '1553911076', '1733211563', 'HTWL');
INSERT INTO `zan_shop_express` VALUES ('204', 'hsgtsd', '海硕高铁速递', 'H', '0', '100', '1553911076', '1733211563', 'HSGTSD');
INSERT INTO `zan_shop_express` VALUES ('205', 'hltop', '海联快递', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('206', 'hlkytj', '互联快运', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('207', 'haidaibao', '海带宝转运', 'H', '0', '100', '1553911076', '1733211563', 'ZY_HDB');
INSERT INTO `zan_shop_express` VALUES ('208', 'flowerkd', '花瓣转运', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('209', 'heimao56', '黑猫速运', 'H', '0', '100', '1553911076', '1733211563', 'TCATCN');
INSERT INTO `zan_shop_express` VALUES ('210', 'logistics', '華信物流WTO', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('211', 'hgy56', '环国运物流', 'H', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('212', 'iparcel', 'i-parcel', 'I', '0', '100', '1553911076', '1733211563', 'IPARCEL');
INSERT INTO `zan_shop_express` VALUES ('213', 'jjwl', '佳吉物流', 'J', '0', '100', '1553911076', '1733211563', 'JIAJI');
INSERT INTO `zan_shop_express` VALUES ('214', 'jywl', '佳怡物流', 'J', '0', '100', '1553911076', '1733211563', 'JYWL');
INSERT INTO `zan_shop_express` VALUES ('215', 'jymwl', '加运美快递', 'J', '0', '100', '1553911076', '1733211563', 'JYM');
INSERT INTO `zan_shop_express` VALUES ('216', 'jxd', '急先达物流', 'J', '0', '100', '1553911076', '1733211563', 'JXD');
INSERT INTO `zan_shop_express` VALUES ('217', 'jgsd', '京广速递快件', 'J', '0', '100', '1553911076', '1733211563', 'JGSD');
INSERT INTO `zan_shop_express` VALUES ('218', 'jykd', '晋越快递', 'J', '0', '100', '1553911076', '1733211563', 'JYKD');
INSERT INTO `zan_shop_express` VALUES ('219', 'jd', '京东物流', 'J', '0', '100', '1553911076', '1733211563', 'JD');
INSERT INTO `zan_shop_express` VALUES ('220', 'jietekuaidi', '捷特快递', 'J', '0', '100', '1553911076', '1733211563', 'JTKD');
INSERT INTO `zan_shop_express` VALUES ('221', 'jiuyicn', '久易快递', 'J', '0', '100', '1553911076', '1733211563', 'JYSD');
INSERT INTO `zan_shop_express` VALUES ('222', 'jiuyescm', '九曳供应链', 'J', '0', '100', '1553911076', '1733211563', 'JIUYE');
INSERT INTO `zan_shop_express` VALUES ('223', 'junfengguoji', '骏丰国际速递', 'J', '1', '100', '1553911076', '1733212305', '');
INSERT INTO `zan_shop_express` VALUES ('224', 'jiajiatong56', '佳家通', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('225', 'jrypex', '吉日优派', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('226', 'jinchengwuliu', '锦程国际物流', 'J', '1', '100', '1553911076', '1733212306', '');
INSERT INTO `zan_shop_express` VALUES ('227', 'jgwl', '景光物流', 'J', '0', '100', '1553911076', '1733211563', 'JGWL');
INSERT INTO `zan_shop_express` VALUES ('228', 'pzhjst', '急顺通', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('229', 'ruexp', '捷网俄全通', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('230', 'jialidatong', '嘉里大通', 'J', '0', '100', '1553911076', '1733211563', 'KERRYLOGISTICS');
INSERT INTO `zan_shop_express` VALUES ('231', 'jmjss', '金马甲', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('232', 'jiacheng', '佳成快递', 'J', '0', '100', '1553911076', '1733211563', 'JCEX');
INSERT INTO `zan_shop_express` VALUES ('233', 'jsexpress', '骏绅物流', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('234', 'hrex', '锦程快递', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('235', 'jieanda', '捷安达国际速递', 'J', '1', '100', '1553911076', '1733212312', 'JAD');
INSERT INTO `zan_shop_express` VALUES ('236', 'newsway', '家家通快递', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('237', 'mapleexpress', '今枫国际快运', 'J', '1', '100', '1553911076', '1733212314', 'JFGJ');
INSERT INTO `zan_shop_express` VALUES ('238', 'jixiangyouau', '吉祥邮（澳洲）', 'J', '0', '100', '1553911076', '1733211563', 'JXYKD');
INSERT INTO `zan_shop_express` VALUES ('239', 'jjx888', '佳捷翔物流', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('240', 'polarexpress', '极地快递', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('241', 'jiazhoumao', '加州猫速递', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('242', 'juzhongda', '聚中大', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('243', 'jieborne', '捷邦物流', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('244', 'jxfex', '集先锋速递', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('245', 'jiugong', '九宫物流', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('246', 'jiujiuwl', '久久物流', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('247', 'jintongkd', '劲通快递', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('248', 'jcsuda', '嘉诚速达', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('249', 'jingshun', '景顺物流', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('250', 'fastontime', '加拿大联通快运', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('251', 'khzto', '柬埔寨中通', 'J', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('252', 'kjkd', '快捷快递', 'K', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('253', 'kangliwuliu', '康力物流', 'K', '0', '100', '1553911076', '1733211563', 'KLWL');
INSERT INTO `zan_shop_express` VALUES ('254', 'kuayue', '跨越速运', 'K', '0', '100', '1553911076', '1733211563', 'KYSY');
INSERT INTO `zan_shop_express` VALUES ('255', 'kuaiyouda', '快优达速递', 'K', '0', '100', '1553911076', '1733211563', 'KYDSD');
INSERT INTO `zan_shop_express` VALUES ('256', 'happylink', '开心快递', 'K', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('257', 'ksudi', '快速递', 'K', '0', '100', '1553911076', '1733211563', 'KSDWL');
INSERT INTO `zan_shop_express` VALUES ('258', 'kyue', '跨跃国际', 'K', '1', '100', '1553911076', '1733212315', '');
INSERT INTO `zan_shop_express` VALUES ('259', 'kfwnet', '快服务', 'K', '0', '100', '1553911076', '1733211563', 'KFW');
INSERT INTO `zan_shop_express` VALUES ('260', 'kuai8', '快8速运', 'K', '0', '100', '1553911076', '1733211563', 'KBSY');
INSERT INTO `zan_shop_express` VALUES ('261', 'kuaidawuliu', '快达物流', 'K', '0', '100', '1553911076', '1733211563', 'KUAIDAWULIU');
INSERT INTO `zan_shop_express` VALUES ('262', 'lianb', '联邦快递（国内）', 'L', '0', '100', '1553911076', '1733211563', 'FEDEX');
INSERT INTO `zan_shop_express` VALUES ('263', 'lhtwl', '联昊通物流', 'L', '0', '100', '1553911076', '1733211563', 'LHT');
INSERT INTO `zan_shop_express` VALUES ('264', 'lb', '龙邦速递', 'L', '0', '100', '1553911076', '1733211563', 'LB');
INSERT INTO `zan_shop_express` VALUES ('265', 'lejiedi', '乐捷递', 'L', '0', '100', '1553911076', '1733211563', 'LJD');
INSERT INTO `zan_shop_express` VALUES ('266', 'lanhukuaidi', '蓝弧快递', 'L', '0', '100', '1553911076', '1733211563', 'LHKD');
INSERT INTO `zan_shop_express` VALUES ('267', 'ltexp', '乐天速递', 'L', '0', '100', '1553911076', '1733211563', 'LTIAN');
INSERT INTO `zan_shop_express` VALUES ('268', 'lutong', '鲁通快运', 'L', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('269', 'ledii', '乐递供应链', 'L', '0', '100', '1553911076', '1733211563', 'LEDII');
INSERT INTO `zan_shop_express` VALUES ('270', 'lundao', '论道国际物流', 'L', '1', '100', '1553911076', '1733212365', '');
INSERT INTO `zan_shop_express` VALUES ('271', 'lasy56', '林安物流', 'L', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('272', 'lsexpress', '6LS EXPRESS', 'L', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('273', 'szuem', '联运通物流', 'L', '0', '100', '1553911076', '1733211563', 'LYT');
INSERT INTO `zan_shop_express` VALUES ('274', 'blueskyexpress', '蓝天国际航空快递', 'L', '1', '100', '1553911076', '1733212365', 'BLUESKYEXPRESS');
INSERT INTO `zan_shop_express` VALUES ('275', 'lfexpress', '龙枫国际速递', 'L', '1', '100', '1553911076', '1733212366', '');
INSERT INTO `zan_shop_express` VALUES ('276', 'gslhkd', '联合快递', 'L', '0', '100', '1553911076', '1733211563', 'LHKDS');
INSERT INTO `zan_shop_express` VALUES ('277', 'longfx', '龙飞祥快递', 'L', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('278', 'luben', '陆本速递 LUBEN EXPRESS', 'L', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('279', 'unitedex', '联合速运', 'L', '0', '100', '1553911076', '1733211563', 'LHKDS');
INSERT INTO `zan_shop_express` VALUES ('280', 'lbex', '龙邦物流', 'L', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('281', 'ltparcel', '联通快递', 'L', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('282', 'macroexpressco', 'ME物流', 'M', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('283', 'mh', '民航快递', 'M', '0', '100', '1553911076', '1733211563', 'MHKD');
INSERT INTO `zan_shop_express` VALUES ('284', 'meiguokuaidi', '美国快递', 'M', '0', '100', '1553911076', '1733211563', 'USEX');
INSERT INTO `zan_shop_express` VALUES ('285', 'menduimen', '门对门', 'M', '0', '100', '1553911076', '1733211563', 'MDM');
INSERT INTO `zan_shop_express` VALUES ('286', 'mingliangwuliu', '明亮物流', 'M', '0', '100', '1553911076', '1733211563', 'MLWL');
INSERT INTO `zan_shop_express` VALUES ('287', 'minbangsudi', '民邦速递', 'M', '0', '100', '1553911076', '1733211563', 'MB');
INSERT INTO `zan_shop_express` VALUES ('288', 'minshengkuaidi', '闽盛快递', 'M', '0', '100', '1553911076', '1733211563', 'MSKD');
INSERT INTO `zan_shop_express` VALUES ('289', 'yundaexus', '美国韵达', 'M', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('290', 'mchy', '木春货运', 'M', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('291', 'meiquick', '美快国际物流', 'M', '1', '100', '1553911076', '1733212366', 'MK');
INSERT INTO `zan_shop_express` VALUES ('292', 'valueway', '美通快递', 'M', '0', '100', '1553911076', '1733211563', 'VALUEWAY');
INSERT INTO `zan_shop_express` VALUES ('293', 'cnmcpl', '马珂博逻', 'M', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('294', 'mailongdy', '迈隆递运', 'M', '0', '100', '1553911076', '1733211563', 'MRDY');
INSERT INTO `zan_shop_express` VALUES ('295', 'zsmhwl', '明辉物流', 'M', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('296', 'mosuda', '魔速达', 'M', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('297', 'meibang', '美邦国际快递', 'M', '1', '100', '1553911076', '1733212319', '');
INSERT INTO `zan_shop_express` VALUES ('298', 'nuoyaao', '偌亚奥国际', 'N', '1', '100', '1553911076', '1733212367', '');
INSERT INTO `zan_shop_express` VALUES ('299', 'nuoer', '诺尔国际物流', 'N', '1', '100', '1553911076', '1733212368', '');
INSERT INTO `zan_shop_express` VALUES ('300', 'nell', '尼尔快递', 'N', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('301', 'ndwl', '南方传媒物流', 'N', '0', '100', '1553911076', '1733211563', 'NFCM');
INSERT INTO `zan_shop_express` VALUES ('302', 'canhold', '能装能送', 'N', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('303', 'wanjiatong', '宁夏万家通', 'N', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('304', 'nlebv', '欧亚专线', 'O', '0', '100', '1553911076', '1733211563', 'EUASIA');
INSERT INTO `zan_shop_express` VALUES ('305', 'oborexpress', 'OBOR Express', 'O', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('306', 'pcaexpress', 'PCA Express', 'P', '0', '100', '1553911076', '1733211563', 'PCA');
INSERT INTO `zan_shop_express` VALUES ('307', 'pingandatengfei', '平安达腾飞', 'P', '0', '100', '1553911076', '1733211563', 'PADTF');
INSERT INTO `zan_shop_express` VALUES ('308', 'peixingwuliu', '陪行物流', 'P', '0', '100', '1553911076', '1733211563', 'PXWL');
INSERT INTO `zan_shop_express` VALUES ('309', 'pengyuanexpress', '鹏远国际速递', 'P', '1', '100', '1553911076', '1733212371', '');
INSERT INTO `zan_shop_express` VALUES ('310', 'postelbe', 'PostElbe', 'P', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('311', 'papascm', '啪啪供应链', 'P', '0', '100', '1553911076', '1733211563', 'PAPA');
INSERT INTO `zan_shop_express` VALUES ('312', 'bazirim', '皮牙子快递', 'P', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('313', 'qfkd', '全峰快递', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('314', 'qy', '全一快递', 'Q', '0', '100', '1553911076', '1733211563', 'UAPEX');
INSERT INTO `zan_shop_express` VALUES ('315', 'qrt', '全日通快递', 'Q', '0', '100', '1553911076', '1733211563', 'QRT');
INSERT INTO `zan_shop_express` VALUES ('316', 'qckd', '全晨快递', 'Q', '0', '100', '1553911076', '1733211563', 'QCKD');
INSERT INTO `zan_shop_express` VALUES ('317', 'sevendays', '7天连锁物流', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('318', 'qbexpress', '秦邦快运', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('319', 'quanxintong', '全信通快递', 'Q', '0', '100', '1553911076', '1733211563', 'QXT');
INSERT INTO `zan_shop_express` VALUES ('320', 'quansutong', '全速通国际快递', 'Q', '1', '100', '1553911076', '1733212377', '');
INSERT INTO `zan_shop_express` VALUES ('321', 'qinyuan', '秦远物流', 'Q', '0', '100', '1553911076', '1733211563', 'CHINZ56');
INSERT INTO `zan_shop_express` VALUES ('322', 'qichen', '启辰国际物流', 'Q', '1', '100', '1553911076', '1733212378', 'VENUCIA');
INSERT INTO `zan_shop_express` VALUES ('323', 'quansu', '全速快运', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('324', 'qzx56', '全之鑫物流', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('325', 'qskdyxgs', '千顺快递', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('326', 'zqlwl', '青旅物流', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('327', 'quanchuan56', '全川物流', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('328', 'quantwl', '全通快运', 'Q', '0', '100', '1553911076', '1733211563', 'IQTWL');
INSERT INTO `zan_shop_express` VALUES ('329', 'yatexpress', '乾坤物流', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('330', 'guexp', '全联速运', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('331', 'bjqywl', '青云物流', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('332', 'signedexpress', '签收快递', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('333', 'express7th', '7号速递', 'Q', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('334', 'riyuwuliu', '日昱物流', 'R', '0', '100', '1553911076', '1733211563', 'RLWL');
INSERT INTO `zan_shop_express` VALUES ('335', 'rfsd', '瑞丰速递', 'R', '0', '100', '1553911076', '1733211563', 'RFEX');
INSERT INTO `zan_shop_express` VALUES ('336', 'rrs', '日日顺物流', 'R', '0', '100', '1553911076', '1733211563', 'RRS');
INSERT INTO `zan_shop_express` VALUES ('337', 'rytsd', '日益通速递', 'R', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('338', 'rrskx', '日日顺快线', 'R', '0', '100', '1553911076', '1733211563', 'RRS');
INSERT INTO `zan_shop_express` VALUES ('339', 'gdrz58', '容智快运', 'R', '0', '100', '1553911076', '1733211563', 'GDRZ58');
INSERT INTO `zan_shop_express` VALUES ('340', 'rrthk', '日日通国际', 'R', '1', '100', '1553911076', '1733212378', '');
INSERT INTO `zan_shop_express` VALUES ('341', 'homecourier', '如家国际快递', 'R', '1', '100', '1553911076', '1733212379', '');
INSERT INTO `zan_shop_express` VALUES ('342', 'sewl', '速尔快递', 'S', '0', '100', '1553911076', '1733211563', 'SURE');
INSERT INTO `zan_shop_express` VALUES ('343', 'haihongwangsong', '山东海红', 'S', '0', '100', '1553911076', '1733211563', 'SDHH');
INSERT INTO `zan_shop_express` VALUES ('344', 'sh', '盛辉物流', 'S', '0', '100', '1553911076', '1733211563', 'SHWL');
INSERT INTO `zan_shop_express` VALUES ('345', 'sfwl', '盛丰物流', 'S', '0', '100', '1553911076', '1733211563', 'SFWL');
INSERT INTO `zan_shop_express` VALUES ('346', 'shiyunkuaidi', '世运快递', 'S', '0', '100', '1553911076', '1733211563', 'SYKD');
INSERT INTO `zan_shop_express` VALUES ('347', 'shangda', '上大物流', 'S', '0', '100', '1553911076', '1733211563', 'SDWL');
INSERT INTO `zan_shop_express` VALUES ('348', 'stsd', '三态速递', 'S', '0', '100', '1553911076', '1733211563', 'STSD');
INSERT INTO `zan_shop_express` VALUES ('349', 'saiaodi', '赛澳递', 'S', '0', '100', '1553911076', '1733211563', 'SAD');
INSERT INTO `zan_shop_express` VALUES ('350', 'ewl', '申通E物流', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('351', 'shenganwuliu', '圣安物流', 'S', '0', '100', '1553911076', '1733211563', 'SAWL');
INSERT INTO `zan_shop_express` VALUES ('352', 'sxhongmajia', '山西红马甲', 'S', '0', '100', '1553911076', '1733211563', 'SXHMJ');
INSERT INTO `zan_shop_express` VALUES ('353', 'suijiawuliu', '穗佳物流', 'S', '0', '100', '1553911076', '1733211563', 'SJWL');
INSERT INTO `zan_shop_express` VALUES ('354', 'syjiahuier', '沈阳佳惠尔', 'S', '0', '100', '1553911076', '1733211563', 'SYJHE');
INSERT INTO `zan_shop_express` VALUES ('355', 'shlindao', '上海林道货运', 'S', '0', '100', '1553911076', '1733211563', 'LDXPRESS');
INSERT INTO `zan_shop_express` VALUES ('356', 'sfift', '十方通物流', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('357', 'shunjiefengda', '顺捷丰达', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('358', 'subida', '速必达物流', 'S', '0', '100', '1553911076', '1733211563', 'SUBIDA');
INSERT INTO `zan_shop_express` VALUES ('359', 'stcd', '速通成达物流', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('360', 'stkd', '顺通快递', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('361', 'sendtochina', '速递中国', 'S', '0', '100', '1553911076', '1733211563', 'SENDCN');
INSERT INTO `zan_shop_express` VALUES ('362', 'sihaiet', '四海快递', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('363', 'staky', '首通快运', 'S', '0', '100', '1553911076', '1733211563', 'STONG');
INSERT INTO `zan_shop_express` VALUES ('364', 'hnssd56', '顺时达物流', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('365', 'superb', 'Superb Grace', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('366', 'sfjhd', '圣飞捷快递', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('367', 'sofast56', '嗖一下同城快递', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('368', 's2c', 'S2C', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('369', 'chinasqk', 'SQK国际速递', 'S', '1', '100', '1553911076', '1733212380', 'CHINASQK');
INSERT INTO `zan_shop_express` VALUES ('370', 'shunshid', '顺士达速运', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('371', 'synship', 'SYNSHIP快递', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('372', 'shandiantu', '闪电兔', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('373', 'sdsy888', '首达速运', 'S', '0', '100', '1553911076', '1733211563', 'SDSY');
INSERT INTO `zan_shop_express` VALUES ('374', 'sczpds', '速呈宅配', 'S', '0', '100', '1553911076', '1733211563', 'SCZPDS');
INSERT INTO `zan_shop_express` VALUES ('375', 'sureline', 'Sureline冠泰', 'S', '0', '100', '1553911076', '1733211563', 'GT');
INSERT INTO `zan_shop_express` VALUES ('376', 'stosolution', '申通国际', 'S', '1', '100', '1553911076', '1733212380', 'STO_INTL');
INSERT INTO `zan_shop_express` VALUES ('377', 'sycawl', '狮爱高铁物流', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('378', 'sxexpress', '三象速递', 'S', '0', '100', '1553911076', '1733211563', 'SXEXPRESS');
INSERT INTO `zan_shop_express` VALUES ('379', 'shangqiao56', '商桥物流', 'S', '0', '100', '1553911076', '1733211563', 'SQWL');
INSERT INTO `zan_shop_express` VALUES ('380', 'shd56', '商海德物流', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('381', 'shenma', '神马快递', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('382', 'sihiexpress', '四海捷运', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('383', 'superoz', '速配鸥翼', 'S', '0', '100', '1553911076', '1733211563', 'SUPEROZ');
INSERT INTO `zan_shop_express` VALUES ('384', 'fastgoexpress', '速派快递', 'S', '0', '100', '1553911076', '1733211563', 'FASTGO');
INSERT INTO `zan_shop_express` VALUES ('385', 'zjstky', '苏通快运', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('386', 'suning', '苏宁物流', 'S', '0', '100', '1553911076', '1733211563', 'SNWL');
INSERT INTO `zan_shop_express` VALUES ('387', 'shaoke', '捎客物流', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('388', 'sdto', '速达通跨境物流', 'S', '0', '100', '1553911076', '1733211563', 'SDTO');
INSERT INTO `zan_shop_express` VALUES ('389', 'sut56', '速通物流', 'S', '0', '100', '1553911076', '1733211563', 'ST');
INSERT INTO `zan_shop_express` VALUES ('390', 'sundarexpress', '顺达快递', 'S', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('391', 'sxjdfreight', '顺心捷达', 'S', '0', '100', '1553911076', '1733211563', 'SX');
INSERT INTO `zan_shop_express` VALUES ('392', 'shengtongscm', '盛通快递', 'S', '0', '100', '1553911076', '1733211563', 'STKD');
INSERT INTO `zan_shop_express` VALUES ('393', 'tnt', 'TNT快递', 'T', '1', '100', '1553911076', '1733212082', 'TNT');
INSERT INTO `zan_shop_express` VALUES ('394', 'tt', '天天快递', 'T', '0', '100', '1553911076', '1733211563', 'ZY_TTHT');
INSERT INTO `zan_shop_express` VALUES ('395', 'tianzong', '天纵物流', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('396', 'chinatzx', '同舟行物流', 'T', '0', '100', '1553911076', '1733211563', 'WHTZX');
INSERT INTO `zan_shop_express` VALUES ('397', 'nntengda', '腾达速递', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('398', 'sd138', '泰国138', 'T', '0', '100', '1553911076', '1733211563', 'TAILAND138');
INSERT INTO `zan_shop_express` VALUES ('399', 'tongdaxing', '通达兴物流', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('400', 'tlky', '天联快运', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('401', 'ibenben', '途鲜物流', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('402', 'krtao', '淘韩国际快递', 'T', '1', '100', '1553911076', '1733212381', '');
INSERT INTO `zan_shop_express` VALUES ('403', 'lntjs', '特急送', 'T', '0', '100', '1553911076', '1733211563', 'TJS');
INSERT INTO `zan_shop_express` VALUES ('404', 'tny', 'TNY物流', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('405', 'djy56', '天翔东捷运', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('406', 'guoeryue', '天天快物流', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('407', 'tianma', '天马迅达', 'T', '0', '100', '1553911076', '1733211563', 'ZY_TM');
INSERT INTO `zan_shop_express` VALUES ('408', 'surpassgo', '天越物流', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('409', 'tianxiang', '天翔快递', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('410', 'tywl99', '天翼物流', 'T', '0', '100', '1553911076', '1733211563', 'ZY_TY');
INSERT INTO `zan_shop_express` VALUES ('411', 'shpost', '同城快寄', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('412', 'humpline', '驼峰国际', 'T', '1', '100', '1553911076', '1733212382', '');
INSERT INTO `zan_shop_express` VALUES ('413', 'transrush', 'TransRush', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('414', 'tstexp', 'TST速运通', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('415', 'ctoexp', '泰国中通CTO', 'T', '0', '100', '1553911076', '1733211563', 'THAIZTO');
INSERT INTO `zan_shop_express` VALUES ('416', 'thaizto', '泰国中通ZTO', 'T', '0', '100', '1553911076', '1733211563', 'THAIZTO');
INSERT INTO `zan_shop_express` VALUES ('417', 'tswlcloud', '天使物流云', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('418', 'tzky', '铁中快运', 'T', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('419', 'tcxbthai', 'TCXB国际物流', 'T', '1', '100', '1553911076', '1733212383', '');
INSERT INTO `zan_shop_express` VALUES ('420', 'taimek', '天美快递', 'T', '0', '100', '1553911076', '1733211563', 'TAIMEK');
INSERT INTO `zan_shop_express` VALUES ('421', 'taoplus', '淘布斯国际物流', 'T', '1', '100', '1553911076', '1733212396', '');
INSERT INTO `zan_shop_express` VALUES ('422', 'ups', 'UPS快递查询', 'U', '0', '100', '1553911076', '1733211563', 'UPS');
INSERT INTO `zan_shop_express` VALUES ('423', 'yskd', '优速快递', 'Y', '0', '100', '1553911076', '1733211563', 'UC');
INSERT INTO `zan_shop_express` VALUES ('424', 'usps', 'USPS美国邮政', 'U', '0', '100', '1553911076', '1733211563', 'USPS');
INSERT INTO `zan_shop_express` VALUES ('425', 'ueq', 'UEQ快递', 'U', '0', '100', '1553911076', '1733211563', 'UEQ');
INSERT INTO `zan_shop_express` VALUES ('426', 'uex', 'UEX国际物流', 'U', '1', '100', '1553911076', '1733212398', 'UEX');
INSERT INTO `zan_shop_express` VALUES ('427', 'utaoscm', 'UTAO 优到', 'U', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('428', 'wxwl', '万象物流', 'W', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('429', 'weitepai', '微特派', 'W', '0', '100', '1553911076', '1733211563', 'WTP');
INSERT INTO `zan_shop_express` VALUES ('430', 'wjwl', '万家物流', 'W', '0', '100', '1553911076', '1733211563', 'WJWL');
INSERT INTO `zan_shop_express` VALUES ('431', 'wanboex', '万博快递', 'W', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('432', 'wtdchina', '威时沛运', 'W', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('433', 'wzhaunyun', '微转运', 'W', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('434', 'gswtkd', '万通快递', 'W', '0', '100', '1553911076', '1733211563', 'GSWTKD');
INSERT INTO `zan_shop_express` VALUES ('435', 'wandougongzhu', '豌豆物流', 'W', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('436', 'wjkwl', '万家康物流', 'W', '0', '100', '1553911076', '1733211563', 'WJK');
INSERT INTO `zan_shop_express` VALUES ('437', 'vps', '维普恩物流', 'W', '0', '100', '1553911076', '1733211563', 'WPE');
INSERT INTO `zan_shop_express` VALUES ('438', 'wykjt', '51跨境通', 'W', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('439', 'wherexpess', '威盛快递', 'W', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('440', 'weilaimingtian', '未来明天快递', 'W', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('441', 'wdm', '万达美', 'W', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('442', 'wto56kj', '温通物流', 'W', '0', '100', '1553911076', '1733211563', 'WTWL');
INSERT INTO `zan_shop_express` VALUES ('443', '56kuaiyun', '五六快运', 'W', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('444', 'wowvip', '沃埃家', 'W', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('445', 'grivertek', '潍鸿', 'W', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('446', 'xbwl', '新邦物流', 'X', '0', '100', '1553911076', '1733211563', 'XBWL');
INSERT INTO `zan_shop_express` VALUES ('447', 'xfwl', '信丰物流', 'X', '0', '100', '1553911076', '1733211563', 'XFEX');
INSERT INTO `zan_shop_express` VALUES ('448', 'newegg', '新蛋物流', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('449', 'xianglongyuntong', '祥龙运通物流', 'X', '0', '100', '1553911076', '1733211563', 'XLYT');
INSERT INTO `zan_shop_express` VALUES ('450', 'xianchengliansudi', '西安城联速递', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('451', 'xilaikd', '喜来快递', 'X', '0', '100', '1553911076', '1733211563', 'XLKD');
INSERT INTO `zan_shop_express` VALUES ('452', 'xsrd', '鑫世锐达', 'X', '0', '100', '1553911076', '1733211563', 'XSRD');
INSERT INTO `zan_shop_express` VALUES ('453', 'xtb', '鑫通宝物流', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('454', 'xintianjie', '信天捷快递', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('455', 'xaetc', '西安胜峰', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('456', 'xianfeng', '先锋快递', 'X', '0', '100', '1553911076', '1733211563', 'ZY_XF');
INSERT INTO `zan_shop_express` VALUES ('457', 'sunspeedy', '新速航', 'X', '0', '100', '1553911076', '1733211563', 'SUNSPEEDY');
INSERT INTO `zan_shop_express` VALUES ('458', 'xipost', '西邮寄', 'X', '0', '100', '1553911076', '1733211563', 'XYJ');
INSERT INTO `zan_shop_express` VALUES ('459', 'sinatone', '信联通', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('460', 'sunjex', '新杰物流', 'X', '0', '100', '1553911076', '1733211563', 'XJ');
INSERT INTO `zan_shop_express` VALUES ('461', 'alog', '心怡物流', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('462', 'csxss', '新时速物流', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('463', 'xiangteng', '翔腾物流', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('464', 'westwing', '西翼物流', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('465', 'littlebearbear', '小熊物流', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('466', 'huanqiuabc', '中国香港环球快运', 'Z', '0', '100', '1553911076', '1733211563', 'HQSY');
INSERT INTO `zan_shop_express` VALUES ('467', 'xinning', '新宁物流', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('468', 'wlwex', '星空国际', 'X', '1', '100', '1553911076', '1733212398', 'XKGJ');
INSERT INTO `zan_shop_express` VALUES ('469', 'yyexp', '西安运逸快递', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('470', 'xiyoug', '西游寄', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('471', 'xlobo', 'xLobo', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('472', 'xunsuexpress', '迅速快递', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('473', 'whgjkd', '香港伟豪国际物流', 'X', '1', '100', '1553911076', '1733212399', '');
INSERT INTO `zan_shop_express` VALUES ('474', 'xyd666', '鑫远东速运', 'X', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('475', 'xdexpress', '迅达速递', 'X', '0', '100', '1553911076', '1733211563', 'XDEXPRESS');
INSERT INTO `zan_shop_express` VALUES ('476', 'ytkd', '运通快递', 'Y', '0', '100', '1553911076', '1733211563', 'YTKD');
INSERT INTO `zan_shop_express` VALUES ('477', 'ycwl', '远成物流', 'Y', '0', '100', '1553911076', '1733211563', 'YCWL');
INSERT INTO `zan_shop_express` VALUES ('478', 'yfsd', '亚风速递', 'Y', '0', '100', '1553911076', '1733211563', 'YFSD');
INSERT INTO `zan_shop_express` VALUES ('479', 'yishunhang', '亿顺航', 'Y', '0', '100', '1553911076', '1733211563', 'YSH');
INSERT INTO `zan_shop_express` VALUES ('480', 'yfwl', '越丰物流', 'Y', '0', '100', '1553911076', '1733211563', 'YFEX');
INSERT INTO `zan_shop_express` VALUES ('481', 'yad', '源安达快递', 'Y', '0', '100', '1553911076', '1733211563', 'YAD');
INSERT INTO `zan_shop_express` VALUES ('482', 'yfh', '原飞航物流', 'Y', '0', '100', '1553911076', '1733211563', 'YFHEX');
INSERT INTO `zan_shop_express` VALUES ('483', 'yinjiesudi', '银捷速递', 'Y', '0', '100', '1553911076', '1733211563', 'YJSD');
INSERT INTO `zan_shop_express` VALUES ('484', 'yitongfeihong', '一统飞鸿', 'Y', '0', '100', '1553911076', '1733211563', 'YTFH');
INSERT INTO `zan_shop_express` VALUES ('485', 'yuxinwuliu', '宇鑫物流', 'Y', '0', '100', '1553911076', '1733211563', 'YXWL');
INSERT INTO `zan_shop_express` VALUES ('486', 'yitongda', '易通达', 'Y', '0', '100', '1553911076', '1733211563', 'YTD');
INSERT INTO `zan_shop_express` VALUES ('487', 'youbijia', '邮必佳', 'Y', '0', '100', '1553911076', '1733211563', 'YBJ');
INSERT INTO `zan_shop_express` VALUES ('488', 'yiqiguojiwuliu', '一柒物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('489', 'yinsu', '音素快运', 'Y', '0', '100', '1553911076', '1733211563', 'YSKY');
INSERT INTO `zan_shop_express` VALUES ('490', 'yilingsuyun', '亿领速运', 'Y', '0', '100', '1553911076', '1733211563', 'YLSY');
INSERT INTO `zan_shop_express` VALUES ('491', 'yujiawuliu', '煜嘉物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('492', 'gml', '英脉物流', 'Y', '0', '100', '1553911076', '1733211563', 'YMWL');
INSERT INTO `zan_shop_express` VALUES ('493', 'leopard', '云豹国际货运', 'Y', '1', '100', '1553911076', '1733212399', 'LEOPARDSCHINA');
INSERT INTO `zan_shop_express` VALUES ('494', 'czwlyn', '云南中诚', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('495', 'sdyoupei', '优配速运', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('496', 'yongchang', '永昌物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('497', 'yufeng', '御风速运', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('498', 'yousutongda', '优速通达', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('499', 'yongwangda', '永旺达快递', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('500', 'yingchao', '英超物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('501', 'edlogistics', '益递物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('502', 'yjxlm', '宜家行', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('503', 'onehcang', '一号仓', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('504', 'ycgky', '远成快运', 'Y', '0', '100', '1553911076', '1733211563', 'YCSY');
INSERT INTO `zan_shop_express` VALUES ('505', 'yunfeng56', '韵丰物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('506', 'iyoungspeed', '驿扬国际速运', 'Y', '1', '100', '1553911076', '1733212400', '');
INSERT INTO `zan_shop_express` VALUES ('507', 'zgyzt', '一站通快递', 'Y', '0', '100', '1553911076', '1733211563', 'YZTSY');
INSERT INTO `zan_shop_express` VALUES ('508', 'eupackage', '易优包裹', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('509', 'ydglobe', '云达通', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('510', 'el56', 'YLTD', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('511', 'yundx', '运东西', 'Y', '0', '100', '1553911076', '1733211563', 'YUNDX');
INSERT INTO `zan_shop_express` VALUES ('512', 'yangbaoguo', '洋包裹', 'Y', '0', '100', '1553911076', '1733211563', 'YBG');
INSERT INTO `zan_shop_express` VALUES ('513', 'uluckex', '优联吉运', 'Y', '0', '100', '1553911076', '1733211563', 'YLJY');
INSERT INTO `zan_shop_express` VALUES ('514', 'ecmscn', '易客满', 'Y', '0', '100', '1553911076', '1733211563', 'EKM');
INSERT INTO `zan_shop_express` VALUES ('515', 'ubonex', '优邦速运', 'Y', '0', '100', '1553911076', '1733211563', 'UBONEX');
INSERT INTO `zan_shop_express` VALUES ('516', 'yue777', '玥玛速运', 'Y', '0', '100', '1553911076', '1733211563', 'YMSY');
INSERT INTO `zan_shop_express` VALUES ('517', 'ywexpress', '远为快递', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('518', 'ezhuanyuan', '易转运', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('519', 'yiqisong', '一起送', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('520', 'yongbangwuliu', '永邦国际物流', 'Y', '1', '100', '1553911076', '1733212401', '');
INSERT INTO `zan_shop_express` VALUES ('521', 'yyox', '邮客全球速递', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('522', 'yihangmall', '易航物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('523', 'yiouzhou', '易欧洲国际物流', 'Y', '1', '100', '1553911076', '1733212401', '');
INSERT INTO `zan_shop_express` VALUES ('524', 'ykouan', '洋口岸', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('525', 'youyou', '优优速递', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('526', 'ytky168', '运通快运', 'Y', '0', '100', '1553911076', '1733211563', 'YTKD');
INSERT INTO `zan_shop_express` VALUES ('527', 'sixroad', '易普递', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('528', 'yourscm', '雅澳物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('529', 'euguoji', '易邮国际', 'Y', '1', '100', '1553911076', '1733212402', '');
INSERT INTO `zan_shop_express` VALUES ('530', 'uscbexpress', '易境达国际物流', 'Y', '1', '100', '1553911076', '1733212403', 'YJD');
INSERT INTO `zan_shop_express` VALUES ('531', 'yfsuyun', '驭丰速运', 'Y', '0', '100', '1553911076', '1733211563', 'YFSUYUN');
INSERT INTO `zan_shop_express` VALUES ('532', 'yimidida', '壹米滴答', 'Y', '0', '100', '1553911076', '1733211563', 'YMDD');
INSERT INTO `zan_shop_express` VALUES ('533', 'ugoexpress', '邮鸽速运', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('534', 'youban', '邮邦国际', 'Y', '1', '100', '1553911076', '1733212406', '');
INSERT INTO `zan_shop_express` VALUES ('535', 'hkems', '云邮跨境快递', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('536', 'youlai', '邮来速递', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('537', 'eta100', '易达国际速递', 'Y', '1', '100', '1553911076', '1733212407', '');
INSERT INTO `zan_shop_express` VALUES ('538', 'yatfai', '一辉物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('539', 'yzswuliu', '亚洲顺物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('540', 'yifankd', '艺凡快递', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('541', 'mantoo', '优能物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('542', 'vctrans', '越中国际物流', 'Y', '1', '100', '1553911076', '1733212408', '');
INSERT INTO `zan_shop_express` VALUES ('543', 'yhtlogistics', '宇航通物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('544', 'ycgglobal', 'YCG物流', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('545', 'yidihui', '驿递汇速递', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('546', 'yuanhhk', '远航国际快运', 'Y', '1', '100', '1553911076', '1733212409', '');
INSERT INTO `zan_shop_express` VALUES ('547', 'yiyou', '易邮速运', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('548', 'eusacn', '优莎速运', 'Y', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('549', 'uhi', '优海国际速递', 'Y', '1', '100', '1553911076', '1733212410', '');
INSERT INTO `zan_shop_express` VALUES ('550', 'zjs', '宅急送', 'Z', '0', '100', '1553911076', '1733211563', 'ZJS');
INSERT INTO `zan_shop_express` VALUES ('551', 'ztky', '中铁快运', 'Z', '0', '100', '1553911076', '1733211563', 'ZTWL');
INSERT INTO `zan_shop_express` VALUES ('552', 'ztwl', '中铁物流', 'Z', '0', '100', '1553911076', '1733211563', 'ZTWL');
INSERT INTO `zan_shop_express` VALUES ('553', 'zywl', '中邮物流', 'Z', '0', '100', '1553911076', '1733211563', 'ZYWL');
INSERT INTO `zan_shop_express` VALUES ('554', 'zhimakaimen', '芝麻开门', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('555', 'zhengzhoujianhua', '郑州建华', 'Z', '0', '100', '1553911076', '1733211563', 'ZZJH');
INSERT INTO `zan_shop_express` VALUES ('556', 'zhongsukuaidi', '中速快件', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('557', 'zhongtianwanyun', '中天万运', 'Z', '0', '100', '1553911076', '1733211563', 'ZTWY');
INSERT INTO `zan_shop_express` VALUES ('558', 'zhongruisudi', '中睿速递', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('559', 'zhongwaiyun', '中外运速递', 'Z', '0', '100', '1553911076', '1733211563', 'ZWYSD');
INSERT INTO `zan_shop_express` VALUES ('560', 'zengyisudi', '增益速递', 'Z', '0', '100', '1553911076', '1733211563', 'ZENY');
INSERT INTO `zan_shop_express` VALUES ('561', 'sujievip', '郑州速捷', 'Z', '0', '100', '1553911076', '1733211563', 'SJ');
INSERT INTO `zan_shop_express` VALUES ('562', 'ztong', '智通物流', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('563', 'zhichengtongda', '至诚通达快递', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('564', 'zhdwl', '众辉达物流', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('565', 'kuachangwuliu', '直邮易', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('566', 'topspeedex', '中运全速', 'Z', '0', '100', '1553911076', '1733211563', 'ZYQS');
INSERT INTO `zan_shop_express` VALUES ('567', 'otobv', '中欧快运', 'Z', '0', '100', '1553911076', '1733211563', 'ZO');
INSERT INTO `zan_shop_express` VALUES ('568', 'zsky123', '准实快运', 'Z', '0', '100', '1553911076', '1733211563', 'ZSKY');
INSERT INTO `zan_shop_express` VALUES ('569', 'cnws', '中国翼', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('570', 'zytdscm', '中宇天地', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('571', 'zhuanyunsifang', '转运四方', 'Z', '0', '100', '1553911076', '1733211563', 'A4PX');
INSERT INTO `zan_shop_express` VALUES ('572', 'hrbzykd', '卓烨快递', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('573', 'zhuoshikuaiyun', '卓实快运', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('574', 'chinaicip', '卓志速运', 'Z', '0', '100', '1553911076', '1733211563', 'ESDEX');
INSERT INTO `zan_shop_express` VALUES ('575', 'ynztsy', '纵通速运', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('576', 'zdepost', '直德邮', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('577', 'chinapostcb', '中邮电商', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('578', 'chunghwa56', '中骅物流', 'Z', '0', '100', '1553911076', '1733211563', 'ZHWL');
INSERT INTO `zan_shop_express` VALUES ('579', 'cosco', '中远e环球', 'Z', '0', '100', '1553911076', '1733211563', 'COSCO');
INSERT INTO `zan_shop_express` VALUES ('580', 'zf365', '珠峰速运', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('581', 'zhongtongkuaiyun', '中通快运', 'Z', '0', '100', '1553911076', '1733211563', 'ZTOKY');
INSERT INTO `zan_shop_express` VALUES ('582', 'eucnrail', '中欧国际物流', 'Z', '1', '100', '1553911076', '1733212411', 'ZO');
INSERT INTO `zan_shop_express` VALUES ('583', 'chnexp', '中翼国际物流', 'Z', '1', '100', '1553911076', '1733212413', '');
INSERT INTO `zan_shop_express` VALUES ('584', 'cccc58', '中集冷云', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('585', 'auvanda', '中联速递', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('586', 'zyzoom', '增速跨境', 'Z', '0', '100', '1553911076', '1733211563', 'ZYZOOM');
INSERT INTO `zan_shop_express` VALUES ('587', 'zhpex', '众派速递', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('588', 'byht', '展勤快递', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('589', 'zhongchuan', '众川国际', 'Z', '1', '100', '1553911076', '1733212413', '');
INSERT INTO `zan_shop_express` VALUES ('590', 'zhonghuanus', '中环转运', 'Z', '0', '100', '1553911076', '1733211563', 'ZHONGHUAN');
INSERT INTO `zan_shop_express` VALUES ('591', 'zhonghuan', '中环快递', 'Z', '0', '100', '1553911076', '1733211563', 'ZHONGHUAN');
INSERT INTO `zan_shop_express` VALUES ('592', 'uszcn', '转运中国', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('593', 'zhitengwuliu', '志腾物流', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('594', 'zsda56', '转瞬达集运', 'Z', '0', '100', '1553911076', '1733211563', '');
INSERT INTO `zan_shop_express` VALUES ('595', 'zjgj56', '振捷国际货运', 'Z', '1', '100', '1553911076', '1733212414', '');
INSERT INTO `zan_shop_express` VALUES ('596', 'jtexpress', '极兔速递', 'J', '0', '100', '1553911076', '1733211563', 'JTSD');
INSERT INTO `zan_shop_express` VALUES ('597', 'fengwang', '丰网速运', 'F', '0', '100', '1553911076', '1733211563', '');

-- -----------------------------
-- Table structure for `zan_shop_goods_label`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_goods_label`;
CREATE TABLE `zan_shop_goods_label` (
  `label_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `label_title` varchar(60) NOT NULL DEFAULT '' COMMENT '标签标题',
  `label_pic` varchar(250) NOT NULL DEFAULT '' COMMENT '标签路径',
  `label_intro` varchar(500) NOT NULL DEFAULT '' COMMENT '标签描述',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(1:启用; 2:禁用)',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`label_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='商城商品服务标签';

-- -----------------------------
-- Records of `zan_shop_goods_label`
-- -----------------------------
INSERT INTO `zan_shop_goods_label` VALUES ('1', '运费险', '/public/static/admin/images/fuwu1.png', '卖家为您购买的商品投保退货运费险（保单生效以确认订单页展示的运费险为准）', '1', '1701250984', '1702626503');
INSERT INTO `zan_shop_goods_label` VALUES ('2', '货到付款', '/public/static/admin/images/fuwu2.png', '支持送货上门后再收款，支持现金、POS机刷卡等方式', '1', '1701250984', '1702626503');
INSERT INTO `zan_shop_goods_label` VALUES ('3', '闪电退款', '/public/static/admin/images/fuwu3.png', '闪电退款为会员提供的快速退款服务', '1', '1701250984', '1702626503');
INSERT INTO `zan_shop_goods_label` VALUES ('4', '7天无理由退货', '/public/static/admin/images/fuwu4.png', '支持7天无理由退货(拆封后不支持)', '1', '1701250984', '1702626503');

-- -----------------------------
-- Table structure for `zan_shop_goods_label_bind`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_goods_label_bind`;
CREATE TABLE `zan_shop_goods_label_bind` (
  `bind_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID(archives 表 aid 字段)',
  `label_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品服务标签ID(shop_goods_label 表 label_id 字段)',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`bind_id`),
  KEY `aid` (`aid`) USING BTREE,
  KEY `label_id` (`label_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='商城商品服务标签与商品ID关联绑定表';


-- -----------------------------
-- Table structure for `zan_shop_order`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_order`;
CREATE TABLE `zan_shop_order` (
  `order_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单id',
  `order_code` varchar(50) NOT NULL DEFAULT '' COMMENT '订单编号',
  `users_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `merchant_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '多商家ID',
  `order_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单状态：0未付款(已下单)，1已付款(待发货)，2已发货(待收货)，3已完成(确认收货)，-1订单取消(已关闭)，4订单过期',
  `payment_method` tinyint(1) DEFAULT '0' COMMENT '订单支付方式，0为在线支付，1为货到付款，默认0',
  `pay_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `pay_name` varchar(20) NOT NULL DEFAULT '' COMMENT '支付方式名称',
  `wechat_pay_type` varchar(20) NOT NULL DEFAULT '' COMMENT '微信支付时，标记使用的支付类型（扫码支付，微信内部，微信H5页面）',
  `order_terminal` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '订单终端(1=电脑端、2=手机端、3微信小程序)',
  `contains_virtual` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '订单是否包含虚拟商品(1=不包含、2=包含)',
  `manual_refund` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '订单是否被手动关闭并退款',
  `refund_note` varchar(500) NOT NULL DEFAULT '' COMMENT '订单手动退款原因',
  `pay_details` text COMMENT '支付时返回的数据，以serialize序列化后存入，用于后续查询。',
  `express_order` varchar(50) DEFAULT '' COMMENT '发货物流单号',
  `express_name` varchar(32) DEFAULT '' COMMENT '发货物流名称',
  `express_code` varchar(32) DEFAULT '' COMMENT '发货物流code',
  `express_time` int(11) DEFAULT '0' COMMENT '发货时间',
  `consignee` varchar(30) NOT NULL DEFAULT '' COMMENT '收货人',
  `confirm_time` int(11) DEFAULT '0' COMMENT '收货确认时间',
  `allow_service` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '订单是否允许申请售后维权，0=允许申请维权，1=不允许申请维权',
  `obtain_scores` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '消费获得积分数',
  `is_obtain_scores` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '该订单是否已赠送积分，0=未赠送，1=已赠送',
  `shipping_fee` decimal(20,2) DEFAULT '0.00' COMMENT '订单运费',
  `order_total_amount` decimal(20,2) DEFAULT '0.00' COMMENT '订单总价',
  `order_amount` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '应付款金额',
  `order_total_num` int(10) DEFAULT '0' COMMENT '订单总数',
  `is_total_amount` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '订单是否已将实际支付金额(order表order_amount字段)累加到会员累计消费金额(users表order_total_amount字段) (0:未累计; 1:已累计;)',
  `country` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '国家',
  `province` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '省份',
  `province_name` varchar(100) NOT NULL DEFAULT '' COMMENT '省份名称',
  `city` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '城市',
  `city_name` varchar(100) NOT NULL DEFAULT '' COMMENT '城市名称',
  `district` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '县区',
  `district_name` varchar(100) NOT NULL DEFAULT '' COMMENT '县区名称',
  `address` varchar(500) NOT NULL DEFAULT '' COMMENT '收货地址',
  `email` varchar(60) NOT NULL DEFAULT '' COMMENT '电子邮件(用于游客结账时写入)',
  `mobile` varchar(20) DEFAULT '' COMMENT '手机',
  `zipcode` varchar(20) DEFAULT '' COMMENT '邮政编码',
  `prom_type` tinyint(1) unsigned DEFAULT '0' COMMENT '订单类型：0普通订单，1虚拟订单,2-核销订单(单次)',
  `virtual_delivery` text COMMENT '虚拟订单时，卖家发货给买家的回复',
  `admin_note` text COMMENT '管理员操作备注',
  `is_comment` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否已评论，0为否，1为是，默认0',
  `user_note` text COMMENT '会员备注',
  `group` varchar(50) DEFAULT '' COMMENT '订单分组',
  `order_md5` varchar(50) DEFAULT '' COMMENT '订单标识串，删除未付款的重复订单',
  `order_source` tinyint(3) DEFAULT '10' COMMENT '10-普通订单 20-秒杀订单',
  `order_source_id` int(10) DEFAULT '0' COMMENT '来源id(秒杀订单:active_time_id)',
  `lang` varchar(30) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned DEFAULT '0' COMMENT '下单时间',
  `update_time` int(11) unsigned DEFAULT '0' COMMENT '更新时间',
  `coupon_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '优惠券数据表ID',
  `use_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员的优惠券数据表ID',
  `coupon_price` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '使用的优惠券金额',
  `verify_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '核销记录表ID(weapp_verify表)',
  `logistics_type` int(11) unsigned NOT NULL DEFAULT '1' COMMENT '订单物流类型(1:快递发货; 2:到店核销;)',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `order_code` (`order_code`),
  KEY `users_id` (`users_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='订单主表';


-- -----------------------------
-- Table structure for `zan_shop_order_comment`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_order_comment`;
CREATE TABLE `zan_shop_order_comment` (
  `comment_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `users_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `order_code` varchar(50) NOT NULL DEFAULT '' COMMENT '订单编号',
  `details_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单明细表ID',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `total_score` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '总评分，1：好评，2中评，3差评',
  `content` text NOT NULL COMMENT '评论内容',
  `upload_img` varchar(3000) NOT NULL DEFAULT '' COMMENT '晒单图片',
  `admin_reply` varchar(1000) NOT NULL DEFAULT '' COMMENT '管理员回复',
  `ip_address` varchar(15) NOT NULL DEFAULT '' COMMENT 'IP地址',
  `is_show` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否显示：0否，1是',
  `is_anonymous` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否匿名评价：0否，1是',
  `is_new_comment` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否新版评价：0否，1是',
  `is_visitors` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否游客评价(0:否; 1:是;)',
  `visitors_name` varchar(60) NOT NULL DEFAULT '' COMMENT '游客评价时写入的昵称',
  `visitors_email` varchar(60) NOT NULL DEFAULT '' COMMENT '游客评价时写入的邮箱',
  `lang` varchar(30) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`comment_id`),
  KEY `users_id` (`users_id`),
  KEY `order_id` (`order_id`),
  KEY `details_id` (`details_id`),
  KEY `product_id` (`product_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='商品评价表';


-- -----------------------------
-- Table structure for `zan_shop_order_details`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_order_details`;
CREATE TABLE `zan_shop_order_details` (
  `details_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `order_id` int(10) NOT NULL DEFAULT '0' COMMENT '订单ID',
  `users_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '产品id',
  `product_name` varchar(100) NOT NULL DEFAULT '' COMMENT '产品名称',
  `num` int(10) NOT NULL DEFAULT '0' COMMENT '单个产品数量',
  `data` text COMMENT '序列化额外数据',
  `product_price` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '产品单价',
  `prom_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '产品类型：0普通产品，1虚拟产品',
  `litpic` varchar(500) NOT NULL DEFAULT '' COMMENT '封面图片',
  `apply_service` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否申请退换货服务：0 未申请、1已申请',
  `is_comment` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否已评论，0为否，1为是，默认0',
  `lang` varchar(30) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '下单时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`details_id`),
  KEY `users_id` (`users_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='订单详情表';


-- -----------------------------
-- Table structure for `zan_shop_order_log`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_order_log`;
CREATE TABLE `zan_shop_order_log` (
  `action_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `users_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `action_user` int(10) DEFAULT '0' COMMENT '操作人；0:用户操作；1以上:管理员id',
  `order_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单状态，单条记录状态',
  `express_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '物流状态，0:未发货，1:已发货',
  `pay_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '支付状态，0:未支付，1:已支付',
  `action_desc` varchar(255) DEFAULT '' COMMENT '状态描述',
  `action_note` varchar(255) NOT NULL DEFAULT '' COMMENT '操作备注',
  `lang` varchar(30) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`action_id`),
  KEY `order_id` (`order_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='订单操作记录表';


-- -----------------------------
-- Table structure for `zan_shop_order_service`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_order_service`;
CREATE TABLE `zan_shop_order_service` (
  `service_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `service_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '类型：1换货，2退货，3维修',
  `users_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `merchant_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '多商家ID',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `order_code` varchar(50) NOT NULL DEFAULT '' COMMENT '订单编号',
  `details_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单明细表ID',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '产品ID',
  `product_name` varchar(200) NOT NULL DEFAULT '' COMMENT '产品名称',
  `product_spec` varchar(200) NOT NULL DEFAULT '' COMMENT '产品规格',
  `product_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '产品数量',
  `product_img` varchar(500) NOT NULL DEFAULT '' COMMENT '产品图片',
  `content` varchar(500) NOT NULL DEFAULT '' COMMENT '退换货描述',
  `upload_img` varchar(3000) NOT NULL DEFAULT '' COMMENT '上传的图片',
  `address` varchar(500) NOT NULL DEFAULT '' COMMENT '退货的收货地址',
  `consignee` varchar(30) NOT NULL DEFAULT '' COMMENT '收货人',
  `mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '手机',
  `manual_refund` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '服务单是否被手动关闭并退款',
  `manual_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服务单手动退款时间',
  `refund_note` varchar(500) NOT NULL DEFAULT '' COMMENT '服务单手动退款原因',
  `refund_way` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '退款方式(1:退款到余额; 2:线下退款; 3:原路退回(微信))',
  `refund_price` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '退还金额',
  `refund_balance` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '退还余额',
  `refund_code` varchar(40) NOT NULL DEFAULT '' COMMENT '退款单号',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态：1审核中 2审核通过 3审核不通过 4已发货 5已收货 6换货完成 7退款完成 8服务取消',
  `audit_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '审核时间',
  `refund_remark` varchar(500) NOT NULL DEFAULT '' COMMENT '退款备注',
  `users_delivery` varchar(500) NOT NULL DEFAULT '' COMMENT '会员发货信息',
  `admin_delivery` varchar(500) NOT NULL DEFAULT '' COMMENT '管理员发货信息',
  `admin_note` varchar(1000) NOT NULL DEFAULT '' COMMENT '管理员操作备注',
  `lang` varchar(30) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '申请时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`service_id`),
  KEY `users_id` (`users_id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE,
  KEY `order_code` (`order_code`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `details_id` (`details_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='订单退换货服务表';


-- -----------------------------
-- Table structure for `zan_shop_order_service_log`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_order_service_log`;
CREATE TABLE `zan_shop_order_service_log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `service_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务表ID',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `users_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
  `log_note` varchar(500) NOT NULL DEFAULT '' COMMENT '记录备注',
  `lang` varchar(30) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`log_id`),
  KEY `service_id` (`service_id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE,
  KEY `users_id` (`users_id`) USING BTREE,
  KEY `admin_id` (`admin_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='订单退换货服务记录表';


-- -----------------------------
-- Table structure for `zan_shop_order_unified_pay`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_order_unified_pay`;
CREATE TABLE `zan_shop_order_unified_pay` (
  `unified_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '统一支付订单ID',
  `unified_number` varchar(30) NOT NULL DEFAULT '' COMMENT '统一支付订单编号',
  `unified_amount` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '统一支付订单应付款金额',
  `users_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `order_ids` text NOT NULL COMMENT '合并支付的订单ID，serialize序列化存储',
  `pay_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '统一支付订单状态：0未付款，1已付款',
  `pay_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '统一支付订单时间',
  `pay_name` varchar(20) NOT NULL DEFAULT '' COMMENT '统一支付订单方式名称',
  `wechat_pay_type` varchar(20) NOT NULL DEFAULT '' COMMENT '微信支付时，标记使用的支付类型（扫码支付，微信内部，微信H5页面）',
  `add_time` int(11) unsigned DEFAULT '0' COMMENT '下单时间',
  `update_time` int(11) unsigned DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`unified_id`),
  KEY `users_id` (`users_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='订单统一支付表';


-- -----------------------------
-- Table structure for `zan_shop_product_attr`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_product_attr`;
CREATE TABLE `zan_shop_product_attr` (
  `product_attr_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '产品属性id自增',
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '产品id',
  `attr_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '属性id',
  `attr_value` text NOT NULL COMMENT '属性值',
  `attr_price` varchar(255) DEFAULT '' COMMENT '属性价格',
  `is_custom` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否自定义参数(0否 1是)',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '100' COMMENT '属性排序',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`product_attr_id`),
  KEY `aid` (`aid`) USING BTREE,
  KEY `attr_id` (`attr_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

-- -----------------------------
-- Records of `zan_shop_product_attr`
-- -----------------------------
INSERT INTO `zan_shop_product_attr` VALUES ('1', '27', '1', 'EMUI 4.1 + Android 6.0', '', '0', '100', '1591262821', '1591262821');
INSERT INTO `zan_shop_product_attr` VALUES ('2', '27', '2', 'EMUI 4.1', '', '0', '100', '1591262821', '1591262821');
INSERT INTO `zan_shop_product_attr` VALUES ('3', '27', '3', '虚拟键盘', '', '0', '100', '1591262821', '1591262821');
INSERT INTO `zan_shop_product_attr` VALUES ('4', '27', '4', 'EDI-AL10', '', '0', '100', '1591262821', '1591262821');
INSERT INTO `zan_shop_product_attr` VALUES ('5', '27', '9', '64GB', '', '0', '100', '1591262821', '1591262821');
INSERT INTO `zan_shop_product_attr` VALUES ('6', '28', '5', '13.3', '', '0', '100', '1591262850', '1591262850');
INSERT INTO `zan_shop_product_attr` VALUES ('7', '28', '6', '3KG', '', '0', '100', '1591262850', '1591262850');
INSERT INTO `zan_shop_product_attr` VALUES ('8', '29', '7', 'AKG&amp;HUAWEI', '', '0', '100', '1591262874', '1591262874');
INSERT INTO `zan_shop_product_attr` VALUES ('9', '29', '8', '支持', '', '0', '100', '1591262874', '1591262874');
INSERT INTO `zan_shop_product_attr` VALUES ('19', '89', '2', 'Apple', '', '0', '100', '1591263033', '1591263033');
INSERT INTO `zan_shop_product_attr` VALUES ('12', '37', '3', '触摸', '', '0', '100', '1591262910', '1591262910');
INSERT INTO `zan_shop_product_attr` VALUES ('18', '89', '1', 'AppleiPhone 8 Plus', '', '0', '100', '1591263033', '1591263033');
INSERT INTO `zan_shop_product_attr` VALUES ('14', '37', '9', '256GB', '', '0', '100', '1591262910', '1591262910');
INSERT INTO `zan_shop_product_attr` VALUES ('15', '37', '1', 'EMUI 9.1 + Android 9.0', '', '0', '100', '1591262982', '1591262982');
INSERT INTO `zan_shop_product_attr` VALUES ('16', '37', '2', 'EMUI 9.1', '', '0', '100', '1591262982', '1591262982');
INSERT INTO `zan_shop_product_attr` VALUES ('17', '37', '4', 'EDI-AL12', '', '0', '100', '1591262982', '1591262982');
INSERT INTO `zan_shop_product_attr` VALUES ('20', '89', '3', '触摸', '', '0', '100', '1591263033', '1591263033');
INSERT INTO `zan_shop_product_attr` VALUES ('21', '89', '4', 'iPhone 8 Plus', '', '0', '100', '1591263033', '1591263033');
INSERT INTO `zan_shop_product_attr` VALUES ('22', '89', '9', '128GB', '', '0', '100', '1591263033', '1591263033');
INSERT INTO `zan_shop_product_attr` VALUES ('23', '90', '1', 'Android', '', '0', '100', '1591263065', '1591263065');
INSERT INTO `zan_shop_product_attr` VALUES ('24', '90', '2', '小米UI', '', '0', '100', '1591263065', '1591263065');
INSERT INTO `zan_shop_product_attr` VALUES ('25', '90', '3', '触摸', '', '0', '100', '1591263065', '1591263065');
INSERT INTO `zan_shop_product_attr` VALUES ('26', '90', '4', '小米8屏幕指纹版', '', '0', '100', '1591263065', '1591263065');
INSERT INTO `zan_shop_product_attr` VALUES ('27', '90', '9', '64GB', '', '0', '100', '1591263065', '1591263065');
INSERT INTO `zan_shop_product_attr` VALUES ('28', '98', '5', '12.2英寸', '', '0', '100', '1591263088', '1591263088');
INSERT INTO `zan_shop_product_attr` VALUES ('29', '98', '6', '1250g', '', '0', '100', '1591263088', '1591263088');
INSERT INTO `zan_shop_product_attr` VALUES ('30', '99', '5', '12.2英寸', '', '0', '100', '1591263111', '1591263111');
INSERT INTO `zan_shop_product_attr` VALUES ('31', '99', '6', '1250g', '', '0', '100', '1591263111', '1591263111');
INSERT INTO `zan_shop_product_attr` VALUES ('32', '100', '5', '14英寸', '', '0', '100', '1591263132', '1591263132');
INSERT INTO `zan_shop_product_attr` VALUES ('33', '100', '6', '1.5kg', '', '0', '100', '1591263132', '1591263132');
INSERT INTO `zan_shop_product_attr` VALUES ('34', '101', '7', 'X1', '', '0', '100', '1591263152', '1591263152');
INSERT INTO `zan_shop_product_attr` VALUES ('35', '101', '8', '支持', '', '0', '100', '1591263152', '1591263152');
INSERT INTO `zan_shop_product_attr` VALUES ('36', '103', '7', 'G1', '', '0', '100', '1610352876', '1610352876');
INSERT INTO `zan_shop_product_attr` VALUES ('37', '103', '8', '支持', '', '0', '100', '1610352876', '1610352876');
INSERT INTO `zan_shop_product_attr` VALUES ('38', '102', '7', 'MINI', '', '0', '100', '1610352910', '1610352910');
INSERT INTO `zan_shop_product_attr` VALUES ('39', '102', '8', '支持', '', '0', '100', '1610352910', '1610352910');

-- -----------------------------
-- Table structure for `zan_shop_product_attribute`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_product_attribute`;
CREATE TABLE `zan_shop_product_attribute` (
  `attr_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '属性id',
  `attr_name` varchar(60) NOT NULL DEFAULT '' COMMENT '属性名称',
  `list_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '栏目id',
  `attr_index` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0不需要检索 1关键字检索 2范围检索',
  `attr_input_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT ' 0=文本框，1=下拉框，2=多行文本框',
  `attr_values` text NOT NULL COMMENT '可选值列表',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0=禁用，1=启用)',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '属性排序',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已删除，0=否，1=是',
  `is_custom` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否自定义参数(0否 1是)',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`attr_id`),
  KEY `cat_id` (`list_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

-- -----------------------------
-- Records of `zan_shop_product_attribute`
-- -----------------------------
INSERT INTO `zan_shop_product_attribute` VALUES ('1', '操作系统', '1', '0', '0', '', '1', '100', 'cn', '0', '0', '1591262495', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('2', '用户界面', '1', '0', '0', '', '1', '100', 'cn', '0', '0', '1591262503', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('3', '键盘类型', '1', '0', '0', '', '1', '100', 'cn', '0', '0', '1591262510', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('4', '产品型号', '1', '0', '0', '', '1', '100', 'cn', '0', '0', '1591262517', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('5', '屏幕大小', '2', '0', '0', '', '1', '100', 'cn', '0', '0', '1591262613', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('6', '整机净重', '2', '0', '0', '', '1', '100', 'cn', '0', '0', '1591262620', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('7', '产品型号', '3', '0', '0', '', '1', '100', 'cn', '0', '0', '1591262712', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('8', '支持蓝牙', '3', '0', '0', '', '1', '100', 'cn', '0', '0', '1591262723', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('9', '机身内存', '1', '0', '1', '64GB\r\n128GB\r\n256GB', '1', '100', 'cn', '0', '0', '1591262771', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('10', '操作系统', '4', '0', '0', '', '1', '100', 'en', '0', '0', '1591262495', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('11', '用户界面', '4', '0', '0', '', '1', '100', 'en', '0', '0', '1591262503', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('12', '键盘类型', '4', '0', '0', '', '1', '100', 'en', '0', '0', '1591262510', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('13', '产品型号', '4', '0', '0', '', '1', '100', 'en', '0', '0', '1591262517', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('14', '机身内存', '4', '0', '1', '64GB\r\n128GB\r\n256GB', '1', '100', 'en', '0', '0', '1591262771', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('15', '屏幕大小', '5', '0', '0', '', '1', '100', 'en', '0', '0', '1591262613', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('16', '整机净重', '5', '0', '0', '', '1', '100', 'en', '0', '0', '1591262620', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('17', '产品型号', '6', '0', '0', '', '1', '100', 'en', '0', '0', '1591262712', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('18', '支持蓝牙', '6', '0', '0', '', '1', '100', 'en', '0', '0', '1591262723', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('19', '操作系统', '7', '0', '0', '', '1', '100', 'fr', '0', '0', '1591262495', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('20', '用户界面', '7', '0', '0', '', '1', '100', 'fr', '0', '0', '1591262503', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('21', '键盘类型', '7', '0', '0', '', '1', '100', 'fr', '0', '0', '1591262510', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('22', '产品型号', '7', '0', '0', '', '1', '100', 'fr', '0', '0', '1591262517', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('23', '机身内存', '7', '0', '1', '64GB\r\n128GB\r\n256GB', '1', '100', 'fr', '0', '0', '1591262771', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('24', '屏幕大小', '8', '0', '0', '', '1', '100', 'fr', '0', '0', '1591262613', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('25', '整机净重', '8', '0', '0', '', '1', '100', 'fr', '0', '0', '1591262620', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('26', '产品型号', '9', '0', '0', '', '1', '100', 'fr', '0', '0', '1591262712', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('27', '支持蓝牙', '9', '0', '0', '', '1', '100', 'fr', '0', '0', '1591262723', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('28', '操作系统', '10', '0', '0', '', '1', '100', 'de', '0', '0', '1591262495', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('29', '用户界面', '10', '0', '0', '', '1', '100', 'de', '0', '0', '1591262503', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('30', '键盘类型', '10', '0', '0', '', '1', '100', 'de', '0', '0', '1591262510', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('31', '产品型号', '10', '0', '0', '', '1', '100', 'de', '0', '0', '1591262517', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('32', '机身内存', '10', '0', '1', '64GB\r\n128GB\r\n256GB', '1', '100', 'de', '0', '0', '1591262771', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('33', '屏幕大小', '11', '0', '0', '', '1', '100', 'de', '0', '0', '1591262613', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('34', '整机净重', '11', '0', '0', '', '1', '100', 'de', '0', '0', '1591262620', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('35', '产品型号', '12', '0', '0', '', '1', '100', 'de', '0', '0', '1591262712', '1623813369');
INSERT INTO `zan_shop_product_attribute` VALUES ('36', '支持蓝牙', '12', '0', '0', '', '1', '100', 'de', '0', '0', '1591262723', '1623813369');

-- -----------------------------
-- Table structure for `zan_shop_product_attrlist`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_product_attrlist`;
CREATE TABLE `zan_shop_product_attrlist` (
  `list_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '列表id',
  `list_name` varchar(60) NOT NULL DEFAULT '' COMMENT '列表名称',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0=禁用，1=启用)',
  `attr_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '参数数量',
  `desc` text NOT NULL COMMENT '描述备注',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否已删除，0=否，1=是',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '100' COMMENT '列表排序',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`list_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- -----------------------------
-- Records of `zan_shop_product_attrlist`
-- -----------------------------
INSERT INTO `zan_shop_product_attrlist` VALUES ('1', '手机数码', '1', '5', '适用于手机数码栏目', '0', '100', 'cn', '1591262479', '1623813369');
INSERT INTO `zan_shop_product_attrlist` VALUES ('2', '电脑产品', '1', '2', '适用于电脑产品栏目', '0', '100', 'cn', '1591262601', '1623813369');
INSERT INTO `zan_shop_product_attrlist` VALUES ('3', '耳机', '1', '2', '适用于耳机栏目', '0', '100', 'cn', '1591262601', '1623813369');
INSERT INTO `zan_shop_product_attrlist` VALUES ('4', '手机数码', '1', '5', '适用于手机数码栏目', '0', '100', 'en', '1591262479', '1623813369');
INSERT INTO `zan_shop_product_attrlist` VALUES ('5', '电脑产品', '1', '2', '适用于电脑产品栏目', '0', '100', 'en', '1591262601', '1623813369');
INSERT INTO `zan_shop_product_attrlist` VALUES ('6', '耳机', '1', '2', '适用于耳机栏目', '0', '100', 'en', '1591262601', '1623813369');
INSERT INTO `zan_shop_product_attrlist` VALUES ('7', '手机数码', '1', '5', '适用于手机数码栏目', '0', '100', 'fr', '1591262479', '1623813369');
INSERT INTO `zan_shop_product_attrlist` VALUES ('8', '电脑产品', '1', '2', '适用于电脑产品栏目', '0', '100', 'fr', '1591262601', '1623813369');
INSERT INTO `zan_shop_product_attrlist` VALUES ('9', '耳机', '1', '2', '适用于耳机栏目', '0', '100', 'fr', '1591262601', '1623813369');
INSERT INTO `zan_shop_product_attrlist` VALUES ('10', '手机数码', '1', '5', '适用于手机数码栏目', '0', '100', 'de', '1591262479', '1623813369');
INSERT INTO `zan_shop_product_attrlist` VALUES ('11', '电脑产品', '1', '2', '适用于电脑产品栏目', '0', '100', 'de', '1591262601', '1623813369');
INSERT INTO `zan_shop_product_attrlist` VALUES ('12', '耳机', '1', '2', '适用于耳机栏目', '0', '100', 'de', '1591262601', '1623813369');

-- -----------------------------
-- Table structure for `zan_shop_shipping_template`
-- -----------------------------
DROP TABLE IF EXISTS `zan_shop_shipping_template`;
CREATE TABLE `zan_shop_shipping_template` (
  `template_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '运费模板ID',
  `template_region` varchar(255) NOT NULL DEFAULT '' COMMENT '模板运送区域',
  `template_money` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '模板运费',
  `province_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'region表id',
  `lang` varchar(30) DEFAULT 'cn' COMMENT '语言标识',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`template_id`)
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COMMENT='运费模板表';

-- -----------------------------
-- Records of `zan_shop_shipping_template`
-- -----------------------------
INSERT INTO `zan_shop_shipping_template` VALUES ('1', '北京市', '0.00', '1', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('2', '天津市', '0.00', '338', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('3', '河北省', '0.00', '636', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('4', '山西省', '0.00', '3102', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('5', '内蒙古自治区', '0.00', '4670', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('6', '辽宁省', '0.00', '5827', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('7', '吉林省', '0.00', '7531', 'cn', '1554775921');
INSERT INTO `zan_shop_shipping_template` VALUES ('8', '黑龙江省', '0.00', '8558', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('9', '上海市', '0.00', '10543', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('10', '江苏省', '0.00', '10808', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('11', '浙江省', '0.00', '12596', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('12', '安徽省', '0.00', '14234', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('13', '福建省', '0.00', '16068', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('14', '江西省', '0.00', '17359', 'cn', '1554775962');
INSERT INTO `zan_shop_shipping_template` VALUES ('15', '山东省', '0.00', '19280', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('16', '河南省', '0.00', '21387', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('17', '湖北省', '0.00', '24022', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('18', '湖南省', '0.00', '25579', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('19', '广东省', '0.00', '28240', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('20', '广西壮族自治区', '0.00', '30164', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('21', '海南省', '0.00', '31563', 'cn', '1555483193');
INSERT INTO `zan_shop_shipping_template` VALUES ('22', '重庆市', '0.00', '31929', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('23', '四川省', '0.00', '33007', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('24', '贵州省', '0.00', '37906', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('25', '云南省', '0.00', '39556', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('26', '西藏自治区', '0.00', '41103', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('27', '陕西省', '0.00', '41877', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('28', '甘肃省', '0.00', '43776', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('29', '青海省', '0.00', '45286', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('30', '宁夏回族自治区', '0.00', '45753', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('31', '新疆维吾尔自治区', '0.00', '46047', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('32', '台湾省', '0.00', '47493', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('33', '香港特别行政区', '0.00', '47494', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('34', '澳门特别行政区', '0.00', '47495', 'cn', '1554775610');
INSERT INTO `zan_shop_shipping_template` VALUES ('35', '统一配送价格', '0.00', '100000', 'cn', '1556618311');
INSERT INTO `zan_shop_shipping_template` VALUES ('36', '海外', '0.00', '47964', 'cn', '1692667955');

-- -----------------------------
-- Table structure for `zan_single_content`
-- -----------------------------
DROP TABLE IF EXISTS `zan_single_content`;
CREATE TABLE `zan_single_content` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `typeid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档栏目ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='文档主表 -- (单页)内容数据表';

-- -----------------------------
-- Records of `zan_single_content`
-- -----------------------------
INSERT INTO `zan_single_content` VALUES ('4', '16', '15', '&lt;p style=&quot;padding: 0px; margin-top: 0px; margin-bottom: 0px; box-sizing: border-box; color: rgb(51, 51, 51); font-family: Roboto, Lato, &amp;quot;Open Sans&amp;quot;, Poppins, Oswald, &amp;quot;Noto Sans&amp;quot;, Montserrat, sans-serif; text-wrap: wrap;&quot;&gt;某某设备企业是指专注于开发和利用新能源，以推动能源转型和应对气候变化为主要目标的企业。这些企业通常涉及可再生能源、清洁能源和节能技术等领域，致力于减少对传统化石能源的依赖，降低碳排放，促进可持续发展。&lt;/p&gt;&lt;p style=&quot;padding: 0px; margin-top: 0px; margin-bottom: 0px; box-sizing: border-box; color: rgb(51, 51, 51); font-family: Roboto, Lato, &amp;quot;Open Sans&amp;quot;, Poppins, Oswald, &amp;quot;Noto Sans&amp;quot;, Montserrat, sans-serif; text-wrap: wrap;&quot;&gt;新能源企业的业务范围广泛，包括太阳能、风能、水能、生物质能、地热能等可再生能源的开发和利用，也包括能源储存、智能电网、节能减排等方面的技术研究和应用推广。这些企业通过不断创新和突破，为全球能源结构的优化和可持续发展做出了积极贡献。&lt;/p&gt;&lt;p style=&quot;padding: 0px; margin-top: 0px; margin-bottom: 0px; box-sizing: border-box; color: rgb(51, 51, 51); font-family: Roboto, Lato, &amp;quot;Open Sans&amp;quot;, Poppins, Oswald, &amp;quot;Noto Sans&amp;quot;, Montserrat, sans-serif; text-wrap: wrap;&quot;&gt;在新能源企业中，有的专注于某一特定领域，如太阳能电池板的生产或风力发电设备的研发，而有的则涉及多个领域，构建了一个完整的清洁能源产业链。这些企业在国内外市场的竞争日益激烈，需要不断提高技术水平和创新能力，以应对市场的挑战和机遇。&lt;/p&gt;&lt;p style=&quot;padding: 0px; margin-top: 0px; margin-bottom: 0px; box-sizing: border-box; color: rgb(51, 51, 51); font-family: Roboto, Lato, &amp;quot;Open Sans&amp;quot;, Poppins, Oswald, &amp;quot;Noto Sans&amp;quot;, Montserrat, sans-serif; text-wrap: wrap;&quot;&gt;新能源企业的发展受到政策和市场的双重影响。政府在推动能源转型和应对气候变化方面发挥着重要作用，通过制定相关政策、标准和补贴机制来引导和促进新能源企业的发展。同时，市场需求也是新能源企业发展的重要动力，随着人们对清洁能源和可持续发展的认识不断提高，新能源企业的市场前景越来越广阔。&lt;/p&gt;&lt;p style=&quot;padding: 0px; margin-top: 0px; margin-bottom: 0px; box-sizing: border-box; color: rgb(51, 51, 51); font-family: Roboto, Lato, &amp;quot;Open Sans&amp;quot;, Poppins, Oswald, &amp;quot;Noto Sans&amp;quot;, Montserrat, sans-serif; text-wrap: wrap;&quot;&gt;总之，新能源企业是推动能源转型和应对气候变化的重要力量，在未来的发展中将发挥更加重要的作用。&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', '', '关于我们', '新能源,碳排放', '某某设备企业是指专注于开发和利用新能源，以推动能源转型和应对气候变化为主要目标的企业。这些企业通常涉及可再生能源、清洁能源和节能技术等领域，致力于减少对传统化石能源的依赖，降低碳排放，促进可持续发展。', '', '1727399159', '1732245160');
INSERT INTO `zan_single_content` VALUES ('5', '17', '16', '&lt;p&gt;&amp;quot;Contact Us&amp;quot; is usually a page or information section that provides a way for users to connect with companies, institutions, organizations, or individuals. This section usually provides contact information such as an email address, phone number, account on social media platforms, etc. In addition, it may also contain instructions on how to contact customer service, technical support, or sales, as well as instructions on how to provide feedback or complaints.&lt;/p&gt;', '', '联系我们', '', '&quot;Contact Us&quot; is usually a page or information section that provides a', '', '1728464226', '1732245160');
INSERT INTO `zan_single_content` VALUES ('7', '65', '17', '', '', 'FAQ', '', '', '', '1740104211', '1740104211');

-- -----------------------------
-- Table structure for `zan_single_content_cn`
-- -----------------------------
DROP TABLE IF EXISTS `zan_single_content_cn`;
CREATE TABLE `zan_single_content_cn` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `typeid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档栏目ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='文档主表 -- (单页)内容数据表';


-- -----------------------------
-- Table structure for `zan_single_content_en`
-- -----------------------------
DROP TABLE IF EXISTS `zan_single_content_en`;
CREATE TABLE `zan_single_content_en` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `typeid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档栏目ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='文档主表 -- (单页)内容数据表';

-- -----------------------------
-- Records of `zan_single_content_en`
-- -----------------------------
INSERT INTO `zan_single_content_en` VALUES ('2', '16', '15', '&lt;p&gt;In the long river of time, there are always some bright stars illuminating the way forward. [Clothing company name], is the shining star in the fashion starry sky. Since its establishment, we have embarked on this journey full of creativity and challenges with awe and pursuit of beauty. From the moment of inspiration to the careful selection of every inch of fabric, we treat every garment like a carved work of art. We travel through the fashion capitals of the world, drawing on cutting-edge design concepts, blending multiculturalism with unique aesthetics. Every season\'s new product release is a visual feast, a perfect collision of fashion and art. From elegant dresses to everyday casual wear, from exquisite accessories to personalized trendy clothes, our product line is rich and diverse, meeting the needs of different occasions and different groups of people. Exquisite craftsmanship is our soul. Experienced tailors, with their dexterous hands and a fiery ingenuity, interweave silk threads and fabrics into dream neon clothes. Every stitch and thread is poured into the dedication to quality; every cut and every cut contains the pursuit of perfection. At [Apparel Company Name], we are not only committed to creating external beauty, but also pay more attention to conveying an attitude to life. Wearing our clothes, you are the protagonist of self-confidence, whether it is walking on the streets of the city or attending important occasions, you can exude unique charm. We use fashion as the language and clothing as the carrier to tell the wonderful story that belongs to you. In the future, we will continue to uphold our original intention, constantly explore and innovate, lead the fashion trend, and bring you more beautiful surprises. Let us work together to bloom in the world of fashion. &lt;/p&gt;', '', 'About Us', 'New energy, carbon emissions', 'In the long river of time, there are always some bright stars illuminating the way forward. [Clothing company name], is the shining star in the fashion starry sky. Since its establishment, we have embarked on this creative and challenging journey with awe and pursuit of beauty. From the moment of inspiration to the careful selection of every inch of fabric, we treat each garment like a work of art.', '', '1727399183', '1732245160');
INSERT INTO `zan_single_content_en` VALUES ('3', '17', '16', '&lt;p&gt;&amp;quot;Contact Us&amp;quot; is usually a page or information section that provides a way for users to connect with companies, institutions, organizations, or individuals. This section usually provides contact information such as an email address, phone number, account on social media platforms, etc. In addition, it may also contain instructions on how to contact customer service, technical support, or sales, as well as instructions on how to provide feedback or complaints.&lt;/p&gt;', '', '联系我们', '', '&quot;Contact Us&quot; is usually a page or information section that provides a', '', '1729156516', '1732245160');

-- -----------------------------
-- Table structure for `zan_single_content_zh`
-- -----------------------------
DROP TABLE IF EXISTS `zan_single_content_zh`;
CREATE TABLE `zan_single_content_zh` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文档内容自增ID',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档主表自增ID',
  `typeid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档栏目ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `seo_title` varchar(255) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(255) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `short_content` text COMMENT '简短介绍',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `aid` (`aid`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='文档主表 -- (单页)内容数据表';


-- -----------------------------
-- Table structure for `zan_sms_log`
-- -----------------------------
DROP TABLE IF EXISTS `zan_sms_log`;
CREATE TABLE `zan_sms_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '表id',
  `source` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '发送来源，与场景ID对应：0=注册，1=绑定，2=登录密码，3=支付密码，4=找回密码',
  `sms_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '短信服务商类型，1---阿里云短信， 2---腾讯云短信',
  `mobile` varchar(11) NOT NULL DEFAULT '' COMMENT '手机号',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '发送时间',
  `code` varchar(10) NOT NULL DEFAULT '' COMMENT '验证码',
  `status` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '发送状态,1:成功,0:失败',
  `is_use` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否使用，1:是，0:否',
  `msg` varchar(255) NOT NULL DEFAULT '' COMMENT '短信内容',
  `ip` varchar(20) DEFAULT 'IP地址',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `error_msg` text NOT NULL COMMENT '发送短信异常内容',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='手机短信发送记录';


-- -----------------------------
-- Table structure for `zan_sms_template`
-- -----------------------------
DROP TABLE IF EXISTS `zan_sms_template`;
CREATE TABLE `zan_sms_template` (
  `tpl_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sms_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '短信服务商类型，1---阿里云短信， 2---腾讯云短信',
  `tpl_title` varchar(128) NOT NULL DEFAULT '' COMMENT '短信标题',
  `sms_sign` varchar(50) NOT NULL DEFAULT '' COMMENT '短信签名',
  `sms_tpl_code` varchar(100) NOT NULL DEFAULT '' COMMENT '短信模板ID',
  `tpl_content` varchar(1000) NOT NULL DEFAULT '' COMMENT '发送短信内容',
  `send_scene` varchar(100) NOT NULL DEFAULT '' COMMENT '短信发送场景',
  `is_open` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否开启使用这个模板，1为是，0为否。',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`tpl_id`)
) ENGINE=MyISAM AUTO_INCREMENT=61 DEFAULT CHARSET=utf8 COMMENT='手机短信发送模板';

-- -----------------------------
-- Records of `zan_sms_template`
-- -----------------------------
INSERT INTO `zan_sms_template` VALUES ('5', '2', '留言验证', '', '', '验证码为 {1} ，请在30分钟内输入验证。', '7', '1', 'en', '1610334638', '1610334638');
INSERT INTO `zan_sms_template` VALUES ('6', '2', '账号登录', '', '', '验证码为 {1} ，请在30分钟内输入验证。', '2', '1', 'en', '1610334638', '1610334638');
INSERT INTO `zan_sms_template` VALUES ('7', '1', '留言验证', '', '', '验证码为 ${content} ，请在30分钟内输入验证。', '7', '1', 'en', '1591262356', '1591262356');
INSERT INTO `zan_sms_template` VALUES ('12', '1', '账号登录', '', '', '验证码为 ${content} ，请在30分钟内输入验证。', '2', '1', 'en', '1591262356', '1591262356');
INSERT INTO `zan_sms_template` VALUES ('13', '2', '订单发货', '', '', '您有新的消息：您有新的{1}订单，请注意查收！', '6', '1', 'en', '1610334638', '1616460912');
INSERT INTO `zan_sms_template` VALUES ('14', '1', '订单发货', '', '', '您有新的消息：您有新的${content}订单，请注意查收！', '6', '1', 'en', '1591262356', '1616460912');
INSERT INTO `zan_sms_template` VALUES ('16', '2', '订单付款', '', '', '您有新的消息：您有新的{1}订单，请注意查收！', '5', '1', 'en', '1610334638', '1616460912');
INSERT INTO `zan_sms_template` VALUES ('18', '2', '找回密码', '', '', '验证码为 {1} ，请在30分钟内输入验证。', '4', '1', 'en', '1610334638', '1610334638');
INSERT INTO `zan_sms_template` VALUES ('19', '2', '手机绑定', '', '', '验证码为 {1} ，请在30分钟内输入验证。', '1', '1', 'en', '1610334638', '1610334638');
INSERT INTO `zan_sms_template` VALUES ('22', '2', '账号注册', '', '', '验证码为 {1} ，请在30分钟内输入验证。', '0', '1', 'en', '1610334638', '1610334638');
INSERT INTO `zan_sms_template` VALUES ('25', '1', '订单付款', '', '', '您有新的消息：您有新的${content}订单，请注意查收！', '5', '1', 'en', '1591262356', '1616460912');
INSERT INTO `zan_sms_template` VALUES ('27', '1', '找回密码', '', '', '验证码为 ${content} ，请在30分钟内输入验证。', '4', '1', 'en', '1591262356', '1591262356');
INSERT INTO `zan_sms_template` VALUES ('30', '1', '手机绑定', '', '', '验证码为 ${content} ，请在30分钟内输入验证。', '1', '1', 'en', '1591262356', '1591262356');
INSERT INTO `zan_sms_template` VALUES ('32', '1', '账号注册', '', '', '验证码为 ${content} ，请在30分钟内输入验证。', '0', '1', 'en', '1591262356', '1591262356');
INSERT INTO `zan_sms_template` VALUES ('33', '1', '留言表单', '', '', '您有新的留言消息，请查收！', '11', '1', 'en', '1591262356', '1591262356');
INSERT INTO `zan_sms_template` VALUES ('34', '2', '留言表单', '', '', '您有新的留言消息，请查收！', '11', '1', 'en', '1610334638', '1610334638');
INSERT INTO `zan_sms_template` VALUES ('35', '1', '投稿提醒', '', '', '您有新的会员投稿，请查看！', '20', '0', 'en', '1591262356', '1591262356');
INSERT INTO `zan_sms_template` VALUES ('36', '2', '投稿提醒', '', '', '您有新的会员投稿，请查看！', '20', '0', 'en', '1610334638', '1610334638');
INSERT INTO `zan_sms_template` VALUES ('37', '2', '后台登录', '', '', '验证码为 {1} ，请在30分钟内输入验证。', '30', '0', 'en', '1610334638', '1610334638');
INSERT INTO `zan_sms_template` VALUES ('38', '1', '后台登录', '', '', '验证码为 ${content} ，请在30分钟内输入验证。', '30', '0', 'en', '1591262356', '1591262356');

-- -----------------------------
-- Table structure for `zan_smtp_record`
-- -----------------------------
DROP TABLE IF EXISTS `zan_smtp_record`;
CREATE TABLE `zan_smtp_record` (
  `record_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `source` tinyint(1) DEFAULT '0' COMMENT '来源，与场景ID对应：0=默认，2=注册，3=绑定邮箱，4=找回密码',
  `email` varchar(50) DEFAULT '' COMMENT '邮件地址',
  `users_id` int(10) DEFAULT '0' COMMENT '用户ID',
  `code` varchar(20) DEFAULT '' COMMENT '发送邮件内容',
  `status` tinyint(1) DEFAULT '0' COMMENT '是否使用，默认0，0为未使用，1为使用',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`record_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='邮件发送记录表';


-- -----------------------------
-- Table structure for `zan_smtp_tpl`
-- -----------------------------
DROP TABLE IF EXISTS `zan_smtp_tpl`;
CREATE TABLE `zan_smtp_tpl` (
  `tpl_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `tpl_name` varchar(200) DEFAULT '' COMMENT '模板名称',
  `tpl_title` varchar(200) DEFAULT '' COMMENT '邮件标题',
  `tpl_content` text COMMENT '发送邮件内容',
  `send_scene` int(5) DEFAULT '0' COMMENT '邮件发送场景(1=留言表单）',
  `is_open` tinyint(1) DEFAULT '0' COMMENT '是否开启使用这个模板，1为是，0为否。',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`tpl_id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='邮件模板表';

-- -----------------------------
-- Records of `zan_smtp_tpl`
-- -----------------------------
INSERT INTO `zan_smtp_tpl` VALUES ('2', '询盘通知', '您有新的询盘消息，请查收！', '${content}', '1', '1', 'en', '1544763495', '1729241073');
INSERT INTO `zan_smtp_tpl` VALUES ('14', 'Member Registration', 'The verification code has been sent to your email. Please log in to your email to check the verification code!', '${content}', '2', '1', 'en', '1733388333', '1733388333');
INSERT INTO `zan_smtp_tpl` VALUES ('15', 'Bind email', 'The verification code has been sent to your email. Please log in to your email to check the verification code!', '${content}', '3', '1', 'en', '1733388333', '1733388333');
INSERT INTO `zan_smtp_tpl` VALUES ('16', 'Retrieve password', 'The verification code has been sent to your email. Please log in to your email to check the verification code!', '${content}', '4', '1', 'en', '1733388333', '1733388333');
INSERT INTO `zan_smtp_tpl` VALUES ('17', 'Order payment', 'You have new pending shipment order messages, please check the orders in the mall!', '${content}', '5', '1', 'en', '1733388333', '1733388333');
INSERT INTO `zan_smtp_tpl` VALUES ('18', 'Order shipment', 'You have new pending orders, please check the member orders!', '${content}', '6', '1', 'en', '1733388333', '1733388333');

-- -----------------------------
-- Table structure for `zan_special_content`
-- -----------------------------
DROP TABLE IF EXISTS `zan_special_content`;
CREATE TABLE `zan_special_content` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `aid` int(10) DEFAULT '0' COMMENT '文档ID',
  `content` longtext COMMENT '内容详情',
  `content_ey_m` longtext COMMENT '手机端内容详情',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `aid` (`aid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='专题附加表';


-- -----------------------------
-- Table structure for `zan_special_node`
-- -----------------------------
DROP TABLE IF EXISTS `zan_special_node`;
CREATE TABLE `zan_special_node` (
  `node_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档ID',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '节点名称',
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '节点标识',
  `isauto` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否自动获取文档',
  `keywords` varchar(200) NOT NULL DEFAULT '' COMMENT '关键字（多个中间用'',''分开）',
  `typeid` int(10) NOT NULL DEFAULT '0' COMMENT '栏目ID',
  `aidlist` text NOT NULL COMMENT '关联文章列表（多个中间用'',''分开）',
  `row` int(5) NOT NULL DEFAULT '10' COMMENT '文档数',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`node_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='专题节点表';


-- -----------------------------
-- Table structure for `zan_sql_cache_table`
-- -----------------------------
DROP TABLE IF EXISTS `zan_sql_cache_table`;
CREATE TABLE `zan_sql_cache_table` (
  `cache_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `sql_name` varchar(60) NOT NULL DEFAULT '' COMMENT 'mysql语句的标识名称，目前由模型名称+模型ID组成',
  `sql_result` text NOT NULL COMMENT 'mysql执行结果',
  `sql_md5` varchar(60) NOT NULL DEFAULT '' COMMENT 'mysql语句MD5的值',
  `sql_query` text NOT NULL COMMENT '完整mysql语句',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`cache_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='mysql缓存表';

-- -----------------------------
-- Records of `zan_sql_cache_table`
-- -----------------------------
INSERT INTO `zan_sql_cache_table` VALUES ('1', 'ArchivesMaxID', '67', 'cc22f07c8edec33a9886e67b084a2d12', 'SELECT MAX(aid) AS tp_max FROM `zan_archives` LIMIT 1', '1740369376', '1740369376');

-- -----------------------------
-- Table structure for `zan_statistics_data`
-- -----------------------------
DROP TABLE IF EXISTS `zan_statistics_data`;
CREATE TABLE `zan_statistics_data` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `date` int(10) DEFAULT '0',
  `num` int(10) DEFAULT '0',
  `type` mediumint(8) DEFAULT '1' COMMENT '1-浏览量 2-订单 3-销售额 4-新增会员 5-充值金额 6-商品数 7-文章数 8-tag数 9-待审数',
  `total` decimal(20,2) DEFAULT '0.00' COMMENT 'type=3/5用',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='商城欢迎页主题的统计表';

-- -----------------------------
-- Records of `zan_statistics_data`
-- -----------------------------
INSERT INTO `zan_statistics_data` VALUES ('1', '1740067200', '4', '1', '0.00');

-- -----------------------------
-- Table structure for `zan_tagindex`
-- -----------------------------
DROP TABLE IF EXISTS `zan_tagindex`;
CREATE TABLE `zan_tagindex` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'tagid',
  `tag` varchar(50) NOT NULL DEFAULT '' COMMENT 'tag内容',
  `typeid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '栏目ID',
  `litpic` varchar(250) DEFAULT '' COMMENT '封面图',
  `seo_title` varchar(200) DEFAULT '' COMMENT 'SEO标题',
  `seo_keywords` varchar(200) DEFAULT '' COMMENT 'SEO关键词',
  `seo_description` text COMMENT 'SEO描述',
  `count` int(10) unsigned DEFAULT '0' COMMENT '点击',
  `total` int(10) unsigned DEFAULT '0' COMMENT '文档数',
  `weekcc` int(10) unsigned DEFAULT '0' COMMENT '周统计',
  `monthcc` int(10) unsigned DEFAULT '0' COMMENT '月统计',
  `weekup` int(10) unsigned DEFAULT '0' COMMENT '每周更新',
  `monthup` int(10) unsigned DEFAULT '0' COMMENT '每月更新',
  `is_common` tinyint(1) DEFAULT '0' COMMENT '是否常用标签，0=否，1=是',
  `sort_order` int(10) DEFAULT '100' COMMENT '排序号',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(10) unsigned DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `typeid` (`typeid`) USING BTREE,
  KEY `count` (`count`,`total`,`weekcc`,`monthcc`,`weekup`,`monthup`,`add_time`) USING BTREE,
  KEY `tag` (`tag`) USING BTREE,
  KEY `lang` (`lang`,`add_time`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='标签索引表';


-- -----------------------------
-- Table structure for `zan_taglist`
-- -----------------------------
DROP TABLE IF EXISTS `zan_taglist`;
CREATE TABLE `zan_taglist` (
  `tid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'tagid',
  `aid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '文档ID',
  `typeid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '栏目ID',
  `tag` varchar(50) DEFAULT '' COMMENT 'tag内容',
  `arcrank` tinyint(1) DEFAULT '0' COMMENT '阅读权限',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`tid`,`aid`),
  KEY `aid` (`aid`,`typeid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='文章标签表';


-- -----------------------------
-- Table structure for `zan_ui_config`
-- -----------------------------
DROP TABLE IF EXISTS `zan_ui_config`;
CREATE TABLE `zan_ui_config` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '表id',
  `md5key` varchar(100) NOT NULL DEFAULT '' COMMENT '唯一键值（由 theme_style、page、name）组成',
  `theme_style` varchar(200) DEFAULT 'pc' COMMENT '模板风格',
  `page` varchar(64) DEFAULT '' COMMENT '页面分组',
  `type` varchar(50) DEFAULT '' COMMENT '编辑类型',
  `name` varchar(50) DEFAULT '' COMMENT '与页面的e-id对应',
  `value` text COMMENT '页面美化的val值',
  `idcode` varchar(50) DEFAULT '' COMMENT '页面唯一id标识（由 标识符+栏目id或文档id等）组成',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `md5key_2` (`md5key`,`lang`),
  KEY `md5key` (`md5key`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='可视化参数设置';

-- -----------------------------
-- Records of `zan_ui_config`
-- -----------------------------
INSERT INTO `zan_ui_config` VALUES ('3', '0e88d3e8fe9ec13ae445c611e5fd0203', 'default/pc', 'footer', 'text', 'f3', '{\"id\":\"f3\",\"type\":\"text\",\"page\":\"footer\",\"lang\":\"en\",\"idcode\":\"\",\"info\":{\"value\":\"Contact Us\"}}', '', 'en', '1730885832', '1730947396');
INSERT INTO `zan_ui_config` VALUES ('6', 'f530a8c985f3491b49756e3a79b0605d', 'default/pc', 'index', 'text', 'i2', '{\"id\":\"i2\",\"type\":\"text\",\"page\":\"index\",\"lang\":\"en\",\"idcode\":\"\",\"info\":{\"value\":\"Welcome to the official website of a company\"}}', '', 'en', '1730886371', '1730950006');
INSERT INTO `zan_ui_config` VALUES ('9', 'd08c4d91d355a6e60184a73463ec6141', 'default/pc', 'index', 'text', 'i21', '{\"id\":\"i21\",\"type\":\"text\",\"page\":\"index\",\"lang\":\"en\",\"idcode\":\"\",\"info\":{\"value\":\"Factory direct sales, first-hand supply, abundant supply, high-quality supply for you to choose from, give us a call, we provide high-quality products and services, so that love purchases more assured, choose the industry\'s high-quality women\'s clothing.\"}}', '', 'en', '1730886508', '1730886508');
INSERT INTO `zan_ui_config` VALUES ('12', '95c5e0d265436be2b6dfc42ff53542dc', 'default/pc', 'index', 'single', 'i31', '{\"id\":\"i31\",\"type\":\"single\",\"page\":\"index\",\"typeid\":\"15\",\"lang\":\"en\",\"idcode\":\"\",\"info\":{\"typeid\":\"15\",\"id\":\"i31\",\"type\":\"single\",\"page\":\"index\",\"v\":\"pc\",\"idcode\":\"\"}}', '', 'en', '1730886521', '1730886521');
INSERT INTO `zan_ui_config` VALUES ('18', '436ae16e2fa1cf1387cdb4e8f27e6f16', 'default/pc', 'header', 'text', 'h1', '{\"id\":\"h1\",\"type\":\"text\",\"page\":\"header\",\"lang\":\"en\",\"idcode\":\"\",\"info\":{\"value\":\"Welcome to the official website of a company\"}}', '', 'en', '1730947366', '1730950022');

-- -----------------------------
-- Table structure for `zan_uploads`
-- -----------------------------
DROP TABLE IF EXISTS `zan_uploads`;
CREATE TABLE `zan_uploads` (
  `img_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `type_id` int(10) NOT NULL DEFAULT '0' COMMENT '分组ID',
  `aid` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '文档ID',
  `title` varchar(500) DEFAULT '' COMMENT '文档标题',
  `image_url` varchar(255) DEFAULT '' COMMENT '文件存储路径',
  `intro` varchar(500) DEFAULT '' COMMENT '图集描述',
  `width` int(11) DEFAULT '0' COMMENT '图片宽度',
  `height` int(11) DEFAULT '0' COMMENT '图片高度',
  `filesize` int(11) unsigned DEFAULT '0' COMMENT '文件大小',
  `mime` varchar(50) DEFAULT '' COMMENT '图片类型',
  `users_id` int(11) DEFAULT '0' COMMENT '用户ID',
  `sort_order` smallint(5) DEFAULT '100' COMMENT '排序',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '1已删除 0未删除',
  `add_time` int(10) unsigned DEFAULT '0' COMMENT '上传时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`img_id`),
  KEY `aid` (`aid`) USING BTREE,
  KEY `add_time` (`add_time`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='上传记录表';

-- -----------------------------
-- Records of `zan_uploads`
-- -----------------------------
INSERT INTO `zan_uploads` VALUES ('1', '0', '0', '1-201014155953623.jpg', '/uploads/allimg/20250221/1-25022111211M01.jpg', '', '277', '335', '29543', 'image/jpeg', '0', '100', '0', '1740108077', '1740108077');
INSERT INTO `zan_uploads` VALUES ('2', '0', '0', '1-20101416013b12.jpg', '/uploads/allimg/20250221/1-25022111211UF.jpg', '', '277', '335', '15898', 'image/jpeg', '0', '100', '0', '1740108078', '1740108078');
INSERT INTO `zan_uploads` VALUES ('3', '0', '0', '1-201014160201461.jpg', '/uploads/allimg/20250221/1-25022111211UB.jpg', '', '277', '335', '13367', 'image/jpeg', '0', '100', '0', '1740108078', '1740108078');
INSERT INTO `zan_uploads` VALUES ('4', '0', '0', '1-2010141602224I.jpg', '/uploads/allimg/20250221/1-25022111211R38.jpg', '', '277', '335', '17327', 'image/jpeg', '0', '100', '0', '1740108078', '1740108078');

-- -----------------------------
-- Table structure for `zan_uploads_type`
-- -----------------------------
DROP TABLE IF EXISTS `zan_uploads_type`;
CREATE TABLE `zan_uploads_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `upload_type` varchar(50) NOT NULL DEFAULT '' COMMENT '名称',
  `add_time` int(10) NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='上传分组表';


-- -----------------------------
-- Table structure for `zan_users`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users`;
CREATE TABLE `zan_users` (
  `users_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '表id',
  `username` varchar(50) NOT NULL DEFAULT '' COMMENT '用户名',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '登录密码',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `is_mobile` tinyint(1) DEFAULT '0' COMMENT '绑定手机号，0为不绑定，1为绑定',
  `mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号码（仅用于登录）',
  `is_email` tinyint(1) DEFAULT '0' COMMENT '绑定邮箱，0为不绑定，1为绑定',
  `email` varchar(60) NOT NULL DEFAULT '' COMMENT '电子邮件（仅用于登录）',
  `paypwd` varchar(255) DEFAULT '' COMMENT '支付密码，暂时未用到，可保留。',
  `users_money` decimal(20,2) DEFAULT '0.00' COMMENT '用户金额',
  `frozen_money` decimal(20,2) DEFAULT '0.00' COMMENT '冻结金额',
  `scores` int(10) DEFAULT '0' COMMENT '积分',
  `devote` int(10) DEFAULT '0' COMMENT '贡献值',
  `reg_time` int(11) unsigned DEFAULT '0' COMMENT '注册时间',
  `last_login` int(11) unsigned DEFAULT '0' COMMENT '最后登录时间',
  `last_ip` varchar(15) DEFAULT '' COMMENT '最后登录ip',
  `login_count` int(11) DEFAULT '0' COMMENT '登陆次数',
  `head_pic` varchar(255) DEFAULT '' COMMENT '头像',
  `province` int(6) DEFAULT '0' COMMENT '省份',
  `city` int(6) DEFAULT '0' COMMENT '市区',
  `district` int(6) DEFAULT '0' COMMENT '县',
  `level` smallint(5) DEFAULT '0' COMMENT '会员等级',
  `open_level_time` int(11) unsigned DEFAULT '0' COMMENT '开通会员级别时间',
  `level_maturity_days` varchar(20) DEFAULT '' COMMENT '会员级别到期天数',
  `discount` decimal(20,2) DEFAULT '1.00' COMMENT '会员折扣，默认1不享受',
  `total_amount` decimal(20,2) DEFAULT '0.00' COMMENT '消费累计额度',
  `order_total_amount` decimal(20,2) unsigned DEFAULT '0.00' COMMENT '订单累计总额，用于会员自动升级。',
  `is_activation` tinyint(1) DEFAULT '1' COMMENT '是否激活，0否，1是。\r\n后台注册默认为1激活。\r\n前台注册时，当会员功能设置选择后台审核，需后台激活才可以登陆。',
  `register_place` tinyint(1) DEFAULT '2' COMMENT '注册位置。后台注册不受注册验证影响，1为后台注册，2为前台注册。默认为2。',
  `open_id` varchar(50) NOT NULL DEFAULT '' COMMENT '第三方唯一标识openid',
  `thirdparty` tinyint(1) DEFAULT '0' COMMENT '第三方注册类型 0=普通, 1=微信, 2=QQ, 3=手机号, 4=微信小程序， 5=微站点, 6-微信公众号, 7-百度小程序, 8-抖音小程序',
  `is_lock` tinyint(1) DEFAULT '0' COMMENT '是否被锁定冻结',
  `admin_id` int(10) DEFAULT '0' COMMENT '关联管理员ID',
  `lang` varchar(20) DEFAULT 'cn' COMMENT '语言标识',
  `is_del` tinyint(1) DEFAULT '0' COMMENT '伪删除，1=是，0=否',
  `unread_notice_num` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '未读消息数量',
  `update_time` int(11) unsigned DEFAULT '0' COMMENT '更新时间',
  `sex` varchar(10) DEFAULT '保密' COMMENT '性别- 男,女,保密',
  `coin` int(11) unsigned DEFAULT '0' COMMENT '金币',
  `union_id` varchar(50) NOT NULL DEFAULT '' COMMENT '微信用户的unionId',
  `source` tinyint(3) DEFAULT '1' COMMENT '来源\r\n1-PC端\r\n2-H5\r\n3-微信公众号\r\n4-微信小程序\r\n5-百度小程序\r\n6-抖音小程序\r\n',
  PRIMARY KEY (`users_id`),
  KEY `union_id` (`union_id`) USING BTREE,
  KEY `username` (`username`) USING BTREE,
  KEY `mobile` (`mobile`) USING BTREE,
  KEY `open_id` (`open_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='会员信息表';


-- -----------------------------
-- Table structure for `zan_users_bottom_menu`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_bottom_menu`;
CREATE TABLE `zan_users_bottom_menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `title` varchar(30) DEFAULT '' COMMENT '导航名称',
  `mca` varchar(50) DEFAULT '' COMMENT '分组/控制器/操作名',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '图标',
  `sort_order` int(10) DEFAULT '100' COMMENT '排序号',
  `status` tinyint(1) DEFAULT '1' COMMENT '功能开关状态，1=开启，0=关闭',
  `display` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否显示, 1--是, 0--否',
  `lang` varchar(20) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='会员中心移动端底部菜单表';

-- -----------------------------
-- Records of `zan_users_bottom_menu`
-- -----------------------------
INSERT INTO `zan_users_bottom_menu` VALUES ('1', '首页', 'home/Index/index', 'shouye', '100', '1', '1', 'cn', '1610334638', '1610334638');
INSERT INTO `zan_users_bottom_menu` VALUES ('2', '下载', 'user/Download/index', 'xiazai', '100', '1', '1', 'cn', '1610334638', '1610334638');
INSERT INTO `zan_users_bottom_menu` VALUES ('3', '发布', 'user/UsersRelease/article_add', 'fabu', '100', '0', '1', 'cn', '1610334638', '1725071336');
INSERT INTO `zan_users_bottom_menu` VALUES ('4', '我的', 'user/Users/centre', 'geren', '100', '1', '1', 'cn', '1610334638', '1610334638');

-- -----------------------------
-- Table structure for `zan_users_collection`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_collection`;
CREATE TABLE `zan_users_collection` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `users_id` int(10) DEFAULT '0',
  `aid` int(10) DEFAULT '0' COMMENT '文档id',
  `channel` int(10) DEFAULT '0' COMMENT '模型',
  `typeid` int(10) DEFAULT '0' COMMENT '栏目',
  `title` varchar(200) DEFAULT '' COMMENT '网站标题',
  `litpic` varchar(255) DEFAULT '' COMMENT '缩略图',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='我的收藏';


-- -----------------------------
-- Table structure for `zan_users_config`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_config`;
CREATE TABLE `zan_users_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT '' COMMENT '配置的key键名',
  `value` text COMMENT '配置的value值',
  `desc` varchar(100) DEFAULT '' COMMENT '键名说明',
  `inc_type` varchar(64) DEFAULT '' COMMENT '配置分组',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=76 DEFAULT CHARSET=utf8 COMMENT='会员功能配置表';

-- -----------------------------
-- Records of `zan_users_config`
-- -----------------------------
INSERT INTO `zan_users_config` VALUES ('35', 'users_reg_notallow', 'www,bbs,ftp,mail,user,users,admin,administrator,zancms', '不允许注册的会员名', 'users', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('36', 'users_open_release', '1', '', 'users', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('37', 'users_open_register', '0', '', 'users', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('38', 'users_open_reg', '0', '', 'users', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('39', 'users_verification', '0', '', 'users', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('40', 'users_login_expiretime', '3600', '', 'users', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('41', 'shop_open', '1', '', 'shop', 'en', '1740369342');
INSERT INTO `zan_users_config` VALUES ('42', 'shop_open_spec', '0', '', 'shop', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('43', 'score_signin_status', '1', '', 'score', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('44', 'score_signin_score', '3', '', 'score', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('45', 'score_name', '积分', '', 'score', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('46', 'score_intro', 'a) 积分不可兑现、不可转让,仅可在本平台使用;\\r\\nb) 您在本平台参加特定活动也可使用积分,详细使用规则以具体活动时的规则为准;\\r\\nc) 积分的数值精确到个位(小数点后全部舍弃,不进行四舍五入)\\r\\nd) 买家在完成该笔交易(订单状态为“已签收”)后才能得到此笔交易的相应积分,如购买商品参加店铺其他优惠,则优惠的金额部分不享受积分获取;', '', 'score', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('47', 'pay_open', '1', '', 'pay', 'en', '1740369342');
INSERT INTO `zan_users_config` VALUES ('48', 'pay_balance_open', '1', '', 'pay', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('49', 'order_right_protect_time', '7', '', 'order', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('50', 'memgift_open', '0', '', 'memgift', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('51', 'level_member_upgrade', '0', '', 'level', 'en', '1732245160');
INSERT INTO `zan_users_config` VALUES ('68', 'shop_visitors_pay', '1', '', 'shop', 'en', '1734915986');
INSERT INTO `zan_users_config` VALUES ('69', 'shop_open_shipping_type', '1', '', 'shop', 'en', '1734915986');
INSERT INTO `zan_users_config` VALUES ('70', 'shop_open_shipping_money', '10', '', 'shop', 'en', '1734915986');
INSERT INTO `zan_users_config` VALUES ('71', 'shop_open_comment_audit', '0', '', 'shop', 'en', '1734915986');
INSERT INTO `zan_users_config` VALUES ('72', 'order_unpay_close_time', '0', '', 'order', 'en', '1734915986');
INSERT INTO `zan_users_config` VALUES ('73', 'order_auto_receipt_time', '0', '', 'order', 'en', '1734915986');
INSERT INTO `zan_users_config` VALUES ('74', 'users_login_jump_type', '2', '', 'users', 'en', '1734915986');
INSERT INTO `zan_users_config` VALUES ('75', 'users_login_jump_url', '', '', 'users', 'en', '1734915986');

-- -----------------------------
-- Table structure for `zan_users_footprint`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_footprint`;
CREATE TABLE `zan_users_footprint` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `channel` int(10) DEFAULT '0' COMMENT '频道模型',
  `typeid` int(10) DEFAULT '0' COMMENT '栏目id',
  `aid` int(10) DEFAULT '0' COMMENT '文档id',
  `title` varchar(100) DEFAULT '' COMMENT '网站标题',
  `litpic` varchar(255) DEFAULT '' COMMENT '缩略图',
  `users_id` int(10) DEFAULT '0',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `users_id` (`users_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='我的足迹';


-- -----------------------------
-- Table structure for `zan_users_forward`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_forward`;
CREATE TABLE `zan_users_forward` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(10) DEFAULT '0',
  `aid` int(10) DEFAULT '0' COMMENT '文档id',
  `channel` int(10) DEFAULT '0' COMMENT '模型',
  `typeid` int(10) DEFAULT '0' COMMENT '栏目',
  `title` varchar(200) DEFAULT '' COMMENT '网站标题',
  `litpic` varchar(255) DEFAULT '' COMMENT '缩略图',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='转发记录';


-- -----------------------------
-- Table structure for `zan_users_level`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_level`;
CREATE TABLE `zan_users_level` (
  `auto_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `level_id` int(10) unsigned DEFAULT '1' COMMENT '级别ID',
  `level_name` varchar(30) DEFAULT '' COMMENT '级别名称',
  `level_value` int(10) DEFAULT '0' COMMENT '会员等级值',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '类型，1=系统，0=用户',
  `amount` decimal(10,2) DEFAULT '0.00' COMMENT '消费额度',
  `down_count` int(10) DEFAULT '0' COMMENT '每天下载次数限制',
  `discount_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '升级条件类型(0:不设置折扣; 1:自定义折扣)',
  `discount` float(10,2) DEFAULT '100.00' COMMENT '折扣率，初始值为100即100%，无折扣',
  `posts_count` int(10) DEFAULT '5' COMMENT '会员投稿次数限制',
  `ask_is_release` tinyint(1) DEFAULT '1' COMMENT '允许在问答中发布问题，1=是，0=否',
  `ask_is_review` tinyint(1) DEFAULT '0' COMMENT '在问答中发布问题或回答是否需要审核，1=是，0=否',
  `upgrade_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '升级条件类型(0:不自动升级; 1:订单金额)',
  `upgrade_order_money` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '累计完成订单金额满多少自动升级成当前会员等级',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '会员等级状态(0:禁用; 1:启用)',
  `lang` varchar(20) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  KEY `level_id` (`level_id`,`lang`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='会员级别表';

-- -----------------------------
-- Records of `zan_users_level`
-- -----------------------------
INSERT INTO `zan_users_level` VALUES ('7', '1', 'Register Member', '10', '1', '0.00', '100', '1', '100', '5', '1', '0', '0', '0.00', '1', 'en', '1733388333', '1733388333');
INSERT INTO `zan_users_level` VALUES ('8', '2', 'Intermediate Member ', '50', '0', '0.00', '100', '1', '100', '10', '1', '0', '0', '0.00', '1', 'en', '1733388333', '1733388333');
INSERT INTO `zan_users_level` VALUES ('9', '3', 'Premium Membership', '100', '0', '0.00', '100', '1', '100', '20', '1', '0', '0', '0.00', '1', 'en', '1733388333', '1733388333');

-- -----------------------------
-- Table structure for `zan_users_like`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_like`;
CREATE TABLE `zan_users_like` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(10) DEFAULT '0',
  `aid` int(10) DEFAULT '0' COMMENT '文档id',
  `channel` int(10) DEFAULT '0' COMMENT '模型',
  `typeid` int(10) DEFAULT '0' COMMENT '栏目',
  `title` varchar(200) DEFAULT '' COMMENT '网站标题',
  `litpic` varchar(255) DEFAULT '' COMMENT '缩略图',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='我喜欢的';


-- -----------------------------
-- Table structure for `zan_users_list`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_list`;
CREATE TABLE `zan_users_list` (
  `list_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `users_id` int(10) NOT NULL DEFAULT '0' COMMENT '会员ID',
  `para_id` int(10) NOT NULL DEFAULT '0' COMMENT '属性ID',
  `info` text COMMENT '属性值',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`list_id`),
  KEY `users_id` (`users_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='会员属性表(信息）';


-- -----------------------------
-- Table structure for `zan_users_log_off`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_log_off`;
CREATE TABLE `zan_users_log_off` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(11) DEFAULT '0',
  `username` varchar(25) DEFAULT NULL,
  `nickname` varchar(30) DEFAULT NULL,
  `mobile` varchar(25) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '0' COMMENT '0-审核中 1-通过 2-拒绝',
  `handle_time` int(11) DEFAULT '0' COMMENT '操作时间',
  `admin_id` int(11) DEFAULT '0' COMMENT '操作人',
  `refuse_reason` varchar(255) DEFAULT NULL COMMENT '拒绝原因',
  `add_time` int(11) DEFAULT '0' COMMENT '申请时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='会员注销日志表';


-- -----------------------------
-- Table structure for `zan_users_login_log`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_login_log`;
CREATE TABLE `zan_users_login_log` (
  `log_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '会员日志自增ID',
  `users_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `log_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '日志时间，年月日(例:20230406)',
  `log_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '日志次数',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`log_id`),
  UNIQUE KEY `users_id` (`users_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='会员登录日志 - 用于登录赠送积分';


-- -----------------------------
-- Table structure for `zan_users_menu`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_menu`;
CREATE TABLE `zan_users_menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `title` varchar(30) DEFAULT '' COMMENT '导航名称',
  `version` varchar(10) DEFAULT 'weapp' COMMENT '分组',
  `mca` varchar(200) DEFAULT '' COMMENT '分组/控制器/操作名',
  `active_url` varchar(500) DEFAULT '' COMMENT '标记为选中的url',
  `is_userpage` tinyint(1) DEFAULT '0' COMMENT '默认会员首页',
  `sort_order` int(10) DEFAULT '0' COMMENT '排序号',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态，1=显示，0=隐藏',
  `lang` varchar(20) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  `type` tinyint(3) DEFAULT '0' COMMENT '左侧菜单类型',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='会员菜单表';

-- -----------------------------
-- Records of `zan_users_menu`
-- -----------------------------
INSERT INTO `zan_users_menu` VALUES ('1', '个人信息', 'v1', 'user/Users/index', '', '1', '100', '1', 'cn', '1555904190', '1555917737', '0');
INSERT INTO `zan_users_menu` VALUES ('2', '账户充值', 'v1', 'user/Pay/pay_consumer_details', '', '0', '100', '1', 'cn', '1555904190', '1563498414', '0');
INSERT INTO `zan_users_menu` VALUES ('3', '商城中心', 'v1', 'user/Shop/shop_centre', '', '0', '100', '1', 'cn', '1555904190', '1725071357', '0');
INSERT INTO `zan_users_menu` VALUES ('4', '会员升级', 'v1', 'user/Level/level_centre', '', '0', '100', '0', 'cn', '1555904190', '1725071347', '0');
INSERT INTO `zan_users_menu` VALUES ('5', '会员投稿', 'v1', 'user/UsersRelease/release_centre', '', '0', '100', '0', 'cn', '1555904190', '1725071336', '0');
INSERT INTO `zan_users_menu` VALUES ('6', '我的下载', 'v1', 'user/Download/index', '', '0', '100', '1', 'cn', '1590484667', '1602320126', '0');
INSERT INTO `zan_users_menu` VALUES ('7', '个人中心', 'v1', 'user/Users/index', '', '1', '100', '1', 'cn', '1608708057', '1609385363', '0');
INSERT INTO `zan_users_menu` VALUES ('11', '个人中心', 'v2', 'user/Users/index', 'user/Users/index', '1', '100', '1', 'cn', '1608708057', '1609385363', '0');
INSERT INTO `zan_users_menu` VALUES ('10', '财务明细', 'v1', 'user/Pay/pay_consumer_details', '', '0', '100', '1', 'cn', '1608709000', '1609387813', '0');
INSERT INTO `zan_users_menu` VALUES ('12', '我的信息', 'v2', 'user/Users/info', 'user/Users/info', '0', '100', '1', 'cn', '1608709100', '1609385363', '0');
INSERT INTO `zan_users_menu` VALUES ('13', '我的收藏', 'v2', 'user/Users/collection_index', 'user/Users/collection_index', '0', '100', '1', 'cn', '1608708100', '1609385363', '0');
INSERT INTO `zan_users_menu` VALUES ('14', '财务明细', 'v2', 'user/Pay/pay_consumer_details', 'user/Pay/pay_consumer_details|user/Users/score_index', '0', '100', '0', 'cn', '1608709000', '1609387813', '0');
INSERT INTO `zan_users_menu` VALUES ('15', '我的收藏', 'v1', 'user/Users/collection_index', '', '0', '100', '1', 'cn', '1590484667', '1614651537', '0');
INSERT INTO `zan_users_menu` VALUES ('16', '积分商城', 'weapp', 'plugins/PointsShop/index', '', '0', '100', '1', 'cn', '1727424455', '1727424455', '0');

-- -----------------------------
-- Table structure for `zan_users_money`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_money`;
CREATE TABLE `zan_users_money` (
  `moneyid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '金额明细表ID',
  `users_id` int(10) DEFAULT '0' COMMENT '会员表ID',
  `money` decimal(10,2) DEFAULT '0.00' COMMENT '金额',
  `users_money` decimal(10,2) DEFAULT '0.00' COMMENT '此条记录的账户金额',
  `cause` text COMMENT '事由，暂时在升级消费中使用到，以serialize序列化后存入，用于后续查询。',
  `cause_type` tinyint(1) DEFAULT '0' COMMENT '数据类型,0-消费,1-充值,2-退款,3-订单支付,4-管理员添加,5-管理员减少',
  `status` tinyint(1) DEFAULT '1' COMMENT '是否成功，默认1，0失败，1未付款，2已付款，3已完成，4订单取消。',
  `pay_method` varchar(50) DEFAULT '' COMMENT '支付方式，wechat为微信支付，alipay为支付宝支付，balance为余额支付',
  `wechat_pay_type` varchar(20) NOT NULL DEFAULT '' COMMENT '微信支付时，标记使用的支付类型（扫码支付，微信内部，微信H5页面）',
  `pay_details` text COMMENT '支付时返回的数据，以serialize序列化后存入，用于后续查询。',
  `order_number` varchar(30) DEFAULT '' COMMENT '订单号',
  `level_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员升级时所升级的会员级别ID，默认0',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  `admin_id` int(10) DEFAULT '0' COMMENT '管理员表ID',
  PRIMARY KEY (`moneyid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='金额明细表';


-- -----------------------------
-- Table structure for `zan_users_notice`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_notice`;
CREATE TABLE `zan_users_notice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT '' COMMENT '通知标题',
  `users_id` text NOT NULL COMMENT '用户id',
  `usernames` text NOT NULL COMMENT '用户名字符串',
  `remark` text COMMENT '通知信息',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='站内通知';


-- -----------------------------
-- Table structure for `zan_users_notice_read`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_notice_read`;
CREATE TABLE `zan_users_notice_read` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `notice_id` int(10) DEFAULT NULL COMMENT '站内信id',
  `is_read` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否已读, 1---是, 0---否',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除, 1---是, 0---否',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户已读站内通知';


-- -----------------------------
-- Table structure for `zan_users_notice_tpl`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_notice_tpl`;
CREATE TABLE `zan_users_notice_tpl` (
  `tpl_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `tpl_name` varchar(200) DEFAULT '' COMMENT '模板名称',
  `tpl_title` varchar(200) DEFAULT '' COMMENT '站内信标题',
  `tpl_content` text COMMENT '发送内容',
  `send_scene` tinyint(1) DEFAULT '0' COMMENT '站内信发送场景(1=留言表单）',
  `is_open` tinyint(1) DEFAULT '0' COMMENT '是否开启使用这个模板，1为是，0为否。',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`tpl_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='站内信模板表';


-- -----------------------------
-- Table structure for `zan_users_notice_tpl_content`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_notice_tpl_content`;
CREATE TABLE `zan_users_notice_tpl_content` (
  `content_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `source` tinyint(1) DEFAULT '0' COMMENT '来源，对应 users_notice_tpl 表 send_scene 字段',
  `admin_id` int(10) DEFAULT '0' COMMENT '管理员ID，不为空则表示管理员接收信息',
  `users_id` int(10) DEFAULT '0' COMMENT '用户ID，不为空则表示会员接收信息，暂未使用',
  `content_title` varchar(200) DEFAULT '' COMMENT '通知标题',
  `content` text COMMENT '接收的通知内容',
  `is_read` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否已读，默认0，1是，0否',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  `aid` int(11) DEFAULT '0' COMMENT '留言id',
  PRIMARY KEY (`content_id`),
  KEY `admin_id` (`admin_id`) USING BTREE,
  KEY `users_id` (`users_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='站内信发送接收记录表';


-- -----------------------------
-- Table structure for `zan_users_parameter`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_parameter`;
CREATE TABLE `zan_users_parameter` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `para_id` int(10) NOT NULL DEFAULT '0' COMMENT 'id',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '标题',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '名称',
  `dtype` varchar(32) NOT NULL DEFAULT '' COMMENT '字段类型',
  `dfvalue` varchar(1000) NOT NULL DEFAULT '' COMMENT '默认值',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '是否为系统属性，系统属性不可删除，1为是，0为否，默认0。',
  `is_hidden` tinyint(1) DEFAULT '0' COMMENT '是否禁用属性，1为是，0为否',
  `is_required` tinyint(1) DEFAULT '0' COMMENT '是否为必填属性，1为是，0为否，默认0。',
  `is_reg` tinyint(1) DEFAULT '1' COMMENT '是否为注册表单，1为是，0为否',
  `placeholder` varchar(255) DEFAULT '' COMMENT '提示文字',
  `sort_order` smallint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  KEY `para_id` (`para_id`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='会员属性表(字段)';

-- -----------------------------
-- Records of `zan_users_parameter`
-- -----------------------------
INSERT INTO `zan_users_parameter` VALUES ('5', '1', 'Mobile', 'mobile_1', 'mobile', '', '1', '1', '0', '0', '', '1', 'en', '1733388333', '1733388333');
INSERT INTO `zan_users_parameter` VALUES ('6', '2', 'Email', 'email_2', 'email', '', '1', '0', '1', '1', '', '2', 'en', '1733388333', '1733388333');

-- -----------------------------
-- Table structure for `zan_users_recharge_pack`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_recharge_pack`;
CREATE TABLE `zan_users_recharge_pack` (
  `pack_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '会员充值套餐ID',
  `pack_names` varchar(100) NOT NULL DEFAULT '' COMMENT '会员充值套餐名称',
  `pack_face_value` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '会员充值套餐充值面值',
  `pack_pay_prices` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '会员充值套餐购买价格',
  `pack_sales_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员充值套餐销售数量',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '会员充值套餐状态(1:开启; 2:关闭;)',
  `sort_order` int(11) unsigned NOT NULL DEFAULT '100' COMMENT '排序号',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`pack_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='会员充值套餐列表';


-- -----------------------------
-- Table structure for `zan_users_recharge_pack_order`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_recharge_pack_order`;
CREATE TABLE `zan_users_recharge_pack_order` (
  `order_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '会员充值套餐订单ID',
  `pack_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员充值套餐ID',
  `users_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `order_code` varchar(50) NOT NULL DEFAULT '' COMMENT '订单编号',
  `order_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '订单状态(1:未支付; 2:已支付(未执行充值); 3:已充值(已执行充值); 4:已过期;)',
  `order_pack_names` varchar(100) NOT NULL DEFAULT '' COMMENT '会员充值套餐名称',
  `order_face_value` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单充值面值',
  `order_pay_prices` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单支付价格',
  `order_pay_code` varchar(50) NOT NULL DEFAULT '' COMMENT '订单支付编号(待用)',
  `order_pay_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `order_pay_name` varchar(20) NOT NULL DEFAULT '' COMMENT '支付方式名称',
  `order_pay_terminal` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '订单终端(1:电脑端; 2:手机端; 3:微信小程序; 4:抖音小程序)',
  `order_pay_details` text COMMENT '支付成功返回的数据，serialize序列化存入',
  `lang` varchar(30) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`order_id`),
  KEY `pack_id` (`pack_id`),
  KEY `users_id` (`users_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='会员充值套餐订单';


-- -----------------------------
-- Table structure for `zan_users_score`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_score`;
CREATE TABLE `zan_users_score` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '积分明细表',
  `type` tinyint(2) DEFAULT '1' COMMENT '类型:1-提问,2-回答,3-最佳答案4-悬赏退回,5-每日签到,6-管理员编辑,7-问题悬赏/获得悬赏,8-消费赠送积分,9-积分兑换/退回,10-登录赠送积分',
  `users_id` int(10) DEFAULT '0' COMMENT '用户id',
  `ask_id` int(10) DEFAULT '0' COMMENT '问题id',
  `reply_id` int(10) DEFAULT '0' COMMENT '回答id',
  `score` varchar(20) NOT NULL DEFAULT '' COMMENT '积分',
  `devote` int(10) DEFAULT '0' COMMENT '贡献值,同score',
  `money` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '余额',
  `info` varchar(255) DEFAULT '' COMMENT '说明',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(10) DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) DEFAULT '0' COMMENT '更新时间',
  `current_score` int(10) DEFAULT '0' COMMENT '当前积分',
  `current_devote` int(10) DEFAULT '0' COMMENT '当前贡献值',
  `admin_id` int(10) DEFAULT '0' COMMENT '管理员表ID',
  `remark` varchar(255) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='积分详情表';


-- -----------------------------
-- Table structure for `zan_users_signin`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_signin`;
CREATE TABLE `zan_users_signin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `users_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `lang` varchar(50) NOT NULL DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '签到时间',
  PRIMARY KEY (`id`),
  KEY `users_id` (`users_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户签到表';


-- -----------------------------
-- Table structure for `zan_users_type_manage`
-- -----------------------------
DROP TABLE IF EXISTS `zan_users_type_manage`;
CREATE TABLE `zan_users_type_manage` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '自增ID',
  `type_name` varchar(30) DEFAULT '' COMMENT '类型名称',
  `level_id` int(10) DEFAULT '0' COMMENT '会员等级ID',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '价格',
  `limit_id` int(10) DEFAULT '0' COMMENT '会员期限限制，存储ID，值对应常量表的admin_member_limit_arr数组',
  `activity` varchar(30) DEFAULT '' COMMENT '活动文案',
  `sort_order` smallint(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `lang` varchar(20) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`),
  UNIQUE KEY `type_id` (`type_id`,`lang`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='会员产品类型表';

-- -----------------------------
-- Records of `zan_users_type_manage`
-- -----------------------------
INSERT INTO `zan_users_type_manage` VALUES ('5', '1', '升级为中级会员', '2', '100.00', '2', '', '100', 'en', '1564532901', '1610620458');
INSERT INTO `zan_users_type_manage` VALUES ('6', '2', '升级为高级会员', '3', '200.00', '3', '', '100', 'en', '1564532901', '1610620458');

-- -----------------------------
-- Table structure for `zan_visit_log`
-- -----------------------------
DROP TABLE IF EXISTS `zan_visit_log`;
CREATE TABLE `zan_visit_log` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `dates` varchar(50) NOT NULL DEFAULT '' COMMENT '日期',
  `count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '累计访问IP数(一个IP一天内只累计+1)',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='前台页面访问日志';

-- -----------------------------
-- Records of `zan_visit_log`
-- -----------------------------
INSERT INTO `zan_visit_log` VALUES ('1', '2024-12-05', '1', '1733328000', '1733388581');
INSERT INTO `zan_visit_log` VALUES ('2', '2025-02-21', '1', '1740067200', '1740102344');

-- -----------------------------
-- Table structure for `zan_visit_log_ip`
-- -----------------------------
DROP TABLE IF EXISTS `zan_visit_log_ip`;
CREATE TABLE `zan_visit_log_ip` (
  `auto_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `ip` varchar(50) NOT NULL DEFAULT '' COMMENT '用户IP地址',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`auto_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='前台页面访问日志ip列表';

-- -----------------------------
-- Records of `zan_visit_log_ip`
-- -----------------------------
INSERT INTO `zan_visit_log_ip` VALUES ('1', '127.0.0.1', '1733328000', '1733388581');
INSERT INTO `zan_visit_log_ip` VALUES ('2', '127.0.0.1', '1740067200', '1740102344');

-- -----------------------------
-- Table structure for `zan_weapp`
-- -----------------------------
DROP TABLE IF EXISTS `zan_weapp`;
CREATE TABLE `zan_weapp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) DEFAULT '' COMMENT '插件标识',
  `name` varchar(55) DEFAULT '' COMMENT '中文名字',
  `config` text COMMENT '配置信息',
  `data` longtext COMMENT '额外序列化存储数据，简单插件可以不创建表，存储这里即可',
  `status` tinyint(1) DEFAULT '0' COMMENT '状态：0=未安装，1=启用，-1=禁用',
  `tag_weapp` tinyint(1) DEFAULT '1' COMMENT '1=自动绑定，2=手工调用。关联模板标签weapp，自动调用内置的show钩子方法',
  `thorough` tinyint(1) DEFAULT '0' COMMENT '彻底卸载：0=是，1=否',
  `position` varchar(30) DEFAULT 'default' COMMENT '插件位置',
  `is_buy` tinyint(1) DEFAULT '0' COMMENT '0-本地,1-线上购买 2-线上购买,但已删除,不显示在我的插件列表',
  `is_upgrade` tinyint(1) DEFAULT '1' COMMENT '是否提示升级',
  `sort_order` int(10) DEFAULT '100' COMMENT '排序号',
  `add_time` int(11) DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  `quick_sort` int(10) DEFAULT '100' COMMENT '首页快捷菜单专用排序号',
  `checked` tinyint(4) DEFAULT '0' COMMENT '选中，0=否，1=是(首页快捷菜单用)',
  PRIMARY KEY (`id`),
  KEY `code` (`code`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='插件应用表';

-- -----------------------------
-- Records of `zan_weapp`
-- -----------------------------
INSERT INTO `zan_weapp` VALUES ('1', 'Chattool', '外贸在线客服', '{\"code\":\"Chattool\",\"name\":\"\\u5916\\u8d38\\u5728\\u7ebf\\u5ba2\\u670d\",\"version\":\"v1.0.1\",\"min_version\":\"v2.0.0\",\"author\":\"\\u5c0f\\u8ff7\\u7ae5\",\"description\":\"\\u4e13\\u95e8\\u9488\\u5bf9\\u5916\\u8d38\\u4f01\\u4e1a\\u7684\\u7f51\\u7ad9\\u5ba2\\u670d\\uff0c\\u9002\\u7528\\u4e8e\\u56fd\\u9645\\u4e1a\\u52a1\\u7684\\u5728\\u7ebf\\u5ba2\\u670d\\u63d2\\u4ef6\\uff0c\\u5916\\u8d38\\u884c\\u4e1a\\u5fc5\\u5907\\uff0c\\u53ea\\u9002\\u7528\\u4e8ePC\\u7aef\\u6a21\\u677f\\u663e\\u793a\",\"litpic\":\"\\/weapp\\/Chattool\\/logo.png\",\"scene\":\"2\",\"subroot\":\"on\",\"permission\":[],\"management\":[]}', 'a:13:{s:9:\"tag_weapp\";s:1:\"1\";s:14:\"service_height\";s:3:\"400\";s:11:\"service_tit\";s:8:\"WhatsApp\";s:11:\"service_one\";s:11:\"13988889999\";s:14:\"service_online\";s:6:\"E-Mail\";s:13:\"service_email\";s:13:\"youweb@qq.com\";s:10:\"name_Skype\";s:5:\"Skype\";s:13:\"service_skype\";s:13:\"skype:cmhello\";s:17:\"wechat_logo_local\";s:47:\"/weapp/Chattool/template/skin/images/weixin.jpg\";s:18:\"wechat_logo_remote\";s:0:\"\";s:14:\"service_wechat\";s:6:\"WeChat\";s:4:\"code\";s:8:\"Chattool\";s:11:\"wechat_logo\";s:47:\"/weapp/Chattool/template/skin/images/weixin.jpg\";}', '1', '1', '1', 'default', '0', '1', '100', '1730686366', '1734916003', '100', '0');
INSERT INTO `zan_weapp` VALUES ('2', 'Paypal', 'Paypal支付', '{\"code\":\"Paypal\",\"name\":\"Paypal\\u652f\\u4ed8\",\"version\":\"v1.0.4\",\"min_version\":\"v1.6.1\",\"author\":\"\\u5c0f\\u864e\\u54e5\",\"description\":\"Paypal\\u652f\\u4ed8\",\"litpic\":\"\\/weapp\\/Paypal\\/logo.png\",\"scene\":\"0\",\"permission\":[],\"management\":[]}', '', '0', '1', '0', 'default', '0', '1', '100', '1733388567', '0', '100', '0');
INSERT INTO `zan_weapp` VALUES ('3', 'Sitecollect', '文章采集（定时发布）', '{\"code\":\"Sitecollect\",\"name\":\"\\u6587\\u7ae0\\u91c7\\u96c6\\uff08\\u5b9a\\u65f6\\u53d1\\u5e03\\uff09\",\"version\":\"v2.2.6\",\"min_version\":\"1.4.0\",\"author\":\"\\u533f\\u540d\",\"litpic\":\"https:\\/\\/www.eyoucms.com\\/uploads\\/allimg\\/191216\\/1-1912161H6150-L.jpg\",\"description\":\"\\u63d2\\u4ef6\\u63cf\\u8ff0\\u6700\\u65b0\\u66f4\\u65b0\\uff1a\\u652f\\u6301\\u5b9a\\u65f6\\u53d1\\u5e03\\u529f\\u80fd\\uff08\\u9700\\u8981\\u5728\\u5b9d\\u5854\\u63a7\\u5236\\u9762\\u677f\\u6dfb\\u52a0\\u8ba1\\u5212\\u4efb\\u52a1\\uff09\\u6613\\u4f18\\u6587\\u7ae0\\u91c7\\u96c6\\u63d2\\u4ef6\\uff0c\\u6279\\u91cf\\u91c7\\u96c6\\u76ee\\u6807\\u7f51\\u7ad9\\u6570\\u636e\\u4fe1\\u606f\\u5230\\u672c\\u7f51\\u7ad9\\u5b58\\u50a8\\uff0c\\u8282\\u7701\\u7f16\\u8f91\\u4eba\\u5de5\\u91c7\\u96c6\\u65f6\\u95f4\\u3002\\uff08\\u6682\\u65f6\\u4e0d\\u652f\\u6301\\u591a\\u8bed\\u8a00\\uff09\\u5e94\\u7528\\u573a\\u666f\\u7ad9\\u957f\\u4ec5\\u9700\\u8981\\u8bbe\\u7f6e\\u597d\\u7b80\\u5355\\u7684\\u6b63\\u5219\\u4efb\\u52a1\\u5373\\u53ef\\u5b8c\\u6210\\u6d4b\\u8bd5\\u81f3\\u91c7\\u96c6\\u7684\\u8fc7\\u7a0b\\u3002\\u4f7f\\u7528\\u6559\\u7a0b\\u70b9\\u51fb\\u67e5\\u770b\\u89c6\\u9891\\u6559\\u7a0b \\u63d2\\u4ef6\\u529f\\u80fd\\u5012\\u5e8f\\u91c7\\u96c6 \\u8fc7\\u6ee4\\u91cd\\u590d\\u6807\\u9898 \\u56fe\\u7247\\u672c\\u5730\\u4fdd\\u5b58 \\u5185\\u5bb9\\u5b58\\u4e3a\\u8349\\u7a3f \\u63d0\\u53d6\\u7b2c\\u4e00\\u5f20\\u56fe\\u4e3a\\u7f29\\u7565\\u56fe\\u5185\\u5bb9\\u8fc7\\u6ee4     Iframe javascript\\u811a\\u672c \\u8d85\\u94fe\\u63a5\",\"scene\":\"0\",\"permission\":[]}', '', '0', '1', '0', 'default', '1', '1', '100', '1734916007', '1734916007', '100', '0');

-- -----------------------------
-- Table structure for `zan_wechat_template`
-- -----------------------------
DROP TABLE IF EXISTS `zan_wechat_template`;
CREATE TABLE `zan_wechat_template` (
  `tpl_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `tpl_title` varchar(128) NOT NULL DEFAULT '' COMMENT '模板标题',
  `template_title` varchar(100) DEFAULT '' COMMENT '官方模板标题',
  `template_code` varchar(30) DEFAULT '' COMMENT '模板编号',
  `template_id` varchar(100) NOT NULL DEFAULT '' COMMENT '模板ID',
  `tpl_data` text NOT NULL COMMENT '模板内容序列化',
  `send_scene` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '发送场景',
  `is_open` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否开启使用这个模板，1为是，0为否。',
  `info` varchar(200) DEFAULT '' COMMENT '发送说明',
  `lang` varchar(50) DEFAULT 'cn' COMMENT '语言标识',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`tpl_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='微信公众号消息发送模板';

-- -----------------------------
-- Records of `zan_wechat_template`
-- -----------------------------
INSERT INTO `zan_wechat_template` VALUES ('1', '新表单', '客户需求提交成功通知', '0', '', '{\"keywordsList\":[{\"name\":\"\\u9700\\u6c42\\u9879\\u76ee\",\"example\":\"\\u57ce\\u4e61\\u73af\\u536b\\u4e00\\u4f53\\u5316\\u62db\\u6807\\u65b9\\u6848\\u5b9a\\u5236\",\"rule\":\"thing7\"},{\"name\":\"\\u9700\\u6c42\\u65f6\\u95f4\",\"example\":\"2023\\u5e7410\\u670831\\u65e5 12:23:34\",\"rule\":\"time6\"}]}', '1', '0', '客户提交留言后立即发送', 'cn', '1713251003', '1713251003');
INSERT INTO `zan_wechat_template` VALUES ('2', '新订单', '订单支付成功提醒', '0', '', '{\"keywordsList\":[{\"name\":\"\\u8ba2\\u5355\\u7f16\\u53f7\",\"example\":\"202304301347362851008422\",\"rule\":\"character_string3\"},{\"name\":\"\\u4ea7\\u54c1\\u540d\\u79f0\",\"example\":\"RS\\u8d27\\u6b3e\",\"rule\":\"thing11\"},{\"name\":\"\\u8ba2\\u5355\\u91d1\\u989d\",\"example\":\"\\uffe599.99\",\"rule\":\"amount4\"},{\"name\":\"\\u652f\\u4ed8\\u65f6\\u95f4\",\"example\":\"2022-10-23 14:23:26\",\"rule\":\"time7\"}]}', '9', '0', '买家付款成功后立即发送', 'cn', '1713251003', '1713251003');

-- -----------------------------
-- Table structure for `zan_wx_shipping_info`
-- -----------------------------
DROP TABLE IF EXISTS `zan_wx_shipping_info`;
CREATE TABLE `zan_wx_shipping_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `users_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `order_code` varchar(255) NOT NULL DEFAULT '' COMMENT '订单编号',
  `order_source` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '订单来源(1:会员普通充值订单; 2:会员商城商品订单; 3:会员升级订单; 8:会员视频订单; 20:会员套餐充值订单;)',
  `pay_success` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否支付成功(1:是; 0:否)',
  `pay_config` varchar(500) NOT NULL DEFAULT '' COMMENT '订单支付时所使用的支付配置信息(serialize存入，需unserialize解析)',
  `errcode` varchar(255) NOT NULL DEFAULT '' COMMENT '错误代码',
  `errmsg` varchar(255) NOT NULL DEFAULT '' COMMENT '错误提示',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='微信发货推送表';


-- -----------------------------
-- Table structure for `zan_wx_users`
-- -----------------------------
DROP TABLE IF EXISTS `zan_wx_users`;
CREATE TABLE `zan_wx_users` (
  `wxuser_id` int(11) NOT NULL AUTO_INCREMENT,
  `users_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `openid` varchar(100) NOT NULL DEFAULT '' COMMENT 'openid',
  `unionid` varchar(100) DEFAULT '' COMMENT 'unionid',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '微信昵称',
  `headimgurl` varchar(200) NOT NULL DEFAULT '' COMMENT '头像',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '新增时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `provider` varchar(25) DEFAULT '' COMMENT '来源',
  PRIMARY KEY (`wxuser_id`),
  KEY `openid` (`openid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='微信小程序用户表';

