class TagsController < ApplicationController
  authorize_resource
  def index
    @tags = Tag.order('created_at desc').page params[:page]

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

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to tags_path, notice: t('controllers.tags.update.flash.success') }
      else
        format.html { render action: 'edit' }
      end
    end
  end
end
