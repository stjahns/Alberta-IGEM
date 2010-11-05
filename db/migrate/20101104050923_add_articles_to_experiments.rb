class AddArticlesToExperiments < ActiveRecord::Migration
  def self.up
    add_column :experiments, :articles, :string
  end

  def self.down
    remove_column :experiments, :articles
  end
end
