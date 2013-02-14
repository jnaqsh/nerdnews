# encoding: utf-8

class UsersController < ApplicationController
  load_and_authorize_resource
  layout 'user_profile', only: [:show, :posts, :comments, :favorites, :activity_logs]

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
      format.json { render json: @users, except: [:password_digest] }
      format.js
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @stories = @user.stories.approved.order('created_at desc').page params[:page], per_page: 30

    if request.path != user_path(@user).downcase  #monkey patch due to error in production (downcase)
      redirect_to @user, status: :moved_permanently
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user, except: [:password_digest] }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @providers = Identity.providers
    if session[:authhash].present?
      @user.full_name = session[:authhash][:name] if session[:authhash][:name]
      @user.email = session[:authhash][:email] if session[:authhash][:email]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user, except: [:password_digest] }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    if params[:cancel]
      session.delete :authhash
      session.delete :service_id
      redirect_to root_url, flash: { error: t('controllers.users.create.flash.canceled') }
    else
      @user = User.new(params[:user])
      @providers = Identity.providers

      if session[:authhash].present?
        @user.identities.build(provider: session[:authhash][:provider], uid: session[:authhash][:uid])
      end

      @user.password, @user.password_confirmation = SecureRandom.urlsafe_base64

      respond_to do |format|
        if @user.save
          # login with new user if confirm with openid
          cookies.permanent.signed[:user_id] = @user.id if session[:authhash].present?

          # delete authhash after login
          session.delete :authhash
          session.delete :service_id

          # send a welcome message and instruction for setting password
          @user.delay.signup_confirmation

          format.html { redirect_to @user, notice: t('controllers.users.create.flash.success') }
          format.json { render json: @user, status: :created, location: @user }
        else
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if params[:cancel]
      redirect_to @user, flash: { error: t('controllers.users.update.flash.canceled') }
    else
      respond_to do |format|
        if @user.update_attributes(params[:user])
          record_activity "پروفایل خود را به‌روز کردید"
          format.html { redirect_to @user, notice: t('controllers.users.update.flash.success') }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
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
    @favorites = @user.votes.where(voteable_type: "Story").order('created_at desc').page params[:page], per_page: 30

    respond_to do |format|
      format.html # favorites.html.erb
      format.json { render json: @favorites }
      format.js
    end
  end

  def activity_logs
    @activity_logs = @user.activity_logs.order('created_at desc').page params[:page], per_page: 30

    respond_to do |format|
      format.html # favorites.html.erb
      format.json { render json: @activity_logs }
      format.js
    end
  end

  def add_to_favorites
    @user = User.find(params[:id])
    @tag = Tag.find_by_name(params[:tag])
    respond_to do |format|
      if @user.add_to_favorites(params[:tag])
        format.html { redirect_to root_path, notice: 'Added' }
        format.js
      else
        format.html { redirect_to :back, notice: 'Oops' }
      end
    end
  end
end
