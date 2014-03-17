# == Schema Information
#
# Table name: tags
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  stories_count          :integer          default(1)
#  thumbnail_file_name    :string(255)
#  thumbnail_content_type :string(255)
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#

require 'faker'
FactoryGirl.define do
  factory :tag do |t|
    t.name Faker::Lorem.characters(7)
    t.thumbnail File.open('app/assets/images/rails.png')
  end
end
