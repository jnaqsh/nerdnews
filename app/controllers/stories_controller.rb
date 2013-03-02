# encoding: utf-8

class StoriesController < ApplicationController
  load_and_authorize_resource
  # GET /stories
  # GET /stories.json

  def recent
    @stories = Story.approved.includes(:tags).where('id > ? and hide = ?', params[:after].to_i, false).order("publish_date desc")

    respond_to do |format|
      format.js
    end
  end

  def index
    @stories = Story.search(:include => [:tags]) do
      without(:publish_date, nil)
      without(:hide, true)
      fulltext params[:search]
      fulltext params[:tag]
      order_by :publish_date, :desc
      paginate :page => params[:page], :per_page => 20
    end.results

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
    @story = Story.includes(:tags).find(params[:id])

    if @story and @story.published?
      @story.increment!(:view_counter)
      @comment = @story.comments.build
      @comments = @story.comments.approved.arrange(order: :created_at)

      story_path = Rails.env.production? ? story_path(@story).downcase : story_path(@story) #monkey patch due to error in production (downcase)

      if request.path != story_path
        redirect_to @story, status: :moved_permanently, only_path: true
        return
      end
    else
      raise ActiveRecord::RecordNotFound, t("controllers.stories.show.story_not_found")
    end

    respond_to do |format|
      format.html
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
    @story = Story.includes(:tags).find(params[:id])
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

    respond_to do |format|
      if params[:preview_button]
        format.html { render action: "new" }
      else
        if @story.save
          if can? :publish, @story
            @story.mark_as_published(current_user, story_url(@story))
            rate_user 3 if current_user.present?
            record_activity "خبر شماره #{@story.id.to_farsi} را ایجاد و منتشر کردید",
              story_path(@story) #This will call application controller  record_activity
          else
            record_activity "خبر شماره #{@story.id.to_farsi} را ایجاد کردید" #This will call application controller  record_activity
          end

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
    @story = Story.includes(:tags).find(params[:id])
    @story.attributes = params[:story]

    respond_to do |format|
      if params[:preview_button]
        format.html { render action: "edit" }
      else
        if @story.update_attributes(params[:story])
          record_activity "خبر شماره #{@story.id.to_farsi} را به‌روز کردید",
              story_path(@story) #This will call application controller  record_activity

          if @story.published?
            format.html { redirect_to @story, notice: t('controllers.stories.update.flash.success') }
          else
            format.html { redirect_to unpublished_stories_path, notice: t('controllers.stories.update.flash.success') }
          end

          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @story.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    @story.update_attributes({remover: current_user}, without_protection: true)

    record_activity "خبر شماره #{@story.id.to_farsi} را حذف کردید"

    respond_to do |format|
      format.html { redirect_to stories_url }
      format.json { head :no_content }
    end
  end

  # PUT /stories/1/publish
  def publish
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.mark_as_published(current_user, story_url(@story))

        rate_user(@story.user, 3) if @story.user #rate for user who wrote a story
        rate_user(1) if current_user #rate for user who publish a story
        record_activity "خبر شماره #{@story.id.to_farsi} را منتشر کردید",
          story_path(@story) #This will call application controller  record_activity

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
