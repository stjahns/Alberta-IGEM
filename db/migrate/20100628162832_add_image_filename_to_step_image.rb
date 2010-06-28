class AddImageFilenameToStepImage < ActiveRecord::Migration
  def self.up
    add_column :step_images, :image_filename, :string
  end

  def self.down
    remove_column :step_images, :image_filename
  end
end
