class AnnouncementsController < ApplicationController
  load_and_authorize_resource

  def index
    @announcements = Announcement.order("created_at desc").page(params[:page]).per(20)

    respond_to do |format|
      format.html
    end
  end

  def show
    @announcement = Announcement.find(params[:id])
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(params[:announcement])

    respond_to do |format|
      if @announcement.save
        format.html {redirect_to @announcement, notice: t('controllers.announcements.create.flash.success')}
      else
        format.html {render action: :new}
      end
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      if @announcement.update_attributes(params[:announcement])
        format.html {redirect_to @announcement, notice: t('controllers.announcements.update.flash.success')}
      else
        format.html {render action: :edit}
      end
    end
  end

  def destroy
    @announcement = Announcement.find(params[:id])
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
end
