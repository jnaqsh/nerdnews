require 'spec_helper'

describe User do
  context "/relations" do
    it { should have_and_belong_to_many :roles }
    it { should have_many :stories}
    it { should have_many :comments }
    it { should have_many :rating_logs }
    it { should have_many :votes }
    it { should have_many :identities }    
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