
function layerLoading(msg) {
    // msg += '...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;请勿刷新页面';
    msg += '...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+ey_langpack_sys27;
    // msg += '<style>.layui-layer-msg{z-index: 19891016!important;border: 0px!important;}</style>';
    var loading = layer.msg(msg, {
        icon: 1,
        time: 3600000, //1小时后后自动关闭
        shade: [0.2] //0.1透明度的白色背景
    });
    //loading层
    var index = layer.load(3, {
        shade: [0.1,'#fff'] //0.1透明度的白色背景
    });
    return loading;
}

function addInquiryList(aid) {
    aid = aid ? aid : ey_aid;
    layerLoading(ey_langpack_sys26);
    $.ajax({
        url: inquiryJsonData.addInquiryListUrl,
        data: {goods_id: aid, goods_num: 1},
        type: 'post',
        dataType: 'json',
        success: function(res) {
            layer.closeAll();
            if (1 === parseInt(res.code)) {
                layer.confirm(res.msg, {
                    shade: [0.7, '#fafafa'],
                    area: ['480px', '190px'],
                    move: false,
                    title: ey_langpack_sys22,
                    btnAlign: 'r',
                    closeBtn: 3,
                    btn: [ey_langpack_sys382, ey_langpack_sys383],
                    success: function () {
                        $(".layui-layer-content").css('text-align', 'left');
                    },
                    cancel: function (index) {
                        layer.close(index);
                    },
                }, function () {
                    window.location.href = inquiryJsonData.inquiryListUrl;
                }, function (index) {
                    layer.close(index);
                });
            } else {
                layer.alert(res.msg, {icon:5, title: false, closeBtn: false});
            }
        },
        error: function(e){
            layer.closeAll();
            layer.alert(e.responseText, {icon:5, title: false, closeBtn: false});
        }
    });
}

var allow = true;
function editInquiryList(goods_id, action) {
    var goods_num = parseInt($('#goods_num_' + goods_id).val());
    if ('add' == action) {
        goods_num++;
    } else if ('cut' == action) {
        goods_num--;
    }
    // 不允许数量等于0
    if (0 === parseInt(goods_num)) return false;
    // 是否允许提交
    if (allow == false) return false;
    allow = false;
    $.ajax({
        url: inquiryJsonData.editInquiryListUrl,
        data: {goods_id: goods_id, goods_num: goods_num},
        type: 'post',
        dataType: 'json',
        success: function(res) {
            allow = true;
            if (1 === parseInt(res.code)) {
                $('#goods_num_' + goods_id).val(goods_num);
            } else {
                layer.alert(res.msg, {icon:5, title: false, closeBtn: false});
            }
        },
        error: function(e) {
            allow = true;
            layer.closeAll();
            layer.alert(e.responseText, {icon:5, title: false, closeBtn: false});
        }
    });
}

function delInquiryList(goods_id) {
    layer.confirm(ey_langpack_sys384, {
        move: false,
        closeBtn: 3,
        title: ey_langpack_sys22,
        btnAlign: 'r',
        shade: [0.7, '#fafafa'],
        btn: [ey_langpack_sys20, ey_langpack_sys21],
        area: ['480px', '200px'],
        success: function () {
            $(".layui-layer-content").css('text-align', 'left');
        },
        cancel: function(index) {
            layer.close(index);
        }
    }, function () {
        // 确认操作
        layerLoading(ey_langpack_sys26);
        $.ajax({
            url: inquiryJsonData.delInquiryListUrl,
            data: {goods_id: goods_id},
            type: 'post',
            dataType: 'json',
            success: function(res) {
                layer.closeAll();
                if (1 === parseInt(res.code)) {
                    layer.msg(res.msg);
                    if (0 >= parseInt(res.data)) {
                        window.location.reload();
                    } else {
                        $('#' + goods_id).remove();
                    }
                }
            },
            error: function(e) {
                layer.closeAll();
                layer.alert(e.responseText, {icon:5, title: false, closeBtn: false});
            }
        });
    }, function (index) {
        layer.close(index);
    });
}