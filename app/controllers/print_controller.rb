class PrintController < ApplicationController
	def print
		# name with unique name
		file_name = "#{ ( Time.now.to_f * 10000 ).to_i }" + 'temp.pdf.erb'

		# get the html
		html = CGI::unescapeHTML( params[:page_content] )
		# that one might not do anything
		html.gsub!(/&quot;/,'')

		# change paths to local paths
		html.gsub!( /url\(\s*"(.+?)\s*"\)/, "url(#{RAILS_ROOT}/public"+'\1)' )
		#NOTE this will only work when caching is on!
		html.gsub!( /src="(.+?)"/,"src=\"#{RAILS_ROOT}/public" + '\1' + '"' )

		#TODO in order for this to work everywhere we need to cache css
		#sheets with all url changed to absolute locations and use these
		#for the pdf generation 

		# TODO add page breaks somehow!!!

		#write to a temp file
		temp_file = File.open( 'app/views/print/' + file_name , 'w') do |f|
		       f.write( html )	
		end
		
		@name = params[:name]

		# render pdf with wkhtmltopdf
		render :pdf => @name, 
		       :template => 'print/' + file_name,
		       :layout => 'pdf'

		# delete the temp file
		File.delete( 'app/views/print/' + file_name )


	end
end
 
