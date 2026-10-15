Hacker is a console DAW for a monks of Perl and UNIX!

Release just for demosceners and professional sound engeeners.

# Dependencies

alsa-utils, espeak, ffmpeg

# Installation

```
curl -s https://vsepohui.ru/hacker.sh | sudo sh
```

# My Hacker Projects

You can try to hearing my Projects in https://github.com/vsepohui/Hacker-Projects


```
https://github.com/vsepohui/Hacker-Projects/archive/refs/heads/main.zip
```


# Using of Hacker

Play Project:
```
hacker Projects-file.hacker   
hacker -i Project-file.hacker   
```

Render Project (in RAW format):
```
hacker -o filename.pcm Projects/One-hand-clapping.hacker
```

Render to flac (supported wav / mp3 / flac / ogg / m4a):
```
hacker -o filename.flac -e "chip sine"
```

Run code from command line:

```
hacker -e "chip sine"
```

Console RAW output and play a sound by an ffplay util:

```
hacker -e "chip sine" - | aplay -q-f s16_le -r 44100
```

Console input:

```
echo "chip sine" | hacker
```

Console input and output:
```
echo "chip sine" | hacker | aplay -q-f s16_le -r 44100
```


 
# Example of Hacker Projects

Dub-step like wave:

```
chip gain (delay [mix(
	[sine 13, 30],
	[silence (0.05), sine 12, 30],
)], frames => 1), 2;
```

Simple Drum Machine:

```
my $kick  = sample('Samples/extra/kick_029.flac');
my $snare = sample('Samples/extra/snare_028.flac');
my $hat   = sample('Samples/extra/hat_003.flac');

my @c1 = seq([$kick->play(-24)],  140, '0,.,.,.,0,0,.,.,0,.,.,.,0,.,.,.'); # Kick
my @c2 = seq([$kick->play(-36)],  140, '0,.,.,.,0,0,.,.,0,.,.,.,0,.,.,.'); # Sub kick
my @c3 = seq([$snare->play(-12)], 140, '.,.,0,.,.,.,0,.,.,.,0,.,.,.,0,.'); # Snare
my @c4 = seq([$hat->play(-24)],   140, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0'); # Hat


my @m = (mix(\@c1, \@c2, \@c3, \@c4)) x 4;

mix ([gain [rev @m] => .1], \@m);

```

Random Piano Player

```
my (@c1, @c2);
for (map {int rand(24)} 1..64) {
	push @c1, sine($_, 0.5);
	push @c2, sine($_+ 12, 0.5);
}

mix(\@c1, \@c2)
```

# Bugs

## Crushes on memory leaks

Perl had a much memory leaks, and on big projects Hacker crushed. Sorry, I don't know how to fix it.

# For demosceners

Please, don't make release, based on my projects! It's rip of my creative! Code by yourself!

# Credits

All project developed by Yahwe, Ivan Trunaev, Russia.
