(function() {
  $.timeago.settings.strings.suffixAgo = '';
  $('abbr.timeago').timeago();
  setTimeout(function() {
    $('abbr.timeago').timeago();
  }, 500);
})(jQuery);
