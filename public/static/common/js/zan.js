
var oldhtml = ''; // 原始内容
var epageJson = {}; // 页面标识，建议是文件名

jQuery(function($){

    // 去除所有A标签链接
    // function remove_a_href()
    // {
    //     $('a').each(function(index, item){
    //         $(item).attr('href', 'javascript:void(0);');
    //     });    
    // }

    /**
     * 页面右上角显示还原数据的操作
     */
    // $('body').prepend('<div e-id="clearall" class="uiset_back-btn" title="还原设置" onclick="zan_clear();"></div>');

    /**
     * Make the elements editable
     */
    $('.zan-edit').mouseenter(function(e){ // 鼠标移入选中状态，只针对该绑定元素
        e.stopPropagation();
        var that = this;
        zan_mouseenter(that);
    })
    .mouseleave(function(e){ // 鼠标移出消除选中状态，只针对该绑定元素
        e.stopPropagation();
        var that = this;
        zan_mouseleave(that);
    });

    // 鼠标移入选中状态，只针对该绑定元素
    function zan_mouseenter(that)
    {
        $(that).addClass('uiset');
        $('body').find('b.ui_icon').remove();
        $(that).prepend('<b class="ui_icon"></b>');
        $(that).find('b.ui_icon').on("click", function(e){
            e.stopPropagation();
            var that = $(this).parent();
            var e_type = $(that).attr('e-type');
            if (e_type == 'text') {
                oldhtml = $(that).html();
                //oldhtml = oldhtml.replace(/[\r\n]/g, "");//去掉回车换行)
                oldhtml = oldhtml.replace(/<b class="ui_icon"><\/b>/g, "");//去掉回车换行)
                oldhtml = $.trim(oldhtml);
                zan_text(that);
            } else if (e_type == 'html') {
                oldhtml = $(that).html();
                oldhtml = oldhtml.replace('<b class="ui_icon"></b>', '');
                zan_html(that);
            } else if (e_type == 'type') {
                zan_type(that);
            } else if (e_type == 'single') {
                zan_single(that);
            } else if (e_type == 'arclist' || e_type == 'artlist') {
                zan_arclist(that);
            } else if (e_type == 'channel' || e_type == 'models') {
                zan_channel(that);
            } else if (e_type == 'upload') {
                zan_upload(that);
            } else if (e_type == 'adv') {
                zan_adv(that);
            } else if (e_type == 'map') {
                zan_map(that);
            } else if (e_type == 'code') {
                oldhtml = $(that).html();
                oldhtml = oldhtml.replace('<b class="ui_icon"></b>', '');
                oldhtml = $.trim(oldhtml);
                zan_code(that);
            } else if (e_type == 'background') {
                zan_background(that);
            }
            // zan_mouseleave(that);
        });
        if (that.nodeName == 'A') {
            $(that).attr('href', 'javascript:void(0);');
        }
    }

    // 鼠标移出消除选中状态，只针对该绑定元素
    function zan_mouseleave(that)
    {
        $(that).removeClass('uiset');
        $(that).find('b.ui_icon').remove();
        $(that).bind('mouseenter');
    }

    // 递归获取最近含有e-page的元素对象
    function get_epage(obj)
    {
        if ($(obj).attr('e-page') == undefined) {
            var parentObj = $(obj).parent();
            if (parentObj.find('body').length > 0) {
                epageJson = {
                    e_page: ''
                };
                return false;
            } else {
                get_epage(parentObj);
            }
        } else {
            epageJson = {
                e_page: $(obj).attr('e-page')
            };
            return false;
        }
    }

    // 纯文本编辑
    function zan_text(that)
    {
        get_epage(that);
        var e_page = epageJson.e_page;
        var e_id = $(that).attr('e-id');
        if (e_page == '' || e_id == undefined) {
            zan_showErrorAlert('html报错：uitext标签的外层html元素缺少属性 e-page | e-id');
            return false;
        }
        layer.open({
            type: 2,
            title: '纯文本编辑',
            fixed: true,
            shadeClose: false,
            shade: 0.3,
            maxmin: false,
            area: ['700px', '580px'],
            content: __root_dir__+'/index.php?m=api&c=Uiset&a=text&id='+e_id+'&page='+e_page+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__
        });

        /*
        var textval = $(that).html();
        //textval = textval.replace(/[\r\n]/g, "");//去掉回车换行)
        textval = textval.replace(/<b class="ui_icon"><\/b>/g, "");//去掉回车换行)
        textval = $.trim(textval);
        layer.prompt({
            title: '纯文本编辑',
            value: textval,
            formType: 2,
            area: ['500px', '300px']
        }, function(text, index){
            layer.close(index);
            text = text.replace(/[\r\n]/g, "");//去掉回车换行)
            text = text.replace(/<b class="ui_icon"><\/b>/g, "");//去掉回车换行)
            text = $.trim(text);
            if( $.trim(text) != '' ) {
                zan_layer_loading('正在处理');
                $.ajax({
                    url: __root_dir__+'/index.php?m=api&c=Uiset&a=submit&v='+v+'&_ajax=1&lang='+__lang__,
                    type: 'POST',
                    dataType: 'JSON',
                    data: {
                        content: text
                        ,id: e_id
                        ,page: e_page
                        ,type: 'text'
                        ,oldhtml: oldhtml
                        ,lang: __lang__
                        ,urltypeid: __urltypeid__
                        ,urlaid: __urlaid__
                    },
                    success: function(res) {
                        layer.closeAll();
                        if (res.code == 1) {
                            layer.msg(res.msg, {icon: 1, shade: 0.3, time: 1000}, function(){
                                window.location.reload();
                            });
                        } else {
                            zan_showErrorAlert(res.msg);
                        }
                        return false;
                    },
                    error: function(e){
                        layer.closeAll();
                        zan_showErrorAlert(e.responseText);
                        return false;
                    }
                });
            }
        });
        */
    }

    // 带html的富文本编辑器
    function zan_html(that)
    {
        get_epage(that);
        var e_page = epageJson.e_page;
        var e_id = $(that).attr('e-id');
        if (e_page == '' || e_id == undefined) {
            zan_showErrorAlert('html报错：uihtml标签的外层html元素缺少属性 e-page | e-id');
            return false;
        }
        layer.open({
            type: 2,
            title: '富文本内容编辑',
            fixed: true,
            shadeClose: false,
            shade: 0.3,
            maxmin: false,
            area: ['700px', '600px'],
            content: __root_dir__+'/index.php?m=api&c=Uiset&a=html&id='+e_id+'&page='+e_page+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__
        });
    }

    // 分类编辑
    function zan_type(that)
    {
        get_epage(that);
        var e_page = epageJson.e_page;
        var e_id = $(that).attr('e-id');
        if (e_page == '' || e_id == undefined) {
            zan_showErrorAlert('html报错：uitype标签的外层html元素缺少属性 e-page | e-id');
            return false;
        }
        //iframe窗
        layer.open({
            type: 2,
            title: '分类编辑',
            fixed: true,
            shadeClose: false,
            shade: 0.3,
            maxmin: false,
            area: ['350px', '200px'],
            content: __root_dir__+'/index.php?m=api&c=Uiset&a=type&id='+e_id+'&page='+e_page+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__
        });
    }

    // 单页编辑
    function zan_single(that)
    {
        get_epage(that);
        var e_page = epageJson.e_page;
        var e_id = $(that).attr('e-id');
        if (e_page == '' || e_id == undefined) {
            zan_showErrorAlert('html报错：uisingle标签的外层html元素缺少属性 e-page | e-id');
            return false;
        }
        //iframe窗
        layer.open({
            type: 2,
            title: '单页编辑',
            fixed: true,
            shadeClose: false,
            shade: 0.3,
            maxmin: false,
            area: ['350px', '200px'],
            content: __root_dir__+'/index.php?m=api&c=Uiset&a=single&id='+e_id+'&page='+e_page+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__
        });
    }

    // 文章分类编辑
    function zan_arclist(that)
    {
        get_epage(that);
        var e_page = epageJson.e_page;
        var e_id = $(that).attr('e-id');
        if (e_page == '' || e_id == undefined) {
            zan_showErrorAlert('html报错：uiarclist标签的外层html元素缺少属性 e-page | e-id');
            return false;
        }
        layer.open({
            type: 2,
            title: '内容分类编辑',
            fixed: true,
            shadeClose: false,
            shade: 0.3,
            maxmin: false,
            area: ['350px', '200px'],
            content: __root_dir__+'/index.php?m=api&c=Uiset&a=arclist&id='+e_id+'&page='+e_page+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__
        });
    }

    // 分类列表编辑
    function zan_channel(that)
    {
        get_epage(that);
        var e_page = epageJson.e_page;
        var e_id = $(that).attr('e-id');
        if (e_page == '' || e_id == undefined) {
            zan_showErrorAlert('html报错：uichannel标签的外层html元素缺少属性 e-page | e-id');
            return false;
        }
        layer.open({
            type: 2,
            title: '分类列表编辑',
            fixed: true,
            shadeClose: false,
            shade: 0.3,
            maxmin: false,
            area: ['350px', '200px'],
            content: __root_dir__+'/index.php?m=api&c=Uiset&a=channel&id='+e_id+'&page='+e_page+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__
        });
    }

    // 图片编辑
    function zan_upload(that)
    {
        get_epage(that);
        var e_page = epageJson.e_page;
        var e_id = $(that).attr('e-id');
        if (e_page == '' || e_id == undefined) {
            zan_showErrorAlert('html报错：uiupload标签的外层html元素缺少属性 e-page | e-id');
            return false;
        }
        var imgsrc = $(that).find('img').attr('src');
        var oldhtml = $.trim($(that).html());
        oldhtml = encodeURI(oldhtml);
        //iframe窗
        layer.open({
            type: 2,
            title: '图片编辑',
            fixed: true,
            shadeClose: false,
            shade: 0.3,
            maxmin: false,
            area: ['400px', '360px'],
            content: __root_dir__+'/index.php?m=api&c=Uiset&a=upload&id='+e_id+'&page='+e_page+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__,
            success: function(layero, index){
                var body = layer.getChildFrame('body', index);
                body.find('input[name=oldhtml]').val(oldhtml);
                body.find('.imgsrc img').attr('src',imgsrc);
                body.find('input[name=litpic]').val(imgsrc);
            }
        });
    }

    // 背景图片编辑
    function zan_background(that)
    {
        get_epage(that);
        var e_page = epageJson.e_page;
        var e_id = $(that).attr('e-id');
        if (e_page == '' || e_id == undefined) {
            zan_showErrorAlert('html报错：uibackground标签的外层html元素缺少属性 e-page | e-id');
            return false;
        }
        var imgsrc = $(that).css("backgroundImage").replace('url(', '').replace(')', '');
        re = new RegExp("'","g");
        imgsrc = imgsrc.replace(re, "");
        re2 = new RegExp("\"","g");
        imgsrc = imgsrc.replace(re2, "");
        imgsrc = $.trim(imgsrc);
        
        //iframe窗
        layer.open({
            type: 2,
            title: '背景图片编辑',
            fixed: true,
            shadeClose: false,
            shade: 0.3,
            maxmin: false,
            area: ['400px', '360px'],
            content: __root_dir__+'/index.php?m=api&c=Uiset&a=background&id='+e_id+'&page='+e_page+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__,
            success: function(layero, index){
                var body = layer.getChildFrame('body', index);
                body.find('.imgsrc img').attr('src',imgsrc);
                body.find('input[name=litpic]').val(imgsrc);
            }
        });
    }
    
    // 广告设置
    function zan_adv(that)
    {
        var e_id = $(that).attr('e-id');
        var url = admin_basefile+'?m=admin&c=Other&a=ui_edit&id='+e_id+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__;
        layer.open({
            type: 2,
            title: '广告编辑',
            fixed: true,
            shadeClose: false,
            shade: 0.3,
            maxmin: true,
            area: ['800px', '500px'],
            content: url
        });
    }

    // 百度地图
    function zan_map(that)
    {
        get_epage(that);
        var e_page = epageJson.e_page;
        var e_id = $(that).attr('e-id');
        if (e_page == '' || e_id == undefined) {
            zan_showErrorAlert('html报错：uimap标签的外层html元素缺少属性 e-page | e-id');
            return false;
        }
        layer.open({
            type: 2,
            title: '百度地图定位',
            fixed: true,
            shadeClose: false,
            shade: 0.3,
            maxmin: false,
            area: ['80%', '80%'],
            content: __root_dir__+'/index.php?m=api&c=Uiset&a=map&id='+e_id+'&page='+e_page+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__
        });
    }

    // 源代码编辑
    function zan_code(that)
    {
        get_epage(that);
        var e_page = epageJson.e_page;
        var e_id = $(that).attr('e-id');
        if (e_page == '' || e_id == undefined) {
            zan_showErrorAlert('html报错：uicode标签的外层html元素缺少属性 e-page | e-id');
            return false;
        }
        layer.open({
            type: 2,
            title: '源代码编辑',
            fixed: true,
            shadeClose: false,
            shade: 0.3,
            maxmin: false,
            area: ['700px', '580px'],
            content: __root_dir__+'/index.php?m=api&c=Uiset&a=code&id='+e_id+'&page='+e_page+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__
        });
    }
});

