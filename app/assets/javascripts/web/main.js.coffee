ready = ->
  $('.ui.dropdown').dropdown()
  $('.ui.checkbox').checkbox()

$(document).on 'turbolinks:load', ready
$(document).on 'ready', ready
