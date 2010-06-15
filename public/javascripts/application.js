// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})


// Define the entry point - when DOM is ready
  
$(document).ready(function(){
  // UJS authenticity token fix: add the authenticity_token parameter
  // expected by any Rails POST request 
//  $(document).ajaxSend(function(event, request, settings) {
    // do nothing if this is a GET request. Rails doesn't need the 
    // authenticity token, and IE converts the request method 
    // to POST, just because
//    if (settings.type == 'GET') return;
//    if (typeof(AUTH_TOKEN) == "undefined") return;
//    settings.data = settings.data || "";
//    settings.data += (settings.data ? "&" : "") + "authenticity_token="
//      + encodeURIComponent(AUTH_TOKEN);
//    });

//----------------------------------------------------------
// TODO MOVE THIS INTO ANOTHER FILE
//---------------------------------------------------------

	// options for editing steps with ajax form
	var step_options = {
		//target:       '', 
                //beforeSubmit: showRequest,
		//success:      showResponse,
	        //success:      processStep,
		dataType:     'json',
		//resetForm:  true

	}

	// submit the edits for steps with ajaX
	$('.inplace_edit_step').submit( function() {
		$(this).ajaxForm(step_options);
		$(this).parent().siblings('.step_view ' ).show( "slow" );
		$(this).parent().hide( "slow" );	
		return false;
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

	
 
