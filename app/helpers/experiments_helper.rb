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
=end
		def total_experiment_status( owner )
			# can be used for group or user

			tcomplete = owner.experiments_completed
			tworking  = owner.experiments_working
			tnone	  = owner.experiments.all.length - tcomplete - tworking
		        "<p>#{tcomplete}, #{tworking}, #{tnone}</p>"	


		end
		def experiment_status( type, number )
			"<span class=\"#{type}\" >#{number}</span>"
		end
			
end
