class MessagesController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource through: :user
  def index
    @messages = Message.where(reciver_id: params[:user_id]).order('created_at desc').page params[:page]
    respond_to do |format|
    format.html { flash[:notice] = t('controllers.messages.flash.no_recived_message') if @messages.blank? }
    end
  end

  def show
    respond_to do |format|
      @message.mark_as_read if current_user.id == @message.reciver_id
      format.html
    end
  end

  def new
    @message = Message.new
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @user = User.find(params[:user_id])
    @message = @user.messages.build(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to user_messages_path, notice: t('controllers.messages.flash.message_sent') }
      else
        format.html { render action: "new" }
      end
    end
  end

  # def destroy
    # Pending option: How? if reciver removes one of the messages, it'll be removed for sender too
    # Edit routes if you wanted to add it
  # end

  def sent
    @messages = Message.where(user_id: params[:user_id]).order('created_at desc').page params[:page]

    respond_to do |format|
      format.html { flash[:notice] = t('controllers.messages.flash.no_sent_message') if @messages.blank? }

    end
  end
end
