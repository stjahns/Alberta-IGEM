class CreateBackbones < ActiveRecord::Migration
  def self.up
    create_table :backbones do |t|
      t.string    :name
      t.string    :prefix
      t.string    :suffix
    end
  end

  def self.down
    drop_table :backbones
  end
end
