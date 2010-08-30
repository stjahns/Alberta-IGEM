module ExperimentsHelper
		def total_experiment_status( owner )
			# can be used for group or user

			tcomplete = owner.complete_counter
			tworking  = owner.working_counter
			#tnone	  = owner.experiments.all.length - tcomplete - tworking
			"<div class=\"experiment-status\"><ul>" +
			"<li>#{experiment_status "complete",tcomplete }</li>" +
			"<li>#{experiment_status "working", tworking}</li>" +
			"</div"	
		end

		def experiment_status( *args )
			( type, number ) = args
			number = "" if number.nil?
		        status = type.nil? ? "" : "class=\"#{type}\"" 

			alt = type == "working" ? "In progress" :
			      type == "complete"? "Completed"   : 
				      "No status"

			"<a #{status} TITLE=\"#{alt}\" >#{number}</a>"
		end
end
