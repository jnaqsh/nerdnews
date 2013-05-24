class FavoredTags
  def initialize(user)
    @user = user
  end

  def to_a
    @user.favorite_tags.split(',') unless @user.favorite_tags.blank?
  end

  def include?(tag)
    to_a.include? tag unless to_a.blank?
  end

  # appends tag to the favorite tags
  def save!(tag)
    if include? tag
      chached_favorite_tags_array = to_a
      chached_favorite_tags_array.delete tag
      @user.update_attributes(favorite_tags: chached_favorite_tags_array.join(","))
    else
      @user.update_attributes(favorite_tags: @user.favorite_tags.to_s + (@user.favorite_tags.blank? ? tag : ",#{tag}"))
    end
  end
  
end