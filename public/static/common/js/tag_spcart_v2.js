var jsonData = b82ac06cf24687eba9bc5a7ba92be4c8;
var showHeight = '200px;';
var showWidth = 1 === parseInt(jsonData.is_wap) ? '380px;' : '480px;';

$(document).ready(function() {
    // if (0 < parseInt($('input[name=ey_buynum]').length)) {
    //     $('input[name=ey_buynum]').each(function() {
    //         var newCartId = $('#'+this.id).attr('cart-id');
    //         if (1 === parseInt($('#'+newCartId+'_Selected').val())) $('#'+newCartId+'_checked').prop('checked', true);
    //     });
    // }
    // if (1 === parseInt($('#AllSelected').val())) $('#AllChecked').prop('checked', true);
});

// 数量加减
function CartUnifiedAlgorithm(is_sold_out, aid, symbol, selected, spec_value_id, cart_id) {
    if ('IsSoldOut' == is_sold_out) {
        showErrorMsg(ey_langpack_users338);
        return false;
    }
    if ('IsDel' == is_sold_out) {
        showErrorMsg('无效商品！');
        return false;
    }

    var numberObj = $('#'+cart_id+'_num');
    var cartNumber = numberObj.val();
    if ('+' == symbol) {
        cartNumber = Number(numberObj.val()) + 1;
    } else if ('-' == symbol) {
        cartNumber = Number(numberObj.val()) - 1;
    }
    if (Number(is_sold_out) < Number(cartNumber)) {
        showErrorMsg(ey_langpack_users339);
        numberObj.val(numberObj.attr('data-pre_value'));
        return false;
    }
    numberObj.attr('data-pre_value', cartNumber);

    // 手动输入数量
    if ('change' == symbol) {
        if (1 > parseInt(numberObj.val()) || '' == numberObj.val()) {
            numberObj.val(1);
            showErrorMsg(ey_langpack_users278);
            return false;
        }
    }
    // 数量加
    else if ('+' == symbol) {
        // 计算单品数量
        numberObj.val(Number(numberObj.val()) + 1);
    }
    // 数量减
    else if ('-' == symbol && parseInt(numberObj.val()) > 1) {
        // 计算单品数量
        numberObj.val(Number(numberObj.val()) - 1);
    } 
    // 商品数量最少为1
    else {
        showErrorMsg(ey_langpack_users278);
        return false;
    }

    // 计算单品小计
    var subTotalNums = Number($('#'+cart_id+'_price').html()) * Number(numberObj.val());
    $('#'+cart_id+'_subtotal').html(parseFloat(subTotalNums.toFixed(2)));

    // 执行更新
    $.ajax({
        url : jsonData.cart_unified_algorithm_url,
        data: {aid: aid, symbol: symbol, num: Number(numberObj.val()), spec_value_id: spec_value_id},
        type: 'post',
        dataType: 'json',
        success: function(res) {
            // 返回错误信息
            if (0 === parseInt(res.code)) {
                showSuccessMsg(res.msg, function() {
                    // 购物车不存在商品，非法操作则刷新页面
                    if (0 === parseInt(res.data.error)) window.location.reload();
                });
            } else {
                $('#TotalNumber').html(parseInt(res.data.NumberVal));
                $('#TotalAmount').html(parseFloat(res.data.AmountVal));
                $('#TotalNumberDel').html(parseInt(res.data.NumberVal));
                $('#TotalCartNumber').html(parseInt(res.data.CartAmountVal));
                updateCart(res.data.NumberVal);
            }
        }
    });
}

