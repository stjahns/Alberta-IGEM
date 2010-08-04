class AddValStringToBioBytes < ActiveRecord::Migration
  def self.up
    add_column :bio_bytes, :val_string, :text
  end

  def self.down
    remove_column :bio_bytes, :val_string
  end
end
