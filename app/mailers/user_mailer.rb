#encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "noreply@nerdnews.ir"

  def comment_reply(comment_id)
    @comment = Comment.find(comment_id)
    mail to: @comment.parent.email, subject: "NerdNews: Someone replied to your comment"
  end

  def password_reset(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "بازنشانی گذرواژه"
  end

  def signup_confirmation(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "به نردنیوز خوش‌آمدید"
  end
end
