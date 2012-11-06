#encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def comment_reply(comment)
    @comment = comment
    mail to: comment.parent.email, subject: "NerdNews: Someone replied to your comment"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "بازنشانی گذرواژه"
  end
end
