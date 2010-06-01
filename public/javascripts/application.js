// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults



//jQuery.ajaxSetup({
///	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "application/json")}
//});

$(document).ready(function() {
	var options = {
		//target:       '#output1', 
		beforeSubmit: showRequest,
		success:      showResponse,
		dataType:     'json',
		//resetForm:    true

	}

	//$("#step_form").submitWithAjax();
	$("#step_form").ajaxForm(options);
	//$("#step_form").ajaxForm({ dataType: 'script', complete: alert("thanks for visiting!")});


	// use something similar to the stuff below to 
	// make an inline form appear and dissapear
//	$("p").click(function () { 
//      		$(this).slideUp(); 
//    	});
//    	$("p").hover(function () {
//      		$(this).addClass("hilite");
//    	}, function () {
//      	$(this).removeClass("hilite");
//    	});
});	

	
// pre-submit callback 
function showRequest(formData, jqForm, options) { 
    // formData is an array; here we use $.param to convert it to a string to display it 
    // but the form plugin does this for you automatically when it submits the data 
    var queryString = $.param(formData); 
 
    // jqForm is a jQuery object encapsulating the form element.  To access the 
    // DOM element for the form do this: 
    // var formElement = jqForm[0]; 
 
    alert('About to submit: \n\n' + queryString); 
 
    // here we could return false to prevent the form from being submitted; 
    // returning anything other than false will allow the form submit to continue 
    return true; 
} 
 
// post-submit callback 
function showResponse(responseText, statusText, xhr, $form)  { 
    // for normal html responses, the first argument to the success callback 
    // is the XMLHttpRequest object's responseText property 
 
    // if the ajaxForm method was passed an Options Object with the dataType 
    // property set to 'xml' then the first argument to the success callback 
    // is the XMLHttpRequest object's responseXML property 
 
    // if the ajaxForm method was passed an Options Object with the dataType 
    // property set to 'json' then the first argument to the success callback 
    // is the json data object returned by the server 
 
    alert('status: ' + statusText + '\n\nresponseText: \n' + responseText + 
        '\n\nThe output div should have already been updated with the responseText.'); 
} 
