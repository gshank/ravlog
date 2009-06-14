package RavLog::Controller::Admin;

use strict;
use warnings;
use base 'Catalyst::Controller::FormBuilder';

sub base : Chained('/') PathPart('admin') CaptureArgs(0) 
{ 
   my ( $self, $c ) = @_;

   $c->res->redirect( $c->uri_for('/login') ) unless $c->user;

}

sub default : Chained('base') PathPart('') Args(0)
{
   my ( $self, $c ) = @_;
   $c->forward( '/admin/article/list' );
}

1;
