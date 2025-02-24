
if (typeof __root_dir__ === 'undefined') {
    var __root_dir__ = '';
}
if (typeof __lang__ === 'undefined') {
    var __lang__ = '';
}

//比较版本号大小，返回值（1：前大于后，0：相等，-1：前小于后） 
function versionStringCompare(preVersion, lastVersion){
    var sources = preVersion.split('.');
    var dests = lastVersion.split('.');
    var maxL = Math.max(sources.length, dests.length);
    var result = 0;
    for (var i = 0; i < maxL; i++) {
        var preValue = sources.length>i ? sources[i]:0;
        var preNum = isNaN(Number(preValue)) ? preValue.charCodeAt() : Number(preValue);
        var lastValue = dests.length>i ? dests[i]:0;
        var lastNum =  isNaN(Number(lastValue)) ? lastValue.charCodeAt() : Number(lastValue);
        if (preNum < lastNum) {
            result = -1;
            break;
        } else if (preNum > lastNum) {
            result = 1;
            break;
        }
    }
    return result;
}

/*------------------------------全局专属 start--------------------------*/

// 读取 cookie
function getCookie_v378141(c_name)
{
    if (document.cookie.length>0)
    {
        c_start = document.cookie.indexOf(c_name + "=")
        if (c_start!=-1)
        {
            c_start=c_start + c_name.length+1
            c_end=document.cookie.indexOf(";",c_start)
            if (c_end==-1) c_end=document.cookie.length
            return unescape(document.cookie.substring(c_start,c_end))
        }
    }
    return "";
}
/*------------------------------会员注册登录标签专属 start--------------------------*/
if ("undefined" != typeof tag_userinfo_json) {
    tag_userinfo_1608459452(tag_userinfo_json);
} else {
    if ("undefined" != typeof tag_user_login_json) {
        tag_user(tag_user_login_json);
    }
    if ("undefined" != typeof tag_user_reg_json) {
        tag_user(tag_user_reg_json);
    }
    if ("undefined" != typeof tag_user_logout_json) {
        tag_user(tag_user_logout_json);
    }
    if ("undefined" != typeof tag_user_cart_json) {
        tag_user(tag_user_cart_json);
    }
}
if ("undefined" != typeof tag_user_collect_json) {
    tag_collect_1608459452(tag_user_collect_json);
}
if ("undefined" != typeof tag_user_info_json) {
    tag_user_info(tag_user_info_json);
}

/*----新注册登录标签专属 start------*/
function tag_userinfo_1608459452(result)
{
    var users_id = getCookie_v378141('users_id');

    var before_display = '';
    var htmlObj = document.getElementById(result.htmlid);
    if (!htmlObj) {
        return true;
    } else {
        before_display = htmlObj.style.display;
    }

    if (users_id > 0 && htmlObj) {
        var box = document.querySelectorAll('[id^=ey_htmlid_v]');
        if (box && box.length > 0) {
            for (var i = box.length - 1; i >= 0; i--) {
                box[i].style.display = 'none';
            }
        } else {
            htmlObj.style.display = 'none';
        }
    }

    /*图形验证码*/
    var ey_login_vertify_display = '';
    if (document.getElementById('ey_login_vertify')) {
        ey_login_vertify_display = document.getElementById('ey_login_vertify').style.display;
        document.getElementById('ey_login_vertify').style.display = 'none';
    }
    /*end*/

    /*第三方快捷登录*/
    var third_party_login_display = third_party_wxlogin_display = third_party_wblogin_display = third_party_qqlogin_display = '';
    if (document.getElementById('ey_third_party_login')) {
        third_party_login_display = document.getElementById('ey_third_party_login').style.display;
        document.getElementById('ey_third_party_login').style.display = 'none';
        if (document.getElementById('ey_third_party_wxlogin')) {
            third_party_wxlogin_display = document.getElementById('ey_third_party_wxlogin').style.display;
            document.getElementById('ey_third_party_wxlogin').style.display = 'none';
        }
        if (document.getElementById('ey_third_party_wblogin')) {
            third_party_wblogin_display = document.getElementById('ey_third_party_wblogin').style.display;
            document.getElementById('ey_third_party_wblogin').style.display = 'none';
        }
        if (document.getElementById('ey_third_party_qqlogin')) {
            third_party_qqlogin_display = document.getElementById('ey_third_party_qqlogin').style.display;
            document.getElementById('ey_third_party_qqlogin').style.display = 'none';
        }
    }
    /*end*/

    if (window.jQuery) {
        $.ajax({
            type : 'post',
            url : result.root_dir+"/index.php?m=api&c=Diyajax&a=check_userinfo&lang="+__lang__,
            data : {aid:ey_aid, viewfile:result.viewfile},
            dataType : 'json',
            success : function(res){
                loginafter_1610585975(res, htmlObj, before_display, ey_login_vertify_display, third_party_login_display, third_party_wxlogin_display, third_party_wblogin_display, third_party_qqlogin_display);
            }
        });
    } else {
        //步骤一:创建异步对象
        var ajax = new XMLHttpRequest();
        //步骤二:设置请求的url参数,参数一是请求的类型,参数二是请求的url,可以带参数,动态的传递参数starName到服务端
        ajax.open("post", result.root_dir+"/index.php?m=api&c=Diyajax&a=check_userinfo&lang="+__lang__, true);
        // 给头部添加ajax信息
        ajax.setRequestHeader("X-Requested-With","XMLHttpRequest");
        // 如果需要像 HTML 表单那样 POST 数据，请使用 setRequestHeader() 来添加 HTTP 头。然后在 send() 方法中规定您希望发送的数据：
        ajax.setRequestHeader("Content-type","application/x-www-form-urlencoded");
        //步骤三:发送请求+数据
        ajax.send("aid="+ey_aid+"&viewfile="+result.viewfile);
        //步骤四:注册事件 onreadystatechange 状态改变就会调用
        ajax.onreadystatechange = function () {
            //步骤五 如果能够进到这个判断 说明 数据 完美的回来了,并且请求的页面是存在的
            if (ajax.readyState==4 && ajax.status==200) {
                var json = ajax.responseText;  
                var res = JSON.parse(json);
                loginafter_1610585975(res, htmlObj, before_display, ey_login_vertify_display, third_party_login_display, third_party_wxlogin_display, third_party_wblogin_display, third_party_qqlogin_display);
          　}
        }
    }
}

