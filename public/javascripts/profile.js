$(document).ready(function(){
	$('.btn-cancel-request').click( function(){
		var request = $(this).parents('request');
		var form = $(this).next('form');
		var save_notice = $('.save-notice', request );

		form.ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				return confirm("Are you sure?");
				},
			success: function(data) { 
				request.slideUp(function(){
					request.remove();
				});
			  },
			error: function() {
				error_message( save_notice, "There was an error rejecting the request.");
			
			}
		});
		return false;

	});

});

