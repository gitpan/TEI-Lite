#!/usr/bin/perl
######################################################################
##                                                                  ##
##  Script: html2tei.pl                                             ##
##  Author: D. Hageman <dhageman@dracken.com>                       ##
##                                                                  ##
##  Description:                                                    ##
##                                                                  ##
##  Utility to convert reasonably compliant HTML files to TEILite.  ##
##                                                                  ##
######################################################################

##==================================================================##
##  Libraries and Variables                                         ##
##==================================================================##

require 5.006;

use strict;
use warnings;

use TEI::Lite;
use XML::LibXML;

our $VERSION = "0.45";

our %HTML2TEI =
(
	'a'				=>	[ 'a_element' ],
	'abbr'			=>	[ 'tei_abbr' ],
	'acronym'		=>	[ 'tei_abbr' ],
	'address'		=>	[ 'tei_address' ],
	'applet'		=>	[ 'null_element' ],
	'area'			=>	[ 'null_element' ],
	'b'				=>	[ 'tei_hi', rend => 'bold' ],
	'base'			=>	[ 'null_element' ],
	'basefont'		=>	[ 'null_element' ],
	'bdo'			=>	[ 'null_element' ],
	'big'			=>	[ 'tei_hi', rend => 'bold' ],
	'blockquote'	=>	[ 'tei_div' ],
	'br'			=>	[ 'tei_lb' ],
	'center'		=>	[ 'tei_hi', rend => 'center' ],
	'cite'			=>	[ 'tei_cit' ],
	'code'			=>	[ 'tei_code' ],
	'col'			=>	[ 'null_element' ],
	'colgroup'		=>	[ 'null_element' ],
	'comment'		=>	[ 'comment_element' ],
	'dd'			=>	[ 'null_element' ],
	'del'			=>	[ 'null_element' ],
	'dfn'			=>	[ 'null_element' ],
	'div'			=>	[ 'null_element' ],
	'dl'			=>	[ 'null_element' ],
	'dt'			=>	[ 'null_element' ],
	'em'			=>	[ 'tei_emph' ],
	'fieldset'		=>	[ 'null_element' ],
	'font'			=>	[ 'null_element' ],
	'h1'			=>	[ 'header_element' ],
	'h2'			=>	[ 'header_element' ],
	'h3'			=>	[ 'header_element' ],
	'h4'			=>	[ 'header_element' ],
	'h5'			=>	[ 'header_element' ],
	'h6'			=>	[ 'header_element' ],
	'hr'			=>	[ 'null_element' ],
	'i'				=>	[ 'tei_hi', rend => 'italic' ],
	'img'			=>	[ 'img_element' ],
	'ins'			=>	[ 'null_element' ],
	'isindex'		=>	[ 'null_element' ],
	'kbd'			=>	[ 'null_element' ],
	'legend'		=>	[ 'null_element' ],
	'li'			=>	[ 'tei_item' ],
	'link'			=>	[ 'null_element' ],
	'ol'			=>	[ 'tei_list', type => 'ordered' ],
	'p'				=>	[ 'tei_p' ],
	'pre'			=>	[ 'null_element' ],
	'q'				=>	[ 'tei_hi', rend => 'quoted' ],
	's'				=>	[ 'null_element' ],
	'samp'			=>	[ 'tei_hi', rend => 'italic' ],
	'small'			=>	[ 'tei_hi', rend => 'normal' ],
	'span'			=>	[ 'tei_div' ],
	'strike'		=>	[ 'tei_hi', rend => 'strike-through' ],
	'strong'		=>	[ 'tei_hi', rend => 'bold' ],
	'style'			=>	[ 'null_element' ],
	'sub'			=>	[ 'null_element' ],
	'table'			=>	[ 'tei_table' ],
	'tbody'			=>	[ 'null_element' ],
	'td'			=>	[ 'tei_cell' ],
	'tfoot'			=>	[ 'null_element' ],
	'th'			=>	[ 'null_element' ],
	'thead'			=>	[ 'null_element' ],
	'tr'			=>	[ 'tei_row' ],
	'tt'			=>	[ 'tei_h', rend => 'monotype' ],
	'u'				=>	[ 'tei_hi', rend => 'underline' ],
	'ul'			=>	[ 'tei_list', type => 'bulleted' ],
	'var'			=>	[ 'tei_hi', rend => 'italic' ]
);

##==================================================================##
##  Main Execution                                                  ##
##==================================================================##

{
	## Check to see if we are given a file to convert.
	if( scalar( @ARGV ) < 1 )
	{
		print_usage();
	}
	
	## Create a parser to pull in the HTML file.
	my $parser = XML::LibXML->new();

	## Parse the HTML file given to utility - if it is reasonably
	## compliant - it should work.
	my $html_file = $parser->parse_html_file( $ARGV[0] );
	my $html_root = $html_file->documentElement;

	my $tei_file = TEI::Lite::Document->new( 'Corpus' 	=> 	0,
											 'Composite'	=>	0 );

	## We need to add a header to document.
	my $tei_header = $tei_file->addHeader();

	## Grab the body element of the TEI document.
	my $tei_body = $tei_file->getBody();
	
	## Time to set the title.
	my $title = $html_root->findvalue( '//head/title' );
	
	## Clean up the title a bit ...
	$title =~ s/^\s+//g;
	$title =~ s/\s+$//g;
	
	## Set the title correctly
	$tei_header->setTitle( $title );

	foreach( $html_root->findnodes( '//body/*' ) )
	{
		$tei_body->appendChild( parse_html( $_ ) );
	}
	
	## Print the docuument ...
	print $tei_file->toString( 2 ) . "\n";

	## We are done, exit nicely and go away!
	exit(0);
}

