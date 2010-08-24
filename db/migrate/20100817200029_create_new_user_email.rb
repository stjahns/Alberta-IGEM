class CreateNewUserEmail < ActiveRecord::Migration
  def self.up
    create_table :new_user_emails do |t|
      t.string :email
      t.string :key
      t.integer :user_id
      t.timestamps
    end
 
  end

  def self.down
	  drop_table :new_user_emails
  end
end
