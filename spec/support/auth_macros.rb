# encoding: utf-8
module AuthMacros
  def login(user = nil)
    user ||= FactoryGirl.create(:user)
    visit root_path
    click_link 'ورود'
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'ورود'
  end

  def logout
    click_link 'user-menu'
    click_link 'خروج'
  end

  # def set_user_session(user)
  #   session[:user_id] = user.id
  # end
end