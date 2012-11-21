#encoding: utf-8

require "spec_helper"

describe UserMailer do
  describe "comment_reply" do
    # let(:user) { FactoryGirl.create (:user) }
    let(:comment) { FactoryGirl.create (:comment_reply) }
    let(:mail) { UserMailer.comment_reply(comment) }

    it "renders the headers" do
      mail.subject.should eq("NerdNews: Someone replied to your comment")
      mail.to.should eq([comment.parent.email])
      mail.from.should eq(["noreply@nerdnews.ir"])
    end

    it "renders the body" do
      # TODO: Mail should have a link to Story_url with comment
      # TODO: Mail should have a link to unsubscribe from sending mail
      mail.body.encoded.should include(comment.parent.name)
      mail.body.encoded.should include(comment.name)
      mail.body.encoded.should include(comment.content)
      # mail.body.encoded.should include(story_url)
    end
  end

  describe "password_reset" do
    let(:user) { FactoryGirl.create(:user, :password_reset_token => "anything") }
    let(:mail) { UserMailer.password_reset(user) }

    it "send user password reset url" do
      mail.subject.should eq("بازنشانی گذرواژه")
      mail.to.should eq([user.email])
      mail.from.should eq(["noreply@nerdnews.ir"])
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
end