// 购物车选中产品
function Checked(cart_id, selected) {
    // html无刷新更新选中状态
    var numberVal = 0; // 初始化参数
    var amountVal = 0; // 初始化参数
    if ('*' == cart_id) {
        // 全选中或全撤销选中
        selected = $('#AllSelected').val();
        var divInputArr = $('input[name=ey_buynum]');
        if (0 === parseInt(selected)) {
            divInputArr.each(function(){
                // 赋值单选框
                $('#'+this.id).prop('checked', true);
                $('#'+this.id).val(1);
                // 赋值隐藏域
                var newCartId = $('#'+this.id).attr('cart-id');
                $('#'+newCartId+'_Selected').val(1);
                // 计算总数总额
                numberVal +=  + Number($('#'+newCartId+'_num').val());
                amountVal +=  + Number($('#'+newCartId+'_subtotal').html());
            });
            // 赋值主选框
            $('#AllSelected').val(1);
        } else {
            divInputArr.each(function(){
                // 赋值单选框
                $('#'+this.id).prop("checked", false);
                $('#'+this.id).val(0);
                // 赋值隐藏域
                var newCartId = $('#'+this.id).attr('cart-id');
                $('#'+newCartId+'_Selected').val(0);
            });
            // 赋值主选框
            $('#AllSelected').val(0);
        }
    } else {
        var checkedNum = 0; // 初始化参数
        var divInputArr = $('input[name=ey_buynum]');
        divInputArr.each(function(){
            if ( $('#'+this.id).is(':checked') ) {
                // 计算选中数量
                checkedNum++;
                // 计算总数总额
                numberVal +=  + Number($('#'+$('#'+this.id).attr('cart-id')+'_num').val());
                amountVal +=  + Number($('#'+$('#'+this.id).attr('cart-id')+'_subtotal').html());
            }
        });

        selected = $('#'+cart_id+'_Selected').val();
        if (0 === parseInt(selected)) {
            $('#'+cart_id+'_Selected').val(1);
            if (divInputArr.length == checkedNum) {
                // 全部选中
                $('#AllSelected').val(1);
                $('#AllChecked').prop('checked', true);
            } else {
                // 非全部选中
                $('#AllSelected').val(0);
                $('#AllChecked').prop("checked", false);
            }
        } else {
            // 撤销选中
            $('#AllSelected').val(0);
            $('#'+cart_id+'_Selected').val(0);
            $('#AllChecked').prop("checked", false);
        }
    }

    // 赋值总额总数
    $('#TotalAmount').html(parseFloat(amountVal.toFixed(2)));
    $('#TotalNumber, #TotalNumberDel').html(parseInt(numberVal));
    updateCart(numberVal);

    // 修改购物车选中数据
    $.ajax({
        url : jsonData.cart_checked_url,
        data: {cart_id: cart_id, selected: selected, _ajax: 1},
        type: 'post',
        dataType: 'json',
        success: function(res) {
            if (0 === parseInt(res.code)) showSuccessMsg(res.msg);
        }
    });
}

// 删除购物车产品
function CartDel(cart_id, title, deteleAll) {
    var msg = deteleAll ? '确认' + ey_langpack_users362 : ey_langpack_users279;
    unifiedConfirmBox(msg + title + '？', showWidth, showHeight, function() {
        $.ajax({
            url : jsonData.cart_del_url,
            data: {cart_id: cart_id, deteleAll: deteleAll},
            type: 'post',
            dataType: 'json',
            success: function(res) {
                layer.closeAll();
                if (1 === parseInt(res.code)) {
                    showSuccessMsg(res.msg);
                    if (0 == res.data.CartCount) {
                        window.location.reload();
                    } else {
                        $('#' + cart_id + '_product').remove();
                        $('#' + cart_id + '_product_spec').remove();
                        $('#TotalNumber').html(parseInt(res.data.NumberVal));
                        $('#TotalAmount').html(parseFloat(res.data.AmountVal));
                        $('#TotalNumberDel').html(parseInt(res.data.NumberVal));
                        $('#TotalCartNumber').html(parseInt(res.data.CartAmountVal));
                        updateCart(res.data.NumberVal);
                    }
                } else {
                    showErrorMsg(res.msg);
                }
            }
        });
    });
}

