class RemoveEmailObserver < ActiveRecord::Migration
  def self.up
	drop_table :email_observers
  end

  def self.down
    create_table :email_observers do |t|
      t.string :email
      t.string :key
      t.integer :user_id
      t.timestamps
    end
  end
end
