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
