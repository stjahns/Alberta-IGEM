$(document).ready(function(){
	// expand the biobyte description when you click on the link
	$('a.btn-byte-desc',$('#bio-bytes-table')).click(function(){
		row = $(this).parents('.byte-row');
		desc = $( 'div.description', row);
		if(desc.is(':visible')){
			desc.hide();
			row.removeClass('selected');
	}
		else{
			desc.show();
			row.addClass('selected');

		}
		return false;
	});

});
