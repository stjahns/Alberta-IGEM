# == Schema Information
# Schema version: 20100629180631
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

#TODO add validation

end
