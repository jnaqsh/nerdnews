class RatingsController < ApplicationController
  def index
    @ratings = Rating.order(:created_at).page params[:page]
    respond_to do |format|
      format.html
    end
  end

  def new
    @rating = Rating.new
  end

  def create
    @rating = Rating.new(params[:rating])

    respond_to do |format|
      if @rating.save
        format.html { redirect_to ratings_path, notice: t('controllers.ratings.create.flash.success') }
      end
    end
  end

  def edit
    @rating = Rating.find(params[:id])
  end

  def update
    @rating = Rating.find(params[:id])
    respond_to do |format|
      if @rating.update_attributes(params[:rating])
        format.html { redirect_to ratings_path, notice: t('controllers.ratings.update.flash.success') }
      end
    end
  end
end
