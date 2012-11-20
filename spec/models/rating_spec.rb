# encoding: utf-8
require 'spec_helper'

describe Rating do
  it { should respond_to :name }
  it { should respond_to :weight }
  it { should have_many :votes }

  describe "validations", focus: true do
    it 'has a valid factory' do
      FactoryGirl.build(:rating).should be_valid
    end

    it { should validate_numericality_of :weight }
    
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
  end
end