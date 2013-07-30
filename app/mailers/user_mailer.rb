#encoding: utf-8

class UserMailer < ActionMailer::Base
  default :css => 'email', from: "do_not_reply@nerdnews.ir"

  def comment_reply(comment_id)
    @comment = Comment.find(comment_id)
    mail to: @comment.parent.email, subject: "نردنیوز: شخصی به دیدگاه شما پاسخ داده‌است"
  end

  def password_reset(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "نردنیوز: بازنشانی گذرواژه"
  end

  def signup_confirmation(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "نردنیوز: به نردنیوز خوش‌آمدید"
  end

  def promotion_message(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "نردنیوز: نقش شما تبدیل به کاربر تاییدشده گردید"
  end

  def message_notify(message_id)
    @message = Message.find(message_id)
    @user = @message.receiver
    mail to: @user.email, subject: "نردنیوز: شخصی برای شما پیام خصوصی گذاشته است"
  end

  def share_by_mail(params)
    @params = params
    @story = Story.find(params[:story_id])
    mail to: params[:reciever], subject: "نردنیوز: #{params[:name]} خبری را با شما به اشتراک گذاشته است"
  end
end
