package Hacker::Synth::GuitarChord;

use 5.022;
use warnings;

use base 'Hacker::Synth';

use Hacker::Effect::Transpose;
use Hacker::Mixer;


sub new {
	my $class  = shift;
	my $sample = shift or die "Sample is not specified";
	
		
	my $self = {
		sample	=> $sample,
	};	
	
	return bless $self, $class;
}

sub signal {
	my $self  	= shift;
	my $chord 	= shift;
	
	my @mix;
	
	my $i = 0;
	for (split /,/, $chord) {
		if ($_ ne 'x' && $_ ne '') {
			push @mix, [Hacker::Effect::Transpose->new($_+$self->config->{GUITAR}->[$_])->process(@{$self->{sample}})];
		}
		$i ++;
	}
		
	return Hacker::Mixer->new(@mix)->mix;
}

1;
