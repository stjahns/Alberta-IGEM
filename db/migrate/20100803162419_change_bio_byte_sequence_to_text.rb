class ChangeBioByteSequenceToText < ActiveRecord::Migration
  def self.up
    remove_column :bio_bytes, :sequence
    add_column :bio_bytes, :sequence, :text
  end

  def self.down
    remove_column :bio_bytes, :sequence
    add_column :bio_bytes, :sequence, :string
  end
end
