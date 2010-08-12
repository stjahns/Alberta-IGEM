class AddColumnsToBiobytes < ActiveRecord::Migration
  def self.up
    add_column :bio_bytes, :biobrick_id, :string
    add_column :bio_bytes, :biobrick_backbone, :string
    add_column :bio_bytes, :biobyte_id, :string
    add_column :bio_bytes, :biobyte_plasmid, :string
    add_column :bio_bytes, :function_verification, :text
    add_column :bio_bytes, :comments, :text
  end

  def self.down
    remove_column :bio_bytes, :biobrick_id
    remove_column :bio_bytes, :biobrick_backbone
    remove_column :bio_bytes, :biobyte_id
    remove_column :bio_bytes, :biobyte_plasmid
    remove_column :bio_bytes, :function_verification
    remove_column :bio_bytes, :comments
  end
end
