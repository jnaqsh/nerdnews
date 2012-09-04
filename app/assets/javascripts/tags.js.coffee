# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#story_tag_names").tokenInput '/tags.json'
    theme: 'facebook'
    prePopulate: $("#story_tag_names").data('load')
    hintText: "کلمه مورد نظر را جستجو کنید"
    noResultsText: "یافت نشد"
    searchingText: "در حال جستجو..."
    
  tags = $('#tags').data('tags')
  $("#tags").jQCloud(tags)