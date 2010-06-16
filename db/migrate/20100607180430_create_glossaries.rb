class CreateGlossaries < ActiveRecord::Migration
  def self.up
    create_table :glossaries do |t|
      t.string :term
      t.text :definition

      t.timestamps
    end
  end

  def self.down
    drop_table :glossaries
  end
end
