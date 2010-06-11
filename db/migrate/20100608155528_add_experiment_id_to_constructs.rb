class AddExperimentIdToConstructs < ActiveRecord::Migration
  def self.up
    add_column :constructs, :experiment_id, :integer
  end

  def self.down
    remove_column :constructs, :experiment_id
  end
end
