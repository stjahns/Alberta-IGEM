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

      
      updatePlasmidDisplay(0);

      //Get experiment + construct id's TODO this is lazy!!
      var url = window.location.pathname.split('/');
      experiment_id = url[2];
      construct_id = url[4];

      //Load biobyte db data thru AJAX
        //init's orfs, linkers, allparts
      loadPartData();

      //save button
      initSaveButton();

      //init construct sortable list
      initConstructSortable();

      //$("*").disableSelection();

      $("#parts-bin-tabs").tabs();
      
      $(".byte").draggable({ 	

        connectToSortable: 'ol#parts_list',
        revert: 'invalid',
        helper: "clone"

      });

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
    
  }); 


//get html formatted sequence with feature partcoords
//THIS IS HIDEOUS!!
function getFormattedSequence(){
  var seq = getSequence().toUpperCase();
  // need to figureout endpoint coordinates of each part
  var length = seq.length;
  var done = false;
  var index = 0;
  var outstring = '';
  var line = 4; //1=parts 2=forward 3= reverse 4=annotations
  var annindex = 0;
  
  outstring += "<table class=seqtable>";
  while (done == false){
    if (index < length){
      // partcoords
      if (line == 2){ // forward strand


        if ((index)%100 == 0){
          if (annindex != index){
            outstring += "<tr><td>" + index + ": </td><td>";
          }
          else{
            outstring += "</td></tr>";
            line = 3;
            continue;
          }
        }

        forward += seq.charAt(index);
        outstring += seq.charAt(index);
        index += 1;
      }
      else if (line==3){ // complementary strand
        outstring += "<tr><td>&nbsp</td><td>";
        reverse = '';
        for (x in forward){
          base = forward[x];
          if (base == 'A'){
            reverse += 'T';
          }
          else if (base=='T'){
            reverse += 'A';
          }
          else if (base=='G'){
            reverse += 'C';
          }
          else if (base=='C'){
            reverse += 'G';
          }

        }
        outstring += reverse;
        outstring += "</td></tr>";
        line = 4;
      }
      else if (line==1){ // part id labels
        var width=0;
        outstring += "<tr><td></td><td>";

        var start = annindex;
        var stop = annindex + 100; 

        var lineparts = []; //the parts in the line

        for (x in partcoords){
          var id = partcoords[x][0];
          var srt = partcoords[x][1];
          var stp = partcoords[x][2];
          var type = partcoords[x][3];

          if (srt >= start && srt <= stop){
            //chunk starts on this line
            //stops?
            if (stp < stop){
              //stops before end
              lineparts.push([id, srt, stp, type]);
            }
            else{
              //goes to end
              lineparts.push([id, srt, stop, type]);
            }
          }
          else if (stp >= start && stp <= stop){
            //chunk goes from before start of line to somewhere in the middle
            lineparts.push([id, start, stp, type]);
          }
          else if (stp > stop && srt < start){
            //chunk takes up whole line
            lineparts.push([id, start, stop, type]);
          }
          else{
            // part isn't on this line
          }
        }
          
          
        //loop for each annotation (part) on the line
        for (i in lineparts){
          width = lineparts[i][2] - lineparts[i][1];
          //may need to add spaces to account for sequence formatting
          //ex. width += 2;  

          outstring += "<div class='annotation " + lineparts[i][3] + "' style='width:" + width + "ex'>";

          if (width > lineparts[i][0].length){
            outstring += "<div class='ann_label'>"
            outstring += lineparts[i][0];
            outstring += "</div>"
          }
          else{         
            outstring += "<div class='ann_label'>"
            outstring += "&nbsp";
            outstring += "</div>"
          }

          outstring += "</div>"

        }
        //loop back?
        outstring += "</td></tr>";         
        line = 2;
        forward = '';
        annindex = stop;
      }
      else if (line == 4){ //annotations
      //NB must add spacer div if 2 parts not touching on same line
        var usedoffset = 0; //offset for when multiple annotations on one line

        var width=0;
        outstring += "<tr><td></td><td>";

        var start = annindex;
        var stop = annindex + 100; 

        var lineparts = []; //the parts in the line ---> [3] is OFFSET

        for (x in partcoords){
          var id = partcoords[x][0];
          var srt = partcoords[x][1];
          var stp = partcoords[x][2];
          // old var type = partcoords[x][3];
          var byte_id = partcoords[x][4];

          if (srt >= start && srt <= stop){
            //chunk starts on this line
            //stops?
            if (stp < stop){
              //stops before end
              lineparts.push([id, srt, stp, 0, byte_id]);
            }
            else{
              //goes to end
              lineparts.push([id, srt, stop, 0, byte_id]);
            }
          }
          else if (stp >= start && stp <= stop){//these next two guys need offset information
            //chunk goes from before start of line to somewhere in the middle
            var offset = start - srt; // amount of part already displayd
            lineparts.push([id, start, stp, offset, byte_id]);
          }
          else if (stp > stop && srt < start){
            //chunk takes up whole line
            var offset = start - srt;
            lineparts.push([id, start, stop, offset, byte_id]);
          }
          else{
            // part isn't on this line
          }
        }
          
        //loop for each part on line
        for (i in lineparts){
          //iterate for each annotation of the part(biobyte)
          //lineparts[i][0] is the name of the biobyte -need id, got it in lineparts[i][4]
          //look for byte_id in annotations
          for(a in annotations){
            if (annotations[a].bio_byte_id == lineparts[i][4]){
              var offset = lineparts[i][1]-lineparts[i][3];
              //Does annotation start on this line?
              if(annotations[a].start+offset >= annindex && 
                 annotations[a].start+offset < annindex + 100) {
                //does it also stop?
                if(annotations[a].stop+offset > annindex &&
                    annotations[a].stop+offset <= annindex + 100){ //starts and stops on this line
                  outstring += "<div class='annotation' style='position:relative;"
                            +  "left:" + (annotations[a].start+offset-annindex-usedoffset) + "ex;"
                            +  "width:" + (annotations[a].stop-annotations[a].start)  + "ex;"
                            +  "background-color:" + (annotations[a].colour) + ";"
                            +  "border:1px solid #333'><div class='ann_label'>" + annotations[a].name + "</div></div>";
                  usedoffset += annotations[a].stop-annotations[a].start;
                }
                else{ //starts, flows over line
                  outstring += "<div class='annotation' style='position:relative;"
                            +  "left:" + (annotations[a].start+offset-annindex-usedoffset) + "ex;"
                            +  "width:" + (100-(annotations[a].start+offset-annindex)) + "ex;"
                            +  "background-color:" + (annotations[a].colour) + ";"
                            +  "border:1px solid #333'><div class='ann_label'>" + annotations[a].name + "</div></div>";
                }
              }
              //Does annotation not start, but does stop on this line?
              else if(annotations[a].stop+offset > annindex &&
                annotations[a].stop+offset < annindex + 100) {
                outstring += "<div class='annotation' style='position:relative;"
                            +  "left:" + 0 + "ex;"
                            +  "width:" + (annotations[a].stop+offset - annindex) + "ex;"
                            +  "background-color:" + (annotations[a].colour) + ";"
                            +  "border:1px solid #333'><div class='ann_label'>" + annotations[a].name + "</div></div>";
                usedoffset += annotations[a].stop+offset - annindex;
              }
              //does annotation blow through the line?
              if(annotations[a].start+offset < annindex &&
                annotations[a].stop+offset > annindex + 100) {
                //easy to deal with assuming no overlap...
                outstring += "<div class='annotation' style='width:100ex;background-color:"
                              + annotations[a].colour + ";border:1px solid #333'><div class='ann_label'>"
                              + annotations[a].name + "</div></div>";
              }

            }
          }

        }

        //loop back?
        outstring += "&nbsp</td></tr>";         
        line = 1;
        forward = '';
        annindex = start;//change
      }



      
    }
    else{
      done = true;
      //disp last line
      outstring += "<tr><td>&nbsp</td><td>";
      reverse = '';
      for (x in forward){
        base = forward[x];
        if (base == 'A'){
          reverse += 'T';
        }
        else if (base=='T'){
          reverse += 'A';
        }
        else if (base=='G'){
          reverse += 'C';
        }
        else if (base=='C'){
          reverse += 'G';
        }

      }
      forward = '';
      outstring += reverse;
      outstring += "</td></tr>";
    }
  }
  outstring += "</td></tr></table>";
  
  return outstring;

}


