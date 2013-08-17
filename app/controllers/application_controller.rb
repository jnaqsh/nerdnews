class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def current_user
    @current_user = User.find_by_id!(cookies.signed[:user_id]) if cookies.signed[:user_id]
  end
  helper_method :current_user

  private

  def bypass_captcha_or_not(object)
    object.skip_textcaptcha = (can? :bypass_captcha, current_user) ? true : false
  end

  def rate_user user=current_user, rate_weight
    user.increment! :user_rate, rate_weight
  end

  def record_activity(note)
    @activity = ActivityLog.new
    @activity.user = current_user
    @activity.note = note
    @activity.browser = request.env['HTTP_USER_AGENT']
    @activity.ip_address = request.env['REMOTE_ADDR']
    @activity.controller = controller_name
    @activity.action = action_name
    @activity.params = params.inspect
    @activity.save
  end

  def share_by_mail
    @share_by_mail = ShareByMail.new(current_user)
    @share_by_mail.textcaptcha
    bypass_captcha_or_not @share_by_mail
  end
end
