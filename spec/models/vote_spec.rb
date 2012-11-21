# encoding: utf-8
require 'spec_helper'

describe Vote do
  context '/Relations' do
    it { should belong_to :user }
    it { should belong_to :rating }
    it { should belong_to :voteable }
  end
end