/**
 * 获取修改之前的内容
 */
function zan_getOldHtml()
{
    return oldhtml;
}

// 清除全部数据
function zan_clear()
{
    layer.confirm('退出装修，并还原至上次装修数据，请确定？', {
            title: false,
            closeBtn: false,
            btn: ['确定', '取消'] //按钮
        }, function(){
            zan_layer_loading('正在处理');
            var e_type = 'all';
            $.ajax({
                url: __root_dir__+'/index.php?m=api&c=Uiset&a=clear_data&lang='+__lang__,
                type: 'POST',
                dataType: 'JSON',
                data: {
                    type: e_type
                    ,v: v
                    ,urltypeid: __urltypeid__
                    ,urlaid: __urlaid__
                    ,_ajax: 1
                },
                success: function(res) {
                    layer.closeAll();
                    if (res.code == 1) {
                        layer.msg(res.msg, {icon: 1, shade: 0.3, time: 1000}, function(){
                            window.location.reload();
                        });
                    } else {
                        zan_showErrorAlert(res.msg);
                    }
                    return false;
                },
                error: function(e){
                    layer.closeAll();
                    zan_showErrorAlert(e.responseText);
                    return false;
                }
            });
        }, function(index){
            layer.close(index);
            return false;// 取消
        }
    );
}

function zan_showErrorMsg(msg){
    layer.msg(msg, {icon: 5,time: 2000});
}

function zan_showSuccessMsg(msg){
    layer.msg(msg, {time: 1000});
}

function zan_showErrorAlert(msg, icon){
    if (!icon && icon != 0) {
        icon = 5;
    }
    layer.alert(msg, {icon: icon, title: false, closeBtn: false});
}

/**
 * 封装的加载层
 */
function zan_layer_loading(msg){
    var loading = layer.msg(
    msg+'...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;请勿刷新页面', 
    {
        icon: 1,
        time: 3600000,
        shade: [0.2]
    });
    var index = layer.load(3, {
        shade: [0.1,'#fff']
    });

    return loading;
}

/**
 * 封装的加载层，用于iframe
 */
function zan_iframe_layer_loading(msg){
    var loading = parent.layer.msg(
    msg+'...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;请勿刷新页面', 
    {
        icon: 1,
        time: 3600000,
        shade: [0.2]
    });
    var index = parent.layer.load(3, {
        shade: [0.1,'#fff']
    });

    return loading;
}
