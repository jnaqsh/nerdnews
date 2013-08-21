require 'spec_helper'
require "cancan/matchers"

describe User do
  describe "abilities" do
    subject { ability }
    let(:ability){ Ability.new(user) }

    context "when is a guest user" do
      let(:user){ User.new }
      let(:story){ FactoryGirl.create(:story)}
      let(:approved_story){ FactoryGirl.create(:approved_story)}

      # activity_logs
      it { user.should_not have_ability([:index, :show], for: ActivityLog.new)}

      # announcements
      it { user.should_not have_ability([:read, :create, :update, :destroy], for: Announcement.new)}
      it { user.should have_ability(:hide, for: Announcement.new)}

      # comments
      it { user.should have_ability(:create, for: Comment.new)}
      it { user.should_not have_ability([:read, :update, :destroy, :mark_as_spam, :mark_as_not_spam], for: Comment.new)}

      # identities
      it { user.should have_ability([:create, :failure], for: Identity.new)}
      it { user.should_not have_ability([:index, :destroy], for: Identity.new)}

      # messages
      it {user.should_not have_ability([:index, :new, :create, :destroy], for: Message.new)}

      # mypage
      it { user.should_not have_ability(:index, for: :mypage)}

      # pages
      it { user.should have_ability(:show, for: Page.new)}
      it { user.should_not have_ability([:index, :create, :update, :destroy], for: Page.new)}

      # ratings
      it { user.should_not have_ability([:read, :create, :update], for: Rating.new)}

      # sessions
      it { user.should have_ability([:new, :create], for: :session)}
      it { user.should_not have_ability(:destroy, for: :session)}

      # stories
      it { user.should have_ability([:index, :create, :recent], for: Story.new)}
      it { user.should have_ability(:show, for: approved_story)}
      it { user.should_not have_ability(:show, for: story)}
      it { user.should_not have_ability([:publish, :unpublished, :update, :destroy], for: Story.new)}

      # tags
      it { user.should have_ability(:index, for: Tag.new)}
      it { user.should_not have_ability([:create, :show, :update, :destroy], for: Tag.new)}

      # users
      it { user.should have_ability([:create, :show, :posts, :comments, :favorites], for: user)}
      it { user.should_not have_ability([:add_to_favorites, :activity_logs, :index, :destroy, :update],
        for: user)}
      it { user.should_not have_ability(:bypass_captcha, for: user)}

      # votes
      it { user.should_not have_ability(:create, Vote.new)}
    end

    context "when is a new user" do
      let(:user){ FactoryGirl.create(:user) }
      let(:user2){ FactoryGirl.create(:user)}

      # activity_logs
      it { user.should_not have_ability(:show, for: ActivityLog.new)}
      it { user.should have_ability(:index, for: ActivityLog.new)}

      # announcements
      it { user.should_not have_ability([:read, :create, :update, :destroy], for: Announcement.new)}
      it { user.should have_ability(:hide, for: Announcement.new)}

      # comments
      it { user.should have_ability(:create, for: Comment.new)}
      it { user.should_not have_ability([:read, :update, :destroy, :mark_as_spam, :mark_as_not_spam], for: Comment.new)}
      it { user.should have_ability([:update, :destroy], for: user.comments.build)}
      it { user.should_not have_ability([:update, :destroy], for: user2.comments.build)}

      # identities
      it { user.should have_ability([:create, :failure], for: Identity.new)}
      it { user.should_not have_ability([:index, :destroy], for: Identity.new)}

      # messages
      it {user.should_not have_ability([:index, :new, :create, :destroy], for: Message.new)}
      it { user.should have_ability([:index, :destroy], for: user.received_messages.new)}
      it { user.should have_ability([:index, :create], for: user.sent_messages.new)}
      it { user.should_not have_ability(:create, for: user.received_messages.new)}
      it { user.should_not have_ability([:index, :destroy], for: user2.received_messages.new)}
      it { user.should_not have_ability([:index, :create], for: user2.sent_messages.new)}
      it { user.should_not have_ability(:create, for: user2.received_messages.new)}

      # mypage
      it { user.should have_ability(:index, for: :mypage)}

      # pages
      it { user.should have_ability(:show, for: Page.new)}
      it { user.should_not have_ability([:index, :create, :update, :destroy], for: Page.new)}

      # ratings
      it { user.should_not have_ability([:read, :create, :update], for: Rating.new)}

      # sessions
      it { user.should_not have_ability([:new, :create], for: :session)}
      it { user.should have_ability(:destroy, for: :session)}

      # stories
      it { user.should have_ability([:read, :create, :recent, :unpublished], for: Story.new)}
      it { user.should_not have_ability([:publish, :update, :destroy], for: Story.new)}
      it {user.should have_ability(:update, for: user.stories.build)}
      it {user.should_not have_ability(:update, for: user2.stories.build)}

      # tags
      it { user.should have_ability(:index, for: Tag.new)}
      it { user.should_not have_ability([:create, :show, :update, :destroy], for: Tag.new)}

      # users
      it { user.should have_ability([:show, :posts, :comments, :favorites], for: User.new)}
      it { user.should have_ability([:update, :activity_logs, :add_to_favorites], for: user)}
      it { user.should_not have_ability([:update, :activity_logs, :add_to_favorites], for: user2)}
      it { user.should_not have_ability([:create, :index, :destroy, :update,
        :activity_logs, :add_to_favorites], for: User.new)}
      it { user.should have_ability(:add_to_favorites, for: user)}
      it { user.should have_ability(:bypass_captcha, for: user)}

      # votes
      it { user.should have_ability(:create, for: Vote.new)}
    end

    context "when is a approved user" do
      let(:user){ FactoryGirl.create(:approved_user) }
      let(:user2){ FactoryGirl.create(:user)}

      # activity_logs
      it { user.should_not have_ability(:show, for: ActivityLog.new)}
      it { user.should have_ability(:index, for: ActivityLog.new)}

      # announcements
      it { user.should_not have_ability([:read, :create, :update, :destroy], for: Announcement.new)}
      it { user.should have_ability(:hide, for: Announcement.new)}

      # comments
      it { user.should have_ability(:create, for: Comment.new)}
      it { user.should_not have_ability([:read, :update, :destroy, :mark_as_spam, :mark_as_not_spam], for: Comment.new)}
      it { user.should have_ability([:update, :destroy], for: user.comments.build)}
      it { user.should_not have_ability([:update, :destroy], for: user2.comments.build)}

      # identities
      it { user.should have_ability([:create, :failure], for: Identity.new)}
      it { user.should_not have_ability([:index, :destroy], for: Identity.new)}

      # messages
      it {user.should_not have_ability([:index, :new, :create, :destroy], for: Message.new)}
      it { user.should have_ability([:index, :destroy], for: user.received_messages.new)}
      it { user.should have_ability([:index, :create], for: user.sent_messages.new)}
      it { user.should_not have_ability(:create, for: user.received_messages.new)}
      it { user.should_not have_ability([:index, :destroy], for: user2.received_messages.new)}
      it { user.should_not have_ability([:index, :create], for: user2.sent_messages.new)}
      it { user.should_not have_ability(:create, for: user2.received_messages.new)}

      # mypage
      it { user.should have_ability(:index, for: :mypage)}

      # pages
      it { user.should have_ability(:show, for: Page.new)}
      it { user.should_not have_ability([:index, :create, :update, :destroy], for: Page.new)}

      # ratings
      it { user.should_not have_ability([:read, :create, :update], for: Rating.new)}

      # sessions
      it { user.should_not have_ability([:new, :create], for: :session)}
      it { user.should have_ability(:destroy, for: :session)}

      # stories
      it { user.should have_ability([:read, :create, :publish, :unpublished, :recent], for: Story.new)}
      it { user.should_not have_ability([:update, :destroy], for: Story.new)}
      it {user.should have_ability(:update, for: user.stories.build)}
      it {user.should_not have_ability(:update, for: user2.stories.build)}

      # tags
      it { user.should have_ability([:index, :create, :update], for: Tag.new)}
      it { user.should_not have_ability(:destroy, for: Tag.new)}

      # users
      it { user.should have_ability([:show, :posts, :comments, :favorites], for: User.new)}
      it { user.should have_ability([:update, :activity_logs, :add_to_favorites], for: user)}
      it { user.should_not have_ability([:update, :activity_logs, :add_to_favorites], for: user2)}
      it { user.should_not have_ability([:create, :index, :destroy, :update,
        :activity_logs, :add_to_favorites], for: User.new)}
      it { user.should have_ability(:add_to_favorites, for: user)}
      it { user.should have_ability(:bypass_captcha, for: user)}

      # votes
      it { user.should have_ability(:create, for: Vote.new)}
    end

    context "when is a founder user" do
      let(:user){ FactoryGirl.create(:founder_user) }
      let(:user2){ FactoryGirl.create(:user)}

      # activity_logs
      it { user.should have_ability([:index, :show], for: ActivityLog.new)}

      # announcements
      it { user.should have_ability(:manage, for: Announcement.new)}

      # comments
      it { user.should have_ability(:manage, for: Comment.new)}

      # identities
      it { user.should have_ability([:create, :failure], for: Identity.new)}
      it { user.should_not have_ability([:index, :destroy], for: Identity.new)}

      # messages
      it {user.should_not have_ability([:index, :new, :create, :destroy], for: Message.new)}
      it { user.should have_ability([:index, :destroy], for: user.received_messages.new)}
      it { user.should have_ability([:index, :create], for: user.sent_messages.new)}
      it { user.should_not have_ability(:create, for: user.received_messages.new)}
      it { user.should_not have_ability([:index, :destroy], for: user2.received_messages.new)}
      it { user.should_not have_ability([:index, :create], for: user2.sent_messages.new)}
      it { user.should_not have_ability(:create, for: user2.received_messages.new)}

      # mypage
      it { user.should have_ability(:index, for: :mypage)}

      # pages
      it { user.should have_ability(:manage, for: Page.new)}

      # ratings
      it { user.should have_ability(:manage, for: Rating.new)}

      # sessions
      it { user.should_not have_ability([:new, :create], for: :session)}
      it { user.should have_ability(:destroy, for: :session)}

      # stories
      it { user.should have_ability(:manage, for: Story.new)}

      # tags
      it { user.should have_ability(:manage, for: Tag.new)}

      # users
      it { user.should have_ability(:manage, for: User.new)}
      it { user.should have_ability(:bypass_captcha, for: user)}

      # votes
      it { user.should have_ability(:create, for: Vote.new)}
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

end
