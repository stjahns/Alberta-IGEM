# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def more_text( text, length )
		    if text.length > length
				  "<p>#{text[0..length]}" + 
				  '<a class="more" href="#">...more</a>' +
				  '<span class="more">'+"#{text[151..text.length]}" + 
				  '<a class="less" href="#">...less</a></span></p> '

			else
					"<p>#{text}</p>"
			end
		end
	def save_notice
  		'<span class="save-notice"></span>'
	end
	
	def nav_bar_select( selection )
		output = ""
		links = { :glossary => link_to( "Glossary", glossaries_path ),
			:articles => link_to( "Articles", encyclopaedias_path ),
			:manual => link_to( "Lab Manual", experiments_path ),
			:parts => link_to( "Parts Bin", bio_bytes_path ),
			:groups => link_to( "Groups", groups_path ),
			:home => link_to( "Home", root_path ) }
		order = [:home,:groups,:parts,:manual,:articles,:glossary].reverse  
		order.each do |page|
			output += "<li"
			output += ' class="selected"' if page == selection
			output += ">#{links[page]}</li>\n"
		end
		output
	end



end
