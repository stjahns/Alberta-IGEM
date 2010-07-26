class Request < ActiveRecord::Base
	belongs_to :group
	belongs_to :user


	attr_accessible :user, :group, :message
	

end
