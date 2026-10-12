package Hacker::Player::aplay;

use 5.022;
use warnings;

use base 'Hacker::Player';

use Hacker::Render;

use File::Temp qw(tempfile);


sub play {
	my $self = shift;
	my @signal = @_;
	
	# Create tmp file
	my (undef, $filename) = tempfile();
	
	my $render = new Hacker::Render(filename => $filename);
	$render->render(@signal);

	# Hook for delete tmp file is user try to kill the app
	$SIG{INT} = sub {
		unlink $filename;
	};

	# Let's play audio by aplay utility
	my $rate = $self->sample_rate;
	`aplay -q -f s16_le -r $rate $filename`;

	# Remove tmp PCM file
	unlink $filename;
	
	# Delete hook
	delete $SIG{INT};
}

1;
