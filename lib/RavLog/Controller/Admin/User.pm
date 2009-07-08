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
   $c->stash( users => $users, template => 'admin/user/list.tt', tabnavid => 'tabnav3' );
}

sub create : Chained('base') PathPart('create') Args(0)
{
   my ( $self, $c ) = @_;
   $c->stash( user => $c->model('DB::User')->new_result({}) );
   return unless $self->form($c);
   $c->res->redirect( $c->uri_for_action('/admin/user/list') );
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
   return unless $self->form($c);
   $c->res->redirect( $c->uri_for_action('/admin/user/list') );
}

sub form
{
   my ( $self, $c ) = @_;
   my $form = RavLog::Form::User->new( $c->stash->{user} );
   $c->stash( template => 'admin/user/edit.tt', form => $form );
   return $form->process( params => $c->req->params );
}

sub delete : Chained('item') PathPart('delete') Args(0)
{
   my ( $self, $c ) = @_;
   $c->stash->{user}->delete;
   $c->res->redirect( $c->uri_for_action( '/admin/user/list') );
}

1;
