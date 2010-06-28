class RemoveOwnerTypeFromImage < ActiveRecord::Migration
  def self.up
	  remove_column :images, :owner_type
  end

  def self.down
	  add_column :images, :owner_type, :integer
  end
end
