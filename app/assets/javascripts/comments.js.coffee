# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  toggleInfo = (divID='#commenter-info')->
    $("#{divID}").slideDown()
    # $("#{divID}").slideToggle()

  # Hide 'info' in first page load. If we hide it with CSS
  # it won't be available for users who doesn't have enabled JS
  # toggleInfo()
  $("#commenter-info").slideUp()

  $('#comment_content').on(
    focus: (e)->
      toggleInfo()
    )
    # blur: (e) ->
    #   toggleInfo()
