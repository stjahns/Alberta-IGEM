# == Schema Information
# Schema version: 20100728230826
#
# Table name: constructs
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  description   :string(255)
#  author        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  experiment_id :integer(4)
#

######################################################
=begin
Construct object
=end
#######################################################

class Construct < ActiveRecord::Base
  has_many :parts, :dependent => :destroy
  belongs_to :experiment

  def part_order
    Part.find(:all, :order => "part_order", :conditions =>{:construct_id => self.id})
  end
  
end 
