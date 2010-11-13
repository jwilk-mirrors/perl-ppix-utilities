#!/usr/bin/env perl

#      $URL$
#     $Date$
#   $Author$
# $Revision$

use 5.006;

use strict;
use warnings;

our $VERSION = '1.001000';

use Test::More;
use Test::Pod::Coverage;

my @trusted_methods = qw<
    description
>;

my $method_string = join q< | >, @trusted_methods;
my $regex = qr< \A (?: $method_string ) \z >xms;
all_pod_coverage_ok( { trustme => [$regex] } );

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
