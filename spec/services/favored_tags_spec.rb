describe FavoredTags do
  let (:user) { FactoryGirl.create(:user, favorite_tags: 'nerd') }

  before do
    @favorite_tags = FavoredTags.new(user)
  end

  it 'returns true if tag is favorited' do
    @favorite_tags.include?('nerd').should be_true
    @favorite_tags.include?('news').should be_false
  end

  it 'updates the favorite tags' do
    # should add "news" to favorite tags
    @favorite_tags.save!('news')
    user.reload.favorite_tags.should match(/news/)
    # should remove "news" to favorite tags
    @favorite_tags.save!('news')
    user.reload.favorite_tags.should_not match(/news/)
  end
end