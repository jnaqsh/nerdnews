#encoding: utf-8

require "spec_helper"

describe UserMailer do
  describe "comment_reply" do
    # let(:user) { FactoryGirl.create (:user) }
    let(:comment) { FactoryGirl.create(:comment_reply) }
    let(:mail) { UserMailer.comment_reply(comment) }

    it "renders the headers" do
      mail.subject.should eq("نردنیوز: شخصی به دیدگاه شما پاسخ داده‌است")
      mail.to.should eq([comment.parent.email])
      mail.from.should eq(["do_not_reply@nerdnews.ir"])
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
      mail.subject.should eq("نردنیوز: بازنشانی گذرواژه")
      mail.to.should eq([user.email])
      mail.from.should eq(["do_not_reply@nerdnews.ir"])
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end

  describe "promotion message" do
    let(:user) {FactoryGirl.create(:approved_user)}
    let(:mail) {UserMailer.promotion_message(user)}

    it 'sends promotion message for user' do
      mail.subject.should eq("نردنیوز: نقش شما تبدیل به کاربر تاییدشده گردید")
      mail.to.should eq([user.email])
      mail.from.should eq(["do_not_reply@nerdnews.ir"])
    end
  end

  describe "message notify" do
    let(:message) {FactoryGirl.create(:message_with_user)}
    let(:mail) {UserMailer.message_notify(message)}

    it 'sends message notify to user' do
      mail.subject.should eq("نردنیوز: شخصی برای شما پیام خصوصی گذاشته است")
      mail.to.should eq([message.receiver.email])
      mail.from.should eq(["do_not_reply@nerdnews.ir"])
    end
  end

  describe "Share By Mail" do
    let(:story) { FactoryGirl.create(:story) }
    let(:params) { {name: 'arash', reciever: 'test@mail.com', body:'this is some random text', story_id: story.id} }
    let(:mail) {UserMailer.share_by_mail(params)}

    it "sends email correctly for sharing a story" do
      mail.subject.should eq("نردنیوز: #{params[:name]} خبری را با شما به اشتراک گذاشته است")
      mail.to.should eq([params[:reciever]])
      mail.body.encoded.should include(params[:body])
      mail.body.encoded.should include(story.title)
      mail.body.encoded.should include(story_url(story))
    end
  end
end
