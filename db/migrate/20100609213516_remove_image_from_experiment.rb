class RemoveImageFromExperiment < ActiveRecord::Migration
  def self.up
	  remove_column :experiments, :image
  end

  def self.down
	  add_column :experiments, :image, :string
  end
end
