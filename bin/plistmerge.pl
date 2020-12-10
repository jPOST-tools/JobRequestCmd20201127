#!/usr/bin/perl

# plistmerge.pl
#
# Copyright © 2020 acyshzw for jPOST　 All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE

# plistmerge.pl (input MGF data file1) (file2) ... (output MGF file name)

@infiles = @ARGV;
$outfile = pop @infiles;

$json = '{
	"inFileAry":[
		"INFILE"
	],
	"outFile":
		"OUTFILE"
}';

$infile = join '","', @infiles;
$infile =~ s/\\/\//g;
$infile =~ s/\,/\,\n\t\t/g;

$outfile =~ s/\\/\//g;

$json =~ s/INFILE/$infile/;
$json =~ s/OUTFILE/$outfile/;

$jsonpath = $outfile;

$jsonpath =~ s/(\/|\\)[^\/|\\]+$/$1inOutFile.json/;

open (OUT, ">$jsonpath");

print OUT $json;

close (OUT);


system("ruby ../JobObjects/PeaklistMerge/PeaklistMerge.rb 20 ppm Wizd 0 $jsonpath");


exit;


