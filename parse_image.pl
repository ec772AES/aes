#!/usr/bin/perl

use strict;
use Cwd;
use Getopt::Long;
use File::Basename;
use GD;


my $cwd      = cwd();
my $help     = undef;
my $to_png   = 0;
my $to_blk   = 0;
my $png_file = undef;
my $blk_file = undef;

GetOptions ('help'       => \$help,
        'to_png'     => \$to_png,
            'to_blk'     => \$to_blk,
            'png_file=s' => \$png_file,
            'blk_file=s' => \$blk_file);


if ((defined $help) or
   (($to_png + $to_blk) != 1) or
   (!defined $png_file) or
   (!defined $blk_file)) {
  print "
USAGE
      parse_image.pl -(to_png|to_blk) -png_file <FILE> -blk_file <FILE>

";
  exit(0);
}


print "\n--------------------- parse_image ----------------------\n\n";


# Convert a PNG image to a BLK of data
if ($to_blk) {
  print "CONVERTING PNG '$png_file' to BLK '$blk_file'\n";

  my @hex = (0,0,0,0);
  my $png = GD::Image->newFromPng("$png_file") or die "$!";

  my ($col_length, $row_length) = $png->getBounds();
  print "  COL=$col_length, ROW=$row_length\n";

  open (PNG, ">", "$blk_file") or die "$!";
  print PNG "// COL=$col_length\n";
  print PNG "// ROW=$row_length\n";

  my $r = 0;
  my $c = 0;
  for ($r=0; $r<$row_length; $r++) {
    for ($c=0; $c<$col_length; $c++) {

      my ($red, $grn, $blu) = $png->rgb( $png->getPixel($c, $r) );
      $hex[$c%4] = sprintf("%02x%02x%02x%02x", $red, $grn, $blu, 0);

      if (($c%4) == 3) {
    print PNG sprintf("%s%s%s%s\n", $hex[0], $hex[1], $hex[2], $hex[3]);
      }
    }
  }

  #print PNG "\n";
  close PNG;

}


# Convert a BLK of data to a PNG image
if ($to_png) {
  print "CONVERTING BLK '$blk_file' to PNG '$png_file'\n";

  my $png;
  my $col_length;
  my $row_length;
  my @red = ();
  my @grn = ();
  my @blu = ();
  my %colors;

  open (BLK, "<", "$blk_file") or die "$!";
  while (my $line = <BLK>) {
    if ($line =~ /^\/\/ COL=(\d+)/) {
      $col_length = $1;
    }
    elsif ($line =~ /^\/\/ ROW=(\d+)/) {
      $row_length = $1;
      print "  COL=$col_length, ROW=$row_length\n";
      $png = GD::Image->new($col_length, $row_length);
    }
    elsif ($line =~ /^(..)(..)(..)00(..)(..)(..)00(..)(..)(..)00(..)(..)(..)00$/) {
      push(@red, $1);  push(@grn, $2);  push(@blu, $3);
      push(@red, $4);  push(@grn, $5);  push(@blu, $6);
      push(@red, $7);  push(@grn, $8);  push(@blu, $9);
      push(@red, $10); push(@grn, $11); push(@blu, $12);
    }
  }
  close BLK;

  my $r = 0;
  my $c = 0;
  for ($r=0; $r<$row_length; $r++) {
    for ($c=0; $c<$col_length; $c++) {

      my $red = hex(shift(@red));
      my $grn = hex(shift(@grn));
      my $blu = hex(shift(@blu));

      if (!exists $colors{$red}{$grn}{$blu}) {
    $colors{$red}{$grn}{$blu} = $png->colorAllocate($red, $grn, $blu);
      }

      $png->setPixel($c, $r, $colors{$red}{$grn}{$blu});

    }
  }

  my $png_data = $png->png();
  open (PNG, ">", "$png_file") or die "$!";
  binmode PNG;
  print PNG $png_data;
  close PNG;

}



print "\n--------------------------------------------------------\n\n";






