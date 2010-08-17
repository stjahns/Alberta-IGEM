class AddEncyclopaediaToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :encyclopaedia_id, :integer
  end

  def self.down
    remove_column :images, :encyclopaedia_id
  end
end
