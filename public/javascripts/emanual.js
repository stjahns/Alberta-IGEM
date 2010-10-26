  var orfs;
  var linkers;
  var allparts;
  // constructs : initialized in experiment/show view

// Define the entry point - when DOM is ready
  
$(document).ready(function(){
	
//	var flashnotice = $('#flash-notice');
//	if(flashnotice.html() != "" ){
//		flashnotice.fadeIn();
//	}


      updatePlasmidDisplay(0);
      
      
      $.ajax({
        type: 'get',
        dataType: 'json',
        url: '/get_part_data',
        success: function(data){
          orfs = data.orfs;
          linkers = data.linkers;
          allparts= orfs.concat(linkers);
          
          //get images
          $(".part, .byte").css('background-image', function(index, value){
            for(i in allparts){
              var byte_id = $(this).attr('byte_id');
              if ( byte_id.split('_')[1] == allparts[i].id.toString()){
                return 'url(/images/'+ allparts[i].image_id +'.png)';
              }
            }
          });
        }
      })

      $(".part").click(function(){
        var con = $(this).attr('construct');
        if ($(this).hasClass('showing')){
          $(this).removeClass('showing');
          $(".part-info." + con ).parent().hide();
        }
        else {
          $(this).addClass('showing');
          //$(".part-info." + con ).html($(this).attr('info'));
          var id = $(this).attr('byte_id').split('_')[1];
          $(".part-info." + con ).contents().replaceWith($("#info_" + id).clone());
          $(".part-info." + con ).parent().show();
        }
      });

/*

      $(".part").mouseleave(function(){
        var con = $(this).attr('construct');
        $(".part-info." + con).parent().hide();
      });
*/
      
	//**********************************************************
	// javascript for editing steps
	//**********************************************************
	
      	//toggle edit controls
	$('#toggle-edit-steps').click( function(){
	 	
		if( $(this).hasClass( 'edit-on' ) ){ 
			$(this).html("Edit off")
				.removeClass('edit-on');
			$('.step-toolbar ul li')
				.not('.btn-step-note')
				.hide();

		}
		else {
			$(this).html("Edit on")
				.addClass('edit-on'); 
			$('.step-toolbar ul li')
				.not('.btn-step-note')
				.show();
		}
		return false;
	});
	

	// submit the edits for steps with ajaX
	//$('.inplace_edit_step').each( function() {
	$('.inplace_edit_step').live('submit', function() {
		var step = $(this).parent().siblings('.step_view');
		var save_notice = $('.save-notice', this);
		var form = $(this).parent();
		$(this).ajaxSubmit( {
			dataType: 'html',
		  	success: function(data) { 
		  	 // remove the old content and insert new stuff
				step.html(data);
				// inform user of success
				success_message(save_notice,"Step updated succesfully.");
			  },
			error: function() {
				error_message(save_notice, "Error: The step could not be updated.");
			}
		});
		return false;
	});

	$('.inplace_edit_step').live('submit', function() {
		var exp = $( "div.lab-book" ,$(this).parents('div.experiment-description-container'));
		var save_notice = $('.save-notice', this);
		var form = $(this).parent();
		$(this).ajaxSubmit( {
			dataType: 'html',
		  	success: function(data) { 
		  	 // remove the old content and insert new stuff
				exp.html(data);
				// inform user of success
				success_message(save_notice,"Experiment updated succesfully.");
			  },
			error: function() {
				error_message(save_notice, "Error: The  could experiment could not be updated.");
			}
		});
		return false;
	});
	

	// submit an image for a step with ajaX
	$('.inplace_upload_image').live('submit', function() {
		var step = $(this).parents('div.step');
		var step_view = $('div.step_view', step);
		var image_container = $(this).siblings('.upload_thumb_container');
		var image = image_container.children('img');
		var edit_toolbar = $('.step-edit-btns',step);

		$(this).ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				image_container.addClass('loading');
				image.fadeOut("slow");
			},

		success: function(data) { 
			// have to unescape data because of iframe
			data = unescapeHTML(data);	
			var $r = $(data);	
			var imageURL = $r.find('img').attr('src').replace("step.jpg","");
			var source = imageURL + "thumb.jpg";

			//get the new thumbnail and put in place of old one
			var thumb = new Image();

			$(thumb).load( function(){
			      $(this).hide();
			      
			      image_container.html(this);
			      $(this).fadeIn("slow", function(){
				      image_container.removeClass('loading')} 
			      );
			      
			}).attr('src',source);

			// add image delete button
		
			var deleteBtn = '<li><a href="#"'+
			     'class="btn-delete-step-image">Delete Image</a>' +
			      generate_delete_form( imageURL ) + '</li>';
			deleteBtn = $(deleteBtn).hide();

			edit_toolbar.append( deleteBtn );
			deleteBtn.fadeIn("slow");


			// replace step	
			step_view.html(data);
		},
		error: function(){
			error_message( $('.inplace_upload_image',step_view).find('.save-notice'),
				"Error: the image could not be deleted.");	
		}


		});
		return false;
	});
	
	// submit an update note for a step with ajaX
	$('.edit_note').live('submit', function() {
		var form = $(this).parent();
		var note = form.siblings('.step_note_view')
		var saveNotice = $('.save-notice',this);
		$(this).ajaxSubmit( {
			dataType: 'html',
		  	success: function(data) { 
		  	  // remove the old content and insert new stuff
			  //form.hide();
		          success_message( saveNotice, "Note saved.");
			  note.html( data );
		        },
			error: function(){
				error_message(saveNotice, "Error: the note could not be saved.");				
			}
		});
		return false;
	});

	// autosubmit a change in published status
	$('#publish').change(function(){
		var save_notice = $('.save-notice',this);
		var published = $("#experiment_published");
		if( publish_status_changed(published ) ){
			//submit change
			$(this).ajaxSubmit( {
					dataType: 'html',
		  	success: function(data,statusText ) { 
			  	// status changed to published
				var message = published.is(':checked') ? 
			       		"Experiment published" :
					"Experiment unpublished" ;	
				success_message( save_notice, message);

		        },
			error: function() {
				var message = "Sorry there was an error.";

				if( published.is(':checked')){
					// uncheck
					published.removeAttr('checked');
					message = message + "  The experiment could not be published.";
				}
				else{
					// check
					published.attr('checked','checked');
					message = message + "  The experiment could not be unpublished.";
				}

				error_message(save_notice, message);
			}
		});
		}
	});

    // ajax submit a change in step completion status
    $('.complete').change(function(){

        var completed = $("#step_completed", this);
        var checked = completed.is(':checked');

        $.ajax({
          type: 'post',
          data: "step_id=" + this.id + "&checked=" + checked, 
          url: location.pathname + '/complete_step',
          });
          
    });

    

	// submit a new note for a step with Ajax
	$('.new_note').live('submit', function() {
		var form = $(this);
		var note = form.parents('div.step_note_container')
		var save_notice = $('.save-notice',note);
		form.ajaxSubmit( {
			dataType: 'html',
		  	success: function(data) { 
			  //alert(data);
		  	  // remove the old content and insert new stuff
			  note.html(data);
			  note.attr('note','true');
			  var url = form.attr('action') + '/edit';
			  /*$.get(url, function( newForm ){
			  	$('div.step_note_form', note).html(newForm);
		    	  });*/
			  success_message($('.step_note_view', note).find('.save-notice') ,"New note created.");
				
		        },
			error: function(){
				error_message(
					$('.step_note_form',note).find('.save-notice') , 
					"Sorry there was an error.  The note could not be created.");
			}
		});
		return false;
	});

	// submit an image for a note with ajaX
	$('.attach_image_to_note').live('submit', function() {
		var note = $(this).parent().siblings(".step_note_view");
	 	var image_container = $(this).siblings('.upload_thumb_container');
		var image = image_container.children('img');
		var save_notice = $('.save-notice',this)

		$(this).ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				image_container.addClass('loading');
				image.fadeOut("slow");
			},
			success: function(data) { 
				  // have to unescape data because of iframe
				  data = unescapeHTML(data);	
				  var $r = $(data);	
				  // get general img url and thumb url
				  var imageURL = $r.find('img').attr('src').replace("step.jpg","");
				  var source = imageURL + "thumb.jpg";
				
				//get the new thumbnail and put in place of old one
				var thumb = new Image();
				  
				$(thumb).load( function(){
					$(this).hide().addClass('note_thumb');
					
					image_container.html(this);
					$(this).fadeIn("slow", function(){
						image_container.removeClass('loading')} 
					);
					
				}).attr('src',source);
				// add image delete button
				var deleteBtn = '<li><a href="#"'+
				       'class="btn-note-delete-image">Delete Image</a>' +
					generate_delete_form( imageURL ) + '</li>';
				deleteBtn = $(deleteBtn).hide();
				image_container.siblings('div.note-toolbar').find('ul').append( deleteBtn );
				deleteBtn.fadeIn("slow");
			   
				// replace note view	
				note.html(data);
			},
			error: function(){
				error_message(save_notice, "Error: image could not be submitted.");
			}
		});
		return false;
	});



	$('.btn-delete-step-image').live('click', function(){
		var step = $(this).parents('div.step' );
		var thumb = $('.step_edit', step).find('img');
		var btn  = $(this).parent();
		var save_notice = $('form.inplace_upload_image',step).find('.save-notice');
		
		$(this).siblings('form').ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				return confirm('Are you sure?');
			},
		  	success: function(data) { 
		  	 // remove the old content and insert new stuff
				thumb.fadeOut("slow");
				// change the form label
				 thumb.parent().siblings('form.inplace_upload_image').find('label')
				 	.html("Add an image");
				btn.fadeOut("slow").remove();
				// remove image in note view
				$('.step_view', step).find('img.step_view').parent().remove();
			},
			error: function() {
				error_message( save_notice, "Error: image could not be deleted." );	
			}

		});
		return false;
	});


	$(".btn-step-edit").live( 'click', function() {
			step = $(this).parents('div.step');
		        $('div.step_view',step ).hide();
			$('div.step_edit', step).show();
			// show the correct buttons
			var toolbar = $(this).parents('div.step-toolbar');
			$('span.step-show-btns', toolbar).hide();
			$('span.step-edit-btns', toolbar).show();
			return false;
	});

	$('.btn-step-show').live('click',function(){
			step = $(this).parents('div.step');
		        $('div.step_edit', step).hide();
			$('div.step_view', step).show();
			var toolbar = $(this).parents('div.step-toolbar');
			$('span.step-edit-btns', toolbar).hide();
			$('span.step-show-btns', toolbar).show();
			return false;
	});


	// bind hidden submit form to links for insert step so
	// appear normally in the edit toolbar 
	$('.btn-step-insert-after').live( 'click', function(){
		var step = $(this).parents('div.step');
		var save_notice = $('.step_view',step).find('.save-notice');
		$(this).siblings('form.button-to').ajaxSubmit({
			dataType: 'html',
		  	success: function(data) { 
		  	  // append a new step after 
			  data = $(data).attr({style: "display: none;"});
			  step.after(data).next().slideDown("slow");
			  renumberSteps();
			},
			error: function() {
				error_message(save_notice, "Error: step could not be inserted.");
			}
		});
		return false;
	});
	$('.btn-step-insert-before').live( 'click', function(){
		var step = $(this).parents('div.step');
		var save_notice = $('.step_view',step).find('.save-notice');
		$(this).siblings('form.button-to').ajaxSubmit({
			dataType: 'html',
		  	success: function(data) { 
		  	  // append a new step after 
   	  		  data = $(data).attr({style: "display: none;"});
			  step.before(data).prev().slideDown("slow");
			  renumberSteps();
			},
			error: function() {
				error_message(save_notice, "Error: step could not be inserted.");
			}

		});
		return false;
	});

	$('.btn-step-destroy').live( 'click', function(){
		var step = $(this).parents('div.step');
		var save_notice = $('.step_view',step).find('.save-notice');
		$(this).siblings('form.button-to').ajaxSubmit({
			dataType: 'html',
			beforeSubmit: function(){
			   return confirm(
				'Are you sure you want to delete this step?');},
		  	success: function() { 
			  step.slideUp("slow", function(){
			  	step.remove();
				renumberSteps();
			  });
			  },
			error: function() {
				error_message(save_notice, "Error: step could not be deleted .");
			}
		});
		return false;
	});
	
	$('.btn-note-delete').live( 'click', function(){
		var note = $(this).parents('div.step_note_container');
		var save_notice = $('.edit_note',note).find('.save-notice');
		$(this).siblings('form.button-to').ajaxSubmit({
			dataType: 'html',
			beforeSubmit: function(){
			   return confirm(
				'Are you sure you want to delete this note?');},
		  	success: function(data) { 
			   // note.html(data);
			    note.parents('div.step').find('.btn-step-note').trigger('click'); 
			    setTimeout( function(){
				    note.html(data);
			    },3500 );	    
			  },
			error: function() {
				error_message(save_notice, "Error: note could not be deleted.");
			}
		});
		return false;
	});


	// buttons to control notes
        $('.btn-step-note').live( 'click', function(){
		var step_toolbar = $(this).parents('div.step-toolbar');
		var note_container = $('.step_note_container',$(this).parents('div.step'));
		var note = note_container.children('.step_note_view');
		var form = note_container.children('.step_note_form');
		if( $(this).hasClass('selected') ){
			$(this).removeClass("selected");

			note_container.slideUp("slow", function(){ 
				$('a',step_toolbar).removeClass('shadow');
			});
		}
		else{
			// check if the note exists
			if( note_container.attr('note') ){
				note.show(); form.hide();
			}
			else{
				note.hide(); form.show();
			}
			$(this).addClass("selected");
			note_container.slideDown("slow");
			$('a',step_toolbar).not('.btn-step-note').addClass('shadow');
					
		}		
		return false;
	});

	$('.btn-note-edit').live('click',function(){
		$(this).parents('div.step_note_view').hide()
			.siblings('.step_note_form').show();
		return false;
	});
	$('.btn-note-show-note').live('click', function(){
		$(this).parents('div.step_note_form').hide()
			.siblings('.step_note_view').show();
		return false;
	});
	$('.btn-note-delete-image').live('click', function(){
		var note = $(this).parents('.step_note_container' );
		var thumb = $('.upload_thumb_container', note).children('img');
		var btn  = $(this).parent();
		
		$(this).siblings('form').ajaxSubmit( {
			dataType: 'html',
			beforeSubmit: function(){
				return confirm('Are you sure?');
			},
		  	success: function(data) { 
		  	 // remove the old content and insert new stuff
				thumb.fadeOut("slow");
				// change the form label
				 $('.attach_image_to_note', note).find('label')
				 	.html("Attach an image");
				btn.fadeOut("slow").remove();
				// remove image in note view
				$('.step_note_view', note).find('img.step_note').remove();
			},
			error: function(){
				error_message($('.attach_image_to_note',note).find('.save-notice')
					,"Error: The image could not be deleted");
			}
		});
		return false;
	});
});	



