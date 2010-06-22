// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$.ajaxSetup({
  'beforeSend': function(xhr) {
  xhr.setRequestHeader("Accept", "text/javascript")}
})


// Define the entry point - when DOM is ready
  
$(document).ready(function(){
	// submit the edits for steps with ajaX
	$('.inplace_edit_step').each( function() {
		var step = $(this).parent().siblings('.step_view');
		var form = $(this).parent()
		//alert( step.attr('id') )
		$(this).ajaxForm( {
			dataType: 'html',
			target:	  step,
			//resetForm: true,
		  	success: function(data) { 
		  	 // remove the old content and insert new stuff
				step.children().remove();
				step.append( data );
			        step.show( "slow" );
				form.hide("slow");
			  }
		});
	});
	
	// submit the edits for steps with ajaX
	$('.inplace_upload_image').each( function() {
		var step = $(this).parent().siblings('.step_view');
		var form = $(this).parent();
		//alert( step.attr('id') )
		$(this).ajaxForm( {
			dataType: 'html',
			target:	  step,
			//resetForm: true,
		  	success: function(data) { 
		  	  // remove the old content and insert new stuff
			  data = unescapeHTML(data);	
			  data = data.replace('<pre>','').replace('</pre>','');

			  step.children().remove();
			  step.append( data );
			  step.show( "slow" );
		          form.hide("slow");
		        }
		});
	});
	// slide up different forms to add content to the step
	// use editButton to define buttons that toggle a form 
	// TODO will have to use delegate or live for this if we
	// want to add steps without a refresh, what about for forms
	// loaded by ajax
	var editButton = function($toggler, $togglee) {

		$($toggler).click( function() {
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

	// buttons to control notes
        $('.step_note_button').click( function(){

		
	});	
});	

function unescapeHTML(html) {
	return $("<div />").html(html).text();
}

// when we ask for html we need rails to use respond to js so we need:
$.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script; 
