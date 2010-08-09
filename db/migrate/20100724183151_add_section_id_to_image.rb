class AddSectionIdToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :section_id, :integer
  end

  def self.down
    remove_column :images, :section_id
  end
end
