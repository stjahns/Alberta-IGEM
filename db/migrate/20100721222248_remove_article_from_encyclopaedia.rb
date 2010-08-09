class RemoveArticleFromEncyclopaedia < ActiveRecord::Migration
  def self.up
    remove_column :encyclopaedias, :Article
  end

  def self.down
    add_column :encyclopaedias, :Article, :text
  end
end
