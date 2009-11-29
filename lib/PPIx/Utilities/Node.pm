package PPIx::Utilities::Node;

use 5.006001;
use strict;
use warnings;

our $VERSION = '1.007';

use Readonly;


use PPI::Document::Fragment qw< >;
use Scalar::Util            qw< refaddr >;


use base 'Exporter';

Readonly::Array our @EXPORT_OK => qw<
    split_ppi_node_by_namespace
>;


sub split_ppi_node_by_namespace {
    my ($node) = @_;

    # Ensure we don't screw up the original.
    $node = $node->clone();

    # We want to make sure that we have locations prior to things are split
    # up, if we can.
    eval { $node->location(); };

    if ( my $single_namespace = _split_ppi_node_by_namespace_single($node) ) {
        return $single_namespace;
    } # end if

    my %nodes_by_namespace;
    my $namespace = 'main';
    my $fragment;
    foreach my $child ( $node->clone()->children() ) {
        if ( $child->isa('PPI::Statement::Package') ) {
            if ($fragment) {
                push @{ $nodes_by_namespace{$namespace} }, $fragment;

                undef $fragment;
            } # end if

            $namespace = $child->namespace();
        } # end if

        $fragment ||= PPI::Document::Fragment->new();
        # Need to fix these to use exceptions.  Thankfully the P::C tests will
        # insist that this happens.
        $child->remove() or die 'Could not remove child from parent.';
        $fragment->add_element($child) or die 'Could not add child to fragment.';
    } # end if
    if ($fragment) {
        push @{ $nodes_by_namespace{$namespace} }, $fragment;
    } # end if

    return \%nodes_by_namespace;
} # end split_ppi_node_by_namespace()


# Handle the case where there's only one.
sub _split_ppi_node_by_namespace_single {
    my ($node) = @_;

    my $package_statements = $node->find('PPI::Statement::Package');

    if ( not $package_statements or not @{$package_statements} ) {
        return { main => [$node] };
    } # end if

    if (@{$package_statements} == 1) {
        my $package_statement = $package_statements->[0];
        my $package_address = refaddr $package_statement;

        # Yes, child and not schild.
        my $first_child = $node->child(0);
        if (
                $package_address == refaddr $node
            or  $first_child and $package_address == refaddr $first_child
        ) {
            return { $package_statement->namespace() => [$node] };
        } # end if
    } # end if

    return;
} # end _split_ppi_node_by_namespace_single()

1;

__END__

=head1 NAME

PPIx::Utilities::Node - Extensions to L<PPI::Node>.


=head1 VERSION

This document describes PPIx::Utilities::Node version 1.7.0.


=head1 SYNOPSIS

    use PPIx::Utilities::Node qw< split_ppi_node_by_namespace >;

    my $dom = PPI::Document->new("...");

    while (
        my ($namespace, $sub_doms) = each split_ppi_node_by_namespace($dom)
    ) {
        foreach my $sub_dom ( @{$sub_doms} ) {
            ...
        }
    }


=head1 DESCRIPTION

This is a collection of functions for dealing with L<PPI::Node>s.


=head1 INTERFACE

Nothing is exported by default.


=head2 split_ppi_node_by_namespace($node)

Returns the subtrees for each namespace in the node as a reference to a hash
of references to arrays of L<PPI::Node>s.  Say we've got the following code:

    #!perl

    my $x = blah();

    package Foo;

    my $y = blah_blah();

    {
        say 'Whee!';

        package Bar;

        something();
    }

    thingy();

    package Baz;

    da_da_da();

    package Foo;

    foreach ( blrfl() ) {
        ...
    }

Calling this function on a L<PPI::Document> for the above returns a value that
looks like this, using multi-line string literals for the actual code parts
instead of PPI trees to make this easier to read:

    {
        main    => [
            q<
                #!perl

                my $x = blah();
            >,
        ],
        Foo     => [
            q<
                package Foo;

                my $y = blah_blah();

                {
                    say 'Whee!';

                }

                thingy();
            >,
            q<
                package Foo;

                foreach ( blrfl() ) {
                    ...
                }
            >,
        ],
        Bar     => [
            q<
                package Bar;

                something();
            >,
        ],
        Baz     => [
            q<
                package Baz;

                da_da_da();
            >,
        ],
    }

Note that the return value contains copies of the original nodes, and not the
original nodes themselves due to the need to handle namespaces that are not
file-scoped.  (Notice how the first element for "Foo" above differs from the
original code.)


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
