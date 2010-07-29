class CreateGroupRoles < ActiveRecord::Migration
  def self.up
    create_table :group_roles do |t|
      t.integer :group_id
      t.integer :role_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_roles
  end
end
