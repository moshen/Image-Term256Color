# Image-Term256Color

Image-Term256Color is a perl module for converting image data into 256 color
terminal ascii.  When output to a compatible terminal, such as the ones
reflected in the following table ( [from the Term::ExtendedColor docs](
https://metacpan.org/module/Term::ExtendedColor) ):

    Terminal    256 colors
    ----------------------
    aterm               no
    eterm              yes
    gnome-terminal     yes
    konsole            yes
    lxterminal         yes
    mrxvt              yes
    roxterm            yes
    rxvt                no
    rxvt-unicode       yes *
    sakura             yes
    terminal           yes
    terminator         yes
    vte                yes
    xterm              yes
    iTerm2             yes
    Terminal.app        no

    GNU Screen         yes
    tmux               yes
    TTY/VC              no

    * Previously needed a patch. Full support was added in version 9.09


## INSTALLATION

This module requires [GD](https://metacpan.org/module/GD), which requires
libgd2 to be installed on your system with the development headers available.

To install libgd2 on Mac OS X:

    brew install gd

To install this module from cpan:

    cpan -i Image::Term256Color

or

    cpanm Image::Term256Color

CPAN may require `--force` since the GD modules tests include actual display
tests which will often fail.

To install this module from source, run the following commands:

    perl Build.PL
    ./Build
    ./Build test
    ./Build install

## EXAMPLES

    use Image::Term256Color;

    print Image::Term256Color::convert( 'myimage.jpg' ) . "\n";

Scalar context spits out a string containing term color coded text
representing the entire image.

    print Image::Term256Color::convert( 'myimage.jpg' , { scale_ratio => .5 } ) . "\n";

Scale 'myimage.jpg' by 50% before converting.

    my @img_rows = Image::Term256Color::convert( 'myimage.jpg' );

Array context gives an array of strings.  Each string representing a row
within the image.  Unlike scalar context, there are no newlines.



Using the included img2term script:

    curl http://octodex.github.com/images/original.jpg | img2term -x=40

Results in something like:

![Termcat](http://i.imgur.com/uF2f8.png)

Using the included nyan script:

    nyan -r 5 -n

Results in something like:

![Nyancat](http://i.imgur.com/XRyIU.gif)

If you just want to have an animated terminal Nyancat, I've ported the 
animation script [in this gist](https://gist.github.com/1417991) to be
a standalone script.

## SUPPORT AND DOCUMENTATION

After installing, you can find documentation for this module with the
perldoc commands.

    perldoc Image::Term256Color
    perldoc img2term
    perldoc nyan

You can also look for information at:

*   GitHub in moshen/Image-Term256Color (report bugs here)
    https://github.com/moshen/Image-Term256Color

*   RT, CPAN's request tracker
    http://rt.cpan.org/NoAuth/Bugs.html?Dist=Image-Term256Color

*   AnnoCPAN, Annotated CPAN documentation
    http://annocpan.org/dist/Image-Term256Color

*   CPAN Ratings
    http://cpanratings.perl.org/d/Image-Term256Color

*   Search CPAN
    http://search.cpan.org/dist/Image-Term256Color/


## LICENSE AND COPYRIGHT

Copyright (C) 2011 Colin Kennedy

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

