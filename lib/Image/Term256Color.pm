package Image::Term256Color;

use 5.008;
use strict;
use warnings;

use GD::Image;
use Term::ExtendedColor ':attributes';

=head1 NAME

Image::Term256Color - Display images in your 256 color terminal! (kinda)

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

package Image::Term256Color;


=head1 SYNOPSIS

Converts an image to 256 color terminal displayable ascii.  Mostly for fun.

    use Image::Term256Color;

    print Image::Term256Color::convert( 'myimage.jpg' ) . "\n";

Scalar context spits out a string containing term color coded text
representing the entire image.

    print Image::Term256Color::convert( 'myimage.jpg' , { scale_ratio => .5 } ) . "\n";

Scale 'myimage.jpg' by 50% before converting.

    my @img_rows = Image::Term256Color::convert( 'myimage.jpg' );

Array context gives an array of strings.  Each string representing a row
within the image.  Unlike scalar context, there are no newlines.

=cut


# Giant table 'o term color codes and their RGB equivalents (roughly)

my $termcolors = {
  16 => [0 , 0 , 0],      52 => [95 , 0 , 0],      88 => [135 , 0 , 0],
  17 => [0 , 0 , 95],     53 => [95 , 0 , 95],     89 => [135 , 0 , 95],
  18 => [0 , 0 , 135],    54 => [95 , 0 , 135],    90 => [135 , 0 , 135],
  19 => [0 , 0 , 175],    55 => [95 , 0 , 175],    91 => [135 , 0 , 175],
  20 => [0 , 0 , 215],    56 => [95 , 0 , 215],    92 => [135 , 0 , 215],
  21 => [0 , 0 , 255],    57 => [95 , 0 , 255],    93 => [135 , 0 , 255],
  22 => [0 , 95 , 0],     58 => [95 , 95 , 0],     94 => [135 , 95 , 0],
  23 => [0 , 95 , 95],    59 => [95 , 95 , 95],    95 => [135 , 95 , 95],
  24 => [0 , 95 , 135],   60 => [95 , 95 , 135],   96 => [135 , 95 , 135],
  25 => [0 , 95 , 175],   61 => [95 , 95 , 175],   97 => [135 , 95 , 175],
  26 => [0 , 95 , 215],   62 => [95 , 95 , 215],   98 => [135 , 95 , 215],
  27 => [0 , 95 , 255],   63 => [95 , 95 , 255],   99 => [135 , 95 , 255],
  28 => [0 , 135 , 0],    64 => [95 , 135 , 0],    100 => [135 , 135 , 0],
  29 => [0 , 135 , 95],   65 => [95 , 135 , 95],   101 => [135 , 135 , 95],
  30 => [0 , 135 , 135],  66 => [95 , 135 , 135],  102 => [135 , 135 , 135],
  31 => [0 , 135 , 175],  67 => [95 , 135 , 175],  103 => [135 , 135 , 175],
  32 => [0 , 135 , 215],  68 => [95 , 135 , 215],  104 => [135 , 135 , 215],
  33 => [0 , 135 , 255],  69 => [95 , 135 , 255],  105 => [135 , 135 , 255],
  34 => [0 , 175 , 0],    70 => [95 , 175 , 0],    106 => [135 , 175 , 0],
  35 => [0 , 175 , 95],   71 => [95 , 175 , 95],   107 => [135 , 175 , 95],
  36 => [0 , 175 , 135],  72 => [95 , 175 , 135],  108 => [135 , 175 , 135],
  37 => [0 , 175 , 175],  73 => [95 , 175 , 175],  109 => [135 , 175 , 175],
  38 => [0 , 175 , 215],  74 => [95 , 175 , 215],  110 => [135 , 175 , 215],
  39 => [0 , 175 , 255],  75 => [95 , 175 , 255],  111 => [135 , 175 , 255],
  40 => [0 , 215 , 0],    76 => [95 , 215 , 0],    112 => [135 , 215 , 0],
  41 => [0 , 215 , 95],   77 => [95 , 215 , 95],   113 => [135 , 215 , 95],
  42 => [0 , 215 , 135],  78 => [95 , 215 , 135],  114 => [135 , 215 , 135],
  43 => [0 , 215 , 175],  79 => [95 , 215 , 175],  115 => [135 , 215 , 175],
  44 => [0 , 215 , 215],  80 => [95 , 215 , 215],  116 => [135 , 215 , 215],
  45 => [0 , 215 , 255],  81 => [95 , 215 , 255],  117 => [135 , 215 , 255],
  46 => [0 , 255 , 0],    82 => [95 , 255 , 0],    118 => [135 , 255 , 0],
  47 => [0 , 255 , 95],   83 => [95 , 255 , 95],   119 => [135 , 255 , 95],
  48 => [0 , 255 , 135],  84 => [95 , 255 , 135],  120 => [135 , 255 , 135],
  49 => [0 , 255 , 175],  85 => [95 , 255 , 175],  121 => [135 , 255 , 175],
  50 => [0 , 255 , 215],  86 => [95 , 255 , 215],  122 => [135 , 255 , 215],
  51 => [0 , 255 , 255],  87 => [95 , 255 , 255],  123 => [135 , 255 , 255],

  124 => [175 , 0 , 0],      160 => [215 , 0 , 0],      196 => [255 , 0 , 0],
  125 => [175 , 0 , 95],     161 => [215 , 0 , 95],     197 => [255 , 0 , 95],
  126 => [175 , 0 , 135],    162 => [215 , 0 , 135],    198 => [255 , 0 , 135],
  127 => [175 , 0 , 175],    163 => [215 , 0 , 175],    199 => [255 , 0 , 175],
  128 => [175 , 0 , 215],    164 => [215 , 0 , 215],    200 => [255 , 0 , 215],
  129 => [175 , 0 , 255],    165 => [215 , 0 , 255],    201 => [255 , 0 , 255],
  130 => [175 , 95 , 0],     166 => [215 , 95 , 0],     202 => [255 , 95 , 0],
  131 => [175 , 95 , 95],    167 => [215 , 95 , 95],    203 => [255 , 95 , 95],
  132 => [175 , 95 , 135],   168 => [215 , 95 , 135],   204 => [255 , 95 , 135],
  133 => [175 , 95 , 175],   169 => [215 , 95 , 175],   205 => [255 , 95 , 175],
  134 => [175 , 95 , 215],   170 => [215 , 95 , 215],   206 => [255 , 95 , 215],
  135 => [175 , 95 , 255],   171 => [215 , 95 , 255],   207 => [255 , 95 , 255],
  136 => [175 , 135 , 0],    172 => [215 , 135 , 0],    208 => [255 , 135 , 0],
  137 => [175 , 135 , 95],   173 => [215 , 135 , 95],   209 => [255 , 135 , 95],
  138 => [175 , 135 , 135],  174 => [215 , 135 , 135],  210 => [255 , 135 , 135],
  139 => [175 , 135 , 175],  175 => [215 , 135 , 175],  211 => [255 , 135 , 175],
  140 => [175 , 135 , 215],  176 => [215 , 135 , 215],  212 => [255 , 135 , 215],
  141 => [175 , 135 , 255],  177 => [215 , 135 , 255],  213 => [255 , 135 , 255],
  142 => [175 , 175 , 0],    178 => [215 , 175 , 0],    214 => [255 , 175 , 0],
  143 => [175 , 175 , 95],   179 => [215 , 175 , 95],   215 => [255 , 175 , 95],
  144 => [175 , 175 , 135],  180 => [215 , 175 , 135],  216 => [255 , 175 , 135],
  145 => [175 , 175 , 175],  181 => [215 , 175 , 175],  217 => [255 , 175 , 175],
  146 => [175 , 175 , 215],  182 => [215 , 175 , 215],  218 => [255 , 175 , 215],
  147 => [175 , 175 , 255],  183 => [215 , 175 , 255],  219 => [255 , 175 , 255],
  148 => [175 , 215 , 0],    184 => [215 , 215 , 0],    220 => [255 , 215 , 0],
  149 => [175 , 215 , 95],   185 => [215 , 215 , 95],   221 => [255 , 215 , 95],
  150 => [175 , 215 , 135],  186 => [215 , 215 , 135],  222 => [255 , 215 , 135],
  151 => [175 , 215 , 175],  187 => [215 , 215 , 175],  223 => [255 , 215 , 175],
  152 => [175 , 215 , 215],  188 => [215 , 215 , 215],  224 => [255 , 215 , 215],
  153 => [175 , 215 , 255],  189 => [215 , 215 , 255],  225 => [255 , 215 , 255],
  154 => [175 , 255 , 0],    190 => [215 , 255 , 0],    226 => [255 , 255 , 0],
  155 => [175 , 255 , 95],   191 => [215 , 255 , 95],   227 => [255 , 255 , 95],
  156 => [175 , 255 , 135],  192 => [215 , 255 , 135],  228 => [255 , 255 , 135],
  157 => [175 , 255 , 175],  193 => [215 , 255 , 175],  229 => [255 , 255 , 175],
  158 => [175 , 255 , 215],  194 => [215 , 255 , 215],  230 => [255 , 255 , 215],
  159 => [175 , 255 , 255],  195 => [215 , 255 , 255],  231 => [255 , 255 , 255],

  # Gray scale ramp
  232 => [8 , 8 , 8],
  233 => [18 , 18 , 18],
  234 => [28 , 28 , 28],
  235 => [38 , 38 , 38],
  236 => [48 , 48 , 48],
  237 => [58 , 58 , 58],
  238 => [68 , 68 , 68],
  239 => [78 , 78 , 78],
  240 => [88 , 88 , 88],
  241 => [98 , 98 , 98],
  242 => [108 , 108 , 108],
  243 => [118 , 118 , 118],
  244 => [128 , 128 , 128],
  245 => [138 , 138 , 138],
  246 => [148 , 148 , 148],
  247 => [158 , 158 , 158],
  248 => [168 , 168 , 168],
  249 => [178 , 178 , 178],
  250 => [188 , 188 , 188],
  251 => [198 , 198 , 198],
  252 => [208 , 208 , 208],
  253 => [218 , 218 , 218],
  254 => [228 , 228 , 228],
  255 => [238 , 238 , 238],
};

