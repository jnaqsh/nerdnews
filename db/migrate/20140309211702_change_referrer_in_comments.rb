class ChangeReferrerInComments < ActiveRecord::Migration
  def change
    change_column :comments, :referrer, :text
  end
end
