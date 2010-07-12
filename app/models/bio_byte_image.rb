class BioByteImage < ActiveRecord::Base
  # association model to link biobyte to an image for its description
  belongs_to :image
  belongs_to :bio_byte

end
