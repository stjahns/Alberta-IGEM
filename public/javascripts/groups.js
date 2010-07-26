$(document).ready(function(){
	$('#btn-new-key').click( function() {
		var form = $(this).next('.button-to');
		var key = $('#group-key');
		var msg = 'If you generate a new key the old key will no longer work!  Are you sure you want to continue?';

		form.ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){

					if( confirm( msg ) ){
						key.addClass('loading');
						return true;
					}
					return false;
				},
		  	success: function(data) { 
		  	 	// remove the old content and insert new stuff
				key.removeClass('loading').html(data)
				.css('background-color', '#c7ffc4' )
				.delay('1000')
				.animate({backgroundColor: '#fff'},3000)
			  },
			//TODO figure why this is not being called on an error
			error: function() {
				alert('error');
				var e = $(document.createElement('span'))
					.attr('id','group-key-error')
					.html('There was an error, key was not changed.');
				key.removeClass('loading')
				.css('background-color','#ff8593')
				.insertAfter(e);
				setTimeout( function(){
					key
					.animate({backgroundColor:'#fff'},3000);
					e.fadeOut('3000', function() {
						e.remove();
					});
				},2000);
			}
		});
		return false;
	});

});
