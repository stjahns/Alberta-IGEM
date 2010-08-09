#!/usr/bin/perl

use strict;
use warnings;
use ABI;
use Bio::Perl;
use Bio::Tools::Run::StandAloneBlast;

my $status; #status of script after running, ERROR or whatever
my $ref = $ARGV[0];
#open (my $refin, "<", $ARGV[0]) or die $!;
my $vfin = $ARGV[1];
my $vrin = $ARGV[2];

my $vfabi = ABI->new($vfin);
my $vrabi = ABI->new($vrin);

#my $ref = <$refin>;
$ref =~ s/\W//g; #chuck any non letters.(ie the \n)

$ref = Bio::Seq->new(-id => 'ref', -seq => $ref, -alphabet => 'dna');

my $vf = Bio::Seq->new(-id => 'vf',
                          -seq => $vfabi->get_sequence(),
                          -alphabet => 'dna');
my $vr = Bio::Seq->new(-id => 'vr', -seq => $vrabi->get_sequence(),
                          -alphabet => 'dna');

#trim vf
#need grab any acgtn until reach 3n's separated by <10 bp
$vf->seq =~ /(GAATTC\w+?)(N{2,})/;
$vf->seq($1);

#trim vr
$vr->seq =~ /(CTGCAG\w+?)(N{2,})/;
$vr->seq($1);

#revcom vr
$vr->seq( $vr->revcom->seq );

my $factory = Bio::Tools::Run::StandAloneBlast->new(program => 'blastn');
my $blast_report = $factory->bl2seq($vf, $vr);

my $result_obj = $blast_report->next_result;
my $hit_obj = $result_obj->next_hit;
my $hsp_obj = $hit_obj->next_hsp;

my $vfhit = uc $hsp_obj->query_string;
my $homo = uc $hsp_obj->homology_string;
my $vrhit = uc $hsp_obj->hit_string;

#print $vfhit, "\n";
#print $homo, "\n";
#print $vrhit, "\n";

my $obsvseq; #observed sequence string -> produced from vf + vr overlap
my $hil; #contains strings of chars corresp. to highlight colors for obsvseq

#get vfss seq before blast hits start
$vfhit =~ /(^.{10})/;
my $query = $1;
$vf->seq =~ /(^.*)$query/;
my $vfss = $1;

#get vrds seq before blast hits stop
$vrhit =~ /(.{10}$)/;
$vr->seq =~ /(^.*$1)/;
my $vrds = $1;


#check out vfss

for (my $i = 0; $i<length($vfss); $i++){
  if (substr($vfss, $i, 1) =~ /[ATCG]/ ) { #if good basecall
    $hil .= 'Y'; #these could also be n's!
    $obsvseq .= substr($vfss, $i, 1);
  }
  else {
    $hil .= '?'; #unsure!
    $obsvseq .= 'N';
  }
}

for (my $i = 0; $i < length($vfhit); $i++) {
    #match?
    if ( substr( $vfhit, $i, 1) eq substr( $vrhit, $i, 1)
      and substr( $vrhit, $i, 1 ) =~ /[ACTG]/ 
         and substr( $vfhit, $i, 1) =~ /[ACTG]/ ) {
      $obsvseq .= substr($vfhit, $i, 1);
      $hil .= 'G';
    }
    elsif ( substr( $vfhit, $i, 1 ) =~ /[ACTG]/ 
         and substr( $vrhit, $i, 1) !~ /[ACTG]/ ) {
      $hil .= 'Y';
      $obsvseq .= substr($vfhit, $i, 1);
    }
    elsif ( substr( $vrhit, $i, 1 ) =~ /[ACTG]/ 
         and substr( $vfhit, $i, 1) !~ /[ACTG]/ ) {
      $hil .= 'B';
      $obsvseq .= substr($vrhit, $i, 1);
    }
    #uncertain
    elsif ( substr( $vrhit, $i, 1 ) !~ /[ACTG]/ 
         and substr( $vfhit, $i, 1) !~ /[ACTG]/ ) {
      $hil .= '?';
      $obsvseq .= 'N';
    }
    #mismatch! maybe this should be the same as uncertain??
    else {
      $hil .= '!';
      $obsvseq .= 'N';
    }
}

my $i = length($vrds);
until ( $i == length $vr->seq ) {
  if ( substr( $vr->seq, $i, 1) =~ /[ACTG]/ ) { #'good'TAATA read
    $hil .= 'B'; #these could also be n's!
    $obsvseq .= substr( $vr->seq, $i, 1);
  }
  else { #bad read
    $hil .= '?';
    $obsvseq .= 'N';
  }
  $i++;
}

my $changes; #store mismatch information

unless (length $obsvseq != length $ref->seq) {

  $status = "GOOD";
  
  #The easy way!!
  #compare seq's char by char
  my @obslist = split ('', $obsvseq);
  my @reflist = split ('', $ref->seq);
  
  my $i = 0; 
  foreach (@obslist) {
    if ($_ eq $reflist[$i]){
      #Whatever
    }
    elsif (/[nN-]/){
      substr( $hil, $i, 1) = '?';
    }
    else {
      #oh crap, mismatch!
      substr( $hil, $i, 1) = "!";
      # $i is coordinate of mismatch..., 
      $changes .= "$i: $reflist[$i] to $_|"; #changes delimited with |'s
    }
    $i++;
  }
  
  unless ($obsvseq eq $ref->seq) {
    $status = "MISMATCH";

  }

}
else {
  # I guess we gotta do things the hard way.... Another blast!
#align ref seq with obsvseq
#alignment cant be longer than refseq right?
#find where hits start, 

  $status = "ERROR: Lengths of observed and reference sequences between cutsites are unequal.";
  
#TODO yo kill this shit, you aren't using it, at least now.
  my $exp = Bio::Seq->new(-id => 'exp', -seq => $obsvseq,
      -alphabet => 'dna');

  my $blast_report2 = $factory->bl2seq($exp, $ref);

  my $result_obj2 = $blast_report2->next_result;
  my $hit_obj2 = $result_obj2->next_hit;
  my $hsp_obj2 = $hit_obj2->next_hsp;


  my $observed = uc $hsp_obj2->query_string;
  my $homo2 = uc $hsp_obj2->homology_string;
  my $reference= uc $hsp_obj2->hit_string;


}

#OUTPUT
print $ref->seq, "\n";
print $hil, "\n";
print $obsvseq, "\n";
print $status, "\n";
print $changes, "\n";

