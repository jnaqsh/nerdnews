require 'spec_helper'

describe Comment do
  let(:user)  { FactoryGirl.create :user }
  let(:story) { FactoryGirl.create :story }

  it "has a correct Factory" do
    FactoryGirl.build :comment, story_id: story.id, user_id: user.id
  end

  context 'Response to methods' do
    subject { FactoryGirl.build :comment, story_id: story.id, user_id: user.id }
    it { should respond_to :content, :name, :email, :website }
  end
end