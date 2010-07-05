class CreateStepGenerators < ActiveRecord::Migration
  def self.up
    create_table :step_generators do |t|
      t.string    :subprotocol #pre part addition, part addition, etc
      t.integer   :sub_order   #order of step within subprotocol
      t.string    :title
      t.string    :description #markup'd template strings
      t.timestamps
    end
  end

  def self.down
    drop_table :step_generators
  end
end
