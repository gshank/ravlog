package RavLog::Controller::Admin::Tag;

use Moose;
BEGIN {
   extends 'Catalyst::Controller';
}
use RavLog::Form::Tag;

has 'tag' => ( is => 'rw' );

sub base : Chained('/admin/base') PathPart('tag') CaptureArgs(0)
{
   my ( $self, $c ) = @_;
}

sub list : Chained('base') PathPart('list') Args(0)
{
   my ( $self, $c ) = @_;

   my $tags = [$c->model('DB::Tag')->all];
   $c->stash( tags => $tags, tabnavid => 'tabnav4' );
}

sub create : Chained('base') PathPart('create') Args(0)
{
   my ( $self, $c ) = @_;
   my $tag = $c->model('DB::Tag')->new_result({});
   $self->tag($tag);
   return unless $self->form($c);
   $c->res->redirect( $c->uri_for_action('/admin/tag/list') );
}

sub item : Chained('base') PathPart('') CaptureArgs(1)
{
   my ( $self, $c, $tag_id ) = @_;
   my $tag = $c->model('DB::Tag')->find($tag_id);
   $self->tag($tag);
}

sub edit : Chained('item') PathPart('edit') Args(0)
{
   my ( $self, $c ) = @_;
   return unless $self->form($c);
   $c->res->redirect( $c->uri_for_action('/admin/tag/list') );
}

sub form
{
   my ( $self, $c ) = @_;
   my $form = RavLog::Form::Tag->new( $self->tag );
   $c->stash(
      form => $form,
      template => 'admin/tag/edit.tt',
   );
   return $form->process( $c->req->params );
}

sub delete : Chained('item') PathPart('delete') Args(0)
{
   my ( $self, $c ) = @_;
   $self->tag->delete;
   $c->res->redirect( $c->uri_for_action('/admin/tag/list') );
}

1;
