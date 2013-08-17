class ShareByMailController < ApplicationController
  def create
    @share_by_mail = ShareByMail.new(current_user, params[:share_by_mail])
    bypass_captcha_or_not @share_by_mail

    respond_to do |format|
      if @share_by_mail.submit
        UserMailer.delay.share_by_mail(params[:share_by_mail])
        format.html { redirect_to :back, notice: t('controllers.share_by_mail.create.flash.success') }
      else
        format.html { redirect_to root_path, flash: { error: t('controllers.share_by_mail.create.flash.fail') }}
      end
    end
  end
end
