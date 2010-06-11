class CreateBioBytes < ActiveRecord::Migration
  def self.up
    create_table :bio_bytes do |t|
      t.string      :type #for sti
      t.string      :name
      t.string      :description
      t.string      :sequence     #consider optimizing with binary?
      t.string      :author
      t.string      :img_file_name
      t.timestamps
    end
  end

  def self.down
    drop_table :bio_bytes
  end
end
