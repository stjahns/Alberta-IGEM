$(document).ready( function(){
	//button show the form for editing an experiment
	$(".btn-edit-experiment").live( 'click', function() {
			exp  = $(this).parents('div.experiment-description-container');
			view = $('div.lab-book',exp ); 
			edit = $('div.edit-experiment', exp);
			if( view.is(':visible') ){
				view.hide();
				edit.show();
				$(this).html('Show');
			}
			else{
				edit.hide();
				view.show();
				$(this).html('Edit');
			}
			return false;
	});

	// button to delete an experiment
	$('.btn-delete-experiment').live( 'click', function(){
		var exp = $(this).parents('div.experiment-description-container');
		var save_notice = $('div.lab-book',exp).find('.save-notice');
		$(this).siblings('form.button-to').ajaxSubmit({
			dataType: 'html',
			beforeSubmit: function(){
			   return confirm(
				'Are you sure you want to delete this experiment?');},
			success: function(data) { 
			   exp.slideUp(function(){
				exp.remove();	   
			   });
			  },
			error: function() {
				error_message(save_notice, "Error: experiment could not be deleted.");
			}
		});
		return false;
	});
	
	// publish form checkbox submits when changed
	$('.publish-experiment').live('change',function(){
		var save_notice = $('.save-notice',this);
		var published = $(".checkbox",this);
		if( publish_status_changed(published) ){
			//submit change
			$(this).ajaxSubmit( {
					dataType: 'html',
		  	success: function(data,statusText ) { 
			  	// status changed to published
				var message = published.is(':checked') ? 
			       		"Experiment published" :
					"Experiment unpublished" ;	
				success_message( save_notice, message);

		        },
			error: function() {
				var message = "Sorry there was an error.";

				if( published.is(':checked')){
					// uncheck
					published.removeAttr('checked');
					message = message + "  The experiment could not be published.";
				}
				else{
					// check
					published.attr('checked','checked');
					message = message + "  The experiment could not be unpublished.";
				}
			error_message(save_notice, message);
			}
		});
		}
	});


});
