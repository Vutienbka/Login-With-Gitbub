$(function() {

  if (window.matchMedia( '(min-width: 993px)' ).matches) {
    $(function(){
      $('.js-click-a').click(function() {
        if($('.js-center').hasClass('center')) {
          $('.js-center').removeClass('center').addClass('hover');
        } else {
          $('.js-center').addClass('center').removeClass('hover');
        }
      });
    });
  } else {
    $('.js-center').addClass('center');
    $('.js-click-a').click(function() {
      if($('.js-center').hasClass('center')) {
        $('.js-center').removeClass('center').addClass('hover');
      } else {
        $('.js-center').addClass('center').removeClass('hover');
      }
    });
  };

  $(window).resize(function() {
  //リサイズされたときの処理
    if (window.matchMedia( '(max-width: 993px)' ).matches) {
      $(function() {
        $('.js-center').addClass('center').removeClass('hover');
      });
    };
  });

  $('.main-sidebar').hover(
    function() {
      if($('.js-center').hasClass('hover')) {
        $('.js-center').addClass('center');
      } else {
        return false;
      }
    },
    function() {
      if($('.js-center').hasClass('hover')) {
        $('.js-center').removeClass('center');
      } else {
        return false;
      }
    }
  );
});
