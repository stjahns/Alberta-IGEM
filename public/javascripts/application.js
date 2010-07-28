// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// include this file in all layout

// this function sets it so that when javascript asks for html, the
// request is changed to text/javascript, this allows the browser to
// respond to javascript requests differently than html request, and
// send html as reponse.  Since the javascript asked for html it is
// expecting this as a response and handles it correctly
$.ajaxSetup({
  'beforeSend': function(xhr) {
  xhr.setRequestHeader("Accept", "text/javascript")}
})


$(document).ready(function(){
	//**********************************************************
	// nav bar
	//**********************************************************
	// check the state of the navbar in the cookie and restore it
	if($.cookie('nav') == 'collapsed'){
		$('#btn-hide-nav a').addClass('slid')
		$('div#navBar').css({top: function(index,value){
			return -26;}
		});
	}

	// slide the nav bar up and down and store its state in a cookie
	$('#btn-hide-nav a').click( function(){
		btn = $(this);
		if( btn.hasClass('slid') ){
			btn.removeClass('slid');
			$.cookie('nav','expanded',{ path: '/'  });
			$('div#navBar').animate(
			{top: '+=26'},
			500 );
		}
		else{
			btn.addClass('slid');
			$.cookie('nav','collapsed',{path: '/'} );
			$('div#navBar').animate(
			{top: '-=26'},
			500);
		}
	
	});

	//submit login form in nav bar if the user pushes enter
	//in the form
	$('#navBar form').keydown(function(event){
		if(event.keyCode == '13'){
//			$(this).submit();
			$(this).ajaxSubmit({
				dataType: 'html',
				success: function(data) { 
					location.reload();
				  },
				error: function() {
				//TODO give a message if it doesn't wor
				}
			});
		}
	});

	//**********************************************************
	// make pop up for glossary links
	//**********************************************************
         $("a.termLink").hover(function(event){
            $(this).next("em").animate({opacity: "show", top: "-75"}, "fast");
          }, function() {
            $(this).next("em").animate({opacity: "hide", top: "-85"}, "fast");
	});  
 

	//**********************************************************
	// more/less text display
	//**********************************************************
	$('a.more').live('click', function(){
		$(this).hide().siblings('span.more').show();
		return false;
	});

	$('a.less').live('click', function(){
		$(this).parent('span.more').hide()
		.siblings('a.more').show();
		return false;
	});

	//**********************************************************
	// fade out flash notices
	//**********************************************************

	//fade out notice after 3 seconds
	setTimeout(function(){
		$('#home-notice').fadeOut("slow");
		$('#flash-notice').fadeOut("slow");
	}, 5000);


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

// function to check publish status of an experiment publish form
function publish_status_changed(box){
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


// function to display a success message in a predefined notice box	
function success_message( message_container, message ){
	message_container.html(message).fadeIn("slow");
		setTimeout(function(){
			message_container.fadeOut("slow");
	}, 3000);	
}

// function to display an error message in a predefined notice box	
function error_message( message_container, message ){
	message_container.addClass("error-message").html(message).fadeIn("slow");
		setTimeout(function(){
			message_container.fadeOut("slow", function(){
				$(this).removeClass("error-message")});
	}, 3000);	
}

// function to unescape HTML that is sent back escaped
function unescapeHTML(html) {
	html = $("<div />").html(html).text();
 	return html.replace('<pre>','').replace('</pre>','');
}

