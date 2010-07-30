# == Schema Information
# Schema version: 20100728230826
#
# Table name: bio_byte_images
#
#  id          :integer(4)      not null, primary key
#  bio_byte_id :integer(4)
#  image_id    :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class BioByteImage < ActiveRecord::Base
  # association model to link biobyte to an image for its description
  belongs_to :image
  belongs_to :bio_byte

end
