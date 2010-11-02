# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem
  # Scrub sensitive parameters from your log
  
  # if the site is locked must be logged in to do anything
  before_filter( :lock_site ) if SITE_LOCKED

  
  # pretty url helpers for group and user 
  helper_method :pretty_group_path
  helper_method :pretty_group_url
  def pretty_group_path( group )
		"/groups/#{group.name.gsub(/ /,"_")}"
  end	
  def pretty_group_url( group )
	  pretty_group_path( group )
  end
  helper_method :pretty_user_path
  helper_method :pretty_user_url
  def pretty_user_path( user )
		"/users/#{user.login}"
  end	
  def pretty_user_url( user )
	  pretty_user_path( user )
  end
  helper_method :profile_path
  def profile_path( user )
	  pretty_user_path( user )
  end

  # NOTE don't use this method in place of roles
  helper_method :is_owner_of
  def is_owner_of( object )
	logged_in? && ( current_user.id  == object.user.id ) 
  end

 
  # use this function when checking for permission of something
  def permission_denied
	flash[:notice] = "You don't have permission to do that!"
	redirect_back_or_default('/')
  end

  # overrides the default function for the filter login_required
  def access_denied
	  flash[:error] = "You must login to continue."
	  redirect_to login_path
  end

  def is_admin
    unless logged_in? and current_user.is_an_admin?
      redirect_to root_path
    end
  end

  private

  def lock_site
 	 unless logged_in?
		 flash[:error] = "You must login to view the site."
	 	 redirect_to root_path 
	 end
  end

end
