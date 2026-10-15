package Hacker::Synth::Sampler;

use 5.022;
use warnings;

use base 'Hacker::Synth';

use Hacker::Effect::Transpose;

sub new {
	my $class = shift;
	my $file  = shift or die "Sample file is not specified";
	
	
	die "Sample file $file not found" unless -f $file;
	
	my $self = {};
	
	$self = bless $self, $class;
	
	$self->load_sample($file);
	
	return $self;
}

sub load_sample {
	my $self = shift;
	my $file = shift;

	my $out = `ffmpeg -loglevel quiet -i $file -f s16le -acodec pcm_s16le pipe:1`;

	my @chunks = unpack("s*", $out);

	my $max = 32767;
	$self->{sample} = [map {$_ / $max} @chunks];
}

sub signal {
	my $self 		= ref $_[0] ? shift : new shift;
	my $note 		= $self->parse_note(shift // 0);
	my $length 		= shift;
	
	$length //= scalar @{$self->{sample}} - 1;
	
	return Hacker::Effect::Transpose->new($note)->process(map{$self->generate($_)} 0 .. $length);
}



sub generate {
	my $self   = shift;
	my $offset = shift;
	
	return $self->{sample}->[$offset];
}

1;
