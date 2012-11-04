class UsersController < ApplicationController
  load_and_authorize_resource
  # GET /users
  # GET /users.json
  def index
    @search = User.search do
      fulltext params[:user_search] do
        boost_fields :id => 2.0
      end
      paginate :page => params[:page], :per_page => 10
      order_by :created_at, :desc
    end

    @users = @search.results

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users, only: [:id, :full_name] }
      format.js
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @stories = @user.stories.approved.order('created_at desc').page params[:page], per_page: 30

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: t('controllers.users.create.flash.success') }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: t('controllers.users.update.flash.success') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # GET /users/1/posts
  # GET /users/1/posts.json
  def posts
    @user = User.find(params[:id])
    @stories = @user.stories.approved.order('created_at desc').page params[:page], per_page: 30

    respond_to do |format|
      format.html # posts.html.erb
      format.json { render json: @stories }
      format.js
    end
  end

  # GET /users/1/comments
  # GET /users/1/comments.json
  def comments
    @user = User.find(params[:id])
    @comments = @user.comments.order('created_at desc').page params[:page], per_page: 30

    respond_to do |format|
      format.html # comments.html.erb
      format.json { render json: @comments }
      format.js
    end
  end

  # GET /users/1/favorites
  # GET /users/1/favorites.json
  def favorites
    @user = User.find(params[:id])
    @favorites = @user.votes.order('created_at desc').page params[:page], per_page: 30

    respond_to do |format|
      format.html # favorites.html.erb
      format.json { render json: @favorites }
      format.js
    end
  end
end
