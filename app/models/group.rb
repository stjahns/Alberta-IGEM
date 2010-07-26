# == Schema Information
# Schema version: 20100726173047
#
# Table name: groups
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  key         :string(255)
#

class Group < ActiveRecord::Base
	has_many :messages
	has_many :requests

	before_create :generate_new_key
	has_and_belongs_to_many :users
	
	attr_accessible :name, :description

#	before_create :create_role

#	def admins
#		#self.role.users
#	end
#	def admin_role
#		self.role
#	end
	#
	def generate_key
		self.key =  ActiveSupport::SecureRandom.hex(5) 
	end

	def generate_new_key
		self.generate_key
		self.save
		self.key
	end

	def join_with_key( user, key )
		return false unless key == self.key
		# if the user submits the correct key than make
		#  them join the group
		user.group = self
		user.save
	end

	private
	def create_role
		#TODO change this to use steves permissions
#admin_role = Role.create( :name => 'group_admin' )
#self.role = admin_role
	end
end
