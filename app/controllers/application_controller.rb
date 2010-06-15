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
        if logged_in? && current_user.login == "admin"
          true
        else
          false
        end
  end

  helper_method :is_owner
  def is_owner( user_id )
	if logged_in? && ( current_user.login == 'admin' || current_user.id  == user_id ) 
	  true
	else
	  false
	end
  end

end