function loginafter_1610585975(res, htmlObj, before_display, ey_login_vertify_display, third_party_login_display, third_party_wxlogin_display, third_party_wblogin_display, third_party_qqlogin_display)
{
    var box = document.querySelectorAll('[id^=ey_htmlid_v]');
    if (box && box.length > 0) {
        for (var i = box.length - 1; i >= 0; i--) {
            box[i].style.display = before_display;
        }
    } else if (htmlObj) {
        htmlObj.style.display = before_display;
    }
    if (1 == res.code) {
        if (1 == res.data.ey_is_login) {
            if (box && box.length > 0) {
                for (var i = box.length - 1; i >= 0; i--) {
                    box[i].innerHTML = res.data.html;
                }
            } else if (htmlObj) {
                htmlObj.innerHTML = res.data.html;
            }
            try {
                executeScript_1610585974(res.data.html);
            } catch (e) {}
        } else {
            /*图形验证码*/
            if (1 == res.data.ey_login_vertify && document.getElementById('ey_login_vertify')) {
                document.getElementById('ey_login_vertify').style.display = ey_login_vertify_display;
            }
            /*end*/
            
            /*第三方快捷登录*/
            if (1 == res.data.ey_third_party_login && document.getElementById('ey_third_party_login')) {
                document.getElementById('ey_third_party_login').style.display = third_party_login_display;
                if (1 == res.data.ey_third_party_wxlogin && document.getElementById('ey_third_party_wxlogin')) {
                    document.getElementById('ey_third_party_wxlogin').style.display = third_party_wxlogin_display;
                }
                if (1 == res.data.ey_third_party_wblogin && document.getElementById('ey_third_party_wblogin')) {
                    document.getElementById('ey_third_party_wblogin').style.display = third_party_wblogin_display;
                }
                if (1 == res.data.ey_third_party_qqlogin && document.getElementById('ey_third_party_qqlogin')) {
                    document.getElementById('ey_third_party_qqlogin').style.display = third_party_qqlogin_display;
                }
            }
            /*end*/
        }
    }
}

/**
 * 执行AJAX返回HTML片段中的JavaScript脚本
 * 将html里的js代码抽取出来，然后通过eval函数执行它
 * @param  {[type]} html [description]
 * @return {[type]}      [description]
 */
