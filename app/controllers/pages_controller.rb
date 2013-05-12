class PagesController < ApplicationController
  load_and_authorize_resource
  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    if params[:permalink]
      @page = Page.find_by_permalink(params[:permalink])
    else
      @page = Page.find(params[:id])
    end

    raise ActiveRecord::RecordNotFound, t("controllers.pages.show.page_not_found") if @page.nil?

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: t('controllers.pages.create.flash.success') }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to @page, notice: t('controllers.pages.update.flash.success') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
    end
  end
end
