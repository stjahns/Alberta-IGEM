class RenameImageFileIdToImageIdInSteps < ActiveRecord::Migration
  def self.up
	  rename_column :steps, :image_file_id, :image_id
  end

  def self.down
     	rename_column :steps, :image_id, :image_file_id
  end
end
