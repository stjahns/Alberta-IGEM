class AddStatusToExperiment < ActiveRecord::Migration
  def self.up
    add_column :experiments, :status, :string
  end

  def self.down
    remove_column :experiments, :status
  end
end
