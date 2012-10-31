# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
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

  $("#user_search").on("change", (e)->
    $('.form-search').submit()
    )