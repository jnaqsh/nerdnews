FactoryGirl.define do
  factory :tag do |t|
    t.name 'tag'
    t.thumbnail File.open('app/assets/images/rails.png')
  end
end