
FactoryGirl.define do
  factory :rating do |r|
    r.name "Positive"
    r.weight 1

    factory :negative_rating do |r|
      r.name "Negative"
      r.weight -1
    end
  end
end
