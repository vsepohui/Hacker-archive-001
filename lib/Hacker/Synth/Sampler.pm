package Hacker::Synth::Sampler;

use 5.022;
use warnings;

use base 'Hacker::Synth';

use Hacker::Effect::Transpose;

sub new {
	my $class = shift;
	my $file  = shift or die "Sample file is not specified";
	
	
	die "Sample file not found" unless -f $file;
	
	my $self = {
		file 	=> $file,
	};
	
	$self = bless $self, $class;
	
	$self->load_sample();
	
	return $self;
}

sub load_sample {
	my $self = shift;
	my $file = $self->{file};

	my $out = `ffmpeg -loglevel quiet -i $file -f s16le -acodec pcm_s16le pipe:1`;

	my @chunks = unpack("s<*", $out);

	my @s;
	my $max = 32767;	
	for (@chunks) {
		push @s, $_ / $max;
	}

	$self->{sample} = \@s;
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
