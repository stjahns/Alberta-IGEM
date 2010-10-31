// global variables

  // arrays of all byte objects from server db
  var orfs;
  var linkers;
  var allparts;

  var partcoords=[]; // array of parts with relavent data currently in construct 
                   //2d array [ [id, start, stop, name, type], [... ]]
  //for sortable/tooltips
  var moving = false;

  // for init of ajax save
  var experiment_id;
  var construct_id;

  $(document).ready(function() {

      
      updatePlasmidDisplay(1);

      //Get experiment + construct id's TODO this is lazy!!
      var url = window.location.pathname.split('/');
      experiment_id = url[2];
      construct_id = url[4];

      //Load biobyte db data thru AJAX
        //init's orfs, linkers, allparts
      loadPartData();

      //save button
      initSaveButton();
      //generate protocol link
      initGenerateProtocol();

      //init construct sortable list
      initConstructSortable();

      $("*").disableSelection();

      //$("#parts-bin-tabs").tabs();
      $("#parts-list").accordion({
          autoHeight: false,
          collapsible: true,
      });
      
      $(".byte").draggable({ 	

        connectToSortable: 'ol#parts_list',
        revert: 'invalid',
        helper: "clone",
        zIndex: 11,
        revertDuration: 0,
        stop: function(){
          updatePlasmidDisplay(0);
        }
      }).addTouch();
/*
      $("#trash").droppable({
        activeClass: 'ui-state-hover',
        hoverClass: 'ui-state-active',
        accept: '#parts_list > li',
        tolerance: 'pointer',
        drop: function(event, ui) {
          ui.draggable.attr()
          ui.draggable.remove();
          $("#parts_list").sortable('refresh');
        }
      }); 
*/
      $("#parts-row").droppable({
        accept: '#parts_list >li',
        tolerace: 'intersect',
        drop: function(event, ui) {
          ui.draggable.attr()
          ui.draggable.remove();
          $("#parts_list").sortable('refresh');
        }
      });
      
/*
      $(".part").tooltip({
        opacity: 0.9, 
        onShow: function(){
          if (moving==true){
            this.hide(); // temp. disable
          }
        }
      });
*/
      $(".part, .byte").mouseenter(function(){
        //$("#part-info").html($(this).attr('info'));
        var id = $(this).attr('byte_id').split('_')[1];
        $("#part-info").contents().replaceWith($("#info_" + id).clone());
      });
    
      $(".placeholder").remove(); // wussy hack to get sortable usable for
      updatePlasmidDisplay(0);    // empty plasmid
  }); 




function validate(bytes){
  // check ab ba alternation
  var toggle = bytes[0].split(' ', 1)[0];
  var valid = true;
  for (x in bytes){

    if (bytes[x].split(' ', 1)[0] != toggle){
      valid = false;
      break;
    }
    else{
      if (toggle == "Linker"){
        toggle = "ORF";
      }
      else{
        toggle = "Linker";
      }
    }

  }

  //check circularizable
  if (bytes[0].split(' ',1)[0] == bytes[bytes.length-1].split(' ',1)[0]){
    valid = false;
  }

  return valid;

}

function setPlasmidWidth(placeholders){
  //placeholders is number of parts to remove from final width,
  // -> deals with sortable placeholder li's i think..

  $('#plasmid-mid').css('width', function(){
    var count = 0;
    $('#parts_list>li').each(function(){
      count+=1;
      });
    return 100*(count-placeholders);
  });

}

function loadPartData(){

      //ajax call to load data
      $.ajax({
        type: 'get',
        dataType: 'json',
        url: '/get_part_data',
        success: function(data){
          orfs = data.orfs;
          for (i in orfs){
            orfs[i].type="orf";
          }
          linkers = data.linkers;
          for (i in linkers){
            linkers[i].type="linker";
          }
          allparts= orfs.concat(linkers);
          annotations = data.annotations;
          backbones = data.backbones;
          //$("#sequence").html(getFormattedSequence());
          $("#sequence").html(getAnnotatedSequence(100));
          $(".part, .byte").css('background-image', function(index, value){
            for(i in allparts){
              var byte_id = $(this).attr('byte_id');
              if ( byte_id.split('_')[1] == allparts[i].id.toString()){
                return 'url(/images/'+ allparts[i].image_id +'.png)';
              }
            }
          });
        }
      });

}

function initSaveButton(){

      $("a#save").click(function() {
        
        // TODO validation
        // sequence must be flanked by alpha and omega bytes - NEED A NEW DB COL FOR SPECIAL CLASS (ie ALPHA/OMEGA etc.)
        // or leave validation for server side?
        // require an ori?
        // require selection?

        var bytes = $('#parts_list').sortable('toArray', {attribute: 'class'});

        if (bytes.length>0 && validate(bytes)){

          $('#header').after("<div id=saving-text style='text-align:center'>Saving...</div><div id=saving-anim class=loading style='height:35px'></div>");

          //submit to server
          $.ajax({
           type: 'put',
           dataType: 'json',
           data: $('#parts_list').sortable('serialize', {attribute: 'part_id'}) + '&'
                + $('#parts_list').sortable('serialize', {attribute: 'byte_id'}) + '&'
                + 'id=' + construct_id + '&'
                + 'experiment_id=' + experiment_id,

            url: '/save_construct',
            success: function(data){
              //kill saving anim
              $("#saving-anim").fadeOut('slow');
              $('#saving-text').html('Saved.')
              setTimeout("$('#saving-text').fadeOut('slow');", 2000);

              $("#parts_list > li").each(function(index) {
                $(this).attr('part_id', "part_"+data.part_ids[index]);
              })
            }
          
          })
        }
        else{
           $('#header').after("<div id=saving-text style='text-align:center'>Construct is not valid!</div>");
           setTimeout("$('#saving-text').fadeOut('slow');", 2000);
        }
      });

}

