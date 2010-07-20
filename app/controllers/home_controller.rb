class HomeController < ApplicationController
	layout 'home';
 	before_filter :set_nav


	private
	def set_nav
	  @navbar_selected = :home
	end
end
