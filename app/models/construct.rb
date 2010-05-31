######################################################
=begin
Construct object
=end
#######################################################

class Construct < ActiveRecord::Base
  has_many :parts

  before_destroy :destroy_parts
  def destroy_parts
    self.parts.each do |part|
      part.destroy
    end
  end

  def part_order
    Part.find(:all, :order => "part_order", :conditions =>{:construct_id => self.id})
  end
  
end 
