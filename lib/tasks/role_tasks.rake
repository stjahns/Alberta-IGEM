namespace :roles do
  
  desc "Remake the permissions for the role"
  task :build_permissions => :environment do
	# run role/permissions.rb
	require 'roles/permissions'
  end
end
