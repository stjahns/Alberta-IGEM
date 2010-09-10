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

	//delete a biobyte and expand up
	$('.btn-delete-biobyte').live('click', function(){
		byte_div = $(this).parents('div.byte-row');
			 
		$(this).next('form.button-to').ajaxSubmit({
			dataType: 'html',
			beforeSubmit: function(){
				return confirm('Are you sure?');
			},
		  	success: function(data) { 
		  	 	// slide the div up then remove it
				byte_div.slideUp(function(){
					byte_div.remove();
				});
			  },
			error: function() {
				error_message($('.save-notice',byte_div), "Error: The part could not be deleted.");
			}
		});
		return false;
	});


	//display the sequence
	$('.btn-show-sequence').live('click',function(){
		byte_div = $(this).parents('div.byte-row');
		text = $('span.text',byte_div);
		seq =  $('span.sequence',byte_div);
		if( text.is(':visible') ){
			text.hide();
			seq.show();
			$(this).html('Description');
		}
		else {
			seq.hide();
			text.show();
			$(this).html('Sequence');
		}
		return false;
	});

  //linkify tabs
  $('.cat').click(function(){
    $('.cat').removeClass('selected');
    $(this).addClass('selected');
    cat = $("#" + $(this).attr('category') );
    $('.category').hide();
    cat.show(); 
  });

});
