#!perl

#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/distributions/PPIx-Utilities/Build.PL $
#     $Date: 2009-06-26 10:48:29 -0400 (Fri, 26 Jun 2009) $
#   $Author: clonezone $
# $Revision: 3365 $

use 5.006001;

use strict;
use warnings;

use Module::Build;


my $class = Module::Build->subclass( code => <<'END_SUBCLASS' );

    sub ACTION_test {
        my ($self) = @_;

        $self->depends_on('manifest');

        return $self->SUPER::ACTION_test();
    }

    sub ACTION_authortest {
        my ($self) = @_;

        $self->depends_on('build');
        $self->depends_on('manifest');
        $self->depends_on('distmeta');

        $self->test_files( qw< t xt/author > );
        $self->recursive_test_files(1);

        $self->depends_on('test');

        return;
    } # end ACTION_authortest()

    sub ACTION_distdir {
        my ($self) = @_;

        $self->depends_on('authortest');

        return $self->SUPER::ACTION_distdir();
    } # end ACTION_distdir

END_SUBCLASS

my $builder = $class->new(
    module_name         => 'PPIx::Utilities',
    dist_author         => 'Elliot Shank <perl@galumph.com>',
    license             => 'perl',
    dynamic_config      => 0,
    create_license      => 1,
    create_makefile_pl  => 'traditional',
    create_packlist     => 1,
    create_readme       => 1,
    sign                => 0,

    requires            => {
        Readonly    => 0,
    },

    build_requires      => {
        # We can't deal with later stuff due to the "#line" directive support.
        'PPI::Document' => '== 1.203',
        'PPI::Dumper'   => '== 1.203',
        'Test::Deep'    => 0,
        'Test::More'    => 0,
    },

    recommends          => {
    },

    meta_merge          => {
        resources   => {
            license     => 'http://dev.perl.org/licenses/',
            Repository  => 'http://guest@perlcritic.tigris.org/svn/perlcritic/trunk/distributions/PPIx-Utilities/',
            MailingList => 'http://perlcritic.tigris.org/servlets/SummarizeList?listName=users',
        },
    },

    add_to_cleanup      => [
        qw<
            LICENSE
            MANIFEST
            MANIFEST.bak
            META.yml
            Makefile
            Makefile.old
            Makefile.PL
            pod2htm?.tmp
            pm_to_blib
            README
            PPIx-Utilities-*
        >,
    ],
);


$builder->create_build_script();


##############################################################################
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
