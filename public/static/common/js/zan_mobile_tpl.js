
var oldhtml = '';
var odlimgstr = '';

// 纯文本编辑
function zan_text(that, e_id, e_page, html)
{
    var textval = $(that).html();
    //textval = textval.replace(/[\r\n]/g, "");//去掉回车换行)
    textval = textval.replace(/<b class="ui_icon"><\/b>/g, "");//去掉回车换行)
    oldhtml = $.trim(textval);
    var url = __root_dir__+'/index.php?m=api&c=Uiset&a=text&id='+e_id+'&page='+e_page+'&iframe='+__iframe__+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__;
    $('#workspace_right').attr('src', url);
    $('.admincp-container-right').addClass('right-show');
    return false;
}

// 带html的富文本编辑器
function zan_html(that, e_id, e_page, html)
{
    oldhtml = html;
    var url = __root_dir__+'/index.php?m=api&c=Uiset&a=html&id='+e_id+'&page='+e_page+'&iframe='+__iframe__+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__;
    $('#workspace_right').attr('src', url);
    $('.admincp-container-right').addClass('right-show');
}

// 分类编辑
function zan_type(that, e_id, e_page)
{
    var url = __root_dir__+'/index.php?m=api&c=Uiset&a=type&id='+e_id+'&page='+e_page+'&iframe='+__iframe__+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__;
    $('#workspace_right').attr('src', url);
    $('.admincp-container-right').addClass('right-show');
}

// 单页编辑
function zan_single(that, e_id, e_page)
{
    var url = __root_dir__+'/index.php?m=api&c=Uiset&a=single&id='+e_id+'&page='+e_page+'&iframe='+__iframe__+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__;
    $('#workspace_right').attr('src', url);
    $('.admincp-container-right').addClass('right-show');
}

// 文章分类编辑
function zan_arclist(that, e_id, e_page)
{
    var url = __root_dir__+'/index.php?m=api&c=Uiset&a=arclist&id='+e_id+'&page='+e_page+'&iframe='+__iframe__+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__;
    $('#workspace_right').attr('src', url);
    $('.admincp-container-right').addClass('right-show');
}

// 分类列表编辑
function zan_channel(that, e_id, e_page)
{
    var url = __root_dir__+'/index.php?m=api&c=Uiset&a=channel&id='+e_id+'&page='+e_page+'&iframe='+__iframe__+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__;
    $('#workspace_right').attr('src', url);
    $('.admincp-container-right').addClass('right-show');
}

// 图片编辑
function zan_upload(that, e_id, e_page, html, imgsrc)
{
    oldhtml = html;
    oldimgsrc = imgsrc;
    var url = __root_dir__+'/index.php?m=api&c=Uiset&a=upload&id='+e_id+'&page='+e_page+'&iframe='+__iframe__+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__;
    $('#workspace_right').attr('src', url);
    $('.admincp-container-right').addClass('right-show');
}

// 背景图片编辑
function zan_background(that, e_id, e_page, imgsrc)
{
    oldimgsrc = imgsrc;
    var url = __root_dir__+'/index.php?m=api&c=Uiset&a=background&id='+e_id+'&page='+e_page+'&iframe='+__iframe__+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__;
    $('#workspace_right').attr('src', url);
    $('.admincp-container-right').addClass('right-show');
}

// 广告设置
function zan_adv(that, e_id)
{
    var url = admin_basefile+'?m=admin&c=Other&a=ui_edit&id='+e_id+'&iframe='+__iframe__+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__;
    $('#workspace_right').attr('src', url);
    $('.admincp-container-right').addClass('right-show');
}

// 百度地图
function zan_map(that, e_id, e_page)
{
    var url = __root_dir__+'/index.php?m=api&c=Uiset&a=map&id='+e_id+'&page='+e_page+'&iframe='+__iframe__+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__;
    $('#workspace_right').attr('src', url);
    $('.admincp-container-right').addClass('right-show');
/*
    layer.open({
        type: 2,
        title: '百度地图定位',
        fixed: true,
        shadeClose: false,
        shade: 0.3,
        maxmin: false,
        area: ['80%', '80%'],
        content: __root_dir__+'/index.php?m=api&c=Uiset&a=map&id='+e_id+'&page='+e_page+'&iframe='+__iframe__+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__
    });
    */
}

// 源代码编辑
function zan_code(that, e_id, e_page, html)
{
    oldhtml = html;
    var url = __root_dir__+'/index.php?m=api&c=Uiset&a=code&id='+e_id+'&page='+e_page+'&iframe='+__iframe__+'&urltypeid='+__urltypeid__+'&urlaid='+__urlaid__+'&v='+v+'&lang='+__lang__;
    $('#workspace_right').attr('src', url);
    $('.admincp-container-right').addClass('right-show');
}

// 清除全部数据
function zan_clear()
{
    layer.confirm('确定要初始化数据？', {
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
                            $('.admincp-container-right').removeClass('right-show');
                            $('#workspace').attr('src', $('#workspace').attr('src'));
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

/**
 * 获取修改之前的内容
 */
function zan_getOldHtml()
{
    return oldhtml;
}

/**
 * 获取修改之前的图片路径
 */
function zan_getOldImgsrc()
{
    return oldimgsrc;
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