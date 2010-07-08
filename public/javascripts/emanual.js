// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$.ajaxSetup({
  'beforeSend': function(xhr) {
  xhr.setRequestHeader("Accept", "text/javascript")}
})


// Define the entry point - when DOM is ready
  
$(document).ready(function(){
	
	
        /*********   ajaxify forms ************************************/
	// submit the edits for steps with ajaX
	//$('.inplace_edit_step').each( function() {
	$('.inplace_edit_step').live('submit', function() {
		var step = $(this).parent().siblings('.step_view');
		var save_notice = $('.save-notice', this);
		var form = $(this).parent();
		$(this).ajaxSubmit( {
			dataType: 'html',
		  	success: function(data) { 
		  	 // remove the old content and insert new stuff
				step.html(data);
				// inform user of success
				success_message(save_notice,"Step updated succesfully.");
			  }
		});
		return false;
	});
	

	// submit an image for a step with ajaX
	$('.inplace_upload_image').live('submit', function() {
		var step = $(this).parents('div.step');
		var step_view = $('div.step_view', step);
		var image_container = $(this).siblings('.upload_thumb_container');
		var image = image_container.children('img');
		var edit_toolbar = $('.step-edit-btns',step);

		$(this).ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				image_container.addClass('loading');
				image.fadeOut("slow");
			},

		success: function(data) { 
			// have to unescape data because of iframe
			data = unescapeHTML(data);	
			var $r = $(data);	
			var imageURL = $r.find('img').attr('src').replace("step","");
			var source = imageURL + "thumb";

			//get the new thumbnail and put in place of old one
			var thumb = new Image();

			$(thumb).load( function(){
			      $(this).hide();
			      
			      image_container.html(this);
			      $(this).fadeIn("slow", function(){
				      image_container.removeClass('loading')} 
			      );
			      
			}).attr('src',source);

			// add image delete button
		
			var deleteBtn = '<li><a href="#"'+
			     'class="btn-delete-step-image">Delete Image</a>' +
			      generate_delete_form( imageURL ) + '</li>';
			deleteBtn = $(deleteBtn).hide();
			var test = edit_toolbar.html();

			edit_toolbar.append( deleteBtn );
			deleteBtn.fadeIn("slow");


			// replace step	
			step_view.html(data);
		}


		});
		return false;
	});
	
	// submit an update note for a step with ajaX
	$('.edit_note').live('submit', function() {
		var form = $(this).parent();
		var note = form.siblings('.step_note_view')
		var saveNotice = $('.save-notice',this);
		$(this).ajaxSubmit( {
			dataType: 'html',
		  	success: function(data) { 
		  	  // remove the old content and insert new stuff
			  //form.hide();
		          success_message( saveNotice, "Note saved.");
			  note.html( data );
		        }
		});
		return false;
	});

	//TODO add error callbacks to all ajaxSubmits
	// autosubmit a change in published status
	$('#publish').change(function(){
		var save_notice = $('.save-notice',this);
		if( publish_status_changed() ){
			//submit change
			$(this).ajaxSubmit( {
					dataType: 'html',
		  	success: function(data,statusText ) { 
			  	// status changed to published
				var message = $("#experiment_published").is(':checked') ? 
			       		"Experiment published" :
					"Experiment unpublished" ;	
				success_message( save_notice, message);

		        },
			error: function() {
				error_message(save_notice, 'There was an error!!');
			}
		});
		}
	});



	// submit a new note for a step with Ajax
	$('.new_note').live('submit', function() {
		var formDiv = $(this).parent();
		var form = $(this);
		var note = form.parent().siblings('.step_note_view')
		$(this).ajaxSubmit( {
			dataType: 'html',
		  	success: function(data) { 
		  	  // remove the old content and insert new stuff
			  note.html(data).show().attr('note','true');
			  formDiv.hide();
			  var url = form.attr('action') + '/edit';
			  $.get(url, function( newForm ){
			  	formDiv.html(newForm);
		    	  });
		        }
		});
		return false;
	});

	// submit an image for a note with ajaX
	$('.attach_image_to_note').live('submit', function() {
		var note = $(this).parent().siblings(".step_note_view");
	 	var image_container = $(this).siblings('.upload_thumb_container');
		var image = image_container.children('img');

		$(this).ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				image_container.addClass('loading');
				image.fadeOut("slow");
			},
			success: function(data) { 
				  // have to unescape data because of iframe
				  data = unescapeHTML(data);	
				  var $r = $(data);	
				  // get general img url and thumb url
				  var imageURL = $r.find('img').attr('src').replace("step","");
				  var source = imageURL + "thumb";
				
				//get the new thumbnail and put in place of old one
				var thumb = new Image();
				  
				$(thumb).load( function(){
					$(this).hide().addClass('note_thumb');
					
					image_container.html(this);
					$(this).fadeIn("slow", function(){
						image_container.removeClass('loading')} 
					);
					
				}).attr('src',source);
				// add image delete button
				var deleteBtn = '<li><a href="#"'+
				       'class="btn-note-delete-image">Delete Image</a>' +
					generate_delete_form( imageURL ) + '</li>';
				deleteBtn = $(deleteBtn).hide();
				image_container.siblings('div.note-toolbar').find('ul').append( deleteBtn );
				deleteBtn.fadeIn("slow");
			   
				// replace note view	
				note.html(data);
			}
		});
		return false;
	});



	$('.btn-delete-step-image').live('click', function(){
		var step = $(this).parents('div.step' );
		var thumb = $('.step_edit', step).find('img');
		var btn  = $(this).parent();
		
		$(this).siblings('form').ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				return confirm('Are you sure?');
			},
		  	success: function(data) { 
		  	 // remove the old content and insert new stuff
				thumb.fadeOut("slow");
				// change the form label
				 thumb.parent().siblings('form.inplace_upload_image').find('label')
				 	.html("Add an image");
				btn.fadeOut("slow").remove();
				// remove image in note view
				$('.step_view', step).find('img.step_view').parent().remove();
			}
		});
		return false;
	});


	$(".btn-step-edit").live( 'click', function() {
			step = $(this).parents('div.step');
		        $('div.step_view',step ).hide();
			$('div.step_edit', step).show();
			// show the correct buttons
			var toolbar = $(this).parents('div.step-toolbar');
			$('span.step-show-btns', toolbar).hide();
			$('span.step-edit-btns', toolbar).show();
			return false;
	});

	$('.btn-step-show').live('click',function(){
			step = $(this).parents('div.step');
		        $('div.step_edit', step).hide();
			$('div.step_view', step).show();
			var toolbar = $(this).parents('div.step-toolbar');
			$('span.step-edit-btns', toolbar).hide();
			$('span.step-show-btns', toolbar).show();
			return false;
	});


	// bind hidden submit form to links for insert step so
	// appear normally in the edit toolbar 
	$('.btn-step-insert-after').live( 'click', function(){
		var step = $(this).parents('div.step');
		$(this).siblings('form.button-to').ajaxSubmit({
			dataType: 'html',
		  	success: function(data) { 
		  	  // append a new step after 
			  data = $(data).attr({style: "display: none;"});
			  step.after(data).next().slideDown("slow");
			  renumberSteps();
			}
		});
		return false;
	});
	$('.btn-step-insert-before').live( 'click', function(){
		var step = $(this).parents('div.step');
		$(this).siblings('form.button-to').ajaxSubmit({
			dataType: 'html',
		  	success: function(data) { 
		  	  // append a new step after 
   	  		  data = $(data).attr({style: "display: none;"});
			  step.before(data).prev().slideDown("slow");
			  renumberSteps();
			}
		});
		return false;
	});

	$('.btn-step-destroy').live( 'click', function(){
		var step = $(this).parents('div.step');
		$(this).siblings('form.button-to').ajaxSubmit({
			dataType: 'html',
			beforeSubmit: function(){
			   return confirm(
				'Are you sure you want to delete this step?');},
		  	success: function() { 
			  step.slideUp("slow", function(){
			  	step.remove();
				renumberSteps();
			  });
			}
		});
		return false;
	});

	// buttons to control notes
        $('.btn-step-note').live( 'click', function(){
		var step_toolbar = $(this).parents('div.step-toolbar');
		var note_container = $('.step_note_container',$(this).parents('div.step'));
		var note = note_container.children('.step_note_view');
		var form = note_container.children('.step_note_form');
		if( $(this).hasClass('selected') ){
			$(this).removeClass("selected");

			note_container.slideUp("slow");
			$('a',step_toolbar).removeClass('shadow');
		}
		else{
			// check if the note exists
			if( note.attr('note') ){
				note.show(); form.hide();
			}
			else{
				note.hide(); form.show();
			}
			$(this).addClass("selected");
			note_container.slideDown("slow");
			$('a',step_toolbar).not('.btn-step-note').addClass('shadow');
					
		}		
		return false;
	});

	$('.btn-note-edit').live('click',function(){
		$(this).parents('div.step_note_view').hide()
			.siblings('.step_note_form').show();
		return false;
	});
	$('.btn-note-show-note').live('click', function(){
		$(this).parents('div.step_note_form').hide()
			.siblings('.step_note_view').show();
		return false;
	});
	$('.btn-note-delete-image').live('click', function(){
		var note = $(this).parents('.step_note_container' );
		var thumb = $('.upload_thumb_container', note).children('img');
		var btn  = $(this).parent();
		
		$(this).siblings('form').ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				return confirm('Are you sure?');
			},
		  	success: function(data) { 
		  	 // remove the old content and insert new stuff
				thumb.fadeOut("slow");
				// change the form label
				 $('.attach_image_to_note', note).find('label')
				 	.html("Attach an image");
				btn.fadeOut("slow").remove();
				// remove image in note view
				$('.step_note_view', note).find('img.step_note').remove();
			}
		});
		return false;
	});

});	

