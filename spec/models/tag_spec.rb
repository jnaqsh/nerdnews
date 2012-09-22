require 'spec_helper'

describe Story do
  it 'has a valid factory' do
    FactoryGirl.build(:story).should be_valid
  end

  it 'validates presence of tag name' do
    tag = FactoryGirl.build(:tag, name: nil)
    tag.should have(1).error_on(:name)
  end

  it 'validated uniqueness of tag' do
    tag1 = FactoryGirl.create(:tag)
    tag2 = FactoryGirl.build(:tag)

    tag2.should have(1).error_on(:name)
  end
end