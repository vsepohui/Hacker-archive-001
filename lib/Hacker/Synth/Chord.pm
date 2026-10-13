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
	my @mix = reverse map {[Hacker::Effect::Transpose->new($_)->process(@{$self->{sample}})]} @gamma;
	
	return Hacker::Mixer->new(@mix)->mix;
}

1;
