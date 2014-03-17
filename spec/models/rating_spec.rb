# encoding: utf-8
# == Schema Information
#
# Table name: ratings
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  weight        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rating_target :string(255)
#

require 'spec_helper'

describe Rating do
  it { should respond_to :name }
  it { should respond_to :weight }
  it { should respond_to :rating_target }
  it { should have_many :votes }

  describe "validations" do
    it 'has a valid factory' do
      FactoryGirl.build(:rating).should be_valid
      FactoryGirl.build(:rating_comments).should be_valid
      FactoryGirl.build(:negative_rating).should be_valid
      FactoryGirl.build(:negative_comments).should be_valid
    end

    it { should validate_numericality_of :weight }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:weight) }
    it { should validate_presence_of(:rating_target) }

    it 'wont accept weights not in the correct range' do
      wrong_weights = [-7, -6, 6, 7]
      wrong_weights.each do |weight|
        FactoryGirl.build(:rating, weight: weight).should_not be_valid
      end
    end

    it 'accepts weights in the correct range' do
      correct_weight = -5..5
      correct_weight.each do |weight|
        FactoryGirl.build(:rating, weight: weight).should be_valid
      end
    end

    describe 'Scopes' do
      it 'gets positive ratings of stories' do
        rating = FactoryGirl.create(:rating)
        Rating.positive('stories').should include rating

        negative_rating = FactoryGirl.create(:negative_rating)
        Rating.positive('stories').should_not include negative_rating
      end

      it 'gets positive ratings of comments'do
        rating = FactoryGirl.create(:rating_comments)
        Rating.positive('comments').should include rating

        negative_rating = FactoryGirl.create(:negative_comments)
        Rating.positive('comments').should_not include negative_rating
      end

      it 'gets negative ratings of stories' do
        rating = FactoryGirl.create(:negative_rating)
        Rating.negative('stories').should include rating

        positive_rating = FactoryGirl.create(:rating)
        Rating.negative('stories').should_not include positive_rating
      end

      it 'gets negative ratings of comments' do
        rating = FactoryGirl.create(:negative_comments)
        Rating.negative('comments').should include rating

        positive_rating = FactoryGirl.create(:rating_comments)
        Rating.negative('comments').should_not include positive_rating
      end
    end
  end
end
