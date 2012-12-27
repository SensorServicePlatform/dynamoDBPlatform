// Helper prototype functions
jQuery.fn.convert_lower_snake_case = function() {
  var o = $(this[0]).val() // It's your element
  o = o .toLowerCase()
    .replace(/[^\w ]+/g,'')
    .replace(/ +/g,'_') ;
  return o
}


jQuery(document).ready(function($) {

  // strip description to make a friendly key
  $("#device_type_device_type_desc").on('keyup', function(event) {
    $("#device_type_device_type_key").val($(this).convert_lower_snake_case())
  });

});