function renumberSteps(){
	var i = 1;
	$(".step_number").each( function(){
		$(this).html( i );
		i++;
	});
	i = 1;
	$(".edit_step_number").each( function(){
		$(this).html( i );
		i++;
	});
}

function generate_delete_form( action ){
	return 	'<form class="button-to" action="' + action +
		'" method="post"><div><input type="hidden" value="delete"'+
		'name="_method"><input type="submit" value="Delete Image"'+
		'style="display: none;"><input'+
		'type="hidden" value="'+ AUTH_TOKEN +
		'" name="authenticity_token"></div></form>';
}



function updatePlasmidDisplay(placeholders){
  //must repeat for all constructs

  for (i in constructs){
   	var numparts = $(".parts_list." + constructs[i]).children().length - placeholders;
    
    	if (numparts < 7){
      		var height = 92;
	    }
    	else{
      		var height = 92 + (-(Math.floor(-numparts/6))-1)*46;
	    	//if (numparts%6 == 0){
      		//add a row
	      //height += 46;
	    //}
      }
	

    $(".left-side." + constructs[i]).css('height',function(){
      return height - 92 + 'px';
    });

    $(".bottom-left." + constructs[i] + ", .bottom-right." + constructs[i] + ", .bottom." + constructs[i]).css('top', function(){
      return height - 46 + 'px';
    });
    $(".plasmid-spacer." + constructs[i]).css('width', function(){
      if (numparts == 0)
        return'650px';
      if (numparts % 6 == 0)
        return 0 + 'px';
      else
        return (6 - numparts%6) * 100 + 'px';
    }).css('top', function(){
      return height - 92 + 'px';
    }).css('left', function(){
      return (numparts % 6  ) * 100 + 50 + 'px';
    });
    $(".plasmid-end." + constructs[i]).css('top', function(){
      return height - 92 + 'px';
    });
    $(".parts_box." + constructs[i]).css('height', function(){
      return height + 'px'; 
    });
    $(".parts_list." + constructs[i]).css('height', function(){
      return height - 46 + 'px';
    });

    // add plasmid line wraps

    var wraps = -(Math.floor(-numparts/6))-1;
    for (var j=1; j<=wraps; j++){
      $(".top-left." + constructs[i]).after(        
        "<div class=plasmid-wrap id=wrap-"+ constructs[i] + " "
        + "style='top:" + (j-1)*46 + "px'></div>"
        );
    }
  }
}

// when we ask for html we need rails to use respond to js so we need:
$.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script; 


