class RemoveImageIdFromStep < ActiveRecord::Migration
  def self.up
    remove_column :steps, :image_id
  end

  def self.down
    add_column :steps, :image_id, :integer
  end
end
