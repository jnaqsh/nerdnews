# encoding: utf-8

class CommentsController < ApplicationController
  load_and_authorize_resource

  # GET /comments
  def index
    @comments = Comment.includes(:story).order("created_at DESC").page params[:page]

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /stories/1/comments/1
  # GET /stories/1/comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /stories/1/comments/new
  # GET /stories/1/comments/new.json
  def new
    @comment = Comment.new(parent_id: params[:parent_id])
    @story = Story.find(params[:story_id])

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  # GET /stories/1/comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @story = Story.find(params[:story_id])
  end

  # POST /stories/1/comments
  # POST /stories/1/comments.json
  def create
    @story = Story.find(params[:story_id])
    @comment = @story.comments.build(params[:comment])
    @comment.user = current_user ? current_user : nil
    @comment.parent_id = params[:comment][:parent_id].empty? ? nil : Comment.find(params[:comment][:parent_id])
    @comment.add_user_requests_data = request
    @comments = @story.comments.arrange(order: :created_at)

    respond_to do |format|
      if @comment.save

        record_activity %Q(دیدگاهی جدید برای خبر #{view_context.link_to @story.title.truncate(40), story_path(@story, :anchor => "comment_#{@comment.id}")} ایجاد کرد)

        UserMailer.delay.comment_reply(@comment.id) unless @comment.parent.nil?
        rate_user(current_user, 1) if current_user.present?
        format.html { redirect_to @story, notice: t('controllers.comments.create.flash.success') }
      else
        format.html { render template: "stories/show" }
      end
    end
  end

  # PUT /stories/1/comments/1
  # PUT /stories/1/comments/1.json
  def update
    @comment = Comment.find(params[:id])
    @story = Story.find(params[:story_id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        record_activity %Q(دیدگاه در خبر #{view_context.link_to @story.title.truncate(40), story_path(@story, :anchor => "comment_#{@comment.id}")} را ویرایش کرد)

        format.html { redirect_to story_path(@comment.story),
          notice: t('controllers.comments.update.flash.success') }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /stories/1/comments/1
  # DELETE /stories/1/comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    record_activity %Q(دیدگاه در خبر #{view_context.link_to @story.title.truncate(40), story_path(@story, :anchor => "comment_#{@comment.id}")} را حذف کرد)

    respond_to do |format|
      format.html { redirect_to story_path(@comment.story) }
    end
  end

  # PUT /stories/1/comments/1/mark_as_spam
  def mark_as_spam
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.mark_as_spam and @comment.save
        format.html { redirect_to comments_path, notice: t('controllers.comments.mark_as_spam.flash.success') }
      end
    end
  end

  # PUT /stories/1/comments/1/unmark_as_spam
  def mark_as_not_spam
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.mark_as_not_spam and @comment.save
        format.html { redirect_to comments_path, notice: t('controllers.comments.mark_as_not_spam.flash.success') }
      end
    end
  end
end
