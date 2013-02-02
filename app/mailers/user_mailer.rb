#encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "do_not_reply@nerdnews.ir"

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
end
