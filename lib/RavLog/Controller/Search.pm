package RavLog::Controller::Search;

use strict;
use warnings;
use base 'Catalyst::Controller';

sub search : Global
{
   my ( $self, $c, $phrase ) = @_;

   if ( !defined $phrase )
   {
      $phrase = $c->req->params->{phrase};
   }

   my @finds = $c->model('DB::Article')->search(
      [
         subject => { like => "%$phrase%" },
         body    => { like => "%$phrase%" },
      ]
   )->all();

   $c->stash->{articles} = [@finds];
   $c->stash->{template} = 'index.tt';
}

1;
