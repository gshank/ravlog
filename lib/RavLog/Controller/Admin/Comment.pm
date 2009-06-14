package RavLog::Controller::Admin::Comment;

use Moose;
BEGIN {
   extends 'Catalyst::Controller';
}

has 'article' => ( is => 'rw' );
has 'comment' => ( is => 'rw' );

sub base : Chained('/admin/base') PathPart('comment') CaptureArgs(1)
{
   my ( $self, $c, $article_id ) = @_;

   my $article = $c->model('DB::Comment')->find($article_id);
   $self->article($article);
}

sub list : Chained('base') PathPart('list') Args(0)
{
   my ( $self, $c ) = @_;

   my $comments = $self->article->comments;
   $c->stash( comments => $comments );

}

sub item : Chained('base') PathPart('') CaptureArgs(1)
{
   my ( $self, $c, $comment_id ) = @_;
   my $comment = $c->model('DB::Comment')->find($comment_id);
   $self->comment($comment);
}

sub edit : Chained('item') PathPart('edit') Args(0)
{
   my ( $self, $c ) = @_;
   $c->stash(
      template => 'admin/comment/edit.tt',
   );
   my $form = RavLog::Form::Comment->new( $self->comment );
   return unless $form->process( $c->req->params );

   $c->res->redirect( $c->uri_for_action('/admin/comment/list') );
}

1;
