class TagsController < ApplicationController
  load_and_authorize_resource

  def index
    @tags = Tag.search do
      fulltext params[:tag_search]
      order_by :created_at, :desc
      paginate :page => params[:page], :per_page => 100
    end.results

    respond_to do |format|
      format.html
      format.json {render json: @tags}
      format.js
    end
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_path, notice: t('controllers.tags.create.flash.success') }
      else
        format.html { render action: "new" }
      end
    end
  end

  def destroy
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to tags_path }
    end
  end

  def destroy_multiple
    Tag.destroy params[:tags] unless params[:tags].nil?

    respond_to do |format|
      format.html { redirect_to tags_path, notice: t('controllers.tags.destroy_multiple.flash.success') }
    end
  end

  def edit
  end

  def update

    respond_to do |format|
      if @tag.update_attributes(tag_params)
        format.html { redirect_to tags_path, notice: t('controllers.tags.update.flash.success') }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  private

    def tag_params
      params.require(:tag).permit(:name, :thumbnail, :tags)
    end
end
