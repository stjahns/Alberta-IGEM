class ActiveRecord::Base
	def permissions_for( user )
		user.permissions
	end
end
