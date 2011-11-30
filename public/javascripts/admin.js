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
  /*
   * Admin menu_items functionality
   */

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

  $('#menu-save-button')
    .hover(
      function() { $(this).addClass('ui-state-hover'); },
      function() { $(this).removeClass('ui-state-hover'); }
    ).mousedown(function() {
      $(this).addClass('ui-state-active');
    }).mouseup(function() {
      $(this).removeClass('ui-state-active');
    }).click(function(event) {
      event.preventDefault();
      var items = $('ol.menu-items > li').map(function(idx, item) {
        var tag = $('> .menu-item input', item);
        return {
          id : $('> .menu-item', item).attr('data-id'),
          enabled : $(tag).is(':checked') ? "1" : "0",
          name_slug : $(tag).attr('id'),
          children : $('> .menu-item > ol > li', item).map(function(idx, subitem) {
            var subtag = $('> .menu-item input', subitem);
            return {
              id : $('> .menu-item', subitem).attr('data-id'),
              enabled : $(subtag).is(':checked') ? "1" : "0",
              name_slug : $(subtag).attr('id'),
              parent_id : $(item).attr('id')
            };
          }).get()
        };
      }).get();
      $.post("/admin/menu_items/save.json", {items: items}, function(data) {
        if (typeof(data.success) !== 'undefined') {
          alert(data.success);
        } else {
          alert('There was a problem saving your page');
        }
      }, "json");
    });

  }, 1000);
  

})(jQuery);

