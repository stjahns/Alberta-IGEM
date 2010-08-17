namespace :roles do
  
  desc "Remake the permissions for the role"
  task :build_permissions => :environment do
	# run roles/permissions.rb
	require 'roles/permissions'
  end

end
