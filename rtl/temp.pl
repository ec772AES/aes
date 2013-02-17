
my $i;
for ($i=127; $i>=0; $i-=8) {
  print sprintf("%3d:%3d\n", $i, $i-7);
}

