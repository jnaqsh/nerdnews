require 'spec_helper'

describe Tag do

  describe "relations" do
    it {should have_many(:taggings)}
    it {should have_many(:stories).through(:taggings)}
    it {should have_attached_file(:thumbnail)}
  end

  describe "validations" do
    it 'has a valid factory' do
      FactoryGirl.build(:story).should be_valid
    end
    it {should validate_presence_of(:name)}
    it {should validate_uniqueness_of(:name)}
    it {should validate_attachment_presence(:thumbnail)}
    it {should validate_attachment_content_type(:thumbnail).
          allowing('image/jpeg', 'image/jpg', 'image/png')}
    it {should validate_attachment_size(:thumbnail).
          less_than(100.kilobytes).greater_than(0.kilobytes)}
    it {should_not allow_mass_assignment_of(:thumbnail_file_name)}
    it {should_not allow_mass_assignment_of(:thumbnail_content_type)}
    it {should_not allow_mass_assignment_of(:thumbnail_file_size)}
    it {should_not allow_mass_assignment_of(:thumbnail_updated_at)}
  end
end
