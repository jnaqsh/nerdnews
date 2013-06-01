class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    password_reset = PasswordReset.new(user)
    password_reset.delay.send_password_reset if user
    redirect_to root_url, notice: t('controllers.password_resets.create.flash.success')
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])

    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, alert: t('controllers.password_resets.update.flash.fail')
    elsif @user.update_attributes(params[:user])
      cookies.permanent.signed[:user_id] = @user.id
      redirect_to root_url, notice: t('controllers.password_resets.update.flash.success')
    else
      render :edit
    end
  end
end
