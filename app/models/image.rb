# == Schema Information
# Schema version: 20100628162016
#
# Table name: images
#
#  id             :integer(4)      not null, primary key
#  owner_id       :integer(4)
#  image_filename :string(255)
#  image_width    :integer(4)
#  image_height   :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#  step_id        :integer(4)
#  owner_type     :integer(4)
#

class Image < ActiveRecord::Base
   acts_as_fleximage :image_directory => 'public/images/fullsize'

   belongs_to :step
   belongs_to :note
end
