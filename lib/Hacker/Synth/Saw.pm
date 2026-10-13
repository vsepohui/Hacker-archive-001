package Hacker::Synth::Saw;

use 5.022;
use warnings;

use base 'Hacker::Synth';


sub generate {
	my $class  = shift;
	my $offset = shift;
	
	my ($x, $y);
	
	my $step = int $offset;
	my $t = $step % 4;
	if ($t == 0 || $t == 3) {
		$x = $offset - $step;
		$y = 1;
	} else {
		$x = $offset - $step;
		$y = -1;
	}
	
	return $y;
}

1;
