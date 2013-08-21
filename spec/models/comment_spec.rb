require 'spec_helper'

describe Comment do
  let(:user)  { FactoryGirl.create :user }
  let(:story) { FactoryGirl.create :story }

  it "has a correct Factory" do
    comment = FactoryGirl.build :comment, story_id: story.id, user_id: user.id
    comment.should be_valid
  end

  context 'Response to methods' do
    subject { FactoryGirl.build :comment, story_id: story.id, user_id: user.id }
    it { should respond_to :content, :name, :email, :website, :user_ip, :user_agent, :referrer }
  end

  describe "relations" do
    it {should belong_to :story}
    it {should belong_to :user}
    it {should have_many :votes}
  end

  describe "validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:content)}
    it {should validate_presence_of(:user_ip)}
    it {should validate_presence_of(:referrer)}
    it {should_not allow_value("test@gmail.").for(:email)}
    it {should allow_value("hamed@example.com").for(:email)}
    it {should_not allow_mass_assignment_of(:id)}
  end

  describe "Spams" do
    let(:comment) { FactoryGirl.create :comment }
    it 'shouldnt show not approved/spam comment' do
      false_comment = FactoryGirl.create :comment, name: 'viagra-test-123', story_id: story.id
      Comment.approved.should include comment
      Comment.approved.should_not include false_comment
    end
  end

  it 'shows votes sum' do
    story = FactoryGirl.create(:comment, positive_votes_count: 1, negative_votes_count: 3)
    story.votes_sum.should equal(-2)
  end
end
