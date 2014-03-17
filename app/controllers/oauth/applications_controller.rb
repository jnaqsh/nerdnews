class Oauth::ApplicationsController < ApplicationController
  authorize_resource :class => Doorkeeper::Application
  respond_to :html

  before_filter :set_application, :only => [:show, :edit, :update, :destroy]

  def index
    @applications = current_user.oauth_applications
  end

  def new
    @application = Doorkeeper::Application.new()
  end

  def show
  end

  def create
    @application = Doorkeeper::Application.new(application_params)
    @application.owner = current_user if Doorkeeper.configuration.confirm_application_owner?
    if @application.save
      flash[:notice] = I18n.t(:notice, :scope => [:oauth, :applications, :flash, :create])
      respond_with [:oauth, @application]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @application.update_attributes(application_params)
      flash[:notice] = I18n.t(:notice, :scope => [:oauth, :applications, :flash, :update])
      respond_with [:oauth, @application]
    else
      render :edit
    end
  end

  def destroy
    flash[:notice] = I18n.t(:notice, :scope => [:oauth, :applications, :flash, :destroy]) if @application.destroy
    redirect_to oauth_applications_url
  end

  private

  def set_application
    @application = Doorkeeper::Application.find(params[:id])
  end

  def application_params
    params.require(:application).permit(:name, :redirect_uri)
  end

end
