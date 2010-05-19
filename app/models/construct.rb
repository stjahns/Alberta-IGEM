######################################################
=begin
Construct object - contains array of parts->biobytes

  Attributes 
    -@parts - association related
    -@part_order - array of parts in correct order

  Methods
    -insert_part
    -destroy_part
    -destroy_parts (ALL)
    -replace_part
    -get_sequence
    -TODO get_part_order ??
    
    -For development:
      -display_construct
    
  Notes:
  TODO -> part_order needs to be called before anything will work..... deal with using controller later
  TODO -> Exception handling
  optimizations -> use arrays of id's??

=end
#######################################################

class Construct < ActiveRecord::Base
  has_many :parts

  attr_accessor :part_order #probably leave as writer
  
  # save order attributes in parts table after saving construct itself
  after_save :save_part_order
  def save_part_order
    
    @part_order.each{ |part| 
      part.update_attribute(:part_order, @part_order.index(part))
    }

  end

  before_destroy :destroy_parts
  def destroy_parts
    self.parts.each do |part|
      part.destroy
    end
  end

  after_find

  # TODO after_find -> initialize part_order, add functions to make interface smoother

  
  def insert_part( index, name )
    #TODO Add exception handing (index out of range)
    p = Part.new( :bio_byte => BioByte.find(:first, :conditions => {:name => name } ), 
                  :construct => self ) 
    self.parts << p #add to assoc.
    @part_order.insert(index, p)
    self.save
  end

  def replace_part( index, name )

    p = Part.new( :bio_byte => BioByte.find(:first, :conditions => {:name => name } ), 
                  :construct => self ) 
    self.parts << p #add to assoc.
    @part_order[index].destroy #kill old db entry
    @part_order[index] = p
    self.save #save new db entry

  end

  def destroy_part ( index )
    @part_order[index].destroy
    self.parts = part_order
    self.save
  end



  def display_parts

    @part_order.each {|part|
      puts "#{part_order.index(part)} : #{part.bio_byte.name}, Sequence: #{part.bio_byte.sequence}"
    }
    return true #to return something small...

  end


  def part_order
    @part_order=Part.find(:all, :order => "part_order", :conditions =>{:construct_id => self.id})
    self.parts=@part_order
#TODO adddd self.save??
  end
  
  def get_sequence
    @sequence = ""
    @part_order.each {|part|
      @sequence += part.bio_byte.sequence
    }
    return @sequence
  end  

end 
