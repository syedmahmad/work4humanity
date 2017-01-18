$("document").ready(function(){
  if ( $("select.init_select2").length > 0) {
    $('select.init_select2').select2({
     theme: "bootstrap",
     val: "sunday"
    });
  }

  $('.add_more_button').on('click', function(){
    var url = $(this).find('a').data('url')
    $.post(url, function(data) {
      $('#availability_fields_div').append(data);
    });
  })
})
