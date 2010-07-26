# == Schema Information
# Schema version: 20100722183147
#
# Table name: annotations
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  bio_byte_id   :integer(4)
#  description   :string(255)
#  img_file_name :string(255)
#  colour        :string(255)
#  start         :integer(4)
#  stop          :integer(4)
#  strand        :integer(4)
#  author        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Annotation < ActiveRecord::Base
  belongs_to :bio_byte
  
end
