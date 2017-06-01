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

  $('.content-wrapper').on('click', function(){
    if(!$('#burger-menu-button').hasClass('collapsed')){
      $('#burger-menu-button').addClass('collapsed');
      $('#bs-example-navbar-collapse-1').removeClass('in');
    }
  });

  setTimeout(function() {
    $('.alert-msg').slideUp();
  }, 3000);

  // $('#availability-div').datepicker({
  //     inline: true,
  //     format: 'dd/mm/yyyy',
  //     startDate: 'd',
  //     multidate: true,
  //     update: "02-16-2017"
  //   }).on("change",function(){
  //     var selected = $(this).val();
  //     alert(selected);
  //   });
  // var $j = jQuery.noConflict();

    $('#availability-div').datespicker();
  // $('#availability-div').datepicker('update', "02-16-2017");

})
