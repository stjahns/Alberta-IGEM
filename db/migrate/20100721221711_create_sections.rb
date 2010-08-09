class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.string :title
      t.text :description
      t.integer :encyclopaedia_id
      t.integer :section_order
      t.text :video

      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end
