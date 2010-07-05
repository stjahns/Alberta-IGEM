class AddUserIdToExperiments < ActiveRecord::Migration
  def self.up
    add_column :experiments, :user_id, :integer
  end

  def self.down
    remove_column :experiments, :user_id
  end
end
