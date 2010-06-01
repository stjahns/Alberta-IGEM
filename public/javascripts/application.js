// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


$(function() {

$('.edit_area').each(function(i) {
	$(this).editable($(this).attr('update_url'), {
		type  : 'textarea',
		name  : $(this).attr('name'),
		id    : $(this).attr('id'),
		cancel: 'Cancel',
		submit: 'OK',
		indicator: 'Saving...',
		tooltip : 'click to edit...',
		submitdata: {_method: "put", "step[id]":$(this).attr('step_id'),authenticity_token: AUTH_TOKEN),
		rows  : 10
			}
	}};	
});
	

