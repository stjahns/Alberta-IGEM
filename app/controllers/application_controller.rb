# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  helper_method :is_admin?
  def is_admin? 
     logged_in? && current_user.login == "admin"
  end

  helper_method :is_owner_of
  def is_owner_of( object )
	logged_in? && ( current_user.login == 'admin' || current_user.id  == object.user.id ) 
  end

end
