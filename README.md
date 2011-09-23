# Image-Term256Color



## INSTALLATION

This module requires [GD](https://metacpan.org/module/GD), which requires
libgd2 to be installed on your system with the development headers available.

To install this module from cpan:

    cpan -i Image::Term256Color

or

    cpanm Image::Term256Color

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
<img src="http://i.imgur.com/8sLut.png">

## SUPPORT AND DOCUMENTATION

After installing, you can find documentation for this module with the
perldoc command.

    perldoc Image::Term256Color
    perldoc img2term

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

Copyright (C) 2011 Colin

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