function publish_status_changed(){
		var box =  $('#experiment_published'); 
		var change = true;
		if( box.is(':checked') ){
			change = confirm(
			'If you publish this experiment, anyone can see it!  ' + 
			'Are you sure you want to publish it? (Note: you can ' + 
			'unpublish it at anytime by unchecking the published ' +
			'checkbox.');
		}
		if( !change ){
			box.attr('checked', false);			
		}
		return change;
}

function unescapeHTML(html) {
	html = $("<div />").html(html).text();
 	return html.replace('<pre>','').replace('</pre>','');
}

function renumberSteps(){
	var i = 1;
	$(".step_number").each( function(){
		$(this).html( i );
		i++;
	});
	i = 1;
	$(".edit_step_number").each( function(){
		$(this).html( i );
		i++;
	});
}

function generate_delete_form( action ){
	return 	'<form class="button-to" action="' + action +
		'" method="post"><div><input type="hidden" value="delete"'+
		'name="_method"><input type="submit" value="Delete Image"'+
		'style="display: none;"><input'+
		'type="hidden" value="'+ AUTH_TOKEN +
		'" name="authenticity_token"></div></form>';
}

function success_message( message_container, message ){
	message_container.html(message).fadeIn("slow");
		setTimeout(function(){
			message_container.fadeOut("slow");
	}, 3000);	
}

function error_message( message_container, message ){
	message_container.addClass("error-message").html(message).fadeIn("slow");
		setTimeout(function(){
			message_container.fadeOut("slow", function(){
				$(this).removeClass("error-message")});
	}, 3000);	
}

// when we ask for html we need rails to use respond to js so we need:
$.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script; 


