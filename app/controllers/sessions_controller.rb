class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.where(:email => params[:email]).first
    if user && user.authenticate(params[:password])
      cookies.permanent.signed[:permanent_user_id] = user.id
      redirect_to root_path, notice: t('controllers.sessions.create.flash.success')
    else
      redirect_to new_session_path
      flash[:error] = t('controllers.sessions.create.flash.error')
    end
  end

  def destroy
    cookies.delete(:permanent_user_id)
    if session[:service_id]
      session[:service_id] = nil
    end
    redirect_to root_path, :notice => t('controllers.sessions.destroy.flash.success')
  end
end
