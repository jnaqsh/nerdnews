class SessionsController < ApplicationController
  authorize_resource :class => false
  def new
  end

  def create
    user = User.where(:email => params[:email]).first
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent.signed[:user_id] = user.id
      else
        cookies.signed[:user_id] = user.id
      end
      redirect_to root_path, notice: t('controllers.sessions.create.flash.success')
    else
      redirect_to new_session_path
      flash[:error] = t('controllers.sessions.create.flash.error')
    end
  end

  def destroy
    cookies.delete(:user_id)
    if session[:service_id]
      session[:service_id] = nil
    end
    redirect_to root_path, :notice => t('controllers.sessions.destroy.flash.success')
  end
end
