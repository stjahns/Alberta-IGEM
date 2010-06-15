class RenameOwnerIdInExperiments < ActiveRecord::Migration
  def self.up
	  rename_column :experiments, :owner_id, :user_id
  end

  def self.down
	  rename_column :experiments, :user_id, :owner_id
  end
end
