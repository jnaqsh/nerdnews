class ShareByMailController < ApplicationController
  def create
    respond_to do |format|
      if UserMailer.share_by_mail(params[:share_mail]).deliver
        format.html { redirect_to :back, notice: t('controllers.share_by_mail.create.flash.success') }
      end
    end
  end
end
