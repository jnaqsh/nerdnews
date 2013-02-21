module StoriesHelper
  def turnoff_voting_button?(story)
    if cookies[:votes].present?
      cookie_array = YAML.load cookies[:votes]
      cookie_array.include? story.id
    else current_user
      story.user_voted?(current_user) or !story.approved?
    end
  end

  def thumbnail_url(story)
    unless story.tags.first.nil?
#      "#{root_url.gsub(/\/$/, '') + story.tags.first.thumbnail.url}"
      story.tags.first.thumbnail.url #using dropbox in production
    end
  end

  def hide_story?(story)
    if story.total_point < Story::HIDE_THRESHOLD
      if current_page?(controller: "stories", action: "index") or
        current_page?(controller: "mypage", action: "index") or
        current_page?("/stories")
          return true
      end
    end
    return false
  end
end
