require "spec_helper"

describe UserMailer do
  describe "comment_reply" do
    # let(:user) { FactoryGirl.create (:user) }
    let(:comment) { FactoryGirl.create (:comment_reply) }
    let(:mail) { UserMailer.comment_reply(comment) }

    it "renders the headers" do
      mail.subject.should eq("NerdNews: Someone replied to your comment")
      mail.to.should eq([comment.parent.email])
      mail.from.should eq(["from@example.com"])
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
end
