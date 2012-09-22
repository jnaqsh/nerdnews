class TagsController < ApplicationController
  authorize_resource
  def index
    @tags = Tag.order(:name)

    respond_to do |format|
      format.html
      format.json {render json: @tags.tokens(params[:q])}
    end
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_path, notice: t('controllers.tags.create.flash.success') }
      else
        format.html { render action: "new" }
      end
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to tags_path }
    end
  end
end