# Create our palette object and lookup array
my $pal = GD::Image->new();

my @colorlookup;
foreach my $k ( keys( %{$termcolors} )){
  $pal->colorAllocate($termcolors->{$k}->[0],
                      $termcolors->{$k}->[1],
                      $termcolors->{$k}->[2]);

  push(@colorlookup, $k);
}

=head1 SUBROUTINES/METHODS

=head2 convert 

=head4 Image::Term256Color::convert( $filename , \%options );
=head4 Image::Term256Color::convert( *FILEHANDLE , \%options );
=head4 Image::Term256Color::convert( $data , \%options );

Accepts a $filename , *FILEHANDLE or scalar containing image data for PNG ,
Jpeg , Gif and GD2 image types.  This is thrown right into GD::Image (See L<GD>);

The \%options hashref may consist of:

=over

=item * scale_ratio

scale_ratio is a decimal number used to scale the original image
before converting to colored text.

=item * scale_x

scale_x represents the number of characters wide the resulting encoded
image will be.  This option scales the image height proportionally.

=back

Returns a color coded string with newlines in scalar context and an
array of strings represting rows in the image in array context.

Returns a 0 in scalar context and empty array in array context if there
is an error with the provided image.

=cut

sub convert {
  my ($img, $opts) = @_;

  my $char = 0;
  my $gdimg;

  if( $opts ){
    if( $opts->{scale_ratio} || $opts->{scale_x} ){
      my $origimg = GD::Image->new($img);
      unless( $origimg ){
        return wantarray ? () : 0;
      }

      my ($width, $height) = $origimg->getBounds();
      my $ratio;

      if( $opts->{scale_ratio} ){
        $ratio = $opts->{scale_ratio};

      } elsif( $opts->{scale_x} ){
        $ratio = $opts->{scale_x} / $width;

      }
      $gdimg = GD::Image->new($width  * $ratio,
                              $height * $ratio);
      $gdimg->copyResized($origimg, 0,0,0,0,
                          $width  * $ratio,
                          $height * $ratio,
                          $width  , $height);

    }

    if( $opts->{string_to_colorize} ){
      $char = $opts->{string_to_colorize};

    }
  }

  unless( $gdimg ){
    $gdimg = GD::Image->new($img);
    unless( $gdimg ){
      return wantarray ? () : 0;
    }
  }
  
  return convert_from_gdimg( $gdimg, $char);
}

