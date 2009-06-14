package RavLog::View::TT;

use strict;
use base 'Catalyst::View::TT';
use Template::Stash::XS;
use Path::Class qw(dir);

__PACKAGE__->config(
   {
      STASH        => Template::Stash::XS->new,
      CATALYST_VAR => 'c',
      INCLUDE_PATH => [
         RavLog->path_to( 'root', 'templates' ),
         RavLog->path_to( 'root', 'templates', RavLog->config->{site}->{template} ),
         RavLog->path_to( 'root', 'templates', 'shared' ),
      ],
      TEMPLATE_EXTENSION => '.tt',
      COMPILE_EXT        => '.ttc',
      PRE_PROCESS        => 'site/config.tt',
      WRAPPER            => 'site/wrapper.tt',
      TIMER              => 0
   }
);

=head1 NAME

RavLog::View::TT

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