// 直接删除购物车产品，不进行询问
function directDeletion(cart_id) {
    $.ajax({
        url : jsonData.cart_del_url,
        data: {cart_id: cart_id},
        type: 'post',
        dataType: 'json',
        success: function(res) {
            layer.closeAll();
            if (1 === parseInt(res.code)) {
                showSuccessMsg(res.msg);
                if (0 == res.data.CartCount) {
                    window.location.reload();
                } else {
                    $('#' + cart_id + '_product').remove();
                    $('#TotalAmount').html(parseFloat(res.data.AmountVal));
                    $('#TotalCartNumber').html(parseInt(res.data.CartAmountVal));
                    updateCart(res.data.NumberVal);
                }
            } else {
                showErrorMsg(res.msg);
            }
        }
    });
}

// 删除选中的购物车商品
function selectCartDel() {
    if (checkSelected()) {
        unifiedConfirmBox(ey_langpack_users378, showWidth, showHeight, function() {
            $.ajax({
                url : jsonData.select_cart_del_url,
                data: {_ajax: 1},
                type: 'post',
                dataType: 'json',
                success: function(res) {
                    if (1 === parseInt(res.code)) {
                        showSuccessMsg(res.msg, function() {
                            window.location.reload();
                        });
                    } else {
                        showErrorAlert(res.msg);
                    }
                }
            });
        });
    }
}

// 移入收藏
function MoveToCollection(cart_id, title) {
    unifiedConfirmBox('确定将商品: '+title+'，移入收藏？', showWidth, showHeight, function() {
        $.ajax({
            url : jsonData.move_to_collection_url,
            data: {cart_id: cart_id},
            type: 'post',
            dataType: 'json',
            success: function(res) {
                layer.closeAll();
                if (1 === parseInt(res.code)) {
                    showSuccessMsg(res.msg);
                    $('#' + cart_id + '_product').remove();
                    $('#' + cart_id + '_product_spec').remove();
                    $('#TotalNumber').html(res.data.NumberVal);
                    $('#TotalAmount').html(parseFloat(res.data.AmountVal));
                    if (0 == res.data.CartCount) window.location.reload();
                } else {
                    showErrorMsg(res.msg);
                }
            }
        });
    });
}

// 检查购物车商品是否库存都充足，不足时提示
function SubmitOrder(GetUrl) {
    $.ajax({
        url : jsonData.cart_stock_detection,
        data: {_ajax:1},
        type: 'post',
        dataType: 'json',
        success: function(res) {
            if (1 === parseInt(res.code)) {
                if (1 === parseInt(res.data)) {
                    unifiedConfirmBox(ey_langpack_users379, showWidth, showHeight, function() {
                        window.location.href = GetUrl;
                    });
                } else {
                    window.location.href = GetUrl;
                }
            } else {
                showErrorMsg(res.msg);
            }
        }
    });
}

function toSplitGoods(jumpUrl) {
    if (checkSelected()) {
        $.ajax({
            url : jsonData.toSplitGoods,
            data: {_ajax: 1},
            type: 'post',
            dataType: 'json',
            success: function(res) {
                if (1 === parseInt(res.code)) {
                    window.location.href = jumpUrl;
                } else {
                    var area = ['1220px', '90%'];
                    if (1 === parseInt(jsonData.is_wap)) area = ['100%', '100%'];
                    layer.open({
                        type: 2,
                        title: '选择结算商品',
                        shadeClose: false,
                        maxmin: false, //开启最大化最小化按钮
                        area: area,
                        content: jsonData.toSplitGoods
                    });
                }
            },
            error: function(e) {
                showErrorAlert(e.responseText);
            }
        });
    }
}

function checkSelected() {
    if (1 === parseInt(jsonData.isCheck)) {
        if (0 === parseInt($('input[name=ey_buynum]:checked').length)) {
            unifiedRemindBox(ey_langpack_users380);
            return false;
        }
    }

    return true;
}