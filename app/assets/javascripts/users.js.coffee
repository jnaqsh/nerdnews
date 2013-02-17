# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  # used in users/index
  $("#user_search").select2({
    minimumInputLength: 1
    ajax:
      url: "/users.json"
      dataType: 'json'
      data: (term, page)->
          user_search: term
          page: 1

      results: (user, page)->
        results: user

    formatResult: (user) ->
      user.full_name

    formatSelection: (user) ->
      user.full_name

    dropdownCssClass: "bigdrop"

    # Translations
    formatNoMatches: (term)->
      'موردی پیدا نشد'
    formatSearching: ->
      'درحال جستجو'
    formatInputTooShort: (term, minLength)->
      minLength + " حرف دیگر وارد کنید"
  })

  # submit the search after selected in users/index
  $("#user_search").on("change", (e)->
    $('.form-search').submit()
    )

  # Used in users/_form
  $("#user_favorite_tags").select2({
    tags: ''
    tokenSeparators: [",", "،"]
    dropdownCssClass: "bigdrop"
    })

  if history && history.pushState
    # for push current state of ajax links
    $("#posts_li,#messages,#favorites_li,#comments_li, #activity_logs_li, #send_message").on('ajax:success', (evt, data, status, xhr)->
      history.pushState(null, document.title, this.href)
    )

    # Back button now working with popstate in ajax links
#    $(window).bind("popstate", ->
#      $.getScript(location.href)
#    )
