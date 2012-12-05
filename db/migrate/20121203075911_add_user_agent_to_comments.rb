class AddUserAgentToComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_ip, :string
    add_column :comments, :user_agent, :string
    add_column :comments, :referrer, :string
    add_column :comments, :approved, :boolean, default: true

    Comment.find_each do |c|
      c.update_attribute :approved, true
    end
  end
end
