#!/bin/perl
# Perl script that parses a list of word+POS lines, and for each
# such line, calls make to generate the corresponding paradigm.

use File::Spec;

my $word_pos_list = @ARGV[0];
my $xsl_script = @ARGV[1];
my $gen_tmp = @ARGV[2];
my $jc = "java net.sf.saxon.Transform -it main ";
my $para_tmp = "PARA_tmp";
my $xml_tmp = "XML_tmp";
my $mk_dir_cmd = "mkdir $gen_tmp/$para_tmp $gen_tmp/$xml_tmp";

    system($mk_dir_cmd);
    print "$word_pos_list\n" ;

open FILE, $word_pos_list or die $!;

while ( <FILE> ) {
  chop;
  if (/^\s.*$/) {
    next;
  } else {
    my $word, $pos;
    ($word, $pos) = split;
    $word_pos = $word . "_" . $pos;
        print "word is $word\n" ;
        print "pos is $pos\n" ;
    my $command = "gmake $pos-paradigm WORD\=$word GEN_TMP\=$gen_tmp PARA_TMP\=$para_tmp" ;
    #    print "$command\n";
    system($command);
    my $xmlcommand = "perl paradigm2xml_sma.pl $gen_tmp/$para_tmp/$word_pos.paradigm > $gen_tmp/$xml_tmp/$word_pos.xml";
    system($xmlcommand);
    
    $abs_path = File::Spec->rel2abs("$gen_tmp/$xml_tmp/$word_pos.xml");
    
    my $xslcommand = "$jc $xsl_script file=$abs_path path=$gen_tmp";
    
    #     print "$xslcommand\n";
    
    system($xslcommand);
    
  }
  
}
