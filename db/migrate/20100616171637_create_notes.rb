class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :step_id
      t.integer :user_id
      t.string :text
      t.integer :image_id

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
