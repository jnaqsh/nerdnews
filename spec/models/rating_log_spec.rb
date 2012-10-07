require 'spec_helper'

describe RatingLog do
  subject { RatingLog.new }
  it { should respond_to :user }
  it { should respond_to :event }
end
