package PPIx::Utilities;

use 5.006001;
use strict;
use warnings;

our $VERSION = '1.007';


1;

__END__

=head1 NAME

PPIx::Utilities - Extensions to L<PPI>.


=head1 VERSION

This document describes PPIx::Utilities version 1.7.0.


=head1 SYNOPSIS

This module does nothing but act as a handle for the PPIx-Utilities
distribution.


=head1 DESCRIPTION

This is a collection of functions for dealing with L<PPI> objects, many of
which originated in L<Perl::Critic>.  They are organized into modules by the
kind of PPI class they relate to, by replacing the "PPI" at the front of the
module name with "PPIx::Utilities", e.g. functionality related to
L<PPI::Node>s is in L<PPIx::Utilities::Node>.


=head1 INTERFACE

None.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-ppix-utilities@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Elliot Shank  C<< <perl@galumph.com> >>


=head1 COPYRIGHT

Copyright (c)2009, Elliot Shank C<< <perl@galumph.com> >>.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR THE
SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE
STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE
SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND
PERFORMANCE OF THE SOFTWARE IS WITH YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE,
YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY
COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE THE
SOFTWARE AS PERMITTED BY THE ABOVE LICENSE, BE LIABLE TO YOU FOR DAMAGES,
INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
OUT OF THE USE OR INABILITY TO USE THE SOFTWARE (INCLUDING BUT NOT LIMITED TO
LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR
THIRD PARTIES OR A FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER
SOFTWARE), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES.

=cut

##############################################################################
#      $URL$
#     $Date$
#   $Author$
# $Revision$
##############################################################################

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 70
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
