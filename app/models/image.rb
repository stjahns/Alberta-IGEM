# == Schema Information
# Schema version: 20100629180631
#
# Table name: images
#
#  id             :integer(4)      not null, primary key
#  image_filename :string(255)
#  image_width    :integer(4)
#  image_height   :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#  step_id        :integer(4)
#  note_id        :integer(4)
#

class Image < ActiveRecord::Base
   acts_as_fleximage :image_directory => 'public/images/fullsize'

   belongs_to :step
   belongs_to :note
   has_one :bio_byte
end
