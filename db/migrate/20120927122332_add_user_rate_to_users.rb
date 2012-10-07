class AddUserRateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_rate, :integer, default: 0
  end
end
