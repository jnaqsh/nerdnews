# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('#stories').next('.pagination').length
    $(window).scroll ->
      url = $('.pagination a[rel="next"]').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').text("")
        $.getScript(url)
    $(window).scroll()

  # Show optins when clicking voting button
  votingOptions =
    init: ->
      $('.btn-thumbs-up').on('click', @show)
      $('.btn-thumbs-down').on('click', @show)

    show: ->
      button = $(@)
      thumbs_up_list = button.parent().nextAll('div.thumbs-up-list')
      thumbs_down_list = thumbs_up_list.siblings('div.thumbs-down-list')

      if button.is('.btn-thumbs-up')
        thumbs_down_list.hide() if thumbs_down_list.is(':visible')
        thumbs_up_list.fadeToggle()
      else
        thumbs_up_list.hide() if thumbs_up_list.is(':visible')
        thumbs_down_list.fadeToggle()

  # $('#story_content').popover()

  votingOptions.init()

  $(document)
    .ajaxStart( ->
      $("#loading-indicator").show()
    )
    .ajaxStop( ->
      $("#loading-indicator").hide()
    )
