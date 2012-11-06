class RemoveNilUserIdFromVotes < ActiveRecord::Migration
  def up
    Vote.all.each do |v|
      unless v.user
        v.destroy
      end
    end
  end

  def down
  end
end
