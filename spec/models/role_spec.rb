# encoding: utf-8
# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Role do
  it 'should creates a new user' do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    user.should be_role("new_user")
  end

  it 'should creates a approved user' do
    user = FactoryGirl.create(:approved_user)
    user.should be_role("approved")
  end

  it 'should creates a founder user' do
    user = FactoryGirl.create(:founder_user)
    user.should be_role("founder")
  end

  it 'shows persian equivelant of role name' do
    role = FactoryGirl.create(:founder_role)
    role.to_persian.should eq('موسس')
  end
end