//update sequence TODO get this to work with byte_id instead?
function getSequence(){

  var seq = '';
  partcoords = [];
  var parts = $('ol#parts_list').sortable('toArray');
  //have array of part_id strings
  //need to get the byte id numbers isolated (middle)
  for (i in parts){
    var temp = new Array();
    temp = parts[i].split('_');
    parts[i]= temp[1];
  }
  //ok, now get sequence corresponding to each byte 
  //and add to sequence string
  // TODO to cut this down, need a type field in the json array of bytes
        // - do with js, or server side by adding a type field to db
  for (i in parts){
    for (j in orfs){
      if (parts[i]==orfs[j].id){
        var first = seq.length; 
        seq += orfs[j].sequence;
        var second = seq.length;
        var id = orfs[j].name;
        var byte_id = orfs[j].id;
        partcoords.push( [id, first, second, "orf", byte_id]);
      }
    }
    for (j in linkers){
      if (parts[i]==linkers[j].id){
        var first = seq.length;
        seq += linkers[j].sequence;
        var second = seq.length;
        var id = linkers[j].name;
        var byte_id = linkers[j].id;
        partcoords.push( [id, first, second, "linker", byte_id]);
      }
    }
  }
  return seq;

}

function validate(bytes){
  var toggle = "Linker";
  var valid = true;
  for (x in bytes){

    if (bytes[x].split(' ', 1) != toggle){
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
          linkers = data.linkers;
          allparts= orfs.concat(linkers);
          annotations = data.annotations;
          $("#sequence").html(getFormattedSequence());
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
         
        if (validate(bytes)){

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
              $("#parts_list > li").each(function(index) {
                $(this).attr('part_id', "part_"+data.part_ids[index]);
              })
              alert("Saved!");
            }
          
          })
        }
        else{
          alert("Construct is not valid!"); //todo: invalid message
        }
      });

}

function initConstructSortable(){

      $("ol#parts_list").sortable({

        connectWith:  '#trash',
        tolerance: 'pointer',
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
            $(this).attr('title', $(this).attr('popup'));
            $(this).addClass('part').removeClass('byte').text('');
            /*
            $(this).tooltip({
              opacity: 0.9,
              onShow: function(){
                if (moving==true){
                  this.hide(); // temp. disable
                }
              }
           });
            */
          });
          //changes=true; // for future "YOU've Neer saved yer changes!"
          $("#sequence").html(getFormattedSequence());
        }
      });

}
  function updatePlasmidDisplay(placeholders){
    var numparts = $("#parts_list").children().length - placeholders;

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

    //add line cont. markers? eg ------//
    //                         //------]

  }

