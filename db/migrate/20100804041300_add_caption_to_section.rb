class AddCaptionToSection < ActiveRecord::Migration
  def self.up
    add_column :sections, :caption, :text
  end

  def self.down
    remove_column :sections, :caption
  end
end
