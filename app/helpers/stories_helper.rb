module StoriesHelper
  def turnoff_voting_button?(story)
    if cookies[:votes].present?
      cookie_array = YAML.load cookies[:votes]
      cookie_array.include? story.id
    else current_user
      story.user_voted?(current_user) or !story.approved?
    end
  end
end
