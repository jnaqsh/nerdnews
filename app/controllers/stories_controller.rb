# encoding: UTF-8
class StoriesController < ApplicationController
  load_and_authorize_resource
  # GET /stories
  # GET /stories.json
  def index
    @search = Story.search do
      without(:publish_date, nil)
      fulltext params[:search]
      order_by :publish_date, :desc
      paginate :page => params[:page], :per_page => 5
    end

    if params[:tag]
      @stories = Tag.find_by_name(params[:tag]).stories.order("publish_date desc").page params[:page]
    else
      @stories = @search.results
    end

    respond_to do |format|
      format.html # index.html.erb
      format.atom
      format.json { render json: @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    @story = Story.find(params[:id])
    @comment = @story.comments.build
    @comments = @story.comments.arrange(order: :created_at)

    @story.increment!(:view_counter)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/new
  # GET /stories/new.json
  def new
    @story = Story.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
  end

  # POST /stories
  # POST /stories.json
  def create
    if current_user
      @user = current_user
      @story = @user.stories.build(params[:story])
    else
      @story = Story.new(params[:story])
    end

    respond_to do |format|
      if params[:preview_button]
        format.html { render action: "new" }
      else
        if @story.save
          format.html { redirect_to @story, only_path: true, notice: t('controllers.stories.create.flash.success') }
          format.json { render json: @story, status: :created, location: @story }
        else
          format.html { render action: "new" }
          format.json { render json: @story.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /stories/1
  # PUT /stories/1.json
  def update
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { redirect_to @story, notice: t('controllers.stories.update.flash.success') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to stories_url }
      format.json { head :no_content }
    end
  end

  # PUT /stories/1/publish
  def publish
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.mark_as_published
        format.html { redirect_to unpublished_stories_path,
          notice: t('controllers.stories.publish.flash.success') }
      end
    end
  end

  # GET /stories/list
  def unpublished
    @stories = Story.not_approved.order("created_at DESC").page params[:page]

    respond_to do |format|
      format.html
    end
  end
end
