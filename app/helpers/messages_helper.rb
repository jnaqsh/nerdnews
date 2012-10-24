module MessagesHelper
  def message_unread? message
    'font-weight:bold' if message.unread? and message.reciver_id == current_user.id
  end
end
