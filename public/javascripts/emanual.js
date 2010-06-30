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
		var form = $(this).parent();
		$(this).ajaxSubmit( {
			dataType: 'html',
		  	success: function(data) { 
		  	 // remove the old content and insert new stuff
				step.children().remove();
				step.append( data );
				$('.btn-step-edit',step.parent()).trigger('click');

			  }
		});
		return false;
	});
	

	// submit an image for a step with ajaX
	$('.inplace_upload_image').live('submit', function() {
		var step = $(this).parent().siblings('.step_view');
		var form = $(this).parent();
		var upload =$(this).children('.step-upload-notice');
		$(this).ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				upload.show();
			},
			success: function(data) { 
			  // have to unescape data because of iframe
		          data = unescapeHTML(data);	
			  upload.hide();
			  step.children().remove();
			  step.append( data );
			  $('.btn-step-image', step.parent()).trigger('click');
		        }
		});
		return false;
	});

	// submit an update note for a step with ajaX
	$('.edit_note').live('submit', function() {
		var form = $(this).parent();
		var note = form.siblings('.step_note_view')
		$(this).ajaxSubmit( {
			dataType: 'html',
		  	success: function(data) { 
		  	  // remove the old content and insert new stuff
			  form.hide();
			  note.html( data ).show();
		        }
		});
		return false;
	});


	// submit a new note for a step with Ajax
	$('.new_note').live('submit', function() {
		var form = $(this);
		var note = form.parent().siblings('.step_note_view')
		$(this).ajaxSubmit( {
			dataType: 'html',
		  	success: function(data) { 
		  	  // remove the old content and insert new stuff
			  note.html(data).show().attr('note','true');
			  form.parent().hide();
			  var url = form.attr('action') + '/edit';
			  $.get(url, function(newForm ){
			  	form.parent().html(newForm);
		    	  });
		        }
		});
		return false;
	});

	// submit an image for a note with ajaX
	$('.attach_image_to_note').live('submit', function() {
		form = $(this).parent();
		$(this).ajaxSubmit( {
			dataType: 'html',
		/*	beforeSubmit: function(){
				upload.show();
			},
		*/	success: function(data) { 
			  // have to unescape data because of iframe
		          data = unescapeHTML(data);	
	//		  alert( data );
			  form.hide();
			  form.siblings(".step_note_view").html(data).show("slow");

		//	  $('.btn-step-image', step.parent()).trigger('click');
		        }
		});
		return false;
	});


	// slide up different forms to add content to the step
	// use editButton to define buttons that toggle a form 
	var editButton = function($toggler, $togglee) {

		//$($toggler).click( function() {
		$($toggler).live( 'click', function() {
			// only one active form at a time
			$(this).siblings("a").removeClass("selected");

			// hide all visible parts
			$(this).parent().siblings("span:visible")
			  .hide("slow");
					
			// show the togglee or the step	
			if( $(this).hasClass("selected") ){
				$(this).parent().siblings('.step_view')
				  .show("slow");
				$(this).removeClass('selected');
			}
			else{
				$(this).parent().siblings($togglee)
				  .slideDown("slow");
				$(this).addClass('selected');
			}	
			return false;
		});
	};

	editButton( '.btn-step-image',  ".step_image_form" );
	editButton( ".btn-step-form", ".step_form" );

	// bind hidden submit form to links for insert step so
	// appear normally in the edit toolbar 
	$('.btn-step-insert-after').live( 'click', function(){
		var step = $(this).parent().parent();
		var btn = $(this).siblings('.hidden_insert_after')
		  .children('.button-to');
		btn.ajaxSubmit({
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
		var step = $(this).parent().parent();
		var btn = $(this).siblings('.hidden_insert_before')
		  .children('.button-to');
		btn.ajaxSubmit({
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
		var step = $(this).parent().parent();
		var btn = $(this).siblings('.hidden_delete_step')
		  .children('.button-to');
		btn.ajaxSubmit({
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
		var note_container = 
			$(this).parent().siblings('.step_note_container');
		var note = note_container.children('.step_note_view');
		var form = note_container.children('.step_note_form');
		if( $(this).hasClass('selected') ){
			$(this).removeClass("selected");
			note_container.slideUp("slow");
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
		}		
		return false;
	});	
	$('.btn-note-edit').live('click',function(){
		$(this).parent().hide()
			.siblings('.step_note_form').show();
		return false;
	});
	$('.btn-note-edit-cancel').live('click', function(){
		$(this).parent().hide()
			.siblings('.step_note_view').show();
		return false;
	});
	$('.btn-delete-image-note').live('submit', function(){
		var form = $(this).parent().parent().parent();
		var url = $(this).attr('action') + '/edit';
		$(this).ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				return confirm('Are you sure?');
			},
		  	success: function(data) { 
		  	 // remove the old content and insert new stuff
			 form.load(url);
			 }
		});
	});

});	

function unescapeHTML(html) {
	html = $("<div />").html(html).text();
 	return html.replace('<pre>','').replace('</pre>','');
}

function renumberSteps(){
	var i = 1;
	$(".step_number").each( function(){
		$(this).html("<p><b>Step " + i + " :</b></p>");
		i++;
	});
}

// when we ask for html we need rails to use respond to js so we need:
$.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script; 
