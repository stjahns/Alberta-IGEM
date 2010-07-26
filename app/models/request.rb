# == Schema Information
# Schema version: 20100726173047
#
# Table name: requests
#
#  id         :integer(4)      not null, primary key
#  group_id   :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  message    :text
#

class Request < ActiveRecord::Base
	belongs_to :group
	belongs_to :user


	attr_accessible :user, :group, :message
	

end