function executeScript_1610585974(html)
{
    var reg = /<script[^>]*>([^\x00]+)$/i;
    //对整段HTML片段按<\/script>拆分
    var htmlBlock = html.split("<\/script>");
    for (var i in htmlBlock) 
    {
        var blocks;//匹配正则表达式的内容数组，blocks[1]就是真正的一段脚本内容，因为前面reg定义我们用了括号进行了捕获分组
        if (blocks = htmlBlock[i].match(reg)) 
        {
            //清除可能存在的注释标记，对于注释结尾-->可以忽略处理，eval一样能正常工作
            var code = blocks[1].replace(/<!--/, '');
            try {
                eval(code) //执行脚本
            } catch (e) {}
        }
    }
}

/*-----旧注册登录标签专属 start----*/
function tag_user(result)
{
    var obj = document.getElementById(result.id);
    var txtObj = document.getElementById(result.txtid);
    var cartObj = document.getElementById(result.cartid);
    var before_display = document.getElementById(result.id) ? document.getElementById(result.id).style.display : '';
    var before_cart_display = document.getElementById(result.cartid) ? document.getElementById(result.cartid).style.display : '';
    var before_html = '';
    var before_txt_html = '';
    if (cartObj) {
        cartObj.style.display="none";
    }
    if (txtObj) {
        before_txt_html = txtObj.innerHTML;
        if ('login' == result.type) {
            txtObj.innerHTML = 'Loading…';
        }
    } else if (obj) {
        before_html = obj.innerHTML;
        if ('login' == result.type) {
            obj.innerHTML = 'Loading…';
        }
    }
    if (obj) {
        obj.style.display="none";
    } else {
        obj = txtObj;
    }

    /*图形验证码*/
    var ey_login_vertify_display = '';
    if (document.getElementById('ey_login_vertify')) {
        ey_login_vertify_display = document.getElementById('ey_login_vertify').style.display;
        document.getElementById('ey_login_vertify').style.display = 'none';
    }
    /*end*/

    if ('login' == result.type){
        /*第三方快捷登录*/
        var third_party_login_display = '';
        if (document.getElementById('ey_third_party_login')) {
            third_party_login_display = document.getElementById('ey_third_party_login').style.display;
            document.getElementById('ey_third_party_login').style.display = 'none';
            if (document.getElementById('ey_third_party_wxlogin')) {
                var third_party_wxlogin_display = '';
                third_party_wxlogin_display = document.getElementById('ey_third_party_wxlogin').style.display;
                document.getElementById('ey_third_party_wxlogin').style.display = 'none';
            }
            if (document.getElementById('ey_third_party_wblogin')) {
                var third_party_wblogin_display = '';
                third_party_wblogin_display = document.getElementById('ey_third_party_wblogin').style.display;
                document.getElementById('ey_third_party_wblogin').style.display = 'none';
            }
            if (document.getElementById('ey_third_party_qqlogin')) {
                var third_party_qqlogin_display = '';
                third_party_qqlogin_display = document.getElementById('ey_third_party_qqlogin').style.display;
                document.getElementById('ey_third_party_qqlogin').style.display = 'none';
            }
        }
        /*end*/
    }

    var send_data = "type="+result.type+"&img="+result.img+"&afterhtml="+result.afterhtml+"&aid="+ey_aid;
    if (result.currentstyle != '') {
        send_data += "&currentstyle="+result.currentstyle;
    }
    //步骤一:创建异步对象
    var ajax = new XMLHttpRequest();
    //步骤二:设置请求的url参数,参数一是请求的类型,参数二是请求的url,可以带参数,动态的传递参数starName到服务端
    ajax.open("post", result.root_dir+"/index.php?m=api&c=Ajax&a=check_user&lang="+__lang__, true);
    // 给头部添加ajax信息
    ajax.setRequestHeader("X-Requested-With","XMLHttpRequest");
    // 如果需要像 HTML 表单那样 POST 数据，请使用 setRequestHeader() 来添加 HTTP 头。然后在 send() 方法中规定您希望发送的数据：
    ajax.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    //步骤三:发送请求+数据
    ajax.send(send_data);
    //步骤四:注册事件 onreadystatechange 状态改变就会调用
    ajax.onreadystatechange = function () {
        //步骤五 如果能够进到这个判断 说明 数据 完美的回来了,并且请求的页面是存在的
        if (ajax.readyState==4 && ajax.status==200) {
            var json = ajax.responseText;  
            var res = JSON.parse(json);
            if (1 == res.code) {
                if (1 == res.data.ey_is_login) {
                    if (obj) {
                        if ('login' == result.type) {
                            if (result.txt.length > 0) {
                                res.data.html = result.txt;
                            }
                            if (txtObj) {
                                txtObj.innerHTML = res.data.html;
                            } else {
                                if (result.afterhtml) {
                                    obj.insertAdjacentHTML('afterend', res.data.html); 
                                    obj.remove();
                                } else {
                                    obj.innerHTML = res.data.html;
                                }
                            }
                            try {
                                obj.setAttribute("href", result.url);
                                if (!before_display) {
                                    obj.style.display=before_display;
                                }
                            }catch(err){}
                        } else if ('logout' == result.type) {
                            if (txtObj) {
                                txtObj.innerHTML = before_txt_html;
                            } else {
                                obj.innerHTML = before_html;
                            }
                            try {
                                if (!before_display) {
                                    obj.style.display=before_display;
                                }
                            }catch(err){}
                        } else if ('reg' == result.type) {
                            obj.style.display="none";
                        } else if ('cart' == result.type) {
                            try {
                                if (cartObj) {
                                    if (0 < res.data.ey_cart_num_20191212) {
                                        cartObj.innerHTML = res.data.ey_cart_num_20191212;
                                        cartObj.style.display = '';
                                        // if (before_cart_display) {
                                        //     cartObj.style.display = ('none' == before_cart_display) ? '' : before_cart_display;
                                        // }
                                    } else {
                                        cartObj.innerHTML = '';
                                    }
                                }
                                if (!before_display) {
                                    obj.style.display=before_display;
                                }
                            }catch(err){}
                        }
                    }
                } else {
                    // 恢复未登录前的html文案
                    if (obj) {
                        if (txtObj) {
                            txtObj.innerHTML = before_txt_html;
                        } else {
                            obj.innerHTML = before_html;
                        }
                        if ('logout' == result.type) {
                            obj.style.display="none";
                        } else if ('cart' == result.type) {
                            try {
                                if (cartObj) {
                                    if (0 < res.data.ey_cart_num_20191212) {
                                        cartObj.innerHTML = res.data.ey_cart_num_20191212;
                                        if (before_cart_display) {
                                            cartObj.style.display = ('none' == before_cart_display) ? '' : before_cart_display;
                                        }
                                    }
                                }
                                if (!before_display) {
                                    obj.style.display=before_display;
                                }
                            }catch(err){}
                        } else {
                            try {
                                if (!before_display) {
                                    obj.style.display=before_display;
                                }
                            }catch(err){}
                        }
                    }
                    /*图形验证码*/
                    if (1 == res.data.ey_login_vertify && document.getElementById('ey_login_vertify')) {
                        document.getElementById('ey_login_vertify').style.display = ey_login_vertify_display;
                    }
                    /*end*/
                    if ('login' == result.type) {
                        /*第三方快捷登录*/
                        if (1 == res.data.ey_third_party_login && document.getElementById('ey_third_party_login')) {
                            document.getElementById('ey_third_party_login').style.display = third_party_login_display;
                            if (1 == res.data.ey_third_party_wxlogin && document.getElementById('ey_third_party_wxlogin')) {
                                document.getElementById('ey_third_party_wxlogin').style.display = third_party_wxlogin_display;
                            }
                            if (1 == res.data.ey_third_party_wblogin && document.getElementById('ey_third_party_wblogin')) {
                                document.getElementById('ey_third_party_wblogin').style.display = third_party_wblogin_display;
                            }
                            if (1 == res.data.ey_third_party_qqlogin && document.getElementById('ey_third_party_qqlogin')) {
                                document.getElementById('ey_third_party_qqlogin').style.display = third_party_qqlogin_display;
                            }
                        }
                        /*end*/
                    }
                }
            } else {
                if (obj) {
                    obj.innerHTML = 'Error';
                    try {
                        if (!before_display) {
                            obj.style.display=before_display;
                        }
                    }catch(err){}
                }
            }
      　}
    } 
}

