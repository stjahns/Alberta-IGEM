class RemoveUserIdFromNotes < ActiveRecord::Migration
  def self.up
    remove_column :notes, :user_id
  end

  def self.down
    add_column :notes, :user_id, :integer
  end
end
