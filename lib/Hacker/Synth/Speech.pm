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
	
	my (undef, $file) = tempfile(SUFFIX => '.wav');
	
	`espeak "$text" -w $file`;
	
	$self->load_sample($file);
	
	unlink $file;
}

1;
