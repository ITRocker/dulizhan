
$.fn.webDisplay = function(type) {
    if (type == 0) {
        if ($(window).width() >= 1250) {
            $('body').addClass('w_1200');
        }
        $(window).resize(function() {
            if ($(window).width() >= 1250) {
                $('body').addClass('w_1200');
            } else {
                $('body').removeClass('w_1200');
            }
        });
    } else if (type == 2) {
        $('body').addClass('w_1200');
    }
}

function nav(father, son, bor, del) {
    var delay = del ? del : 0;
    var func = function() {
        var chd = $(son);
        var nav = $(father).width();
        var chd_width = 0;
        var border = bor ? bor : 0;
        chd.show();
        chd.each(function() {
            var w = $(this).width();
            var pl = $(this).css("padding-left");
            var pr = $(this).css("padding-right");
            var ml = $(this).css("margin-left");
            var mr = $(this).css("margin-right");
            var width = parseInt(w) + parseInt(pl) + parseInt(pr) + parseInt(ml) + parseInt(mr) + border;
            chd_width += width;
            if (chd_width > nav) {
                $(this).hide();
            } else {
                $(this).show();
            }
        });
    }
    func();
    $(window).resize(function() {
        if (delay) {
            setTimeout(func, 210);
        } else {
            func();
        }
    });
}

function showthis(o1, o2, i, c) {
    $(o1).eq(i).addClass(c).siblings(o1).removeClass(c);
    $(o2).eq(i).show().siblings(o2).hide();
}

function SetEditorContents(ContentsId) {
    var _this = $(ContentsId);
    var _img = _this.find("img");
    _img.each(function() {
        var _float = $(this).css("float");
        if (_float == 'left') {
            $(this).css("margin-right", "20px");
        } else if (_float == 'right') {
            $(this).css("margin-left", "20px");
        }
    });
    _this.find('td').css('word-break', 'normal');
}
$(function() {
    SetEditorContents("#global_editor_contents");
})

function product_gallery() {
    if ($('body').hasClass('mode_horizontal')) {
        var node_name = 'horizontal',
            pic_num = 1;
    } else {
        var node_name = 'vertical',
            pic_num = 4;
    }
    if ($('.webpro_detail .gallery .left_small_img .pic_box').length > pic_num) {
        $('.left_small_img_inner').bxSlider({
            mode: node_name,
            auto: false,
            slideWidth: 90,
            minSlides: 4,
            maxSlides: 4,
            moveSlides: 1,
            slideMargin: 20
        });
    }
    $('.webpro_detail .products_img ul').bxSlider({
        slideWidth: $('.webpro_detail .products_img ul').width(),
        pager: false,
        auto: false,
        minSlides: 1,
        maxSlides: 1,
        moveSlides: 1,
        slideMargin: 0
    });
    $('#small_img .small_img_list .bd , .left_small_img').on('click', 'span', function() {
        $bigPic = $('.gallery .bigimg');
        if ($(this).attr('pos') == 'video') {
            $bigPic.find(".zoom_out").hide();
            $bigPic.find(".video_container").show();
            $(this).addClass('on').siblings('span').removeClass('on');
            $('#zoom').css('width', 'auto');
            var_j(document).a('domready', MagicZoom.refresh);
            var_j(document).a('mousemove', MagicZoom.z1);
        } else {
            $bigPic.find(".zoom_out").show();
            $bigPic.find(".video_container").hide().find('.ytp-chrome-bottom .ytp-play-button').click();
            var img = $(this).attr('pic');
            var big_img = $(this).attr('big');
            if ($('#bigimg_src').length) {
                $('#bigimg_src').attr('src', img).parent().attr('href', big_img);
            } else {
                $('#zoom').find('img').attr('src', img).parent().attr('href', big_img);
            }
            $(this).addClass('on').siblings('span').removeClass('on');
            $('#zoom').css('width', 'auto');
            var_j(document).a('domready', MagicZoom.refresh);
            var_j(document).a('mousemove', MagicZoom.z1);
        }
    });
    var_j(document).a('domready', MagicZoom.refresh);
    var_j(document).a('mousemove', MagicZoom.z1);
}
$(function() {
    $('.description .global_mtitle').click(function() {
        var _this = $(this),
            obj = _this.siblings('.editor_cnt'),
            content = obj.find('#global_editor_contents'),
            height = content.outerHeight(true),
            cur = _this.hasClass('cur');
        if (cur) {
            _this.removeClass('cur');
            height = 0;
        } else {
            _this.addClass('cur');
        }
        obj.height(height);
        var sib = _this.parents('.contents').siblings('.contents');
        sib.find('.global_mtitle').removeClass('cur');
        sib.find('.editor_cnt').height(0);
    })
    if ($(window).width() < 768) {
        $('.description .global_mtitle').eq(0).click();
    }

    $(window).scroll(function() {
        if ($(window).scrollTop() > 0) {
            $('#go_top').addClass("show");
        } else {
            $('#go_top').removeClass("show");
        }
    });
    $('#go_top').click(function() {
        $("html, body").animate({
            "scrollTop": 0
        }, 700);
    });
    $("#global_editor_contents table").wrap("<div class='editor_table_wrap'></div>");
    $(document).click(function(e) {
        e = window.event || e;
        obj = $(e.srcElement || e.target);
        if (!$(obj).is("#country_chzn, #country_chzn *")) {
            $('#country_chzn').removeClass('chzn-container-active').css('z-index', '0').children('a')
                .blur().removeClass('chzn-single-with-drop').end().children('.chzn-drop').css({
                    'left': '-9000px'
                }).find('input').val('').parent().next().find('.group-option').addClass(
                'active-result');
        }
    });
    jQuery.expr[':'].Contains = function(a, i, m) {
        return (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
    };
    $('body').on('click', '#default_search_box i', function() {
        if ($('#default_search_box').is(":animated")) {
            return false;
        }
        $('#default_search_box').fadeOut("slow", function() {
            $('#default_search_box').remove();
        });
    });
});
$(function() {
    nav('.head-nav', '.head-nav .n_item');
    $('.products .pro_cate .first_cate').on('click', function() {
        $(this).parents('.list').find('.son_cate').toggleClass('on');
        $(this).parents('.list').toggleClass('on');
    })
    $('.search-form').on('click', function(e) {
        e.stopPropagation();
        if (!$(this).hasClass('open')) {
            $(this).addClass('open');
        }
    });
    $('body').click(function() {
        $('.search-form').removeClass('open');
    });
    $("#footer .link ul li.tit").click(function() {
        $(this).parent().toggleClass('show-child');
    });

    function footer_click() {
        $('#footer .f_left .f_title , #footer .f_right .f_item .f_title').on('click', function() {
            var $this = $(this),
                cur = $this.parent().hasClass('cur');
            if ($this.find('em').length == 0) {
                return false;
            }
            if (cur) {
                $this.parent().removeClass('cur');
                $this.next().hide();
                console.log($this.next());
            } else {
                $this.parent().addClass('cur');
                $this.next().show();
            }
        })
    }
    if ($(window).width() <= 768) {
        footer_click();
    }
    $(window).scroll(function() {
        var height = $(".header_top").outerHeight();
        var w_top = $(this).scrollTop();
        if (w_top > height) {
            $('.responsive_pc_header .header_in').addClass('fixed');
        } else {
            $('.responsive_pc_header .header_in').removeClass('fixed');
        }
    });
});