function initConstructSortable(){

      $("ol#parts_list").sortable({

        connectWith:  '#trash',
        helper: 'clone',
        cursor: 'move',
        appendTo: 'body',
        tolerance: 'pointer',
        placeholder: 'part-placeholder',
        start: function(){
          updatePlasmidDisplay(1);
          /*
          $('.tooltip').hide();
          */
          moving = true;
          //update plasmid width 
          //setPlasmidWidth(1);
        },
        stop: function(){
          updatePlasmidDisplay(0);
          moving = false;
          //update plasmid width 
          //setPlasmidWidth(0);
        },
        update: function(){
          //if dropped in a new part from bin
          updatePlasmidDisplay(0);
          $('ol#parts_list > .byte').each(function(){
            $(this).mouseenter(function(){
              //$("#part-info").html($(this).attr('info'));
              var id = $(this).attr('byte_id').split('_')[1];
              $("#part-info").contents().replaceWith($("#info_" + id).clone());
            });
            $(this).addClass('part').removeClass('byte').text('');
          });
          //changes=true; // for future "YOU've Neer saved yer changes!"
          //$("#sequence").html(getFormattedSequence());
          $("#sequence").html(getAnnotatedSequence(100));
          $("ol#parts_list > li").addTouch();
        }
      });

      $("ol#parts_list > li").addTouch();

}
  function updatePlasmidDisplay(placeholders){
    var numparts = $("#parts_list").children().length - placeholders;
    
    if (numparts < 7)
      var height = 92;
    else
      var height = 92 + (-(Math.floor(-numparts/6))-1)*46;
    //if (numparts%6 == 0){
      //add a row
      //height += 46;
    //}

    $("#left-side").css('height',function(){
      return height - 92 + 'px';
    });

    $("#bottom-left, #bottom-right, #bottom").css('top', function(){
      return height - 46 + 'px';
    });
    $("#plasmid-spacer").css('width', function(){
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
    $("#plasmid-end").css('top', function(){
      return height - 92 + 'px';
    });
    $("#parts_box").css('height', function(){
      return height + 'px'; 
    });
    $("#parts_list").css('height', function(){
      return height - 46 + 'px';
    });

    // add plasmid line wraps
    // delete em all and rebuild
    $(".plasmid-wrap").remove();
    // How many wraps?
    var wraps = -(Math.floor(-numparts/6))-1;
    for (var i=1; i<=wraps; i++){
      $("#top-left").after(
        "<div class=plasmid-wrap id=wrap-"+ i + " "
        + "style='top:" + (i-1)*46 + "px'></div>"
        );
    }

  }

function getParts(){
  var partids = $('ol#parts_list').sortable('toArray');
  //get byte_id numbers
  for (i in partids){
    var temp = new Array();
    temp = partids[i].split('_');
    partids[i]=temp[1];
  }

  var loc = 0;
  var parts = new Array();
  for (i in partids){
    for (j in allparts){
      if (partids[i] == allparts[j].id){
        
        var p = clone(allparts[j]);

        //if first part, add end to start
        if (i==0){
          var start = new Object();
          if (p.type == "linker"){
            start.sequence = "GCCT";
            start.name = "B";
            start.colour = "#0000FF";
          }
          else{
            start.sequence = "TGGG";
            start.name = "A"
            start.colour = "#FF0000";
          }
          start.start = loc;
          loc += 4;
          start.stop = loc;
          parts.push(start);
        }

        p.start = loc;
        loc += p.sequence.length; 
        p.stop = loc;
        // get s_correct value
        for (b in backbones){
          if (backbones[b].id == p.backbone_id){
            p.s_correct = backbones[b].prefix.length;
          }
        }
        parts.push(p);
        
        //add a/b end 
        var end = new Object();
        if (p.type == "orf"){
          end.sequence = "GCCT";
          end.name = "B";
          end.colour = "#0000FF";
        }
        else{
          end.sequence = "TGGG";
          end.name = "A"
          end.colour = "#FF0000";
        }
        end.start = loc;
        loc += 4;
        end.stop = loc;
        parts.push(end);

        
        //loc++;

      }
    }
  }
  //return array of parts 
  return parts;
}

function initGenerateProtocol(){
    $("a#generate_protocol").click(function() {

        var bytes = $('#parts_list').sortable('toArray', {attribute: 'class'});

        if (bytes.length>0 && validate(bytes)){

          $('#header').after("<div id=saving-text style='text-align:center'>Generating protocol...</div><div id=saving-anim class=loading style='height:35px'></div>");

          //submit to server
          $.ajax({
           type: 'put',
           dataType: 'json',
           data: $('#parts_list').sortable('serialize', {attribute: 'part_id'}) + '&'
                + $('#parts_list').sortable('serialize', {attribute: 'byte_id'}) + '&'
                + 'id=' + construct_id + '&'
                + 'experiment_id=' + experiment_id,

            url: '/generate_protocol',
            success: function(id){
              //kill saving anim
              //go to 
              $("#saving-anim").fadeOut('slow');
              $("#saving-text").html("Done.").fadeOut('slow');

              window.open('/experiments/' + id, 'Protocol', 'toolbar=yes,location=yes,directories=yes,status=yes,menubar=yes,scrollbars=yes,copyhistory=yes,resizable=yes');
            },
            error: function(){
              $("#saving-anim").fadeOut('slow');
              $("#saving-text").html("Something has gone horribly wrong!").fadeOut('slow');
            }
          
          })
        }
        else{
           $('#header').after("<div id=saving-text style='text-align:center'>Construct is not valid!</div>");
           setTimeout("$('#saving-text').fadeOut('slow');", 2000);
        }
      });
}
