class CreateORves < ActiveRecord::Migration
  def self.up
    create_table :orves do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :orves
  end
end
