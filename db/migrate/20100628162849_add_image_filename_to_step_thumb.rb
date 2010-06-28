class AddImageFilenameToStepThumb < ActiveRecord::Migration
  def self.up
    add_column :step_thumbs, :image_filename, :string
  end

  def self.down
    remove_column :step_thumbs, :image_filename
  end
end
