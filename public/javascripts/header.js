$(document).ready(function(){

	// tabs on profile page
	header_tab('#profile');
	header_tab('#lab-book');
	header_tab('#profile-options');

	// tabs on group profile page
	header_tab('#group-info');
	header_tab('#group-members');
	header_tab('#admin-tools');
	header_tab('#group-messages');

	// for smoother tab changes
	fix_heights_of_tabs();

	// if url has '#_tab-name' in it then activate that tab
	url_tab();
	

});

// fix heights of tab divs to mathch the largest tab
// prevents browser from jumping when we switchi

function fix_heights_of_tabs() {
	var list_tabs = [];
	var max_height = 0;
	if($("#header-toolbar") ){
		$('#header-toolbar a').each( function(){
			var tabId =  $(this).attr('id').replace(/-tab/,"");
			if( tabId ){
				var tab = $("#" + tabId);		
				var tab_height = tab.height();
				list_tabs.push(tab);
				if( tab_height > max_height ) max_height = tab_height; 
			}
		});

		
		//set the tab container to the height of the larges div
		$('#tab-container').height(max_height+1);
	}
}

// binds the tab name x-tab to the div named x
// and puts #_tab-name into the location hash so you can bookmark
// the tab location, putting _ infront of tab nam stops the browser from
// jumping on tab switch

function header_tab( tabId ){
	var btnId = tabId + '-tab'; 
	var container = $('#tab-container');
	
	$(btnId).click( function(){
		container.children('div:visible').hide();
		$(tabId).show();

		$('a','#header-toolbar').removeClass('selected');
		$(this).addClass('selected');
	
		//change URL for bookmarkable tabs
		location.hash = "_" + tabId.replace(/#/,"");

		return false;
	});
	
}	

function url_tab() {
	var tab = location.hash.replace(/_/,"");
	if(tab){ 
		$( tab + '-tab' ).trigger('click'); 
	}
}
