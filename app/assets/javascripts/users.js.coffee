# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
    ciudad = $('#ciudad :selected').val()
    if ciudad == ''
      $('#ciudad').hide()
    comuna = $('#comuna :selected').val()
    if comuna == ''
      $('#comuna').hide()
    $('#pais').change ->
      pais = $('#pais :selected').val()
      $.ajax
        url: "/load_ciudades",
        type: "GET",
        dataType: "script",
        data: { id: pais }
    $('#ciudad').change ->
      ciudad = $('#ciudad :selected').val()
      $.ajax
        url: "/load_comunas",
        type: "GET",
        dataType: "script",
        data: { id: ciudad }