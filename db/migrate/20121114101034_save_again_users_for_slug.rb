class SaveAgainUsersForSlug < ActiveRecord::Migration
  def up
    User.find_each(&:save)
  end

  def down
    User.find_each do |u|
      u.slug = nil
      u.save!
    end
  end
end
