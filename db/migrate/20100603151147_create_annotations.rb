class CreateAnnotations < ActiveRecord::Migration
  def self.up
    create_table :annotations do |t|
      t.string      :name
      t.integer     :bio_byte_id
      t.string      :description
      t.string      :img_file_name #for manual
      t.string     :colour  #for editor
      t.integer     :start #relative to byte start
      t.integer     :stop
      t.integer     :strand #1=forward, 0=reverse?
      t.string      :author
      t.timestamps
    end
  end

  def self.down
    drop_table :annotations
  end
end
