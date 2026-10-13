package Hacker::Synth::Speech;

use 5.022;
use warnings;

use base 'Hacker::Synth::Sampler';

use Hacker::Effect::Transpose;

use File::Temp qw(tempfile);


sub new {
	my $class = shift;
	my $text  = shift or die "text is not specified";
	
	my $self = {
		text => $text,
	};
	
	$self = bless $self, $class;
	
	$self->render_sample();
	
	return $self;
}

sub render_sample {
	my $self = shift;
	my $text = $self->{text};
	
	my (undef, $file) = tempfile();
	
	`espeak-ng "$text" -w $file`;

	my $out = `ffmpeg -loglevel quiet -i $file -f s16le -acodec pcm_s16le pipe:1`;
	
	unlink $file;

	my @chunks = unpack("(a4)*", $out);

	my @s;
	my $max = 32767;	
	for (@chunks) {
		my $s;

		my ($left, $right) = unpack('s<s<', $_);
		$s = $left;
		
		push @s, $s / $max;
	}

	$self->{sample} = \@s;
}

1;
