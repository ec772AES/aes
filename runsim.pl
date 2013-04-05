#!/usr/bin/perl

use strict;
use Cwd;
use Getopt::Long;
use File::Basename;


my $stim;
my $tb;
my $nosim;
my $gui;
my $clean;
my $waves;
my $help;

GetOptions ('help'     => \$help,
            'tb=s'     => \$tb,
            'nosim'    => \$nosim,
            'stim=s'   => \$stim,
            'clean'    => \$clean,
            'waves'    => \$waves,
            'gui'      => \$gui);


if ($help or (!defined $stim)) {
  print "
USAGE
      runsim.pl -stim <FILE>

OPTIONS
      -tb   <FILE>         Testbench to run.
      -stim <FILE>         Stimulus file to use.
      -nosim               Don't simulate, just print files.
      -gui                 Run sim with gui mode.
      -waves               Dumps waves with the sim.
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
die "ERROR: No tb ($tb) exists!"     if (!-e $tb);
die "ERROR: No stim ($stim) exists!" if (!-e $stim);
system("cp $stim stim.v");


# Get a list of files to compile
my @files = ($tb);
my @dirs  = ('../rtl');

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


# Run the NC-Verilog command  +ncv200x    
my $cmd = 'ncverilog +sv +nc64bit +define+USING_RUNSIM +incdir+../inputs/';
foreach my $file (@files) {
  $cmd .= " $file";
}
$waves = 1 if (defined $gui);
$cmd .= ' -clean'                       if (defined $clean);
$cmd .= ' +define+DUMP_WAVES +access+r' if (defined $waves);
$cmd .= ' +gui &'                       if (defined $gui);
print "\n\nRUNNING COMMAND: '$cmd'\n";
print "\n-------------------- NC Verilog --------------------\n";

if (defined $nosim) {
  print "NO SIMULATION due to -nosim switch!\n";
}
else {
  system($cmd);
}

print "\n---------------------------------------------------\n";



