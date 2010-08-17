namespace :roles do
  
  desc "Remake the permissions for the role"
  task :build_permissions => :environment do
	puts "building...."
	# run role/permissions.rb
	require 'roles/permissions'
	puts "done"
  end
end
