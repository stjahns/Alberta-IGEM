module ExperimentsHelper
		def total_experiment_status( owner )
			# can be used for group or user

			tcomplete = owner.experiments_completed
			tworking  = owner.experiments_working
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
			"<a #{status} >#{number}</a>"
		end
end
