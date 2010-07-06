class RemoveOwnerIdFromImage < ActiveRecord::Migration
  def self.up
    remove_column :images, :owner_id
  end

  def self.down
    add_column :images, :owner_id, :integer
  end
end
