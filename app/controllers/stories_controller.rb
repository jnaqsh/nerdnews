# encoding: utf-8

class StoriesController < ApplicationController
  load_and_authorize_resource
  # GET /stories
  # GET /stories.json

  def recent
    @stories = Story.approved.where('publish_date > ? and hide = ?', Time.at(params[:after].to_f), false).order("publish_date desc")

    respond_to do |format|
      format.js
    end
  end

  def index
    @stories = Story.search(:include => [:tags, :user, :publisher, {:votes => [:rating, :user]}]) do
      without(:publish_date, nil)
      without(:hide, true)
      fulltext params[:search]
      fulltext params[:tag]
      order_by :publish_date, :desc
      paginate :page => params[:page], :per_page => 5
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
    @story = Story.includes(:user, :votes => [:rating, :user]).find(params[:id])

    if @story
      @story.increment!(:view_counter)
      @comment = @story.comments.build
      @comments = @story.comments.approved.includes(:user, :story).arrange(order: :created_at)

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

    respond_to do |format|
      if params[:preview_button]
        format.html { render action: "new" }
      else
        if @story.save

          record_activity %Q(خبر
            #{view_context.link_to @story.title.truncate(40),
              story_path(@story)} را ایجاد کرد)

          format.html { redirect_to root_path, only_path: true,
            notice: t("controllers.stories.create.flash.success", link: unpublished_stories_path).html_safe }
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
    @story.attributes = params[:story]

    respond_to do |format|
      if params[:preview_button]
        format.html { render action: "edit" }
      else
        if @story.update_attributes(params[:story])

          record_activity %Q(خبر
            #{view_context.link_to @story.title.truncate(40),
              story_path(@story)} را ویرایش کرد)

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

    record_activity %Q(خبر
      #{view_context.link_to @story.title.truncate(40),
        story_path(@story)} را حذف کرد)

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

        record_activity %Q(خبر
          #{view_context.link_to @story.title.truncate(40),
            story_path(@story)} را منتشر کرد)

        format.html { redirect_to story_path(@story),
          notice: t('controllers.stories.publish.flash.success') }
      end
    end
  end

  # GET /stories/list
  def unpublished
    @stories = Story.not_approved.includes([:tags, :user, {:votes => [:rating, :user]}]).order("created_at DESC").page params[:page]

    respond_to do |format|
      format.html
    end
  end
end
