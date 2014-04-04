# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('#pathContenidoVideo').hide()
  $('#pathContenido').hide()
  $('#advertising_tipoContenidoYoutube').change ->
    if $('#advertising_tipoContenidoYoutube').is(':checked') && !$('#advertising_tipoContenidoVideo').is(':checked')
      $('#advertising_tipoContenidoVideo').attr("disabled", true);
      $('#pathContenido').slideDown()
    else
      $('#advertising_tipoContenidoVideo').removeAttr("disabled");
      $('#pathContenido').hide("slow")
  $('#advertising_tipoContenidoVideo').change ->
    if $('#advertising_tipoContenidoVideo').is(':checked') && !$('#advertising_tipoContenido').is(':checked')
      $('#advertising_tipoContenidoYoutube').attr("disabled", true);
      $('#pathContenidoVideo').slideDown()
    else
      $('#pathContenidoVideo').hide("slow")
      $('#advertising_tipoContenidoYoutube').removeAttr("disabled");