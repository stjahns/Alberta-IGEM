class RemoveImageFromStep < ActiveRecord::Migration
  def self.up
	  remove_column :steps, :image
  end

  def self.down
	  add_column :steps, :image, :string
  end
end
