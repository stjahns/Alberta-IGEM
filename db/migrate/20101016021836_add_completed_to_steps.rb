class AddCompletedToSteps < ActiveRecord::Migration
  def self.up
    add_column :steps, :completed, :boolean, :default => false
  end

  def self.down
    remove_column :steps, :completed
  end
end
