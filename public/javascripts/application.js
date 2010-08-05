// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// Define the entry point - when DOM is ready
  
$(document).ready(function(){
  // UJS authenticity token fix: add the authenticity_token parameter
  // expected by any Rails POST request 
  $(document).ajaxSend(function(event, request, settings) {
    // do nothing if this is a GET request. Rails doesn't need the 
    // authenticity token, and IE converts the request method 
    // to POST, just because
    if (settings.type == 'GET') return;
    if (typeof(AUTH_TOKEN) == "undefined") return;
    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token="
      + encodeURIComponent(AUTH_TOKEN);
    });
});	

	
 
