class CreateImageFiles < ActiveRecord::Migration
  def self.up
    create_table :image_files do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :image_files
  end
end
