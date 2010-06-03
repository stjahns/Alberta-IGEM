//get html formatted sequence with feature annotations
function getFormattedSequence(){
  var seq = getSequence().toUpperCase();
  // need to figureout endpoint coordinates of each part
  var length = seq.length;
  var done = false;
  var index = 0;
  var outstring = '';
  var line = 1;
  var annindex = 0;
  
  outstring += "<table class=seqtable>";
  while (done == false){
    if (index < length){
      // annotations
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
        line = 1;
      }
      else if (line==1){ // part id labels
        var width=0;
        outstring += "<tr><td></td><td>";

        var start = annindex;
        var stop = annindex + 100; 

        var lineparts = []; //the parts in the line

        for (x in annotations){
          var id = annotations[x][0];
          var srt = annotations[x][1];
          var stp = annotations[x][2];
          var type = annotations[x][3];

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
  annotations = [];
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
  // TODO this is some really fucking shitty code
  for (i in parts){
    for (j in orfs){
      if (parts[i]==orfs[j].id){
        var first = seq.length; 
        seq += orfs[j].sequence;
        var second = seq.length;
        var id = orfs[j].name;
        annotations.push( [id, first, second, "orf"]);
      }
    }
    for (j in linkers){
      if (parts[i]==linkers[j].id){
        var first = seq.length;
        seq += linkers[j].sequence;
        var second = seq.length;
        var id = linkers[j].name;
        annotations.push( [id, first, second, "linker"]);
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
