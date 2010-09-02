function getAnnotatedSequence(width){

  var output = '';

  var parts = getParts(); //get array of all parts in const
  // get array of all construct features
  var features = getConstructFeatures(parts); // todo implement
  var forwardSeq = getForwardSequence(parts);
  var revSeq = getComplement(forwardSeq);

  // todo get array of parts to display part borders
  // get them split into each line 
  // split, truncate features into separate sequence lines
  var featurelines = splitFeatures(features, width, forwardSeq.length); // todo implement
  var partlines = splitFeatures(parts, width, forwardSeq.length);
  //split sequences into array of lines
  var forwardSeqlines = splitSequence(forwardSeq, width); //TODO implement
  var revSeqlines = splitSequence(revSeq, width);

  
  for (l in forwardSeqlines){ // for each line of sequence
    // add features
    output += formatFeatures(featurelines[l]); // todo implement
    // add parts
    output += formatParts(partlines[l]);
    // add forward seq
    output += formatSeq(forwardSeqlines[l], l*width, "selectable"); 
    // add reverse seq
    output += formatSeq(revSeqlines[l], l*width, "");
    // add line spacer
    output += "<div>&nbsp;</div>";
  }
  
  //return html formatted string
  return output;
}

function getForwardSequence(parts){
  //return string 
  var seq = ''; 

  for (i in parts){
    seq += parts[i].sequence;
    //TODO need to get 4bp scar sequences too!
  }
  return seq;
}


function getComplement(seq){
  comseq = '';

  for (var i = 0; i < seq.length; i++){
    switch(seq.charAt(i))
    {
      case 'A':
        comseq += 'T';
        break;
      case 'T':
        comseq += 'A';
        break;
      case 'C':
        comseq += 'G';
        break;
      case 'G':
        comseq += 'C';
        break;
      default:
        comseq += 'N';
    }
  }
  //return revcom string of forward seq
  return comseq;
}

function splitSequence(seq, width){
  //split sequence (forward or reverse) into an array of strings for each line according to width
  var lines = new Array( Math.ceil( seq.length / width ) );
  
  for (var i=0; i<lines.length; i++){
    lines[i] = seq.substring( i * width, (i+1) * width)
  }
  return lines; 
}

function formatFeatures(features){ 
  //features = one sequence lines' worth of features
  tidyfeats = tidyFeatures(features);
  //tidyfeats is array of lines that can be output without overlap

  var output = '';
  for (i in tidyfeats) { //for each line in.. 
    output += getFormattedFeatureLine(sortFeatures(tidyfeats[i]));
  }

  //return html formatted string to display all features for that line
  //NB string may itself be multiple lines POSSIBLY
  return output;
}

function getCorrectedCoords(){
  //correct feature coordinates to relative start of cut part
  //return int
}

function getConstructFeatures(parts){
  //return all features included in construct in a single array
  features = new Array();
  index = 0;
  for (i in parts){
    for (a in annotations){
      if (annotations[a].bio_byte_id == parts[i].id){
        var feat = clone(annotations[a]);
        //gotta adjust start and stop relative to construct
        feat.start = feat.start + index - parts[i].s_correct; //todo also need to adjust for
        feat.stop = feat.stop + index - parts[i].s_correct;  //prefix offset!!!
        //if ( parts[i].s_correct < feat.start ){
          features.push(feat);
        //}
      }
    }
    index += parts[i].sequence.length;
  }
  return features;
}

function splitFeatures(features, width, length){
  
  var lines = new Array( Math.ceil( length / width ) ); // each line contains an array of features

  //init nested array
  for (var i=0; i<lines.length; i++){
    lines[i] = new Array(); //empty for now, push stuff in
  }

  for (i in features){
    var f1 = clone(features[i]);
    var startrow = Math.floor ( f1.start / width );  
    var stoprow = Math.floor ( f1.stop / width );
    
    if (stoprow == startrow){
      f1.start = f1.start - startrow * width;
      f1.stop = f1.stop - startrow * width;
      lines[startrow].push(f1);
    }
    else {
      //first 
      f1.start = f1.start - startrow * width;
      f1.stop = width;
      lines[startrow].push(f1);

      //fill in lines if needed
      var fills = stoprow - startrow - 1;
      for (var j= 1; j <= fills; j++){
        var f = clone(features[i]);
        f.start = 0;
        f.stop = width; 
        lines[startrow + j].push(f);
      }

      //end line
      var fstop = clone(features[i]);
      fstop.start = 0;
      fstop.stop = fstop.stop - stoprow * width;
      lines[stoprow].push(fstop);
    }
  }
  //return array of truncated features for each sequence line
  return lines;
}

