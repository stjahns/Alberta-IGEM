class AddPhotoCaptionToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :caption, :text
  end

  def self.down
    remove_column :images, :caption
  end
end
