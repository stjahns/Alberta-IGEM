class CreateBioByteImages < ActiveRecord::Migration
  def self.up
    create_table :bio_byte_images do |t|
      t.integer   :bio_byte_id
      t.integer   :image_id
      t.timestamps
    end
  end

  def self.down
    drop_table :bio_byte_images
  end
end
