require 'spec_helper'

describe Identity do
  it { should belong_to :user }
end
