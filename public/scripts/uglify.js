$(document).ready(function(){
  $('#beautify').hide();
  $('#uglify').click(function(){
    $('table').toggleClass('table')
    $('table').toggleClass('table-hover')
    // $('table').toggleClass('table-bordered')
    $(this).hide()
    $('#beautify').show()
  });
  $('#beautify').click(function(){
    $('table').toggleClass('table')
    $('table').toggleClass('table-hover')
    // $('table').toggleClass('table-bordered')
    $(this).hide()
    $('#uglify').show()
    $('#standards').tablesorter()
  });
  // $('#standards').tablesorter();
});
