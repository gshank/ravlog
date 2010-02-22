package RavLog::Controller::View;

use Moose;
BEGIN {
   extends 'Catalyst::Controller';
}
use RavLog::Form::Comment;

has 'comment' => ( is => 'rw' );
has 'article' => ( is => 'rw' );
has model_name => ( is => 'ro', isa => 'Str', default => 'DB' );

sub base : Chained PathPart('') CaptureArgs(1)
{
   my ( $self, $c, $article_title ) = @_;

   my $article =
      $c->model('DB::Article')
      ->search( { 'subject' => { like => $c->ravlog_url_to_query($article_title) } } )->first;
   $self->article($article);

}

sub view : Chained('base') PathPart('view') Args(0)
{
   my ( $self, $c, $id ) = @_;

   $c->stash->{article}  = $self->article;
   $c->stash->{title}    = $self->article->subject();
   $c->stash->{comments} = [ $self->article->comments->all() ];
   $c->stash->{template} = 'blog_view.tt';

   my $form = RavLog::Form::Comment->new( user => $c->user,
      article_id => $self->article->id, remote_ip => $c->req->address,
      schema => $c->model('DB'), ctx => $c,
   );
   $form->process( params => $c->req->params );
$DB::single=1;
   $c->stash->{comment_form} = $form;
#  $self->stash_comment_form( $c, $self->article->id );

}


1;
