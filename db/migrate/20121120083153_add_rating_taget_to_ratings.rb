class AddRatingTagetToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :rating_target, :string

    Rating.find_each do |r|
      r.update_attribute :rating_target, 'stories'
    end
  end
end
