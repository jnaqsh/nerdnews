require 'spec_helper'

describe Message do
  it { should belong_to :user }
end
