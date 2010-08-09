class AddVideoTitleToSection < ActiveRecord::Migration
  def self.up
    add_column :sections, :video_title, :text
  end

  def self.down
    remove_column :sections, :video_title
  end
end
