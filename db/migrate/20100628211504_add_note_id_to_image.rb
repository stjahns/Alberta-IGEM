class AddNoteIdToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :note_id, :integer
  end

  def self.down
    remove_column :images, :note_id
  end
end
