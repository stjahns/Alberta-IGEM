class AddMessageToRequest < ActiveRecord::Migration
  def self.up
    add_column :requests, :message, :text
  end

  def self.down
    remove_column :requests, :message
  end
end
