# == Schema Information
#
# Table name: activity_logs
#
#  id         :integer          not null, primary key
#  user_id    :string(255)
#  browser    :string(255)
#  ip_address :string(255)
#  controller :string(255)
#  action     :string(255)
#  params     :string(255)
#  note       :text(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ActivityLog do
  subject { ActivityLog.new }
  it { should respond_to :user }
  it { should respond_to :browser }
  it { should respond_to :ip_address }
  it { should respond_to :controller }
  it { should respond_to :action }
  it { should respond_to :params }
  it { should respond_to :note }

  describe "relations" do
    it {should belong_to :user}
  end
end
