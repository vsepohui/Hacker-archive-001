package Hacker::Player;

use 5.022;
use warnings;

use base 'Hacker';


sub new {
	my $class = shift;
	my %opts  = (
		@_,
	);
	
	my $self = {%opts};
	
	return bless $self, $class;
}

# Limit possible overload of signal
sub limiter {
	my $self = shift;
	my $s = shift;
	return $s > 1 ? 1 : $s < -1 ? -1 : $s;
}

# Play sound method; virtual method, must be redefined in child class
sub play {
	my $self   = shift;
	my @signal = @_;
	...
}

sub init {
	my $class  = shift;
	my $driver = shift // Hacker->config->{DEFAULT_DRIVER};
	
	# Validating driver by config
	die "Wrond driver \"$driver\"" unless $driver ~~ Hacker->config->{DRIVERS};

	# Compare child playe class value
	my $c = $class.'::'.$driver;
	
	# Including child class
	eval "use $c"; die $@ if $@;
	
	# Init player from child class
	my $player = eval "new $c"; die $@ if $@;
	return $player;
}

1;
