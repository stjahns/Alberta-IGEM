class AddGroupIdToExperiments < ActiveRecord::Migration
  def self.up
    add_column :experiments, :group_id, :integer
  end

  def self.down
    remove_column :experiment, :group_id
  end
end
