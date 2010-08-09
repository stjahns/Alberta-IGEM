class CreateEmailObservers < ActiveRecord::Migration
  def self.up
    create_table :email_observers do |t|
      t.string :email
      t.string :key

      t.timestamps
    end
  end

  def self.down
    drop_table :email_observers
  end
end