function tag_collect_1608459452(result)
{
    var collectObj = document.getElementById(result.collectid);
    var before_collect_display = document.getElementById(result.collectid) ? document.getElementById(result.collectid).style.display : '';
    if (collectObj) {
        collectObj.style.display="none";
    }
    
    var send_data = "type="+result.type+"&img="+result.img+"&afterhtml="+result.afterhtml;
    if (result.currentstyle != '') {
        send_data += "&currentstyle="+result.currentstyle;
    }
    //步骤一:创建异步对象
    var ajax = new XMLHttpRequest();
    //步骤二:设置请求的url参数,参数一是请求的类型,参数二是请求的url,可以带参数,动态的传递参数starName到服务端
    ajax.open("post", result.root_dir+"/index.php?m=api&c=Ajax&a=check_user&lang="+__lang__, true);
    // 给头部添加ajax信息
    ajax.setRequestHeader("X-Requested-With","XMLHttpRequest");
    // 如果需要像 HTML 表单那样 POST 数据，请使用 setRequestHeader() 来添加 HTTP 头。然后在 send() 方法中规定您希望发送的数据：
    ajax.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    //步骤三:发送请求+数据
    ajax.send(send_data);
    //步骤四:注册事件 onreadystatechange 状态改变就会调用
    ajax.onreadystatechange = function () {
        //步骤五 如果能够进到这个判断 说明 数据 完美的回来了,并且请求的页面是存在的
        if (ajax.readyState==4 && ajax.status==200) {
            var json = ajax.responseText;  
            var res = JSON.parse(json);
            if (1 == res.code) {
                if (1 == res.data.ey_is_login) {
                    if ('collect' == result.type) {
                        try {
                            if (collectObj) {
                                if (0 < res.data.ey_collect_num_20191212) {
                                    collectObj.innerHTML = res.data.ey_collect_num_20191212;
                                    if (!before_collect_display) {
                                        collectObj.style.display = ('none' == before_collect_display) ? '' : before_collect_display;
                                    }
                                } else {
                                    collectObj.innerHTML = '';
                                }
                            }
                        }catch(err){}
                    }
                } else {
                    // 恢复未登录前的html文案
                    if ('collect' == result.type) {
                        try {
                            if (collectObj) {
                                if (0 < res.data.ey_collect_num_20191212) {
                                    collectObj.innerHTML = res.data.ey_collect_num_20191212;
                                    if (!before_collect_display) {
                                        collectObj.style.display = ('none' == before_collect_display) ? '' : before_collect_display;
                                    }
                                }
                            }
                        }catch(err){}
                    }
                }
            }
      　}
    } 
}

