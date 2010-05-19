class Experiment < ActiveRecord::Base
  attr_accessor :name, :authour
  attr_accessible :name, :authour
  

  has_many :steps
  has_many :definitions
  has_many :articles
end
