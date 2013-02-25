# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

load_pages = (divID='#stories', messageReplace='در حال دریافت...') ->
  if $("#{divID}").next('.pagination').length
    $(window).scroll ->
      url = $('.pagination a[rel="next"]').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 2500
        $('.pagination').text("#{messageReplace}")
        $.getScript(url)
    $(window).scroll()
window.load_pages = load_pages

jQuery ->
  #loads more stories when scroll to the end of the page
  load_pages("#stories", "در حال دریافت خبرهای بیشتر...")

  # Show optins when clicking voting button
  votingOptions =
    init: ->
      $(document).on('click', '.btn-thumbs-up', @show)
      $(document).on('click', '.btn-thumbs-down', @show)

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

  votingOptions.init()

  # show/hide loading indicator
  $(document)
    .ajaxStart( ->
      $("#loading-indicator").show()
    )
    .ajaxStop( ->
      $("#loading-indicator").hide()
    )
