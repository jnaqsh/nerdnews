#encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "noreply@nerdnews.ir"

  def comment_reply(comment)
    @comment = comment
    mail to: comment.parent.email, subject: "NerdNews: Someone replied to your comment"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "بازنشانی گذرواژه"
  end

  def signup_confirmation(user)
    @user = user
    mail to: @user.email, subject: "به نردنیوز خوش‌آمدید"
  end
end
