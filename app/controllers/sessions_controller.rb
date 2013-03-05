#encoding: utf-8

class SessionsController < ApplicationController
  authorize_resource :class => false
  def new
    @providers = Identity.providers
  end

  def create
    user = User.where(:email => params[:email]).first
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent.signed[:user_id] = user.id
      else
        cookies.signed[:user_id] = user.id
      end
      record_activity "وارد نردنیوز شد"

      redirect_to root_path, notice: t('controllers.sessions.create.flash.success')
    else
      redirect_to new_session_path
      flash[:error] = t('controllers.sessions.create.flash.error')
    end
  end

  def destroy
    record_activity "از نردنیوز خارج شد"
    cookies.delete(:user_id)
    session[:authhash] = nil
    session[:service_id] = nil
    redirect_to root_path, :notice => t('controllers.sessions.destroy.flash.success')
  end
end
