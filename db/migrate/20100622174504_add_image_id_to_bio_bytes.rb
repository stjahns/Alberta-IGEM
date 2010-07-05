class AddImageIdToBioBytes < ActiveRecord::Migration
  def self.up
    add_column :bio_bytes, :image_id, :integer
  end

  def self.down
    remove_column :bio_bytes, :image_id
  end
end
