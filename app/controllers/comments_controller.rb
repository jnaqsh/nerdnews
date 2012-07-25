class CommentsController < ApplicationController
  load_and_authorize_resource
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @story = Story.find(params[:story_id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @story = Story.find(params[:story_id])
    @comment = @story.comments.build(params[:comment])
    @comments = @story.comments.all

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @story, notice: t('controllers.comments.create.flash.success') }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render template: "stories/show" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    @story = Story.find(params[:story_id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @story,
          notice: t('controllers.comments.update.flash.success') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to story_path(@comment.story) }
      format.json { head :no_content }
    end
  end
end
