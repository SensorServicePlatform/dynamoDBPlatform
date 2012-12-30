// Js for CRUD pages (Sensor, Device, Sensor Type, Device Type etc.)
jQuery(document).ready(function($) {
  // strip description to make a friendly key
  $("#device_type_device_type_desc").on('keyup', function(event) {
    $("#device_type_device_type_key").val($(this).convert_lower_snake_case())
  });
  $("#sensor_type_property_type_desc").on('keyup', function(event) {
    $("#sensor_type_property_type_key").val($(this).convert_lower_snake_case())
  });
});