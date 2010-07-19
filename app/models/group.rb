class Group < ActiveRecord::Base
	has_many :users
	belongs_to :role
	
	attr_accessible :name, :description

	before_create :create_role

	def admins
		self.role.users
	end
	def admin_role
		self.role
	end

	private
	def create_role
		admin_role = Role.create( :name => 'group_admin' )
		self.role = admin_role
	end
end
