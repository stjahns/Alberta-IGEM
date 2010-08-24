module PrintHelper

	# this form require javascript to take the html from the page
	# and post it to the server, this allows printing of dynamic content
	# that can be changed in the browser
	def print_to_pdf_btn id, name_of_doc, *args
		name_of_btn = args[0]
		
		render :partial => 'print/print_form', :locals => {
			:id => id, 
			:name_of_btn => name_of_btn, 
			:name_of_doc => name_of_doc }
	end



end
