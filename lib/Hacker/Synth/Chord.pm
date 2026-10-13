package Hacker::Synth::Chord;

use 5.022;
use warnings;

use base 'Hacker::Synth';

use Hacker::Effect::Transpose;
use Hacker::Mixer;

use constant CHORDS => ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'H'];


sub new {
	my $class  = shift;
	my $sample = shift or die "Sample is not specified";
	
		
	my $self = {
		sample	=> $sample,
	};	
	
	return bless $self, $class;
}


sub signal {
	my $self  = shift;
	my $chord = shift;
	
	my $i = 0;
	my @gamma = (); 
	for my $ch (@{$self->CHORDS()}) {
		if ($chord eq $ch) {
			@gamma = map {$i + $_} qw/0 2 3/;
		} elsif ($chord eq ($ch . 'm')) {
			@gamma = map {$i + $_} qw/0 2 4/;
		}
		$i ++;
	}
	
	die "Wrong chord $chord" unless @gamma;
		
	my $s = $self->{sample};
	my @mix = map {[Hacker::Effect::Transpose->new($_)->process(@{$self->{sample}})]} @gamma;
	
	return Hacker::Mixer->new(@mix)->mix;
}

1;
