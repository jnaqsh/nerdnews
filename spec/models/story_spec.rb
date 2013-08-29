require 'spec_helper'

describe Story do
  context '/relations' do
    it { should have_many :comments }
    it { should have_many(:taggings) }
    it { should have_many(:tags).through(:taggings) }
    it { should have_many :votes }
    it { should belong_to :user }
    it { should belong_to :publisher }
    it { should belong_to :remover }
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
      @story.mark_as_published(@user, "http://example.com/stories/story_name")
    end

    it 'makes the story published' do
      @story.reload.publish_date.should_not be_nil
    end

    it 'updates publisher id in story after getting published' do
      @story.reload.publisher_id.should_not be_nil
    end
  end

  context '/Hiding' do
    it 'should mark stories as hide' do
      story1 = FactoryGirl.create(:story, publish_date: Date.today - 2.day)
      story2 = FactoryGirl.create(:story, publish_date: Date.today - 1.day)
      story3 = FactoryGirl.create(:story, publish_date: Date.today - 1.day, total_point: -7)
      story4 = FactoryGirl.create(:approved_story, publish_date: Date.today - 1.day, total_point: -10)
      Story.hide_negative_stories
      expect(story1.reload.hide?).to be_false
      expect(story2.reload.hide?).to be_false
      expect(story3.reload.hide?).to be_false
      expect(story4.reload.hide?).to be_true
    end
  end

  context "counter" do
    before do
      @story = FactoryGirl.create(:story)
    end

    it 'should increment counter after creating a comment' do
      expect do
        @comment = FactoryGirl.create(:comment, story: @story)
      end.to change{@story.reload.comments_count}.by(1)
    end

    it "should not change counter if a comment is a spam" do
      expect do
        @comment = FactoryGirl.create(:comment, story: @story, name: "viagra-test-123")
      end.to_not change{@story.reload.comments_count}
    end

    it "should decrement comments_counter if comment marked as spam" do
      @comment = FactoryGirl.create(:comment, story: @story, approved: true)
      expect do
        @comment.mark_as_spam
      end.to change{@story.reload.comments_count}.by(-1)
    end

    it "should increment comments_counter if comment marked as not spam" do
      @comment = FactoryGirl.create(:comment, story: @story, approved: false)
      expect do
        @comment.mark_as_not_spam
      end.to change{@story.reload.comments_count}.by(1)
    end
  end
end
