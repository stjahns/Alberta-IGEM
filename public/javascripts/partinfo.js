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
        }
      });

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
          }
          else{
            start.sequence = "TGGG";
            start.name = "A"
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
        }
        else{
          end.sequence = "TGGG";
          end.name = "A"
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
