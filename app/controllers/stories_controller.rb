# encoding: UTF-8
class StoriesController < ApplicationController
  load_and_authorize_resource
  # GET /stories
  # GET /stories.json
  def index
    @search = Story.search(:include => [:tags]) do
      without(:publish_date, nil)
      without(:hide, true)
      fulltext params[:search]
      order_by :publish_date, :desc
      paginate :page => params[:page], :per_page => 5
    end

    if params[:tag]
      @stories = Tag.find_by_name!(params[:tag]).stories.order("publish_date desc").page params[:page]
    else
      @stories = @search.results
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.atom
      format.json { render json: @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    @story = Story.approved.find(params[:id])
    @story.increment!(:view_counter)
    @comment = @story.comments.build
    @comments = @story.comments.arrange(order: :created_at)

    if request.path != story_path(@story)
      redirect_to @story, status: :moved_permanently, only_path: true
    end
  end

  # GET /stories/new
  # GET /stories/new.json
  def new
    @story = Story.new
    @story.textcaptcha

    bypass_captcha_or_not @story

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

    bypass_captcha_or_not @story

    @story.mark_as_published(current_user) if can? :publish, @story

    respond_to do |format|
      if params[:preview_button]
        format.html { render action: "new" }
      else
        if @story.save
          rate_user(1, "#{current_user.full_name} posted a story with id #{@story.id}") if current_user.present?
          format.html { redirect_to root_path, only_path: true, notice: t("#{successful_notice(@story)}") }
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
      if @story.mark_as_published(current_user)
        rate_user(@story.user, 3, "a story from #{@story.user.full_name} with id #{@story.id} got approved")
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

  private

  def successful_notice(story)
    unless story.published? #successful message for guest and new users
      "controllers.stories.create.flash.success_for_guest_and_new_users"
    else #successful message for approved and founder users
      "controllers.stories.create.flash.success"
    end
  end
end
