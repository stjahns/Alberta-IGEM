class AddImageWidthAndImageHeightToThumb < ActiveRecord::Migration
  def self.up
    add_column :step_thumbs, :image_width, :integer
    add_column :step_thumbs, :image_height, :integer
  end

  def self.down
    remove_column :thumbs, :image_height
    remove_column :thumbs, :image_width
  end
end
