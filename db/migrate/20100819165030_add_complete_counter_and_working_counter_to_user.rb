class AddCompleteCounterAndWorkingCounterToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :complete_counter, :integer
    add_column :users, :working_counter, :integer
  end

  def self.down
    remove_column :users, :working_counter
    remove_column :users, :complete_counter
  end
end
