# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  sender_id   :integer
#  receiver_id :integer
#  subject     :string(255)
#  message     :text
#  unread      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Message do
  it { should belong_to :sender }
  it { should belong_to :receiver }
end
