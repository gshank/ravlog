package RavLog::Controller::Admin;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole' }

sub base : Chained('/') PathPart('admin') CaptureArgs(0) Does('NeedsLogin') 
{ 
   my ( $self, $c ) = @_;

}

sub default : Chained('base') PathPart('') Args(0)
{
   my ( $self, $c ) = @_;
   $c->forward( '/admin/article/list' );
}

1;
