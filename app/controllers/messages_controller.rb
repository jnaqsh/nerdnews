#encoding: utf-8

class MessagesController < ApplicationController
  load_and_authorize_resource :user

  layout 'user_profile'

  def index
    @message = @user.received_messages.build
    authorize! :index, @message

    @messages = Message.messages(@user).order('created_at desc').page(params[:page]).per(10)

    @messages.each {|m| m.mark_as_read if m.receiver == current_user}

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @message = @user.received_messages.build
    @message.sender = current_user

    authorize! :new, @message

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  def create
    @message = @user.received_messages.build(params[:message])
    @message.sender = current_user

    authorize! :create, @message

    respond_to do |format|
      if @message.save
        record_activity "برای #{@message.receiver.full_name} پیام فرستادید"
        format.html { redirect_to user_messages_path(current_user),
          notice: t('controllers.messages.create.flash.success', name: @user.full_name) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def destroy
    @message = @user.received_messages.find(params[:id])
    authorize! :destroy, @message

    @message.destroy

    record_activity "پیام شماره #{@message.id.to_farsi} را حذف کردید"

    respond_to do |format|
      format.html { redirect_to user_messages_path(current_user) }
      format.json { head :no_content }
    end
  end
end
