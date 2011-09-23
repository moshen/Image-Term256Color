#!perl -T

use Test::More tests => 1;

BEGIN {
  ok( $^O !~ /MSWin32/ , "OS isn't Windows") or BAIL_OUT("Right now this only works on Unix-like oses");
}

$ENV{'PATH'} = '/bin:/usr/bin:/usr/local/bin';
delete @ENV{'IFS', 'CDPATH', 'ENV', 'BASH_ENV'};

unless( `which tput` ){
  diag( "Warning: tput not found in " . $ENV{PATH} . " , img2term requires tput to function." );
}

