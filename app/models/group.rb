# == Schema Information
# Schema version: 20100728230826
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

	has_many :users, :through=>:group_roles
	
	has_many :group_roles
	#has_and_belongs_to_many :users
	
	attr_accessible :name, :description

#	before_create :create_role
#	after_create :assign_role

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
		# if the user submits the correct key then
		# add user to group with member role
		create_member( user )
	end

	def permissions_for( user )
		# give permissions for the role 
		role_for_group = user.group_roles.find_by_group_id( self.id )
		if role_for_group.nil? 
			return user.permissions
		else	
			return role_for_group.permissions
		end
	end

	def create_admin( user )
		create_role user, "group_admin"
	end

	def create_member( user )
		create_role user, "group_member"
	end

	private
	def create_role( user, name_of_role )
	  	r = self.group_roles.new
		r.user = user
  	  	r.role = Role.find_by_name( name_of_role  )	  
		r.save
	end
end
