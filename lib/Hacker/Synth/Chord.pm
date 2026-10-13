package Hacker::Synth::Chord;

use 5.022;
use warnings;

use base 'Hacker::Synth';

use Hacker::Effect::Transpose;
use Hacker::Effect::Gainer;
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
	my $self  = shift;
	my $chord = shift;
	
	my $i = 0;
	my @gamma = $self->gamma($chord);

	die "Wrong chord $chord" unless @gamma;
	
	@gamma = @gamma[0..2];
		
	my @mix;
	
	my $vol = 1;
	for (@gamma) {
		my $g = Hacker::Effect::Gainer->new(value => $vol);
		push @mix,[
			$g->process(Hacker::Effect::Transpose->new($_)->process(@{$self->{sample}}))
		];
		#$i -= 0.5;
	}
	
	return Hacker::Mixer->new(@mix)->mix;
}

1;
