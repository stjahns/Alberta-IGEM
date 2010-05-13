class CreateLinkers < ActiveRecord::Migration
  def self.up
    create_table :linkers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :linkers
  end
end
