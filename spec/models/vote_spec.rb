# encoding: utf-8
require 'spec_helper'

describe Vote do
  context '/Relations' do
    it { should belong_to :user }
    it { should belong_to :rating }
    it { should belong_to :voteable }
  end

  context "/validation" do
    let(:story)   { FactoryGirl.create(:story) }
    let(:rating)  { FactoryGirl.create(:rating) }
    let(:user)    { FactoryGirl.create(:user) }

    it {should validate_uniqueness_of(:voteable_id)}

    it 'checks for uniquness' do

      vote1 = Vote.new do |v|
        v.user = user
        v.rating = rating
        v.voteable = story
      end

      vote2 = Vote.new do |v|
        v.user = user
        v.rating = rating
        v.voteable = story
      end

      vote1.save
      vote1.id.should eq(1)

      vote2.save
      vote2.id.should be_nil
    end
  end
end