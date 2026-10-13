package Hacker::Synth::Chord;

use 5.022;
use warnings;

use base 'Hacker::Synth';

use Hacker::Effect::Transpose;
use Hacker::Effect::Gainer;
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

sub gamma {
	my $self = shift;
	my $m 	 = shift;
	
	if ($m eq 'M' ) {
		return qw/0 2 3/
	} elsif ($m eq 'm') {
		return qw/0 2 3/;
	} elsif ($m eq '7') {
		return qw/0 5 8/;
	} elsif ($m eq 'm7') {
		return qw/0 4 8/;
	} elsif ($m eq 'V' || $m eq 'mV') {
		return qw/0 7 12/;
	}
	
	die "Wrong gamma code $m";
}

sub signal {
	my $self  = shift;
	my $chord = shift;
	
	my $i = 0;
	my @gamma = (); 

	my ($base, $code) = $chord =~ /^(\w\#?)(.*)$/i;
	$code ||= 'M';
	
	for my $ch (@{$self->CHORDS()}) {
		if ($base eq $ch) {
			@gamma = map {$i + $_} $self->gamma($code);
			last;
		}
		$i ++;
	}
	
	die "Wrong chord $chord" unless @gamma;
		
	my $s = $self->{sample};
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
