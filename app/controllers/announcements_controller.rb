class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @announcements = Announcement.order("created_at desc").page(params[:page]).per(20)

    respond_to do |format|
      format.html
    end
  end

  def show
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(announcement_params)

    respond_to do |format|
      if @announcement.save
        format.html {redirect_to @announcement, notice: t('controllers.announcements.create.flash.success')}
      else
        format.html {render action: :new}
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @announcement.update_attributes(announcement_params)
        format.html {redirect_to @announcement, notice: t('controllers.announcements.update.flash.success')}
      else
        format.html {render action: :edit}
      end
    end
  end

  def destroy
    @announcement.destroy

    respond_to do |format|
      format.html {redirect_to announcements_path}
    end
  end

  def hide
    ids = [params[:id], *cookies.signed[:hidden_annoucement_ids]]
    cookies.permanent.signed[:hidden_annoucement_ids] = ids

    respond_to do |format|
      format.html do
        begin
          redirect_to :back
        rescue ActionController::RedirectBackError
          redirect_to root_path
        end
      end
      format.js
    end
  end

  private
    def set_announcement
      @announcement = Announcement.find(params[:id])
    end

    def announcement_params
      params.require(:announcement).permit(:message, :starts_at, :ends_at)
    end
end
