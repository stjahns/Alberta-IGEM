# == Schema Information
# Schema version: 20100728230826
#
# Table name: group_roles
#
#  id         :integer(4)      not null, primary key
#  group_id   :integer(4)
#  role_id    :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class GroupRole < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	belongs_to :role

	delegate :permissions, :to=>:role

	# this member connects a user with a group and a role
	# for example a user could be a group member in one group
	# and a group admin in another
	# 
end
