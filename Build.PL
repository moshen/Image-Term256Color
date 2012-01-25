use 5.008;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Image::Term256Color',
    license             => 'perl',
    dist_author         => q{Colin Kennedy <moshen@cpan.org>},
    dist_version_from   => 'lib/Image/Term256Color.pm',
    script_files        => [ 'bin/img2term', 'bin/nyan' ],
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Term::ExtendedColor' => 0,
        'GD'                  => 0,
        'Getopt::Long'        => 0,
        'Pod::Usage'          => 0,
        'perl'                => 5.008,
    },
    add_to_cleanup      => [ 'Image-Term256Color-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();

