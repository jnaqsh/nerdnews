class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def comment_reply(comment)
    @comment = comment
    mail to: comment.parent.email, subject: "NerdNews: Someone replied to your comment"
  end
end
