class PasswordReset
  def initialize(user)
    @user = user
  end
  
  # password_reset
  def send_password_reset
    generate_token(:password_reset_token)
    @user.password_reset_sent_at = Time.zone.now
    @user.save!
    UserMailer.password_reset(@user.id).deliver
  end

  # password_reset
  def signup_confirmation
    generate_token(:password_reset_token)
    @user.password_reset_sent_at = Time.zone.now
    @user.save!
    UserMailer.signup_confirmation(@user.id).deliver
  end

private

  def generate_token(column)
    begin
      @user[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => @user[column])
  end

end