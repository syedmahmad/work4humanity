$(function() {
  $("#phone").intlTelInput({
    initialCountry: 'pk',
    formatOnInit: true,
    separateDialCode: true
  });

  $("#check_phone, #submit_check_phone").click(function(e) {
      e.preventDefault();
      if($("#phone").intlTelInput("isValidNumber")) {
        var dialCode = $("#phone").intlTelInput("getSelectedCountryData").dialCode
        $('#phone').val(dialCode + $('#phone').val());
        $(this).closest('form').submit();
      } else {
        $('.content-wrapper').prepend( "<p class='alert alert-danger'>Please enter valid phone.</p>" )
        $(".alert").slideDown(500, function(){setTimeout(function(){$(".alert").slideUp(500, function(){$(".js-flash-notification-div").remove()});},3000);});
      }
    });
});