function tag_user_info(result)
{
    var obj = document.getElementById(result.t_uniqid);
    var before_display = '';
    if (obj) {
        before_display = obj.style.display;
        obj.style.display="none";
    }

    //步骤一:创建异步对象
    var ajax = new XMLHttpRequest();
    //步骤二:设置请求的url参数,参数一是请求的类型,参数二是请求的url,可以带参数,动态的传递参数starName到服务端
    ajax.open("post", result.root_dir+"/index.php?m=api&c=Ajax&a=get_tag_user_info&lang="+__lang__, true);
    // 给头部添加ajax信息
    ajax.setRequestHeader("X-Requested-With","XMLHttpRequest");
    // 如果需要像 HTML 表单那样 POST 数据，请使用 setRequestHeader() 来添加 HTTP 头。然后在 send() 方法中规定您希望发送的数据：
    ajax.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    //步骤三:发送请求+数据
    ajax.send("t_uniqid="+result.t_uniqid);
    //步骤四:注册事件 onreadystatechange 状态改变就会调用
    ajax.onreadystatechange = function () {
        //步骤五 如果能够进到这个判断 说明 数据 完美的回来了,并且请求的页面是存在的
        if (ajax.readyState==4 && ajax.status==200) {
            var json = ajax.responseText;  
            var res = JSON.parse(json);
            if (1 == res.code) {
                if (1 == res.data.ey_is_login) {
                    var dtypes = res.data.dtypes;
                    var users = res.data.users;
                    for (var key in users) {
                        var subobj = document.getElementById(key);
                        if (subobj) {
                            if ('img' == dtypes[key]) {
                                subobj.setAttribute("src", users[key]);
                            } else if ('href' == dtypes[key]) {
                                subobj.setAttribute("href", users[key]);
                            } else {
                                subobj.innerHTML = users[key];
                            }
                        }
                    }
                    if (obj) {
                        try {
                            if (!before_display) {
                                obj.style.display=before_display;
                            }
                        }catch(err){}
                    }
                } else {
                    if (obj) {
                        obj.style.display="none";
                    }
                }
            }
      　}
    }
}


/*------------------------------浏览量标签专属 start--------------------------*/
/**
 * 浏览量
 * @param  {[type]} aid [description]
 * @return {[type]}     [description]
 */
