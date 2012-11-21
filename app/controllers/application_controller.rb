class ApplicationController < ActionController::Base
  protect_from_forgery
  # before_filter :load_tags

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

    # def load_tags
    #   tags = Tag.order('name asc').select("name, stories_count")
    #   maximum_font_size = 70
    #   minimum_font_size = 10
    #   minmum_tag_count = Tag.minimum(:stories_count)
    #   maximum_tag_count = Tag.maximum(:stories_count)
    #   @tags = []
    #   if minmum_tag_count != maximum_tag_count
    #     tags.each do |tag|
    #       count = tag.stories_count
    #       display_font = (((count - minmum_tag_count) * (maximum_font_size - minimum_font_size)) / (maximum_tag_count - minmum_tag_count)) + minimum_font_size
    #       @tags << {title: tag.name, font: display_font, count: count, url: stories_url(tag: tag.name)}
    #     end
    #   end

    def rate_user user=current_user, rate_weight, event
      user.increment! :user_rate, rate_weight
      RatingLog.create! user_id: user, event: event
    end
end
