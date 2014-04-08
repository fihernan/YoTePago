# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if ($('#video').length > 0)
    jwplayer.key="3raTwUxFEiZ0vqcEKmFZwDFCuKSGFBKEQHnUlg==";
    jwplayer("video").setup({file: $('#video_url ').text(),'width': '800','height': '600','autostart': 'true',});

