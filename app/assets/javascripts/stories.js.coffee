# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination a[rel="next"]').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').text("در حال دریافت خبرهای بیشتر...")
        $.getScript(url)
    $(window).scroll()

  $('.btn-thumbs-up').on('click', ->
    id = $(this).data('id')
    $('.thumbs-down-list#' + id).hide()
    $('.thumbs-up-list#' + id).fadeToggle())

  $('.btn-thumbs-down').on('click', ->
    id = $(this).data('id')
    $('.thumbs-up-list#' + id).hide()
    $('.thumbs-down-list#' + id).fadeToggle())

  $('#story_content').popover()
