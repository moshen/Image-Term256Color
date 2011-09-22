#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Image::Term256Color' ) || print "Bail out!\n";
}

diag( "Testing Image::Term256Color $Image::Term256Color::VERSION, Perl $], $^X" );
