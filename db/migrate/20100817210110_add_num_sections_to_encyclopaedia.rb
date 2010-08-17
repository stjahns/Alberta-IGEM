class AddNumSectionsToEncyclopaedia < ActiveRecord::Migration
  def self.up
    add_column :encyclopaedias, :num_sections, :integer
  end

  def self.down
    remove_column :encyclopaedias, :num_sections
  end
end
