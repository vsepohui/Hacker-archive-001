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
	my $self  = shift;
	my $chord = shift;
	
	my @notes;

	my ($base, $m) = $chord =~ /^(\w\#?)(.*)$/i;
	my $add_bass = undef;
	if ($m =~ /^(.*)\/(\w\#?)$/) {
		$m = $1;
		$add_bass = $2;
	}

	$m ||= 'M';
	
	if ($m eq 'M' ) {
		@notes = qw/0 2 3/
	} elsif ($m eq 'm') {
		@notes = qw/0 2 3/;
	} elsif ($m eq '7') {
		@notes = qw/0 5 8/;
	} elsif ($m eq 'm7') {
		@notes = qw/0 4 8/;
	} elsif ($m eq 'V' || $m eq 'mV') {
		@notes = qw/0 7 12/;
	} else {
		die "Wrong chord $chord $m";
	}

	
	my @gamma;
	my $i = 0;
	for my $ch (@{$self->CHORDS()}) {
		if ($base eq $ch) {
			@gamma = map {$i + $_} @notes;
			last;
		}
		$i ++;
	}
	
	if ($add_bass) {
		$i = 0;
		for my $n (@{$self->CHORDS()}) {
			if ($add_bass eq $n) {
				$gamma[0] = $i;
			}
			$i ++;
		}
	}
	
	die "Wrong chord $chord" unless @gamma;
	
	return @gamma;
	
}

sub signal {
	my $self  = shift;
	my $chord = shift;
	
	my $i = 0;
	my @gamma = $self->gamma($chord);

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
