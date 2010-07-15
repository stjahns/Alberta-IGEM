module ExperimentsHelper
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
end
