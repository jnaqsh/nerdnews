require 'spec_helper'
require "cancan/matchers"

describe User do
  describe "abilities" do
    subject { ability }
    let(:ability){ Ability.new(user) }

    context "when is a guest user" do
      let(:user){ User.new }

      it { user.should have_ability(:create, for: Comment.new)}
      it { user.should_not have_ability([:read, :update, :destroy], for: Comment.new)}
      it { user.should have_ability([:create, :failure], for: Identity.new)}
      it { user.should_not have_ability([:index, :destroy], for: Identity.new)}
      it { user.should_not have_ability(:index, for: :mypage)}
      it { user.should have_ability(:show, for: Page.new)}
      it { user.should_not have_ability([:index, :create, :update, :destroy], for: Page.new)}
      it { user.should_not have_ability([:read, :create, :update], for: Rating.new)}
      it { user.should have_ability([:new, :create], for: :session)}
      it { user.should_not have_ability(:destroy, for: :session)}
      it { user.should have_ability([:read, :create, :recent], for: Story.new)}
      it { user.should_not have_ability([:publish, :unpublished, :update, :destroy], for: Story.new)}
      it { user.should have_ability(:index, for: Tag.new)}
      it { user.should_not have_ability([:create, :show, :update, :destroy], for: Tag.new)}
      it { user.should have_ability([:create, :show, :posts, :comments, :favorites], for: User.new)}
      it { user.should_not have_ability(:activity_logs), for: User.new}
      it { user.should_not have_ability([:index, :destroy, :update], for: User.new)}
      it { user.should_not have_ability(:create, Vote.new)}
      it { user.should_not have_ability(:bypass_captcha, for: user)}
      it { user.should_not have_ability([:index, :show], for: ActivityLog.new)}
    end

    context "when is a new user" do
      let(:user){ FactoryGirl.create(:user) }
      let(:user2){ FactoryGirl.create(:user)}

      it { user.should_not have_ability(:show, for: ActivityLog.new)}
      it { user.should have_ability(:index, for: ActivityLog.new)}
      it { user.should have_ability(:create, for: Comment.new)}
      it { user.should have_ability([:update, :destroy], for: user.comments.build)}
      it { user.should_not have_ability(:update, for: user2.comments.build)}
      it { user.should_not have_ability([:read, :update, :destroy], for: Comment.new)}
      it { user.should have_ability([:create, :failure], for: Identity.new)}
      it { user.should have_ability([:index, :destroy], for: user.identities.new) }
      it { user.should have_ability([:index, :destroy], for: user.received_messages.new)}
      it { user.should have_ability([:index, :create], for: user.sent_messages.new)}
      it { user.should_not have_ability(:create, for: user.received_messages.new)}
      it { user.should_not have_ability([:index, :destroy], for: user2.received_messages.new)}
      it { user.should_not have_ability([:index, :create], for: user2.sent_messages.new)}
      it { user.should_not have_ability(:create, for: user2.received_messages.new)}
      it { user.should have_ability(:index, for: :mypage)}
      it { user.should have_ability(:show, for: Page.new)}
      it { user.should_not have_ability([:index, :create, :update, :destroy], for: Page.new)}
      it { user.should_not have_ability(:manage, for: :password_reset)}
      it { user.should_not have_ability([:read, :create, :update], for: Rating.new)}
      it { user.should_not have_ability([:new, :create], for: :session)}
      it { user.should have_ability(:destroy, for: :session)}
      it { user.should have_ability([:read, :create, :recent], for: Story.new)}
      it { user.should_not have_ability([:publish, :unpublished, :update, :destroy], for: Story.new)}
#      it { user.should have_ability(:activity_logs), for: user}
#      it { user.should_not have_ability(:activity_logs), for: user2}
      it { user.should have_ability(:index, for: Tag.new)}
      it { user.should_not have_ability([:create, :show, :update, :destroy], for: Tag.new)}
      it { user.should have_ability([:show, :posts, :comments, :favorites], for: User.new)}
      it { user.should have_ability(:update, for: user)}
      it { user.should_not have_ability([:create, :index, :destroy, :update], for: User.new)}
      it { user.should have_ability(:create, for: Vote.new)}
      it { user.should_not have_ability(:bypass_captcha, for: user)}
    end

    context "when is a approved user" do
      let(:user){ FactoryGirl.create(:approved_user) }
      let(:user2){ FactoryGirl.create(:user)}

      it { user.should have_ability(:update, for: user.comments.build)}
      it { user.should_not have_ability(:update, for: user2.comments.build)}
      it { user.should have_ability([:create, :failure], for: Identity.new)}
      it { user.should have_ability([:index, :destroy], for: user.identities.new)}
      it { user.should have_ability([:index, :destroy], for: user.received_messages.new)}
      it { user.should have_ability([:index, :create], for: user.sent_messages.new)}
      it { user.should_not have_ability(:create, for: user.received_messages.new)}
      it { user.should_not have_ability([:index, :destroy], for: user2.received_messages.new)}
      it { user.should_not have_ability([:index, :create], for: user2.sent_messages.new)}
      it { user.should_not have_ability(:create, for: user2.received_messages.new)}
      it { user.should have_ability(:index, for: :mypage)}
      it { user.should have_ability(:show, for: Page.new)}
      it { user.should_not have_ability([:index, :create, :update, :destroy], for: Page.new)}
      it { user.should_not have_ability(:manage, for: :password_reset)}
      it { user.should_not have_ability([:read, :create, :update], for: Rating.new)}
      it { user.should_not have_ability([:new, :create], for: :session)}
      it { user.should have_ability(:destroy, for: :session)}
      it { user.should have_ability([:read, :create, :publish, :unpublished, :recent], for: Story.new)}
      it { user.should have_ability(:update, for: user.stories.build)}
      it { user.should_not have_ability(:update, for: user2.stories.build)}
      it { user.should have_ability([:read, :create, :update], for: Tag.new)}
      it { user.should_not have_ability(:destroy, for: Tag.new)}
      it { user.should have_ability([:show, :posts, :comments, :favorites], for: User.new)}
