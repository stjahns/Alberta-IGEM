# == Schema Information
# Schema version: 20100616171637
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
	attr_accessible :text, :image_id
        belongs_to :step

	has_one :image

        #only one note can exist for each step by each user
        before_create :destroy_other_notes

	private
	
	def destroy_other_notes
          old_note = self.step.note_for( self.user )
	  #puts( "#######################################\n #{old_note} ")
	  old_note.destroy if old_note
	end

end
