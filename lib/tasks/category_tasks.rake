namespace :categories do
  
  desc "Create byte categories"
  task :build_categories => :environment do
	# run lib/tasks/categories.rb
	require 'lib/tasks/categories'
  end

end
