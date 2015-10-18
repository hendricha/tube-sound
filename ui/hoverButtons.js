$('.hover.buttons').transition('hide');
$('.selection.list .item').on('mouseover', function() {
  $(this).find('.hover.buttons').transition('fade');
});
$('.selection.list .item').on('mouseleave', function() {
  $(this).find('.hover.buttons').transition('fade');
});
