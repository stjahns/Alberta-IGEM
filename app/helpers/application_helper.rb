# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
# File lib/will_paginate/view_helpers.rb, line 167
    def search_page_info(search_term, collection, options = {})
      if collection.total_pages < 2
        case collection.size
        when 0; "No results found for search: #{search_term}"
        when 1; "Displaying <b>1</b> result for search: #{search_term}"
        else;   "Displaying <b>all #{collection.size}</b> results for search: #{search_term}"
        end
      else
        %{Displaying <b>%d to %d</b> of <b>%d</b> total results found for search: #{search_term}}% [
          collection.offset + 1,
          collection.offset + collection.length,
          collection.total_entries
        ]
      end
    end
	def search_box( path, name )
		render :partial => "shared/search_form", 
			:locals =>{:path => path, :name=>name }
	end
		

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
		links = { :glossary => link_to( "GLOSSARY", glossaries_path ),
			:articles => link_to( "ARTICLES", encyclopaedias_path ),
			:manual => link_to( "LAB MANUAL", experiments_path ),
			:parts => link_to( "PARTS BIN", bio_bytes_path ),
			:groups => link_to( "GROUPS", groups_path ),
			:sandbox => link_to( "SANDBOX", sandbox_path ),
			:home => link_to( "HOME", root_path ) }
		order = [:home,:sandbox,:groups,:parts,:manual,:articles,:glossary]
		order.each do |page|
			output += "<li"
			output += ' class="selected"' if page == selection
			output += ">#{links[page]}</li>\n"
		end
		output
	end



end
