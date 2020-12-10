#!/usr/bin/perl

# plistsplit.pl
#
# Copyright © 2020 acyshzw for jPOST　 All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE

# plistsplit.pl (input MGF data file) (main name for output MGF files) (MS/MS spectra number upper limit (arbitrary))

@args = @ARGV;

$infile = $args[0];
$outfile = $args[1];
if ($args[2]){

    $lim = $args[2];
    
} else {

    $lim = 100000;
}

$basename = $outfile . ".%s.split.mgf";

system("php ../JobObjects/PeaklistSplit/PeaklistSplit.php $infile $basename $lim");

exit;


