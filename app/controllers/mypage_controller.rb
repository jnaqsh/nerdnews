class MypageController < ApplicationController
  authorize_resource :class => false

  def index
    @stories = Story.search(:include => [:tags, :user, :publisher, {:votes => [:rating, :user]} ]) do
      fulltext params[:search]
      without(:hide, true)
      keywords("#{favorite_tags.join(' ')} #{current_user.email}") {minimum_match 1}
      order_by :created_at, :desc
      order_by :publish_date, :desc
      paginate :page => params[:page], :per_page => 20
    end.results

    respond_to do |format|
      if !@stories || @stories.empty?
        format.html { flash.now[:notice] = t('.controllers.mypage.flash.add_tags') }
      else
        format.html
      end
      format.js
    end
  end

  private

  def favorite_tags
    current_user.favorite_tags ? current_user.favored_tags.to_a : []
  end
end
