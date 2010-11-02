# == Schema Information
# Schema version: 20101030224800
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

	# note if this is set to genreate_new_key it creates an endless loop
	before_create :generate_key

	has_many :users, :through=>:group_roles
	has_many :experiments, :through=>:users
	
	has_many :group_roles
	#has_and_belongs_to_many :users


	# pagination stuff
	cattr_reader :per_page
	@@per_page = 10
		
	attr_accessible :name, :description


	validates_presence_of :name
	validates_length_of   :name, :within => 3..40
	validates_format_of :name, :with => /^(\s|[0-9a-zA-Z])+$/, :message=>"Only alphanumberic characters and spaces allowed"
  	validates_format_of :name, :with => /[a-zA-Z]/, :message=>"must contain at least one letter"
	validates_uniqueness_of :name, :case_sensitive => false

 


#	def admins
#		#self.role.users
#	end
#	def admin_role
#		self.role
#	end
	#
	def self.search(search,page)
		paginate :per_page => 10, :page => page,
			:conditions => ['name like ?', "%#{search}%" ],:order => 'name'
	end
	
	def generate_key
		self.key =  ActiveSupport::SecureRandom.hex(5) 
	end

	def generate_new_key
		generate_key
		self.save
		self.key
	end

	def join_with_key( user, key )
		return false unless key == self.key
		# if the user submits the correct key then
		# add user to group with member role
		create_member( user )
	end

	def request_to_join( user, message )
		request = Request.new( 
			:group=>self, :user=>user, :message=>message )
		request.save	
	end

	def permissions_for( user )
		# give permissions for the role 
		role_for_user = user.group_roles.find_by_group_id( self.id )
		
		if role_for_user.nil? 
			return user.permissions
		else	
			return role_for_user.permissions
		end
	end

	def role_for( user )
		user.group_roles.find_by_group_id( self.id ).role
	end

	def name_of_role_for( user )
		role = user.group_roles.find_by_group_id( self.id ).role
		role.description
	end

	def create_admin( user )
		create_role user, "group_admin"
	end

	def create_member( user )
		create_role user, "group_member"
	end

	def make_member_admin( user )
		change_role( user, "group_admin" )
	end

	def make_admin_member( user )
		change_role( user, "group_member" )
	end

	def ban_member( user )
		change_role( user, "banned" )
	end

	def unban_member( user )
		change_role( user, "group_member" )
	end

	def kick_out( user )
		r = self.group_roles.find_by_user_id( user.id )
		return false if r.blank?
		r.destroy
	end
	def complete_counter
		total = 0
		all_users =  self.users.all
		all_users.each do |user|
			total += user.complete_counter
		end
		total
	end
	def working_counter
		total = 0
		all_users = self.users.all
		all_users.each do |user|
			total += user.working_counter
		end
		total
	end


	private
	def change_role( user, name_of_role )
		r = self.group_roles.find_by_user_id( user.id )
		r.role = Role.find_by_name( name_of_role )
		r.save
	end
	def create_role( user, name_of_role )
	  	r = self.group_roles.new
		r.user = user
  	  	r.role = Role.find_by_name( name_of_role  )	  
		r.save
	end
end
