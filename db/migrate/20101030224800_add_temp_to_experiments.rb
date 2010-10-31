class AddTempToExperiments < ActiveRecord::Migration
  def self.up
    add_column :experiments, :temp, :boolean, :default => false
  end

  def self.down
    remove_column :experiments, :temp
  end
end
