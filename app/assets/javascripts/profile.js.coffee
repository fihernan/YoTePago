# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if($(location).attr('pathname').indexOf("profile") >= 0)
    $('#user_sexo_m').attr("disabled", true);
    $('#user_sexo_f').attr("disabled", true);
    $('#user_fechaNacimiento_3i').attr("disabled", true);
    $('#user_fechaNacimiento_2i').attr("disabled", true);
    $('#user_fechaNacimiento_1i').attr("disabled", true);
    $('#Pais_idpais').attr("disabled", true);
    $('#Ciudad_idciudad').attr("disabled", true);
    $('#Comuna_idcomuna').attr("disabled", true);
    $('#Educacion_idEducacion').attr("disabled", true);
    $('#Ocupacion_idOcupacion').attr("disabled", true);