class CreateConstructs < ActiveRecord::Migration
  def self.up
    create_table :constructs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :constructs
  end
end
