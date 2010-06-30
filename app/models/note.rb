# == Schema Information
# Schema version: 20100628162016
#
# Table name: notes
#
#  id         :integer(4)      not null, primary key
#  step_id    :integer(4)
#  text       :string(255)
#  image_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Note < ActiveRecord::Base
	attr_accessible :text, :image 
        belongs_to :step
	has_one :image, :dependent => :destroy


	private
	

end
