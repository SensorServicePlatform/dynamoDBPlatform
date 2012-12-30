// Helper prototype functions
jQuery.fn.convert_lower_snake_case = function() {
  var o = $(this[0]).val() // It's your element
  o = o .toLowerCase()
    .replace(/[^\w ]+/g,'')
    .replace(/ +/g,'_') ;
  return o
}
