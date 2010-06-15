# == Schema Information
# Schema version: 20100615162153
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
#

class BioByte < ActiveRecord::Base
  has_many :parts
  has_many :annotations

#TODO add validation

end
