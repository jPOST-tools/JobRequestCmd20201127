#!/usr/bin/perl

# proteowizardplist.pl
#
# Copyright © 2020 acyshzw for jPOST　 All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE

# proteowizardplist.pl (input raw data file) (output MGF file name)

($infile, $outfile) = @ARGV;

if ($infile =~ m/\.raw$/){

    system("ruby ../JobObjects/ProteoWizardPlist/ProteoWizardPlist.rb $infile $outfile 9 ppm dummy");
    
} elsif ($infile =~ m/\.wiff$/){

    system("ruby ../JobObjects/ProteoWizardPlistW/ProteoWizardPlistW.rb $infile $outfile 9 ppm dummy");
}

exit;

