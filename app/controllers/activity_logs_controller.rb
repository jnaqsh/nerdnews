class ActivityLogsController < ApplicationController
  load_and_authorize_resource

  def index
    @activity_logs = ActivityLog.search(:include => :user) do
      fulltext params[:search]
      keywords("stories comments") {minimum_match 1} unless current_user.role? "founder"
      order_by :created_at, :desc
      paginate :page => params[:page], :per_page => 500
    end.results

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @activity_log = ActivityLog.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
end
