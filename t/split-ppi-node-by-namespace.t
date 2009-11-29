#!/usr/bin/env perl

use 5.006001;

use strict;
use warnings;

our $VERSION = '1.001';


use Readonly;


use PPI::Document qw< >;
use PPI::Dumper qw< >;
use PPIx::Utilities::Node qw< split_ppi_node_by_namespace >;


use Test::Deep qw< cmp_deeply >;
use Test::More tests => 3;


Readonly::Scalar my $DUMP_INDENT => 4;


{
    my $source = <<'END_SOURCE';
package Foo;

$x = 1;
END_SOURCE

    my %expected = (
        Foo => [ <<'END_EXPECTED' ],
                    PPI::Document
                        PPI::Statement::Package
[    1,   1,   1 ]         PPI::Token::Word     'package'
[    1,   8,   8 ]         PPI::Token::Whitespace   ' '
[    1,   9,   9 ]         PPI::Token::Word     'Foo'
[    1,  12,  12 ]         PPI::Token::Structure    ';'
[    1,  13,  13 ]     PPI::Token::Whitespace   '\n'
[    2,   1,   1 ]     PPI::Token::Whitespace   '\n'
                        PPI::Statement
[    3,   1,   1 ]         PPI::Token::Symbol   '$x'
[    3,   3,   3 ]         PPI::Token::Whitespace   ' '
[    3,   4,   4 ]         PPI::Token::Operator     '='
[    3,   5,   5 ]         PPI::Token::Whitespace   ' '
[    3,   6,   6 ]         PPI::Token::Number   '1'
[    3,   7,   7 ]         PPI::Token::Structure    ';'
[    3,   8,   8 ]     PPI::Token::Whitespace   '\n'
END_EXPECTED
    );

    _test($source, \%expected, 'Single namespace.');
} # end scope block


{
    my $source = <<'END_SOURCE';
$x = 1;
END_SOURCE

    my %expected = (
        main => [ <<'END_EXPECTED' ],
                    PPI::Document
                        PPI::Statement
[    1,   1,   1 ]         PPI::Token::Symbol   '$x'
[    1,   3,   3 ]         PPI::Token::Whitespace   ' '
[    1,   4,   4 ]         PPI::Token::Operator     '='
[    1,   5,   5 ]         PPI::Token::Whitespace   ' '
[    1,   6,   6 ]         PPI::Token::Number   '1'
[    1,   7,   7 ]         PPI::Token::Structure    ';'
[    1,   8,   8 ]     PPI::Token::Whitespace   '\n'
END_EXPECTED
    );

    _test($source, \%expected, 'Default namespace.');
} # end scope block


{
    my $source = <<'END_SOURCE';
$x = 1;

package Foo;

$y = 2;
END_SOURCE

    my %expected = (
        main => [ <<'END_EXPECTED_MAIN' ],
                    PPI::Document::Fragment
                        PPI::Statement
[    1,   1,   1 ]         PPI::Token::Symbol   '$x'
[    1,   3,   3 ]         PPI::Token::Whitespace   ' '
[    1,   4,   4 ]         PPI::Token::Operator     '='
[    1,   5,   5 ]         PPI::Token::Whitespace   ' '
[    1,   6,   6 ]         PPI::Token::Number   '1'
[    1,   7,   7 ]         PPI::Token::Structure    ';'
[    1,   8,   8 ]     PPI::Token::Whitespace   '\n'
[    2,   1,   1 ]     PPI::Token::Whitespace   '\n'
END_EXPECTED_MAIN

        Foo => [ <<'END_EXPECTED_FOO' ],
                    PPI::Document::Fragment
                        PPI::Statement::Package
[    3,   1,   1 ]         PPI::Token::Word     'package'
[    3,   8,   8 ]         PPI::Token::Whitespace   ' '
[    3,   9,   9 ]         PPI::Token::Word     'Foo'
[    3,  12,  12 ]         PPI::Token::Structure    ';'
[    3,  13,  13 ]     PPI::Token::Whitespace   '\n'
[    4,   1,   1 ]     PPI::Token::Whitespace   '\n'
                        PPI::Statement
[    5,   1,   1 ]         PPI::Token::Symbol   '$y'
[    5,   3,   3 ]         PPI::Token::Whitespace   ' '
[    5,   4,   4 ]         PPI::Token::Operator     '='
[    5,   5,   5 ]         PPI::Token::Whitespace   ' '
[    5,   6,   6 ]         PPI::Token::Number   '2'
[    5,   7,   7 ]         PPI::Token::Structure    ';'
[    5,   8,   8 ]     PPI::Token::Whitespace   '\n'
END_EXPECTED_FOO
    );

    _test($source, \%expected, 'Simple multiple namespaces: default followed by non-default.');
} # end scope block


sub _test {
    my ($source, $expected_ref, $test_name) = @_;

    my $document = PPI::Document->new(\$source);

    my %expanded_expected;
    while ( my ($namespace, $strings) = each %{$expected_ref} ) {
        $expanded_expected{$namespace} =
            [ map { [ split m/ \n /xms ] } @{$strings} ];
    } # end while

    my $got = split_ppi_node_by_namespace($document);
    my %got_expanded;
    while ( my ($namespace, $ppi_doms) = each %{$got} ) {
        $got_expanded{$namespace} =
            [
                map {
                        [ map { _expand_tabs($_) } _new_dumper($_)->list() ]
                    }
                    @{$ppi_doms}
            ];
    } # end while

use Data::Dumper::Names;
    cmp_deeply(\%got_expanded, \%expanded_expected, $test_name)
or diag Dumper(\%got_expanded, \%expanded_expected);

    return;
} # end _test()


sub _new_dumper {
    my ($node) = @_;

    return PPI::Dumper->new($node, indent => $DUMP_INDENT, locations => 1);
} # end _new_dumper()


# Why Adam had to put @#$^@#$&^ hard tabs in his dumper output, I don't know.
sub _expand_tabs {
    my ($string) = @_;

    while (
        $string =~
            s< \A ( [^\t]* ) ( \t+ )                          >
             <$1 . ( ' ' x (length($2) * $DUMP_INDENT - length($1) % $DUMP_INDENT) )>xmse
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
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
