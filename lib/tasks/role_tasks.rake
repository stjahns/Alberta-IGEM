namespace :roles do
  
  desc "Remake the permissions for the role"
  task :build_permissions => :environment do
	puts "building...."
	# run role/permissions.rb
	require 'roles/permissions'
	puts "done"
  end

  desc "Add a guest role and user for locking down the whole site"
  task :build_guest => :build_permissions do
	  puts "adding guest role... "
	  require 'roles/guest_permissions'
	  puts "done"

	  #add a guest user if one does not exist already
	  if User.find_by_login("guest")
		  puts "guest already exist, no need to make"
	  else
		  puts "no guest user found, making a guest user now..."
		  pass = nil
		  confirm = nil
		  begin 
		  	print "please choose a password:"
		 	pass = STDIN.gets.chomp
		 	print "please confirm password:"
		  	confirm = STDIN.gets.chomp
		  end while pass != confirm

		  guest = User.new( :login => "guest", :email => "guest@genomikon.com", :password => pass , :password_confirmation => confirm )

		  if guest.save && guest.activate! 
			  puts "guest created!"
		  else
			  puts "error creating guest:"
			  guest.errors.each do |e|
			  	puts "#{e[0]} #{e[1]}"
			  end
		  end
	  end

  end

  desc "remove the guest user"
  task :destroy_guest => :environment do 
	  puts "removing guest"
	  guest = User.find_by_login( "guest" )
	  guest.delete if guest

  end

end
