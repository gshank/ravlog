package RavLog::Controller::Admin::Page;

use Moose;
BEGIN {
   extends 'Catalyst::Controller';
}

use RavLog::Form::Page;
has 'page' => ( is => 'rw' );

sub base : Chained('/admin/base') PathPart('page') CaptureArgs(0)
{
   my ( $self, $c ) = @_;
}

sub list : Chained('base') PathPart('list') Args(0)
{
   my ( $self, $c ) = @_;

   my $pages = [$c->model('DB::Page')->all];
   $c->stash( pages => $pages );
}


sub create : Chained('base') PathPart('create') Args(0)
{
   my ( $self, $c ) = @_;
   my $page = $c->model('DB::Page')->new_result({});
   $self->page($page);
   return unless $self->form($c);
   $c->res->redirect( $c->uri_for_action('/admin/page/list') );
}

sub item : Chained('base') PathPart('') CaptureArgs(1)
{
   my ( $self, $c, $page_id ) = @_;
   my $page = $c->model('DB::Page')->find($page_id);
   $self->page($page);
}

sub edit : Chained('item') PathPart('edit') Args(0)
{
   my ( $self, $c ) = @_;

   return unless $self->form($c);
   $c->res->redirect( $c->uri_for_action('/admin/page/list') );
}

sub form
{
   my ( $self, $c ) = @_;
   my $form = RavLog::Form::Page->new( $self->page );
   $c->stash(
      form => $form,
      template => 'admin/page/edit.tt',
   );
   return $form->process( $c->req->params );
}

sub delete : Chained('item') PathPart('delete') Args(0)
{
   my ( $self, $c ) = @_;
   $self->page->delete;
   $c->res->redirect( $c->uri_for_action('/admin/page/list') );
}

1;
