package TEI::Lite;
######################################################################
##                                                                  ##
##  Package:  Lite.pm                                               ##
##  Author:   D. Hageman <dhageman@dracken.com>                     ##
##                                                                  ##
##  Description:                                                    ##
##                                                                  ##
##  Perl object designed to assist the user in the creation and     ##
##  manipulation of TEILite documents.                              ##
##                                                                  ##
######################################################################

##==================================================================##
##  Libraries and Variables                                         ##
##==================================================================##

require 5.6.0;
require Exporter::Cluster;

use strict;
use warnings;

our @ISA = qw( Exporter::Cluster );

our %EXPORT_CLUSTER = ( 'TEI::Lite::Document'	=>	[],
						'TEI::Lite::Element'	=>	[],
						'TEI::Lite::Header'		=>	[] );

our $VERSION = "0.4.0";

##==================================================================##
##  Constructor(s)/Deconstructor(s)                                 ##
##==================================================================##

##
##  None.
##

##==================================================================##
##  Method(s)                                                       ##
##==================================================================##

##
##  None.
##

##==================================================================##
##  End of Code                                                     ##
##==================================================================##
1;

##==================================================================##
##  Plain Old Documentation (POD)                                   ##
##==================================================================##

__END__

=head1 NAME

TEI::Lite

=head1 DESCRIPTION

TEI::Lite is a DOM wrapper designed to ease the creation and modification
of XML documents based on the Text Encoding Initiative markup variant
called TEILite.  TEILite is generally considered to contain enough tags 
and markup flexibility to be able to handle most document types.

=head1 AUTHOR

D. Hageman E<lt>dhageman@dracken.comE<gt>

=head1 SEE ALSO

L<TEI::Lite::Document>, L<TEI::Lite::Header>, L<TEI::Lite::Element>
L<XML::LibXML>, L<XML::LibXML::Element>, L<XML::LibXML::Node>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2002 D. Hageman (Dracken Technologies).
All rights reserved.

This program is free software; you can redistribute it and/or modify 
it under the same terms as Perl itself. 

=cut

