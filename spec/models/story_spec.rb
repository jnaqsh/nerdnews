require 'spec_helper'

describe Story do
  context '/relations' do
    it { should have_many :comments }
    it { should have_many :taggings }
    it { should have_many :tags }
    it { should have_many :votes }
    it { should belong_to :user }
  end

  it 'has a valid factory' do
    FactoryGirl.build(:story).should be_valid
  end

  it 'is not published' do
    story = FactoryGirl.build(:story)
    story.publish_date.should be_nil
  end

  it 'makes the story published' do
    story = FactoryGirl.build(:story)
    story.mark_as_published
    story.reload.publish_date.should_not be_nil
  end

  context "Title" do
    it 'has a title' do
      FactoryGirl.build(:story, title: nil).should_not be_valid
    end

    it 'doesnt have a small title' do
      FactoryGirl.build(:story, title: 'small').should_not be_valid
    end
  end

  context "Content" do
    it 'has a content' do
      FactoryGirl.build(:story, content: nil).should_not be_valid
    end

    it 'doesnt have a small contetnt' do
      FactoryGirl.build(:story, content: 'small').should_not be_valid
    end
  end

  context do
    it 'checks source url' do
      # Should be valid
      FactoryGirl.build(:story, source: 'http://ruby.bastardsbook.com').should be_valid
      FactoryGirl.build(:story, source: 'http://stackoverflow.com/').should be_valid
      FactoryGirl.build(:story, source: 'http://railscasts.com/episodes/243-beanstalkd-and-stalker?view=comments').should be_valid

      #should not be valid
      FactoryGirl.build(:story, source: 'http://sdfsdfdsfsiwuery').should_not be_valid
      FactoryGirl.build(:story, source: 'http://sdf.sdfd.sfsiwuery.').should_not be_valid
      FactoryGirl.build(:story, source: 'http:sdfsdfdsfsiwuery.com').should_not be_valid
    end
  end
end
