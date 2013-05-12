# encoding: utf-8
module StoryMacros
  def create_story(user=nil)
    login user if user
    visit root_path
    find('.page-header').click_link "جدید"
    fill_in "story_title", with: Faker::Lorem.characters(10)
    fill_in "story_content", with: Faker::Lorem.characters(260)
    fill_in "story_spam_answer", with: "four" unless user || (user.role? "new_user")
    click_button "ایجاد"
  end
end
