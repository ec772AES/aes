#!/usr/bin/perl

use strict;
use Cwd;
use Getopt::Long;
use File::Basename;


my $stim;
my $gui;
my $clean;
my $help;

GetOptions ('help'     => \$help,
            'stim=s'   => \$stim,
            'clean'    => \$clean,
            'gui'      => \$gui);


if ($help or (!defined $stim)) {
  print "
USAGE
      runsim.pl -stim <FILE>

OPTIONS
      -stim <FILE>         Stimulus file to use.
      -gui                 Run sim with gui mode.
      -clean               Removes all tmp files.
      -help                Prints this usage.

";
exit(0);
}


print "\n--------------------- runsim ----------------------\n\n";


# Check the CWD
my $cwd = cwd();
die "ERROR: Must run from 'tmp' directory!" if (basename($cwd) ne 'tmp');


# Cleanup tmp directory
if (defined $clean) {
  print "\nCLEANING the tmp directory...\n\n";
  system('rm -rf *');
}


# Copy the stim file to the tmp dir
die "ERROR: No stim ($stim) exists!" if (!-e $stim);
system("cp $stim stim.v");


# Get a list of files to compile
my @files = ();
my @dirs  = ('../rtl',
             '../tb');

foreach my $dir (@dirs) {
  opendir DIR, $dir;
  print "PARSING DIR = $dir\n";
  while (my $file = readdir(DIR)) {
    if ($file =~ /\.(sv|v)$/) {
      print "      $file\n";
      push(@files, "$dir/$file");
    }
  }
  closedir DIR;
}


# Run the NC-Verilog command
my $cmd = 'ncverilog +sv +nc64bit ';
foreach my $file (@files) {
  $cmd .= " $file";
}
$cmd .= ' -clean' if (defined $clean);
$cmd .= ' +define+DUMP_WAVES +access+r +gui &' if (defined $gui);
print "\n\nRUNNING COMMAND: '$cmd'\n";
print "\n-------------------- NC Verilog --------------------\n";
system($cmd);


print "\n---------------------------------------------------\n";




