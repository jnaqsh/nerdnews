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
      format.js
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @stories = @user.stories.approved.order('created_at desc').page(params[:page])

    user_path = Rails.env.production? ? user_path(@user).downcase : user_path(@user) #monkey patch due to error in production (downcase)

    if request.path != user_path
      redirect_to @user, status: :moved_permanently
      return
    end

    respond_to do |format|
      format.html # show.html.erb
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
      delete_sessions
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
          record_activity %Q(کاربر #{view_context.link_to @user.full_name, user_path(@user)} در نردنیوز ثبت‌نام کرد)
          # send a welcome message and instruction for setting password
          password_reset = PasswordReset.new(@user)
          password_reset.delay.signup_confirmation

          # login with new user if confirm with openid
          if session[:authhash].present?
            cookies.permanent.signed[:user_id] = @user.id

            # delete authhash after login
            session.delete :authhash
            session.delete :service_id

            format.html { redirect_to @user, notice: t("controllers.users.create.flash.success_with_openid") }
          else
            format.html { redirect_to root_path, notice: t("controllers.users.create.flash.success") }
          end
        else
          format.html { render action: "new" }
        end
      end
    end
  end

  def delete_sessions
    session.delete :authhash
    session.delete :service_id
  end

  def log_in(user)
    cookies.permanent.signed[:user_id] = user.id if session[:authhash].present?
  end

  def build_identity_if_used_openid(user)
    if session[:authhash].present?
      user.identities.build(provider: session[:authhash][:provider], uid: session[:authhash][:uid])
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
          record_activity %Q(پروفایل خود را ویرایش کرد)
          format.html { redirect_to @user, notice: t('controllers.users.update.flash.success') }
        else
          format.html { render action: "edit" }
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
    end
  end

  # GET /users/1/posts
  # GET /users/1/posts.json
  def posts
    @user = User.find(params[:id])
    @stories = @user.stories.approved.order('created_at desc').page(params[:page])

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
    @comments = @user.comments.includes(:story).order('created_at desc').page(params[:page])

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
    @favorites = @user.votes.where(voteable_type: "Story").includes(:voteable, :rating).order('created_at desc').page(params[:page])

    respond_to do |format|
      format.html # favorites.html.erb
      format.json { render json: @favorites }
      format.js
    end
  end

  def activity_logs
    @activity_logs = @user.activity_logs.order('created_at desc').page(params[:page])

    respond_to do |format|
      format.html # favorites.html.erb
      format.json { render json: @activity_logs }
      format.js
    end
  end

  # Add a tag to users favorites
  # Does it belongs to here or tags controller?
  def add_to_favorites
    @user = User.find(params[:id])
    @tag = Tag.find_by_name(params[:tag])

    respond_to do |format|
      if @user.favored_tags.save!(params[:tag])
        format.html { redirect_to root_path, notice: 'Added' }
        format.js
      else
        format.html { redirect_to :back, notice: 'Oops' }
      end
    end
  end
end
