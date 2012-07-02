class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.where(:email => params[:email]).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: t('controllers.sessions.create.flash.success')
    else
      redirect_to new_session_path
      flash[:error] = t('controllers.sessions.create.flash.error')
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => t('controllers.sessions.destroy.flash.success')
  end
end
