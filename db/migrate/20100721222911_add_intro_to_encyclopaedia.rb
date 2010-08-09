class AddIntroToEncyclopaedia < ActiveRecord::Migration
  def self.up
    add_column :encyclopaedias, :intro, :text
  end

  def self.down
    remove_column :encyclopaedias, :intro
  end
end
