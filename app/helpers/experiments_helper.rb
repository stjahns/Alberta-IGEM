module ExperimentsHelper
=begin		def experiment_status( experiment ) 
			if experiment.complete?
				image = "complete_status_large.jpg"

			elsif experiment.working?
				image = "working_status_large.jpg"
			
			else
				image = "no_status_large.jpg"
			end	

			image_tag image
		end


		def select_status( experiment )
			status = experiment.status
			"
			<div class="status-form">
			<a class=\"current-status\"></a>
			#{form_ta}
			</div>"
			
		end
=end
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
