class AddImageFileIdToSteps < ActiveRecord::Migration
  def self.up
	  add_column :steps, :image_file_id, :integer
  end

  def self.down
	  remove_column :steps, :image_file_id
  end
end
