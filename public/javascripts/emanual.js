// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$.ajaxSetup({
  'beforeSend': function(xhr) {
  xhr.setRequestHeader("Accept", "text/javascript")}
})


// Define the entry point - when DOM is ready
  
$(document).ready(function(){
	// options for editing steps with ajax form
	var step_options = {
		//target:       '', 
                //beforeSubmit: showRequest,
		//success:      showResponse,
	        //success:      processStep,
		dataType:     'html',
		//resetForm:  true

	}

	// submit the edits for steps with ajaX
/*	$('.inplace_edit_step').submit( function() {
		alert('About to submit')
		$(this).ajaxForm( {
			dataType: 'html',
			target:	  '#' + $(this).parent().siblings('.step_view').attr('id')
		});
		$(this).parent().siblings('.step_view ' ).show( "slow" );
		$(this).parent().hide( "slow" );	
		return false;
	});
*/

	$('.inplace_edit_step').each( function() {
		var step = $(this).parent().siblings('.step_view');
		var form = $(this)
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
	// replace step with edit form on click
	var editButton = function($toggler, $togglee) {

		$($toggler).click( function() {
			// only one active form at a time
			$(this).siblings("a").removeClass("selected");
			
			// hide all visible parts
			$(this).parent().siblings("span:visible")
			.slideUp("slow");
					
			// show the togglee or the step	
			
			if( $(this).hasClass("selected") ){
				$(this).parent().siblings('.step_view')
				.slideDown("slow");
			}
			else{
				
				$(this).parent().siblings($togglee)
				.slideDown("slow");
			}	

			$(this).toggleClass("selected");	
			return false;
			
		});
	};


	editButton( '.btn-step-image',  ".step_image_form" );
	editButton( ".btn-step-form", ".step_form" );

});	

var replaceStep = function(step,data){
	alert(data);
}

// when we ask for html we need rails to use respond to js so we need:
$.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script; 
