class ShareByMailController < ApplicationController
  def create
    @share_by_mail = ShareByMail.new(current_user)
    # raise
    respond_to do |format|
      if @share_by_mail.submit(params[:share_by_mail])
        UserMailer.delay.share_by_mail(params[:share_by_mail])
        format.html { redirect_to :back, notice: t('controllers.share_by_mail.create.flash.success') }
      else
        format.html { redirect_to root_path, flash: { error: t('controllers.share_by_mail.create.flash.fail') }}
      end
    end
  end
end
