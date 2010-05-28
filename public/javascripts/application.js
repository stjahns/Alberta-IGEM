// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})


// Define the entry point - when DOM is ready
  
$(document).ready(function(){
  // UJS authenticity token fix: add the authenticity_token parameter
  // expected by any Rails POST request 
  $(document).ajaxSend(function(event, request, settings) {
    // do nothing if this is a GET request. Rails doesn't need the 
    // authenticity token, and IE converts the request method 
    // to POST, just because
    if (settings.type == 'GET') return;
    if (typeof(AUTH_TOKEN) == "undefined") return;
    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token="
      + encodeURIComponent(AUTH_TOKEN);
    });
});

//group bases in sequence string into groups of 10 bases
function groupBases(seq){
  
  var sequence = "";
  var i = 0;

  for (x in seq){

    if (i%11==0){
      sequence = sequence + " ";
      i++;
    }

    sequence = sequence + seq[x];
    i++;
  }
  
  return sequence;

}

//update sequence TODO get this to work with byte_id instead?
function getSequence(){

  var seq = '';
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
  for (i in parts){
    for (j in orfs){
      if (parts[i]==orfs[j].id){
        seq += orfs[j].sequence;
      }
    }
    for (j in linkers){
      if (parts[i]==linkers[j].id){
        seq += linkers[j].sequence;
      }
    }
  }
  return seq;

}
