class TagsController < ApplicationController
  authorize_resource
  def index
    @search = Tag.search do
      fulltext params[:tag_search]
      order_by :created_at, :desc
      paginate :page => params[:page], :per_page => 10
    end

    @tags = @search.results

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
