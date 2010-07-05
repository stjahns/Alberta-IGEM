class CreateImageFiles < ActiveRecord::Migration
  def self.up
    create_table :image_files do |t|
	t.column :image_filename, :string
	t.column :image_width, :integer
	t.column :image_height, :integer
      	t.timestamps
    end
  end

  def self.down
    drop_table :image_files
  end
end
