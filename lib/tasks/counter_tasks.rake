  
  desc "count the experiments"
  task :count_experiments => :environment do
	all_users = User.all
	puts "counting experiments for #{all_users.length} users...."

	all_users.each do |user|
		print "user: #{user.id}\t"
		user.complete_counter = user.experiments_completed.length
		print "complete:#{user.complete_counter}\t"
		user.working_counter = user.experiments_working.length
		puts "working:#{user.working_counter}"
		print "saving .... "
		user.save || print( "Error: user #{user.id} not saved\n"); 
		print"\n"
	end
	puts "done"
  end

