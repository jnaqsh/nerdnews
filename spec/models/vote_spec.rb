# encoding: utf-8
# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  rating_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  voteable_id   :integer
#  voteable_type :string(255)
#

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
      vote2.save
      vote2.id.should be_nil
    end
  end
end
