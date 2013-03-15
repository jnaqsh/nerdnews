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
