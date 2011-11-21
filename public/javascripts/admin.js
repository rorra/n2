// Place your application-specific jQuery JavaScript functions and classes here

$(document).ajaxSend(function(e, xhr, options) {
  var token = $("meta[name='csrf-token']").attr("content");
  xhr.setRequestHeader("X-CSRF-Token", token);
});

function rebuild_facebook_dom() {
  try {
    FB.XFBML.Host.parseDomTree();
  } catch(error) { }
}

// From: http://yehudakatz.com/2009/04/20/evented-programming-with-jquery/
var $$ = function(param) {
  var node = $(param)[0];
  var id = $.data(node);
  $.cache[id] = $.cache[id] || {};
  $.cache[id].node = node;

  return $.cache[id];
};

var $$$ = function(key) {
	$.cache[key] = $.cache[key] || {};

	return $.cache[key];
};

$(function() {
  setTimeout(function() {
		$('.flash').effect('fade', {}, 1000);

  }, 3500);
});

(function($) {
  setTimeout(function() {
    $('ol.menu-items').nestedSortable({
      disableNesting: 'no-nest',
      forcePlaceholderSize: true,
      handle: 'div.menu-item',
      helper:	'clone',
      items: 'li',
      maxLevels: 2,
      opacity: .6,
      placeholder: 'placeholder',
      revert: 250,
      tabSize: 25,
      tolerance: 'pointer',
      toleranceElement: '> div'
    });
		$('#toArray').click(function(e){
                  console.log("Dumping data");
			arraied = $('ol.menu-items').nestedSortable('toArray', {startDepthCount: 0});
                  console.log(arraied);
			//arraied = dump(arraied);
			//(typeof($('#toArrayOutput')[0].textContent) != 'undefined') ?
			//$('#toArrayOutput')[0].textContent = arraied : $('#toArrayOutput')[0].innerText = arraied;
		});
  }, 1000);
  


})(jQuery);

