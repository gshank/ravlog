package RavLog::Controller::Admin::User;

use Moose;
BEGIN {
   extends 'Catalyst::Controller';
}

use RavLog::Form::User;

sub base : Chained('/admin/base')  PathPart('user') CaptureArgs(0) {}

sub list : Chained('base') PathPart('list') Args(0)
{
   my ( $self, $c ) = @_;
   my $users = $c->model('DB::User');
   $c->stash( users => $users, template => 'admin/user/list.tt' );
}

sub create : Chained('base') PathPart('create') Args(0)
{
   my ( $self, $c ) = @_;
   $c->stash( user => $c->model('DB::User')->new_result({}) );
   return $self->form($c);
}

sub item : Chained('base') PathPart('') CaptureArgs(1)
{
   my ( $self, $c, $user_id ) =  @_;

   my $user = $c->model('DB::User')->find($user_id);
   $c->stash( user => $user ); 
}

sub view : Chained('item') PathPart('') Args(0)
{
   my ( $self, $c ) = @_;

   $c->stash( template => 'admin/user/view.tt' );
}

sub edit :  Chained('item') PathPart('edit') Args(0)
{
   my ( $self, $c ) = @_;
   return $self->form($c);
}

sub form
{
   my ( $self, $c ) = @_;
   my $form = RavLog::Form::User->new( $c->stash->{user} );
   $c->stash( template => 'admin/user/edit.tt', form => $form,
      action => $c->uri_for( $self->action, $c->req->captures) );
   return unless $form->process( params => $c->req->params );
   
   $c->res->redirect( $c->uri_for( $self->action_for('view'), $c->req->captures) );
}

sub delete : Chained('item') PathPart('delete') Args(0)
{
   my ( $self, $c ) = @_;
   $c->stash->{user}->delete;
   $c->res->redirect( $c->uri_for_action( '/admin/user/list') );
}

1;
