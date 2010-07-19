# == Schema Information
# Schema version: 20100719175140
#
# Table name: groups
#
#  id          :integer(4)      not null, primary key
#  role_id     :integer(4)
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Group < ActiveRecord::Base
	has_many :users
	
	attr_accessible :name, :description

#	before_create :create_role

#	def admins
#		#self.role.users
#	end
#	def admin_role
#		self.role
#	end

	private
	def create_role
		#TODO change this to use steves permissions
#		admin_role = Role.create( :name => 'group_admin' )
#		self.role = admin_role
	end
end
