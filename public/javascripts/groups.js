$(document).ready(function(){
	$('#btn-new-key').click( function() {
		var form = $(this).next('.button-to');
		var key = $('#group-key');
		key.addClass('loading');

		form.ajaxSubmit( {
			dataType: 'html',
		  	success: function(data) { 
		  	 	// remove the old content and insert new stuff
				key.removeClass('loading').html(data)
				.css('background-color', '#c7ffc4' )
				.delay('1000')
				.animate({backgroundColor: '#fff'},3000)
			  },
			error: function() {
				error_message(save_notice, "Error: The step could not be updated.");
			}
		});
		return false;
	});

});
