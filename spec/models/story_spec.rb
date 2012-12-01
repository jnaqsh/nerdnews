require 'spec_helper'

describe Story do
  context '/relations' do
    it { should have_many :comments }
    it { should have_many(:taggings) }
    it { should have_many(:tags).through(:taggings) }
    it { should have_many :votes }
    it { should belong_to :user }
  end

  context 'validations' do
    it 'has a valid factory' do
      FactoryGirl.create(:story).should be_valid
    end

    it { should validate_presence_of(:title) }
    it { should ensure_length_of(:title).is_at_least(10).is_at_most(100) }
    it { should validate_presence_of(:content) }
    it { should ensure_length_of(:content).is_at_least(250).is_at_most(1500) }
    it { should allow_value("").for(:source) }
    it { should allow_value("www.google.com").for(:source) }
    it { should allow_value("http://stackoverflow.com/").for(:source) }
    it { should allow_value("http://railscasts.com/episodes/243-beanstalkd-and-stalker?view=comments")
        .for(:source) }
    it { should_not allow_value("wrong_uri").for(:source) }
    it { should_not allow_value("http://sdfsdfdsfsiwuery").for(:source) }
    it { should_not allow_value("http:sdfsdfdsfsiwuery.com").for(:source) }
  end

  it 'is not published' do
    story = FactoryGirl.build(:story)
    story.publish_date.should be_nil
  end

  context '/Publishing' do
    before do
      @story = FactoryGirl.build(:story)
      @user = FactoryGirl.create(:approved_user)
      @story.mark_as_published(@user)
    end

    it 'makes the story published' do
      @story.reload.publish_date.should_not be_nil
    end

    it 'updates publisher id in story after getting published' do
      pp @story
      @story.reload.publisher_id.should_not be_nil
    end
  end
end