function splitParts(parts, width, length){
  var partlines = new Array( Math.ceil(length/width) );
  var loc = 0; //location counter

  for (var i=0; i<partlines.length; i++){
    partlines[i] = new Array(); //empty for now, push stuff in
  }

  for (i in parts){
    var p1 = clone(parts[i]);
    var startrow = Math.floor ( loc / width );
    var stoprow = Math.floor ( loc + p1.sequence.length );

  
  }

  return partlines;
}

function tidyFeatures(features){
  //take array of truncated features for a single line
  //return array of arrays of truncated features that don't overlap
  
  // graph theory wtf?
  // take features
  // shift first feature to tidy[0]
  // for each feature, 
  // compare to each tidy, if non overlapping, splice and add to tidy
  // reapeat shift to tidy[+1] until feature array empty
  var tidy = new Array();
  var i = 0;

  while (features.length > 0 ) {
    tidy[i] = new Array();
    tidy[i].push( features.shift() );
    for (f in features){
      var overlap = true;
      for (t in tidy[i]){
        //if t and f overlap
        if (f.start > t.start){
          if (f.start > t.stop){
            //no overlap
            overlap = false;
          }
        }
        else if (f.stop < t.start){
          //nooverlap
          overlap = false;
        }

      }
      // if f didn't overlap with anything in t
      if (!overlap){
        tidy[i].push( features.splice(f,1) ); // this will fuck up array index...
      }
    }
    i++;
  }
  return tidy;
}

function getFormattedFeatureLine(features){
  //take array of features that don't overlap
  //return html formatted string 
  var output = "<div class='featureline'>";
  for (f in features){
    output += "<span class='annotation' style='"
          + "left:" + features[f].start + "ex;"
          + "width:" + (features[f].stop - features[f].start) + "ex;"
          + "background-color:" + features[f].colour + ";'><span class='ann_label'>"; 
    if (features[f].stop - features[f].start > features[f].name.length){
      output += features[f].name;
    }
    else{
      output += "&nbsp";
    }
    output += "</span></span>";
    
  }
  output += "</div>";
  return output;
}

function sortFeatures(features){
  //take array of features that don't overlap
  //return sorted array, in order of occurence
  return features.sort(sortByStart);
}

function sortByStart(a,b) {
  var x = a.start;
  var y = b.start;
  return ((x < y ) ? -1 : (( x > y ? 1 : 0)) );
}

function clone(obj){
    if(obj == null || typeof(obj) != 'object')
        return obj;

    var temp = obj.constructor(); // changed

    for(var key in obj)
        temp[key] = clone(obj[key]);
    return temp;
}

function formatSeq(seq, linenumber, classes){
  var output = "<div class='sequence'>" 
        + "<span class='numspacer'>" + linenumber + ":</span>"
        + "<span class='seq " + classes + "'>" + seq + "</span>"
        + "</div>";
  return output;
}

function formatParts(parts){
  var output = "<div class='partline'>";
  for (p in parts){
    output += "<span class='annotation' style='"
          + "left:" + parts[p].start + "ex;"
          + "width:" + (parts[p].stop - parts[p].start) + "ex;"
          + "background-color:" + parts[p].colour + ";'>" + "<span class='ann_label'>";
    if (parts[p].stop - parts[p].start > parts[p].name.length){
      output +=  parts[p].name;
    }
    else{
      output += "&nbsp";
    }
    output += "</span></span>";
  }
  output += "</div>";
  return output;
}
