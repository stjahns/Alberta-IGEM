class CreateParts < ActiveRecord::Migration
  def self.up
    create_table :parts do |t|
      t.integer   :construct_id
      t.integer   :bio_byte_id
      t.integer   :part_order
      #maybe some user set annotations, author, etc.
      t.timestamps #  is this necessary?
    end
  end

  def self.down
    drop_table :parts
  end
end
