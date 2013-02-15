class StaticPagesController < ApplicationController
  def faq
    respond_to do |format|
      format.html
    end
  end
end
