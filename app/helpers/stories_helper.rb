module StoriesHelper
  def turnoff_voting_button?(story)
    if cookies[:votes].present?
      cookie_array = YAML.load cookies[:votes]
      cookie_array.include? story.id
    end
  end
end
