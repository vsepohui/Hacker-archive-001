package Hacker::Effect::Compressor;

use 5.022;
use warnings;

use base 'Hacker::Effect';


# Port from C code
# Copy-pasted from https://www.musicdsp.org/en/latest/Effects/169-compressor.html


sub process {
	my $self 		= shift;
	my $trel 		= pop; 	# release time
	my $tatt 		= pop; 	# attack time
	my $twnd   		= pop;	# window time
	my $tla			= pop;	# lookhead
	my $slope		= pop;	# slope angle (percents)
	my $threshold	= pop;	# threshold (percents)
	my @s = @_;
	
	my $sr = $self->sample_rate();
	
    $threshold *= 0.01; 	# hreshold to unity (0...1)
    $slope *= 0.01;			# slope to unity
    

    # attack and release "per sample decay"
    my $att = ($tatt == 0.0) ? (0.0) : exp (-1.0 / ($sr * $tatt));
    my $rel = ($trel == 0.0) ? (0.0) : exp (-1.0 / ($sr * $trel));

    # envelope
    my $env = 0.0;

    # sample offset to lookahead wnd start
    my $lhsmp = int ($sr * $tla);

    # samples count in lookahead window
    my $nrms = int ($sr * $twnd);

	my @result = ();
    # for each sample...
    my $n = scalar @s;
    for (my $i = 0; $i < $n; ++$i)
    {
        # now compute RMS
        my $summ = 0;

        # for each sample in window
        for (my $j = 0; $j < $nrms; ++$j)
        {
            my $lki = $i + $j + $lhsmp;
            my $smp;

            # if we in bounds of signal?
            # if so, convert to mono
            if ($lki < $n) {
                $smp = $s[$lki];
			} else {
                $smp = 0.0; # if we out of bounds we just get zero in smp
			}

            $summ += $smp * $smp; # square em..
        }

        my $rms = sqrt ($summ / $nrms); # root-mean-square

        # dynamic selection: attack or release?
        my $theta = $rms > $env ? $att : $rel;

        # smoothing with capacitor, envelope extraction...
        # here be aware of pIV denormal numbers glitch
        $env = (1.0 - $theta) * $rms + $theta * $env;

        # the very easy hard knee 1:N compressor
        my $gain = 1.0;
        if ($env > $threshold) {
            $gain = $gain - ($env - $threshold) * $slope;
		}

        # result - two hard kneed compressed channels...
        push @result, $s[$i] * $gain;
    }
    
    return @result;
}


1;
