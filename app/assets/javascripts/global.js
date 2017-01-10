$("document").ready(function(){
  if ( $("select.init_select2").length > 0) {
    $('select.init_select2').select2({
     theme: "bootstrap",
     val: "sunday"
    });
  }
})