function tag_arcclick(aids)
{
    if (document.getElementsByClassName('eyou_arcclick')[0]) {
        var obj = document.getElementsByClassName('eyou_arcclick');
        var type = obj[0].getAttribute('data-type');
        var root_dir = obj[0].getAttribute('data-root_dir');

        if (window.jQuery) {
            $.ajax({
                type : 'GET',
                url : root_dir+"/index.php?m=api&c=Ajax&a=arcclick&type="+type+"&aids="+aids+"&lang="+__lang__,
                data : {},
                dataType : 'json',
                success : function(res){
                    for (var i = 0; i < obj.length; i++) {
                        obj[i].innerHTML = res[obj[i].getAttribute('data-aid')]['click'];
                    }
                }
            });
        } else {
            var ajax = new XMLHttpRequest();
            ajax.open("get", root_dir+"/index.php?m=api&c=Ajax&a=arcclick&type="+type+"&aids="+aids+"&lang="+__lang__, true);
            ajax.setRequestHeader("X-Requested-With","XMLHttpRequest");
            // ajax.setRequestHeader("Content-type","application/x-www-form-urlencoded");
            ajax.send();
            ajax.onreadystatechange = function () {
                if (ajax.readyState==4 && ajax.status==200) {
                    var json = ajax.responseText;
                    var res = JSON.parse(json);
                    for (var i = 0; i < obj.length; i++) {
                        obj[i].innerHTML = res[obj[i].getAttribute('data-aid')]['click'];
                    }
              　}
            }
        }
    }
}

if (document.getElementsByClassName('eyou_arcclick')[0]) {
    var arr_1653059625 = [];
    var obj_1653059625 = document.getElementsByClassName('eyou_arcclick');
    for (var i = 0; i < obj_1653059625.length; i++) {
        arr_1653059625.push(obj_1653059625[i].getAttribute('data-aid'));
    }
    var aids_1653059625 = arr_1653059625.toString();
    tag_arcclick(aids_1653059625);
}

function tag_getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
}

/*------------------------------访问足迹专属 start--------------------------*/

/*
function footprint_1606269933(aid, root_dir)
{
    var users_id = getCookie_v378141('users_id');
    if (!users_id || aid == 0) {
        return false;
    }

    //步骤一:创建异步对象
    var ajax = new XMLHttpRequest();
    //步骤二:设置请求的url参数,参数一是请求的类型,参数二是请求的url,可以带参数,动态的传递参数starName到服务端
    ajax.open("post", root_dir+'/index.php?m=api&c=Ajax&a=footprint_save&lang='+__lang__, true);
    // 给头部添加ajax信息
    ajax.setRequestHeader("X-Requested-With","XMLHttpRequest");
    // 如果需要像 HTML 表单那样 POST 数据，请使用 setRequestHeader() 来添加 HTTP 头。然后在 send() 方法中规定您希望发送的数据：
    ajax.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    //步骤三:发送请求+数据
    ajax.send('aid='+aid+'&_ajax=1');
    //步骤四:注册事件 onreadystatechange 状态改变就会调用
    ajax.onreadystatechange = function () {
        //步骤五 如果能够进到这个判断 说明 数据 完美的回来了,并且请求的页面是存在的
        if (ajax.readyState==4 && ajax.status==200) {
            var json = ajax.responseText;
            var res = JSON.parse(json);
            if (1 == res.code) {
                //成功
            }
        }
    }
}

footprint_1606269933(ey_aid, __root_dir__);
*/

/*------------------------------cookie协议 start--------------------------*/

var cookieagrem_popup_obj = '';
var cookieagrem_obj = '';
var cookieagrem_content_obj = '';
document.addEventListener('DOMContentLoaded', function() {
    cookieagrem_popup_obj = document.getElementById("cookies-popup");
    cookieagrem_obj = document.getElementById("cookies_agreement");
    cookieagrem_content_obj = document.getElementById("cookieagrem_content")
    if (cookieagrem_obj) {
        cookieagrem_show_init();
        // 获取所有具有指定 class 的元素
        const elements = document.getElementsByClassName('opencookies');
        if (cookieagrem_popup_obj && elements[0]) {
            // 遍历这些元素并添加点击事件监听器
            for (let i = 0; i < elements.length; i++) {
                elements[i].addEventListener('click', function () {
                    cookieagrem_content_view();
                });
            }
        }
    }
});

