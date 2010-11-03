class HomeController < ApplicationController
	layout 'home'
 	before_filter :set_nav
  	# skip_before_filter( :lock_site ) if SITE_LOCKED
	skip_before_filter :lock_site 


	# SITE_LOCKED is defined in config/environments/[environment].rb	
	def index
		if SITE_LOCKED && !logged_in?
			render "site_lock"
		end
	end

    def about
      @navbar_selected = :about
    end

	private
	def set_nav
	  @navbar_selected = :home
	end
end
