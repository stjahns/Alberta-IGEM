class AddBackboneIdToBioBytes < ActiveRecord::Migration
  def self.up
    add_column :bio_bytes, :backbone_id, :integer
  end

  def self.down
    remove_column :bio_bytes, :backbone_id
  end
end
