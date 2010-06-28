class AddImageWidthAndImageHeightToStepImage < ActiveRecord::Migration
  def self.up
    add_column :step_images, :image_width, :integer
    add_column :step_images, :image_height, :integer
  end

  def self.down
    remove_column :step_images, :image_height
    remove_column :step_images, :image_width
  end
end
