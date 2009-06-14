package RavLog::Controller::Login;

use strict;
use warnings;
use base 'Catalyst::Controller';
use Data::Dumper;

#since this will be forwarded to a method with a form
sub login_as : Local
{
   my ( $self, $c ) = @_;
   my $username    = $c->req->params->{username};
   my $password = $c->req->params->{password};

   $c->log->info('logging in!');
   if ( $c->authenticate( { username => $username, password => $password } ) )
   {
      $c->res->redirect('/admin/article/list');
      return;
   }
   else
   {
      $c->flash->{notice} = "Wrong password or name.";
      $c->res->redirect('/login');
      return;
   }
}

sub index : Local
{
   my ( $self, $c ) = @_;
   $c->stash->{template} = 'admin/login_as.tt';
}

sub logout : Local
{
   my ( $self, $c ) = @_;

   $c->logout;
   $c->res->redirect('/');
   $c->res->body('stub');
}

sub info : Local
{
   my ( $self, $c ) = @_;
   $c->stash->{template} = 'shared/info.tt';
}

sub end : Private
{
   my ( $self, $c ) = @_;

   return 1 if $c->req->method eq 'HEAD';
   return 1 if length( $c->response->body );
   return 1 if scalar @{ $c->error } && !$c->stash->{template};
   return 1 if $c->response->status =~ /^(?:204|3\d\d)$/;

   $c->forward( $c->view('TT') );
}

1;
