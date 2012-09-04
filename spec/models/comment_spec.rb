require 'spec_helper'

describe Comment do
  let(:user)  { FactoryGirl.create :user }
  let(:story) { FactoryGirl.create :story }

  it "has a correct Factory" do
    FactoryGirl.create :comment, story_id: story.id, user_id: user.id
  end
end