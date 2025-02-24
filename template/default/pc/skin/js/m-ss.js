$('.web_header .menu_btn').on('click', function() {
    if ($(this).hasClass('on')) {
        $(this).removeClass('on');
        $('.web_header').find('.nav, .nav_bg, .son_nav').removeClass('on');
        $('body').attr('style', '');
    } else {
        $(this).addClass('on');
        $('.web_header').find('.nav, .nav_bg').addClass('on');
        $('body').css({
            'overflow': 'hidden'
        });
    }
});
$('.web_header .language_btn').on('click', function() {
    if ($(this).hasClass('on')) {
        $(this).removeClass('on');
        $('.web_header .language').removeClass('on');
        $('body').attr('style', '');
    } else {
        $(this).addClass('on');
        $('.web_header .language').addClass('on');
        $('.web_header').find('.menu_btn, .nav_bg, .nav, .son_nav').removeClass('on');
        $('body').css({
            'overflow': 'hidden'
        });
    }
});
$('.web_header .search_btn').on('click', function() {
    if ($(this).hasClass('on')) {
        $(this).removeClass('on');
        $('.web_header .resp_search_box').removeClass('on');
    } else {
        $(this).addClass('on');
        $('.web_header .resp_search_box').addClass('on');
        $('.web_header').find('.menu_btn, .nav_bg, .nav, .son_nav').removeClass('on');
        $('body').attr('style', '');
    }
});
$('.web_header .nav_bg').on('click', function() {
    $(this).removeClass('on');
    $('.web_header').find('.nav, .son_nav, .menu_btn').removeClass('on');
    $('body').attr('style', '');
});
$('.web_header .resp_search_box .close_btn span').on('click', function() {
    $(this).parents('.resp_search_box').removeClass('on');
    $('.web_header .search_btn').removeClass('on');
});
$('.web_header .language .close_btn span').on('click', function() {
    $(this).parents('.language').removeClass('on');
    $('.web_header .language_btn').removeClass('on');
})
$('.web_header .nav .list .title').on('click', function(e) {
    $('.web_header .hasub .sub').removeClass('on');
    $('.web_header .son_nav').html($(this).parents('.list').find('.sub').html()).addClass('on');
});
$('.web_header .son_nav').on('click', '.cate_close', function(e) {
    $('.web_header .son_nav').removeClass('on');
})
$('.web_header .son_nav').on('click', '.son_nav_title', function() {
    $(this).parent('.item').find('.third_nav').toggle('on');
    $(this).toggleClass('on');
});
$(document).ready(function() {
    $('.bxslider_1').bxSlider({
        slideWidth: 1920,
        adaptiveHeight: true,
        mode: 'fade',
        pause: 4000,
        autoHover: true
    });
});