class CreateBioBytes < ActiveRecord::Migration
  def self.up
    create_table :bio_bytes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bio_bytes
  end
end
