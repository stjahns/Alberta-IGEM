# == Schema Information
# Schema version: 20100726173047
#
# Table name: bio_bytes
#
#  id            :integer(4)      not null, primary key
#  type          :string(255)
#  name          :string(255)
#  description   :string(255)
#  sequence      :string(255)
#  author        :string(255)
#  img_file_name :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  image_id      :integer(4)
#

class BioByte < ActiveRecord::Base
  has_many :parts
  has_many :annotations
  belongs_to :image
  has_one :bio_byte_image

  def icon
	#return the image object that contains the biobyte icon
	self.image
  end
  def function_image
	#return the function image 
	linker =  self.bio_byte_image || return
	linker.image  
  end
#TODO add validation
  #TODO change bio_byte_image to has_one :through association?

end
