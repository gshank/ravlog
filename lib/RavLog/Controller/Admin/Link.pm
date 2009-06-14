package RavLog::Controller::Admin::Link;

use Moose;
BEGIN {
   extends 'Catalyst::Controller';
}
use RavLog::Form::Link;

has 'link' => ( is => 'rw' );

sub base : Chained('/admin/base') PathPart('link') CaptureArgs(0)
{
   my ( $self, $c ) = @_;
}

sub list : Chained('base') PathPart('list') Args(0)
{
   my ( $self, $c ) = @_;

   my $links = [$c->model('DB::Link')->all];
   $c->stash( links => $links );

}

sub create : Chained('base') PathPart('create') Args(0)
{
   my ( $self, $c ) = @_;

   my $link = $c->model('DB::Link')->new_result({});
   $self->link($link);
   return unless $self->form($c);
   $c->res->redirect( $c->uri_for_action('/admin/link/list') );
}

sub item : Chained('base') PathPart('') CaptureArgs(1)
{
   my ( $self, $c, $link_id ) = @_;
   my $link = $c->model('DB::Link')->find($link_id);
   $self->link($link);
}

sub edit : Chained('item') PathPart('edit') Args(0)
{
   my ( $self, $c ) = @_;
   return unless $self->form($c);
   $c->res->redirect( $c->uri_for_action('/admin/link/list') );
}

sub form
{
   my ( $self, $c ) = @_;
   my $form = RavLog::Form::Link->new( $self->link );
   $c->stash(
      form => $form,
      template => 'admin/link/edit.tt',
   );
   return $form->process( $c->req->params );
}

sub delete : Chained('item') PathPart('delete') Args(0)
{
   my ( $self, $c ) = @_;
   $self->link->delete;
   $c->res->redirect( $c->uri_for_action('/admin/link/list') );
}

1;