##==================================================================##
##  Function(s)                                                     ##
##==================================================================##

##----------------------------------------------##
##  a_element                                   ##
##----------------------------------------------##
sub a_element
{
	my $node = shift;

	my $href = $node->getAttribute( "href" );
	
	my $element = tei_xref( { url => $href } );

	foreach( $node->childNodes )
	{
		$element->appendChild( parse_html( $_ ) );
	}
	
	return( $element );
}

##----------------------------------------------##
##  header_element                              ##
##----------------------------------------------##
##  Special case for header elements.           ##
##----------------------------------------------##
sub header_element
{
	my $node = shift;

}

##----------------------------------------------##
##  comment_element                             ##
##----------------------------------------------##
##  Special case for converting comments.       ##
##----------------------------------------------##
sub comment_element
{
	my $node = shift;

	my $element;
	
	my $name = $node->nodeName;

	if( $name eq "h1" )
	{
		$element = tei_div1();
	}
	elsif( $name eq "h2" )
	{
		$element = tei_div2();
	}
	elsif( $name eq "h3" )
	{
		$element = tei_div3();
	}
	elsif( $name eq "h4" )
	{
		$element = tei_div4();
	}
	elsif( $name eq "h5" )
	{
		$element = tei_div5();
	}
	elsif( $name eq "h6" )
	{
		$element = tei_div6();
	}
	else
	{
		$element = tei_div();
	}
	
	my $head = tei_head();

	foreach( $node->childNodes )
	{
		$head->appendChild( $_ );
	}

	$element->appendChild( $head );
	
	return( $element );
}

##----------------------------------------------##
##  null_element                                ##
##----------------------------------------------##
##  Catch all case for elements we don't know.  ##
##  We basically just pass the data and remove  ##
##  the tag.                                    ##
##----------------------------------------------##
sub null_element
{
	return( XML::LibXML::DocumentFragment->new() );
}

##----------------------------------------------##
##  convert_element                             ##
##----------------------------------------------##
##  Most of the conversion magic happens in     ##
##  in this function.                           ##
##----------------------------------------------##
sub convert_element
{
	my( $node, $element )  = @_;

	foreach( $node->childNodes )
	{
		$element->appendChild( parse_html( $_ ) );
	}

	return( $element );
}

##----------------------------------------------##
##  img_element                                 ##
##----------------------------------------------##
##  Special case for img elements.              ##
##----------------------------------------------##
sub img_element
{
	my $node = shift;

	my $src = $node->getAttribute( "src" ) || "";
	my $alt = $node->getAttribute( "alt" ) || "";

	my $element = tei_figure( { url => $src } );

	if( $alt ne "" )
	{
		my $figDesc = tei_Desc( {}, $alt );

		$element->appendChild( $figDesc );
	}

	return( $element );
}

##----------------------------------------------##
##  parse_html                                  ##
##----------------------------------------------##
##  Function dispatch function.  MHH.           ##
##----------------------------------------------##
sub parse_html
{
	my $node = shift;

	## We need to declare a variable ...
	my $element;
	
	## If it is a text node, then just let it pass on
	## through ...
	if( ref( $node ) eq ( "XML::LibXML::Text" ) )
	{
		return( $node );
	}

	## Determine what type of node we are really dealing with.
	my $name = lc( $node->nodeName );
	
	no strict 'refs';
	
	my( @conversion ) = @{ $HTML2TEI{ $name } };
	
	my $function = shift( @conversion );
	my %attributes = @conversion;
	
	if( !defined( $function ) )
	{
		warn "No translation available for $name element!\n";
		return( XML::LibXML::Text->new( "" ) );
	}
	
	## Special cases and then the generic case.
	if( $name eq "img" )
	{
		$element = img_element( $node );
	}
	elsif( $name eq "a" )
	{
		$element = a_element( $node );
	}
	elsif( $name eq "comment" )
	{
		$element = comment_element( $node );
	}
	else
	{
		$element = convert_element( $node, &$function( \%attributes )  );
	}
	use strict 'refs';
	
	return( $element );
}

##----------------------------------------------##
##  print_usage                                 ##
##----------------------------------------------##
##  Subroutine to print usage information.      ##
##----------------------------------------------##
sub print_usage
{
	print "\nUsage: html2tei.pl <html file>\n\n";
	exit( 1 );
}

##==================================================================##
##  End of Code                                                     ##
##==================================================================##
1;

##==================================================================##
##  Plain Old Documenation (POD)                                    ##
##==================================================================##

__END__

=head1 NAME

html2tei.pl

=head1 SYNOPSIS

html2tei.pl <htmlfile>

=head1 DESCRIPTION

Utility to convert a HTML to a TEILite file.

=head1 AUTHOR

D. Hageman E<lt>dhageman@dracken.comE<gt>

=head1 SEE ALSO

L<TEI::Lite>, L<XML::LibXML>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2002 D. Hageman (Dracken Technologies).
All rights reserved.

This program is free software; you can redistribute it and/or modify 
it under the same terms as Perl itself. 

=cut
