class AddStepOrderToSteps < ActiveRecord::Migration
  def self.up
    rename_column :steps, :order, :step_order
  end

  def self.down
    remove_column :steps, :step_order
  end
end
