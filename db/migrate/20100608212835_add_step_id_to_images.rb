class AddStepIdToImages < ActiveRecord::Migration
  def self.up
	  add_column :images, :step_id, :integer
  end

  def self.down
	  remove_colun :images, :step_id
  end
end
