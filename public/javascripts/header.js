$(document).ready(function(){

	// tabs on profile page
	header_tab('#profile');
	header_tab('#lab-book');

	// tabs on group profile page
	header_tab('#group-info');
	header_tab('#group-members');
	header_tab('#admin-tools');
	header_tab('#group-messages');

});

// binds the tab name x-tab to the div named x
function header_tab( tabId ){
	btnId = tabId + '-tab'; 
	
	$(btnId).click( function(){
		$('#header').nextAll().hide();
		$(tabId).show();
		$('a','#header-toolbar').removeClass('selected');
		$(this).addClass('selected');
		return false;
	});
	
}	
