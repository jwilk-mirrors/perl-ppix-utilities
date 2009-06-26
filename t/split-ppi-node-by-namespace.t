#!/usr/bin/env perl

use 5.006;

use strict;
use warnings;

our $VERSION = '1.001';


use PPI::Document qw< >;
use PPI::Dumper qw< >;
use PPIx::Utilities::Node qw< split_ppi_node_by_namespace >;


use Test::Deep qw< cmp_deeply >;
use Test::More tests => 1;


my $source = <<'END_SOURCE';
package Foo;

$x = 1;
END_SOURCE

my %expected = (
    Foo => [ <<'END_EXPECTED' ],
PPI::Document
  PPI::Statement::Package
    PPI::Token::Word    'package'
    PPI::Token::Whitespace      ' '
    PPI::Token::Word    'Foo'
    PPI::Token::Structure   ';'
  PPI::Token::Whitespace    '\n'
  PPI::Token::Whitespace    '\n'
  PPI::Statement
    PPI::Token::Symbol      '$x'
    PPI::Token::Whitespace      ' '
    PPI::Token::Operator    '='
    PPI::Token::Whitespace      ' '
    PPI::Token::Number      '1'
    PPI::Token::Structure   ';'
  PPI::Token::Whitespace    '\n'
END_EXPECTED
);

_test($source, \%expected, 'Single namespace.');


sub _test {
    my ($source, $expected_ref, $test_name) = @_;

    my %expanded_expected;
    while ( my ($namespace, $strings) = each %{$expected_ref} ) {
        $expanded_expected{$namespace} =
            [ map { [ split m/ \n /xms ] } @{$strings} ];
    } # end while

    my $got = split_ppi_node_by_namespace( PPI::Document->new(\$source) );
    my %got_expanded;
    while ( my ($namespace, $ppi_doms) = each %{$got} ) {
        $got_expanded{$namespace} =
            [
                map {
                        [
                            map { _expand_tabs($_) }
                                PPI::Dumper->new($_)->list()
                        ]
                    }
                    @{$ppi_doms}
            ];
    } # end while

    cmp_deeply(\%got_expanded, \%expanded_expected, $test_name);

    return;
} # end _test()


# Why Adam had to put @#$^@#$&^ hard tabs in his dumper output, I don't know.
sub _expand_tabs {
    my ($string) = @_;

    while (
        $string =~ s< \A ( [^\t]* ) ( \t+ ) >
                    <$1 . ( ' ' x (length($2) * 4 - length($1) % 4) )>xmse
    ) {
        # Nothing here.
    } # end while

    return $string;
} # end _expand_tabs()


#      $URL$
#     $Date$
#   $Author$
# $Revision$

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# setup vim: set filetype=perl tabstop=4 softtabstop=4 expandtab :
# setup vim: set shiftwidth=4 shiftround textwidth=78 nowrap autoindent :
# setup vim: set foldmethod=indent foldlevel=0 :