function cookieagrem_show_init() {
    var before_display = cookieagrem_obj.style.display;
    if (before_display.indexOf('none') == -1) {
        cookieagrem_obj.style.display = 'none';
    }

    var accept_rejectt_cookie = window.localStorage.getItem("accept_rejectt_cookie");
    if (!accept_rejectt_cookie) {
        if (before_display.indexOf('none') == -1) {
            cookieagrem_obj.style.display = before_display;
        } else {
            cookieagrem_obj.style.display = 'block';
        }
        /*
        //步骤一:创建异步对象
        var ajax = new XMLHttpRequest();
        //步骤二:设置请求的url参数,参数一是请求的类型,参数二是请求的url,可以带参数,动态的传递参数starName到服务端
        ajax.open("post", __root_dir__ + "/index.php?m=api&c=Ajax&a=cookieagrem_show_init&lang="+__lang__, true);
        // 给头部添加ajax信息
        ajax.setRequestHeader("X-Requested-With","XMLHttpRequest");
        // 如果需要像 HTML 表单那样 POST 数据，请使用 setRequestHeader() 来添加 HTTP 头。然后在 send() 方法中规定您希望发送的数据：
        ajax.setRequestHeader("Content-type","application/x-www-form-urlencoded");
        //步骤三:发送请求+数据
        ajax.send('_ajax=1');
        //步骤四:注册事件 onreadystatechange 状态改变就会调用
        ajax.onreadystatechange = function () {
            //步骤五 如果能够进到这个判断 说明 数据 完美的回来了,并且请求的页面是存在的
            if (ajax.readyState == 4 && ajax.status == 200) {
                var json = ajax.responseText;  
                var res = JSON.parse(json);
                if (res && 1 == res.data.status) {
                    if (before_display.indexOf('none') == -1) {
                        cookieagrem_obj.style.display = before_display;
                    } else {
                        cookieagrem_obj.style.display = 'block';
                    }
                    
                    if (1 == res.data.position) {
                        cookieagrem_obj.classList.add("cookies-bottom");
                    } else {
                        cookieagrem_obj.classList.remove("cookies-bottom");
                    }
                }
          　}
        }
        */
    }
}

function cookieagrem_content_view(obj, title) {
    cookieagrem_popup_obj.classList.add("cookies-open-popup");
    /*
    //步骤一:创建异步对象
    var ajax = new XMLHttpRequest();
    //步骤二:设置请求的url参数,参数一是请求的类型,参数二是请求的url,可以带参数,动态的传递参数starName到服务端
    ajax.open("post", __root_dir__ + "/index.php?m=api&c=Ajax&a=cookieagrem_get_content&lang="+__lang__, true);
    // 给头部添加ajax信息
    ajax.setRequestHeader("X-Requested-With","XMLHttpRequest");
    // 如果需要像 HTML 表单那样 POST 数据，请使用 setRequestHeader() 来添加 HTTP 头。然后在 send() 方法中规定您希望发送的数据：
    ajax.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    //步骤三:发送请求+数据
    ajax.send('_ajax=1');
    //步骤四:注册事件 onreadystatechange 状态改变就会调用
    ajax.onreadystatechange = function () {
        //步骤五 如果能够进到这个判断 说明 数据 完美的回来了,并且请求的页面是存在的
        if (ajax.readyState == 4 && ajax.status == 200) {
            var json = ajax.responseText;  
            var res = JSON.parse(json);
            if(res && res.code == 1){
                if (cookieagrem_content_obj) {
                    cookieagrem_content_obj.innerHTML = res.data.content;
                }
                cookieagrem_popup_obj.classList.add("cookies-open-popup");
            }
      　}
    }
    */
}

/**
 * 同意协议
 * @return {[type]} [description]
 */
function accept_cookieagrem(obj) {
    if (cookieagrem_obj) {
        cookieagrem_obj.style.display = 'none';
        window.localStorage.setItem("accept_rejectt_cookie", "accept");
        // ey_cookieagrem_session_set("ey_cookie_httponly", 1);
    }
}

/**
 * 拒绝协议
 * @return {[type]} [description]
 */
function rejectt_cookieagrem(obj) {
    if (cookieagrem_obj) {
        cookieagrem_obj.style.display = 'none';
        window.localStorage.setItem("accept_rejectt_cookie", "rejectt");
        // ey_cookieagrem_session_set("ey_cookie_httponly", 0);
    }
}

/**
 * 关闭协议弹窗
 * @return {[type]} [description]
 */
function close_cookieagrem_popup(obj) {
    if (cookieagrem_popup_obj) {
        cookieagrem_popup_obj.classList.remove("cookies-open-popup");
    }
}