#      it { user.should_not have_ability(:activity_logs), for: user2}
#      it { user.should have_ability(:activity_logs), for: user}
      it { user.should have_ability(:update, for: user)}
      it { user.should_not have_ability(:update, for: user2)}
      it { user.should_not have_ability([:create, :index, :destroy, :update], for: User.new)}
      it { user.should have_ability(:create, for: Vote.new)}
      it { user.should have_ability(:bypass_captcha, for: user)}
      it { user.should_not have_ability(:show, for: ActivityLog.new)}
      it { user.should have_ability(:index, for: ActivityLog.new)}
    end

    context "when is a founder user" do
      let(:user){ FactoryGirl.create(:founder_user) }
      let(:user2){ FactoryGirl.create(:user)}

      it { user.should have_ability(:manage, for: Comment.new)}
      it { user.should have_ability([:create, :failure], for: Identity.new)}
      it { user.should have_ability([:index, :destroy], for: user.identities.new)}
      it { user.should have_ability([:index, :destroy], for: user.received_messages.new)}
      it { user.should have_ability([:index, :create], for: user.sent_messages.new)}
      it { user.should_not have_ability(:create, for: user.received_messages.new)}
      it { user.should_not have_ability([:index, :destroy], for: user2.received_messages.new)}
      it { user.should_not have_ability([:index, :create], for: user2.sent_messages.new)}
      it { user.should_not have_ability(:create, for: user2.received_messages.new)}
      it { user.should have_ability(:index, for: :mypage)}
      it { user.should have_ability([:read, :create, :update, :destroy], for: Page.new)}
      it { user.should_not have_ability(:manage, for: :password_reset)}
      it { user.should have_ability([:read, :create, :update], for: Rating.new)}
      it { user.should_not have_ability([:new, :create], for: :session)}
      it { user.should have_ability(:destroy, for: :session)}
      it { user.should have_ability(:manage, for: Story.new)}
      it { user.should have_ability(:manage, for: Tag.new)}
      it { user.should have_ability(:manage, for: User.new)}
      it { user.should have_ability(:create, for: Vote.new)}
      it { user.should have_ability(:bypass_captcha, for: user)}
      it { user.should have_ability([:index, :show], for: ActivityLog.new)}
    end
  end

  describe "#send_password_reset" do
    let(:user) { FactoryGirl.create(:user) }

    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not eq(last_token)
    end

    it "saves the time the password reset was sent" do
      user.send_password_reset
      user.reload.password_reset_sent_at.should be_present
    end

    it "delivers email to user" do
      user.send_password_reset
      last_email.to.should include(user.email)
    end
  end

  context "/relations" do
    it { should have_and_belong_to_many :roles }
    it { should have_many :stories}
    it { should have_many :comments }
    it { should have_many :votes }
    it { should have_many :identities }
    it { should have_many :sent_messages }
    it { should have_many :received_messages }
    it { should have_many :activity_logs }
    it { should have_many :published_stories }
    it { should have_many :removed_stories }
  end

  context 'Validations' do
    it 'has a valid factory' do
      FactoryGirl.create(:user).should be_valid
    end

    it { should validate_presence_of(:full_name) }
    it { should ensure_length_of(:full_name).is_at_least(4).is_at_most(30) }
    it { should validate_presence_of(:email) }
    it { should allow_value("asd@asdas.com").for(:email) }
    it { should_not allow_value("Asdasd@asd").for(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_confirmation_of(:password) }
    it { should allow_value("www.example.com").for(:website) }
    it { should_not allow_value("www.").for(:website) }
    it { should allow_value('').for(:website) }
    it { should allow_value("http://www.example.com/").for(:website) }
    it { should_not allow_value("http://www.example").for(:website) }
  end

  context 'Authentication' do
    before(:each) do
      @user = FactoryGirl.build(:user)
    end

    it "encrypts password upon creation" do
      @user.password_digest.should_not be_empty
    end

    it "returns user upon authentication" do
      @logged_in = @user.authenticate("secret")
      @logged_in.id.should eq(@user.id)
    end
  end

  context 'Story/Comment counter cache' do
    before do
      @user = FactoryGirl.create(:user)
    end
    it 'should update after creating a story' do
      expect {
        FactoryGirl.create(:story, user: @user)
      }.to change { @user.reload.stories_count }.by(1)
    end

    it 'should update after creating a comment' do
      story = FactoryGirl.create(:story, user: @user)
      expect {
        FactoryGirl.create(:comment, story: story, user: @user)
      }.to change { @user.reload.comments_count }.by(1)
    end
  end

  it 'returns true if tag is favorited' do
    user = FactoryGirl.create(:user, favorite_tags: 'nerd')
    user.included_tag_as_favorite?('nerd').should be_true
    user.included_tag_as_favorite?('news').should be_false
  end

  it 'updates the favorite tags' do
    user = FactoryGirl.create(:user, favorite_tags: 'nerd')
    user.add_to_favorites('news')
    pp user.favorite_tags_array
    user.reload.favorite_tags_array.should be_include('news')
  end
end
