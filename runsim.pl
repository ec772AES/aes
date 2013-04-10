#!/usr/bin/perl

use strict;
use Cwd;
use Getopt::Long;
use File::Basename;


my $stim;
my $tb;
my $sim;
my $simnet;
my $gui;
my $synth;
my $waves;
my $help;

GetOptions ('help'     => \$help,
            'tb=s'     => \$tb,
            'sim'      => \$sim,
            'simnet'   => \$simnet,
            'synth'    => \$synth,
            'stim=s'   => \$stim,
            'waves'    => \$waves,
            'gui'      => \$gui);

if ($help or ((!defined $sim) and (!defined $synth) and (!defined $simnet)) ) {
  print "
USAGE
      runsim.pl -sim <FILE>

OPTIONS
      -tb   <FILE>         Testbench to run.
      -stim <FILE>         Stimulus file to use.
      -ncv                 Simulate, using ncverilog.
      -synth               Synthesize using the rc compiler.
      -gui                 Run sim with gui mode.
      -waves               Dumps waves with the sim.
      -help                Prints this usage.

";
exit(0);
}


print "\n--------------------- runsim ----------------------\n\n";


# Check the CWD
my $cwd = cwd();
die "ERROR: Must run from 'tmp' directory!" if (basename($cwd) ne 'tmp');


# Cleanup tmp directory, this rm -rf * scared me!!!!
#
#if (defined $clean) {
#  print "\nCLEANING the tmp directory...\n\n";
#  system('rm -rf *');
#}


# Copy the stim file to the tmp dir
if (defined $sim or $simnet) {
  die "ERROR: No tb ($tb) exists!"     if (!-e $tb);
  die "ERROR: No stim ($stim) exists!" if (!-e $stim);
  system("cp $stim stim.v");
}

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

# -------------------------------------------------------------------------------
# Run the NC-Verilog command
# -------------------------------------------------------------------------------

if (defined $sim) {
  my $cmdVerilog = 'ncverilog +sv +nc64bit +define+USING_RUNSIM +incdir+../inputs/';
  foreach my $file (@files) {
    $cmdVerilog .= " $file";
  }
  $waves = 1 if (defined $gui);
  #$cmdVerilog .= ' -clean'                       if (defined $clean);
  $cmdVerilog .= ' +define+DUMP_WAVES +access+r' if (defined $waves);
  $cmdVerilog .= ' +gui &'                       if (defined $gui);
  print "\n\nRUNNING COMMAND: '$cmdVerilog'\n";
  print "\n-------------------- NC Verilog --------------------\n";
  print "ncverilog simulation!\n";
  system($cmdVerilog);
}
# -------------------------------------------------------------------------------


# -------------------------------------------------------------------------------
# RTL compiler
# -------------------------------------------------------------------------------
my $cmdSynth = 'rc < synth.tcl';
#$cmdSynth .= 'set_attribute library /ad/eng/courses/ec/ec772/Nangate/NangateOpenCellLibrary_PDKv1_3_v2009_07/liberty/NangateOpenCellLibrary_typical_conditional_ccs.lib\n';
#$cmdSynth .= 'set_attribute hdl_search_path ../rtl';
#$cmdSynth .= 'set_attribute hdl_max_loop_limit 10000';
#$cmdSynth .= 'read_hdl';
#foreach my $file (@files) {
#  $cmdSynth .= " $file";
#}
#$cmdSynth .= 'elaborate';
#$cmdSynth .= 'check_design > synth_check_design.rpt';
#$cmdSynth .= 'set clk_input [define_clock -period 2000 -name clk_input clk]';
#$cmdSynth .= 'external_delay -input 0 -clock $clk_input -name in_con [find /des* -port ports_in/*]';
#$cmdSynth .= 'external_delay -output 0 -clock $clk_input -name out_con [find /des* -port ports_out/*]';
#$cmdSynth .= 'synthesize -to_mapped -effort medium';
#$cmdSynth .= 'write -mapped > core_top_netlist.v'; # TODO: specify output file
# Print out the reports
#$cmdSynth .= 'report timing > timing.rpt';
#$cmdSynth .= 'report area > cell_area.rpt';
#$cmdSynth .= 'report gates > gate_area.rpt';
#$cmdSynth .= 'report design_rules core_top > design_rule_violations.rpt';
# $cmdSynth .= 'exit'; # done

if (defined $synth) {
    system("cp ../synth.tcl synth.tcl");
    print "rc synthesis using nangate technology!\n";
    system($cmdSynth);
}


# -------------------------------------------------------------------------------
# Run the NC-Verilog command  with netlist
# -------------------------------------------------------------------------------

if (defined $simnet) {
  my $cmdVerilog = 'ncverilog +sv +nc64bit +define+USING_RUNSIM +incdir+../inputs/';
  $cmdVerilog .= " $tb";
  $cmdVerilog .= ' core_top_netlist.v ../../NangateOpenCellLibrary.v';
  $waves = 1 if (defined $gui);
  #$cmdVerilog .= ' -clean'                       if (defined $clean);
  $cmdVerilog .= ' +define+DUMP_WAVES +access+r' if (defined $waves);
  $cmdVerilog .= ' +gui &'                       if (defined $gui);
  print "\n\nRUNNING COMMAND: '$cmdVerilog'\n";
  print "\n-------------------- NC Verilog --------------------\n";
  print "ncverilog simulation!\n";
  system($cmdVerilog);
}
# -------------------------------------------------------------------------------


print "\n---------------------------------------------------\n";

