describe PasswordReset do
  let(:user) { FactoryGirl.create(:user) }

  before do
    @password_reset = PasswordReset.new(user)
  end

  it "generates a unique password_reset_token each time" do
    @password_reset.send_password_reset
    last_token = user.password_reset_token
    @password_reset.send_password_reset
    user.password_reset_token.should_not eq(last_token)
  end

  it "saves the time the password reset was sent" do
    @password_reset.send_password_reset
    user.reload.password_reset_sent_at.should be_present
  end

  it "delivers email to user" do
    @password_reset.send_password_reset
    last_email.to.should include(user.email)
  end
end