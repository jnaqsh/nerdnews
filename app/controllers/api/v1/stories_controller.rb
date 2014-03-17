module Api
  module V1
    class StoriesController < ApplicationController
      doorkeeper_for :index, :show, :scopes => ['public']
      # doorkeeper_for :index
      respond_to :json

      def index
        respond_with stories_index
      end

      def show
        @story = Story.includes([:tags, :user, :publisher, {:votes => [:rating, :user]}]).find(params[:id])
        respond_with @story
      end

      private

      def stories_index
        @stories = Story.search(:include => [:tags, :user, :publisher, {:votes => [:rating, :user]}]) do
          without(:publish_date, nil)
          without(:hide, true)
          fulltext params[:search]
          fulltext params[:tag]
          order_by :publish_date, :desc
          paginate :page => params[:page], :per_page => 20
        end.results
      end

    end

  end

end
