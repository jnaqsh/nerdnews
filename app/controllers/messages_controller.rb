#encoding: utf-8

class MessagesController < ApplicationController
  load_and_authorize_resource :user

  layout 'user_profile'

  def index
    @message = @user.received_messages.build
    authorize! :index, @message

    @messages = Message.messages(@user).includes(:receiver, :sender).order('created_at desc').page(params[:page]).per(10)

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
        UserMailer.delay.message_notify(@message)

        record_activity %Q(برای #{view_context.link_to @message.receiver.full_name, user_path(@message.receiver)} پیام فرستاد)

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

    record_activity "پیام شماره #{@message.id.to_farsi} را حذف کرد"

    respond_to do |format|
      format.html { redirect_to user_messages_path(current_user) }
    end
  end
end
