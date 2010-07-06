class CreateEncyclopaedias < ActiveRecord::Migration
  def self.up
    create_table :encyclopaedias do |t|
      t.string :title
      t.text :article

      t.timestamps
    end
  end

  def self.down
    drop_table :encyclopaedias
  end
end
