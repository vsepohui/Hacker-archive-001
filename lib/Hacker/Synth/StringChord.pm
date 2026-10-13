package Hacker::Synth::StringChord;

use 5.022;
use warnings;

use base 'Hacker::Synth';

use Hacker::Effect::Transpose;
use Hacker::Mixer;

use constant GUITAR => [qw/-8 -3 2 7 11 16/];

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
			push @mix, [Hacker::Effect::Transpose->new($_+$self->GUITAR->[$_])->process(@{$self->{sample}})];
		}
		$i ++;
	}
		
	return Hacker::Mixer->new(@mix)->mix;
}

1;
