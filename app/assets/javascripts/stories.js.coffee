# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
@load_pages = (divID='#stories', messageReplace='در حال دریافت...') ->
  if $("#{divID}").next('.pagination').length
    $(window).scroll ->
      url = $('.pagination a[rel="next"]').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 2500
        $('.pagination').text("#{messageReplace}")
        $.getScript(url)
    $(window).scroll()

@StoryPoller =
  poll: ->
    setTimeout @request, 60000

  request: ->
    $.get($("#stories").data('url'), after: $('.story').first().data('timestamp'))

  addStories: (stories) ->
    if stories.length > 0
      $("#stories").prepend($(stories).hide())
      $("#show_stories").show()
    @poll()

  showStories: (e) ->
    e.preventDefault()
    $('.story').show()
    $('#stories hr').show()
    $('#show_stories').hide()

@popitup = (url) ->
  newwindow = window.open(url,'name','height=600,width=600')
  if window.focus
    newwindow.focus()
  return false

jQuery ->
  # to prevent send multiple times
  $(document).on('click', '.story_operation a', (e) ->
    $(this).remove();
  )

  $('ul.social-icons').on('click', '.popup', (e) ->
    popitup $(this).attr('href')
  )

  current_url = document.URL;
  regxp = /^http:\/\/[^\/]*(\/stories|\/)$/;

  #load recent stories just added recently
  if (($("#stories").length > 0) && (regxp.test(current_url)))
    StoryPoller.poll()
    $("#show_stories a").click StoryPoller.showStories

  #loads more stories when scroll to the end of the page
  load_pages("#stories", "در حال دریافت خبرهای بیشتر...")


  #toggle voters div to show/hide list of voters
  $(document).on('click', 'a.toggle-voters', (e) ->
    e.preventDefault()
    $(this).parent().parent().parent().next("div.row").slideToggle()
  )

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

  # Character counter for story form
  $("textarea[data-maxlength]").each( ->
      thiz = $(@)
      maxLength = parseInt(thiz.attr("data-maxlength"))
      $('label[for=story_content]').append('<br /><p class="counterSpan label label-success">' + maxLength + '</p>')
      counterSpan = $('p.counterSpan')

      thiz.on('keyup', ->
          currentCount = maxLength - thiz.val().length
          counterSpan.text(Math.abs currentCount)

          if currentCount < 0
            counterSpan.removeClass('label-success')
            counterSpan.addClass('label-important')
          else
            counterSpan.removeClass('label-important')
            counterSpan.addClass('label-success')
      )
    )
