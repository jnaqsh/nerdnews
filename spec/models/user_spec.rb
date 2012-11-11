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
      it { user.should_not have_ability([:create, :read, :sent], for: Message.new)}
      it { user.should_not have_ability(:index, for: :mypage)}
      it { user.should have_ability(:show, for: Page.new)}
      it { user.should_not have_ability([:index, :create, :update, :destroy], for: Page.new)}
      it { user.should have_ability(:manage, for: :password_reset)}
      it { user.should_not have_ability([:read, :create, :update], for: Rating.new)}
      it { user.should have_ability([:new, :create], for: :session)}
      it { user.should_not have_ability(:destroy, for: :session)}
      it { user.should have_ability([:read, :create], for: Story.new)}
      it { user.should_not have_ability([:publish, :unpublished, :update, :destroy], for: Story.new)}
      it { user.should have_ability(:index, for: Tag.new)}
      it { user.should_not have_ability([:create, :show, :update, :destroy], for: Tag.new)}
      it { user.should have_ability([:create, :show, :posts, :comments, :favorites], for: User.new)}
      it { user.should_not have_ability([:index, :destroy, :update], for: User.new)}
      it { user.should_not have_ability(:create, Vote.new)}
    end

    context "when is a new user" do
      let(:user){ FactoryGirl.create(:user) }
      let(:user2){ FactoryGirl.create(:user)}

      it { user.should have_ability(:create, for: Comment.new)}
      it { user.should_not have_ability([:read, :update, :destroy], for: Comment.new)}
      it { user.should have_ability([:create, :failure], for: Identity.new)}
      it { user.should have_ability([:index, :destroy], for: user.identities.new) }
      it { user.should have_ability(:manage, for: user.messages.new)}
      it { user.should have_ability(:show, for: Message.new(reciver_id: user.id))}
      it { user.should_not have_ability(:manage, for: user2.messages.new)}
      it { user.should have_ability(:index, for: :mypage)}
      it { user.should have_ability(:show, for: Page.new)}
      it { user.should_not have_ability([:index, :create, :update, :destroy], for: Page.new)}
      it { user.should_not have_ability(:manage, for: :password_reset)}
      it { user.should_not have_ability([:read, :create, :update], for: Rating.new)}
      it { user.should_not have_ability([:new, :create], for: :session)}
      it { user.should have_ability(:destroy, for: :session)}
      it { user.should have_ability([:read, :create], for: Story.new)}
      it { user.should_not have_ability([:publish, :unpublished, :update, :destroy], for: Story.new)}
      it { user.should have_ability(:index, for: Tag.new)}
      it { user.should_not have_ability([:create, :show, :update, :destroy], for: Tag.new)}
      it { user.should have_ability([:show, :posts, :comments, :favorites], for: User.new)}
      it { user.should have_ability([:update, :destroy], for: user)}
      it { user.should_not have_ability([:create, :index, :destroy, :update], for: User.new)}
      it { user.should have_ability(:create, for: Vote.new)}
    end

    context "when is a approved user" do
      let(:user){ FactoryGirl.create(:approved_user) }
      let(:user2){ FactoryGirl.create(:user)}

      it { user.should have_ability(:manage, for: Comment.new)}
      it { user.should have_ability([:create, :failure], for: Identity.new)}
      it { user.should have_ability([:index, :destroy], for: user.identities.new)}
      it { user.should have_ability(:manage, for: user.messages.new)}
      it { user.should have_ability(:show, for: Message.new(reciver_id: user.id))}
      it { user.should_not have_ability(:manage, for: user2.messages.new)}
      it { user.should_not have_ability(:show, for: Message.new(reciver_id: user2.id))}
      it { user.should have_ability(:index, for: :mypage)}
      it { user.should have_ability(:show, for: Page.new)}
      it { user.should_not have_ability([:index, :create, :update, :destroy], for: Page.new)}
      it { user.should_not have_ability(:manage, for: :password_reset)}
      it { user.should_not have_ability([:read, :create, :update], for: Rating.new)}
      it { user.should_not have_ability([:new, :create], for: :session)}
      it { user.should have_ability(:destroy, for: :session)}
      it { user.should have_ability([:manage], for: Story.new)}
      it { user.should have_ability([:read, :create, :update], for: Tag.new)}
      it { user.should_not have_ability(:destroy, for: Tag.new)}
      it { user.should have_ability([:show, :posts, :comments, :favorites], for: User.new)}
      it { user.should have_ability([:update, :destroy], for: user)}
      it { user.should_not have_ability([:create, :index, :destroy, :update], for: User.new)}
      it { user.should have_ability(:create, for: Vote.new)}
    end

    context "when is a founder user" do
      let(:user){ FactoryGirl.create(:founder_user) }
      let(:user2){ FactoryGirl.create(:user)}

      it { user.should have_ability(:manage, for: Comment.new)}
      it { user.should have_ability([:create, :failure], for: Identity.new)}
      it { user.should have_ability([:index, :destroy], for: user.identities.new)}
      it { user.should have_ability(:manage, for: user.messages.new)}
      it { user.should have_ability(:show, for: Message.new(reciver_id: user.id))}
      it { user.should_not have_ability(:manage, for: user2.messages.new)}
      it { user.should_not have_ability(:show, for: Message.new(reciver_id: user2.id))}
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
    it { should have_many :rating_logs }
    it { should have_many :votes }
    it { should have_many :identities }
    it { should have_many :messages }
  end

  context 'Validations' do
    it 'has a valid factory' do
      FactoryGirl.create(:user).should be_valid
    end

    it "validates length and presence of full name attribute" do
      user = FactoryGirl.build(:user, full_name: nil)
      user.should have(2).errors_on(:full_name)
    end

    it "validates uniqueness of email attribue" do
      user = FactoryGirl.create(:user, email: 'repeat@email.com')
      user2 = FactoryGirl.build(:user, email: 'repeat@email.com')
      user2.should have(1).errors_on(:email)
    end

    it "validates match of password and confirmation attributes" do
      user = FactoryGirl.build(:user, password_confirmation: 'wrong')
      user.should have(2).errors_on(:password)
    end

    it "validates presence of password attribute" do
      pending "Need more investigation"
      user = FactoryGirl.build(:user, password_confirmation: nil)
      user.save
      user.should have(1).error_on(:password_confirmation)
    end
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
