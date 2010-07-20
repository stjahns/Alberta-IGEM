$(document).ready(function(){

	$('#profile-tab').click( function(){
		$('#lab-book').hide();
		$('#profile').show();
		$('a','#profile-toolbar').removeClass('selected');
		$(this).addClass('selected');
		return false;
	});
	
	$('#lab-book-tab').click( function(){
		$('#profile').hide();
		$('#lab-book').show();
		$('a','#profile-toolbar').removeClass('selected');
		$(this).addClass('selected');
		return false;
	});

	// toolbar on group page	
	$('#group-info-tab').click( function(){
		$('#profile-toolbar').nextAll().hide();
		$('#group-info').show();
		$('a','#profile-toolbar').removeClass('selected');
		$(this).addClass('selected');
		return false;
	});
	$('#group-members-tab').click( function(){
		$('#profile-toolbar').nextAll().hide();
		$('#group-members').show();
		$('a','#profile-toolbar').removeClass('selected');
		$(this).addClass('selected');
		return false;
	});
	$('#admin-tools-tab').click( function(){
 		$('#profile-toolbar').nextAll().hide();
		$('#admin-tools').show();
		$('a','#profile-toolbar').removeClass('selected');
		$(this).addClass('selected');
		return false;
	});
});
