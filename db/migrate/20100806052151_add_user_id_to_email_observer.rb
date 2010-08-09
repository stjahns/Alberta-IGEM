class AddUserIdToEmailObserver < ActiveRecord::Migration
  def self.up
    add_column :email_observers, :user_id, :integer
  end

  def self.down
    remove_column :email_observers, :user_id
  end
end
