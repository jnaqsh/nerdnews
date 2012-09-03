class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_tags

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end
  helper_method :current_user

  private

  def load_tags
    tags = Tag.order('created_at desc').select("name, stories_percentage")
    @tags = []
    tags.each do |t|
      @tags << {text: "#{t.name}", weight: "#{t.stories_percentage}",
                link: "#{stories_path(tag: t.name)}"}
    end
  end
end