function ey_cookieagrem_session_set(name, value) {
    if (cookieagrem_obj) {
        //步骤一:创建异步对象
        var ajax = new XMLHttpRequest();
        //步骤二:设置请求的url参数,参数一是请求的类型,参数二是请求的url,可以带参数,动态的传递参数starName到服务端
        ajax.open("post", __root_dir__ + "/index.php?m=api&c=Ajax&a=cookieagrem_session_set&lang="+__lang__, true);
        // 给头部添加ajax信息
        ajax.setRequestHeader("X-Requested-With","XMLHttpRequest");
        // 如果需要像 HTML 表单那样 POST 数据，请使用 setRequestHeader() 来添加 HTTP 头。然后在 send() 方法中规定您希望发送的数据：
        ajax.setRequestHeader("Content-type","application/x-www-form-urlencoded");
        //步骤三:发送请求+数据
        ajax.send('_ajax=1&name='+name+'&value='+value);
        //步骤四:注册事件 onreadystatechange 状态改变就会调用
        ajax.onreadystatechange = function () {
            //步骤五 如果能够进到这个判断 说明 数据 完美的回来了,并且请求的页面是存在的
            if (ajax.readyState == 4 && ajax.status == 200) {
                var json = ajax.responseText;  
                var res = JSON.parse(json);
                if (res && 1 == res.code) {
                    cookieagrem_obj.style.display = 'none';
                }
          　}
        }
    }
}

/*------------------------------cookie协议 end--------------------------*/



/*------------------------------记录访问IP地址 start--------------------------*/

ey_visit_log_ip();
function ey_visit_log_ip() {
    //步骤一:创建异步对象
    var ajax = new XMLHttpRequest();
    //步骤二:设置请求的url参数,参数一是请求的类型,参数二是请求的url,可以带参数,动态的传递参数starName到服务端
    ajax.open("post", __root_dir__ + "/index.php?m=api&c=Ajax&a=visit_log_ip&lang="+__lang__, true);
    // 给头部添加ajax信息
    ajax.setRequestHeader("X-Requested-With","XMLHttpRequest");
    // 如果需要像 HTML 表单那样 POST 数据，请使用 setRequestHeader() 来添加 HTTP 头。然后在 send() 方法中规定您希望发送的数据：
    ajax.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    //步骤三:发送请求+数据
    ajax.send('_ajax=1');
    //步骤四:注册事件 onreadystatechange 状态改变就会调用
    ajax.onreadystatechange = function () {
        //步骤五 如果能够进到这个判断 说明 数据 完美的回来了,并且请求的页面是存在的
        if (ajax.readyState == 4 && ajax.status == 200) {
            var json = ajax.responseText;  
            var res = JSON.parse(json);
            if (res && 1 == res.code) {
                // console.log(res.msg);
            }
      　}
    }
}

/*------------------------------记录访问IP地址 end--------------------------*/


/*------------------------------更新购物车商品 start--------------------------*/

function updateCart(cartNum, cartHtml, isParent, resMsg) {
    if (isParent) {
        var parent_ = parent;
        // 购物车侧边页面
        if (cartHtml && 0 < parseInt(parent_.$('#zan_mini_cart').length)) parent_.$('#zan_mini_cart').html(cartHtml);

        // 购物车图标数量
        if (0 < parseInt(cartNum) && 0 < parseInt(parent_.$('.shopping_cart .item_count').length)) {
            parent_.$('.shopping_cart .item_count').html(parseInt(cartNum));
        } else if (1 === parseInt(cartNum)) {
            parent_.$('.shopping_cart').append('<span class="item_count">'+parseInt(cartNum)+'</span>');
        }

        // 关闭自身页面，弹出侧边购物车
        parent_.layer.closeAll();
        parent_.layer.msg(resMsg ? resMsg : 'successfully');
        if (0 < parseInt(parent_.$('#zan_mini_cart .mini_cart').length)) parent_.$('.mini_cart, .body_overlay').addClass('active');
    } else {
        // 购物车侧边页面
        if (cartHtml && 0 < parseInt($('#zan_mini_cart').length)) $('#zan_mini_cart').html(cartHtml);

        // 购物车图标数量
        if (0 < parseInt(cartNum) && 0 < parseInt($('.shopping_cart .item_count').length)) {
            $('.shopping_cart .item_count').html(parseInt(cartNum));
        } else if (1 === parseInt(cartNum)) {
            $('.shopping_cart').append('<span class="item_count">'+parseInt(cartNum)+'</span>');
        }
    }
}

/*------------------------------更新购物车商品 end--------------------------*/