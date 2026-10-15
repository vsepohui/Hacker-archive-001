package Hacker::Effect::Transpose;

use 5.022;
use warnings;

use base 'Hacker::Effect';


sub new {
	my $class = shift;
	my $value = shift;

	
	if ($value =~ /^-?\d+$/) {
		# ok
	} else {
		$value = $class->parse_note($value);
	}
	
	return $class->SUPER::new(value => $value);
}

sub process {
	my $self = shift;
	my @s = @_;
	
	my $v = $self->{value};
	if ($v) {
		
		if ($v > 0) {
			my $speed = (1 + $v / 12.0);
			my $n = scalar @s;
		
			my @out;
			for (my $i = 0 ; $i < $n ; $i += $speed) {
				push @out, $s[int $i];
			}
			return @out;
		} else {
			my $speed = (-1 + $v / 12.0);
			my $n = scalar @s;
		
			my @out;
			for (my $i = 0 ; $i < $n ; $i += 1 / (-1 * $speed)) {
				push @out, $s[int $i];
			}
			return @out;
		}
	}
	
	return @s;
}

1;
