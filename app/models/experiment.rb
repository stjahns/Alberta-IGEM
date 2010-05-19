# == Schema Information
# Schema version: 20100519203759
#
# Table name: experiments
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Experiment < ActiveRecord::Base
  attr_accessor :name, :authour
  attr_accessible :name, :authour
  

  has_many :steps
  has_many :definitions
  has_many :articles
end
