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

	// buttons for change in member roles
	roleBtn( '.btn-remove-admin' );
	roleBtn( '.btn-unban' );
	roleBtn( '.btn-ban' );
	roleBtn( '.btn-make-admin' );
	roleBtn( '.btn-kick-out-user' );

	//hide toolbars in members tab and show on hover
/*	var member_bar_up = true;
	$('div.member').live('mouseover mouseout', function(event){
		var btns = $('.hanging-toolbar ul li', $(this));
		if (event.type == 'mouseover' ){
			if( member_bar_up){	
				member_bar_up = false;
				btns.slideDown("slow");
			}
		 }   
		 else {
		 	setTimeout( function(){
				btns.slideUp("slow");
			},1500);
		 }
	});
	
	// slideDown toolbar on hover over member
	
*/	
	// buttons for rejecting and accepting requests to join the group
	$('.accept-request-btn').click( function(){
		var request = $(this).parents('.request');
		var form = $(this).next('form');
		var save_notice = $('.save-notice', request );

		form.ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				return confirm("Are you sure?");
				},
		  	success: function(data) { 
				$('#group-members').append( data );
				success_message( save_notice, "Member accepted" );
				setTimeout(function(){
					request.fadeOut("3000").remove()},3000);
			  },
			error: function() {
				error_message( save_notice, "There was an error accepting the request.");
			
			}
		});
		return false;

	});

	$('.reject-request-btn').click( function(){
		var request = $(this).parents('request');
		var form = $(this).next('form');
		var save_notice = $('.save-notice', request );

		form.ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				return confirm("Are you sure?");
				},
		  	success: function(data) { 
				success_message( save_notice, "Member rejected" );
				setTimeout(function(){
					request.fadeOut().remove()},3000);
			  },
			error: function() {
				error_message( save_notice, "There was an error rejecting the request.");
			
			}
		});
		return false;

	});

	$(".btn-delete-message").live('click', function(){
		var form = $(this).next('form');
		var message = $(this).parents('div.message');
		
		var save_notice = $('.save-notice', message );

		form.ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				return confirm("Are you sure?");
				},
		  	success: function(data) { 
				message.slideUp( function(){
					message.remove()});
			  },
			error: function() {
				error_message( save_notice, "There was an error deleting the message.");
			
			}
		});
		return false;

	});

	$('#new_message').submit(function(){
		var form = $(this);
		var save_notice = $('.save-notice',form);
		var text_area = $('textarea', form );

		form.ajaxSubmit({
			dataType: 'html',
			beforeSubmit: function(){
				text_area.addClass('loading');	
				},
		  	success: function(data) { 

				text_area.removeClass('loading')
				.css('background-color', '#c7ffc4' )
				.delay('1000')
				.animate({backgroundColor: '#fff'},3000)

/*
				text_area.removeClass('loading');

				success_message( save_notice, "Message sent");
*/
				form.reset();
				$('#group-messages').prepend(data);

			  },
			error: function() {
				text_area.removeClass('loading');
				error_message( save_notice, "There was an error sending the message.");
			}
		
			
		});
		return false;
	});


	$('#edit-group-info').submit(function(){
		var form = $(this);
		var save_notice = $('.save-notice',form);
		var text_area = $('textarea', form );
		var msg = 'Are you sure you want to save your changes to the group\'s info?';

		form.ajaxSubmit({
			dataType: 'html',
			beforeSubmit: function(){
				if( confirm( msg ) ){
					text_area.addClass('loading');	
					return true;
				}
				return false;		
			},
		  	success: function(data) { 
				text_area.removeClass('loading');
				success_message( save_notice, "Changes saved.");
				data = $(data).hide();
				$('#group-info').replaceWith(data);

			  },
			error: function() {
				text_area.removeClass('loading');
				error_message( save_notice, "There was an error saving the changes.");
			}
		
			
		});
		return false;
	});




});

function roleBtn( btnClass )
	$(btnClass).live( 'click', function(){
		var member = $(this).parents('.member');
		
		var form = $(this).next('form')

		form.ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){

					return confirm("Are you sure?");
				},
		  	success: function(data) { 
		  	 	// remove the old content and insert new stuff
				data = $(data);
				member.replaceWith( data );
				var save_notice = $('.save-notice', data );
				success_message( save_notice, "Role in group was changed" );	
			  },
			error: function() {
				var save_notice = $('.save-notice',member);
				error_message( save_notice, "There was an error changeing the users role.");
			
			}
		});
		return false;
	});
