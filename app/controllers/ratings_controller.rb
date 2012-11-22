class RatingsController < ApplicationController
  load_and_authorize_resource
  def index
    @ratings = Rating.order('weight DESC').page params[:page]
    respond_to do |format|
      format.html
    end
  end

  def new
  end

  def create
    respond_to do |format|
      if @rating.save
        format.html { redirect_to ratings_path, notice: t('controllers.ratings.create.flash.success') }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @rating.update_attributes(params[:rating])
        format.html { redirect_to ratings_path, notice: t('controllers.ratings.update.flash.success') }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @rating.destroy
        format.html { redirect_to ratings_path, notice: t('controllers.ratings.destroy.flash.success') }
      end
    end
  end
end
