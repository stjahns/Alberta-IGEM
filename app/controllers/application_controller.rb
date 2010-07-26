# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  helper_method :is_admin? #makes this method available from views as well
  def is_admin? 
    # logged_in? && current_user.is_admin?
	 true
  end

  # replace the use of this method with has_role
  helper_method :is_owner_of
  def is_owner_of( object )
		logged_in? && ( current_user.is_an_admin? || current_user.id  == object.user.id ) 
  end

  helper_method :can_edit_experiment?
  def can_edit_experiment?( experiment )
		logged_in? && ( current_user.can_edit_experiments? || 
                    (current_user.id  == experiment.user.id && 
                      current_user.can_edit_own_experiments?) )
  end

  helper_method :can_create_experiment_for?
  def can_create_experiment_for?( user )
		logged_in? && ( current_user.can_create_experiments? ||
                     ( current_user == user && 
                        current_user.can_create_own_experiments?))
  end
  
  # use this function when checking for permission of something
  def permission_denied
	flash[:notice] = "You don't have permission to do that!"
	redirect_back_or_default('/')
  end


end
