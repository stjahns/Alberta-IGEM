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
				step.html(data);
//				$('.btn-step-edit',step.siblings('.step-toolbar')).trigger('click');

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
		//	  step.children().remove();
		//	  step.append( data );
			  step.html(data);
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
		image_container = $(this).siblings('.note_thumb_container');
		image = image_container.children('.note_thumb');

		$(this).ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				image_container.addClass('loading');
				image.fadeOut("slow");
			},
			success: function(data) { 
				  // have to unescape data because of iframe
				  data = unescapeHTML(data);	
				  //alert(data);
				  var $r = $(data);	
				  var source = $r.find('img').attr('src').replace("step","thumb");
				
				//get the new thumbnail and put in place of old one
				var thumb = new Image();
				  
				$(thumb).load( function(){
					$(this).hide().addClass('note_thumb');
					
					image_container.html(this);
					$(this).fadeIn("slow", function(){
						image_container.removeClass('loading')} 
					);
					
				}).attr('src',source);
			   
				// replace note view	
				form.siblings(".step_note_view").html(data);
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

//	editButton( '.btn-step-image',  ".step_image_form" );
//	editButton( ".btn-step-form", ".step_form" );

	$(".btn-step-form").live( 'click', function() {
			toolbar = $(this).parent().parent().parent();
			step = toolbar.siblings(".step_view" );
			form = toolbar.siblings(".step_form");
			
			//if not selected
			if( $(this).hasClass("selected") ){
				step.show();
				form.hide();
				$(this).removeClass("selected").html("Edit Step");

			}
			else{
				// hide step and show forms
				step.hide();
				form.show();
				$(this).addClass('selected').html("Show Step");
			}		
			return false;
	});


	// bind hidden submit form to links for insert step so
	// appear normally in the edit toolbar 
	$('.btn-step-insert-after').live( 'click', function(){
		var step = $(this).parent().parent().parent().parent();
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
		var step = $(this).parent().parent().parent().parent();
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
		var step = $(this).parent().parent().parent().parent();
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
			$(this).parent().parent().parent()
			.siblings('.step_note_container');
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
		$(this).parent().parent().hide()
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
		$(this).html( i );
		i++;
	});
	i = 1;
	$(".edit_step_number").each( function(){
		$(this).html( i );
		i++;
	});
}


// when we ask for html we need rails to use respond to js so we need:
$.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script; 