# Undocumented functions
sub get_term256color {
  my( $r , $g , $b ) = @_;

  return $colorlookup[$pal->colorClosest( $r , $g , $b )];
}

sub convert_from_gdimg {
  my ($img, $char) = @_;

  my ($width, $height) = $img->getBounds();

  unless( $char ){
    $char = '  ';
  }
  
  my @termimg;
  
  for( my $i=0; $i<$height; $i++ ){
    my $rowstring;
    my $localstring; # Used to group spaces of the same color
    my $curcolor = 0;
    for( my $j=0; $j<$width; $j++ ){
      my $ptotest = $img->getPixel($j,$i);
      my $newcolor = $colorlookup[$pal->colorClosest($img->rgb($ptotest))];

      if( $newcolor != $curcolor ){
        $rowstring .= bg( $curcolor , $localstring);
        $curcolor = $newcolor;
        $localstring = '';
      }
      
      $localstring .= $char;
    }

    $rowstring .= bg( $curcolor , $localstring);
    push(@termimg, $rowstring);
  }

  return wantarray ? @termimg : join("\n", @termimg);
}

=head1 EXAMPLES

Please look at L<img2term> bundled with this distribution.

=head1 AUTHOR

Colin, C<< <moshen at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests through
the web interface at L<https://github.com/moshen/Image-Term256Color/issues>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Image::Term256Color


You can also look for information at:

=over 4

=item * GitHub in moshen/Image-Term256Color (report bugs here)

L<https://github.com/moshen/Image-Term256Color>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Image-Term256Color>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Image-Term256Color>

=item * Search CPAN

L<http://search.cpan.org/dist/Image-Term256Color/>

=back


=head1 ACKNOWLEDGEMENTS

L<GD>!  It does all the work.

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Colin.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Image::Term256Color
