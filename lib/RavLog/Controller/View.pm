package RavLog::Controller::View;

use Moose;
BEGIN {
   extends 'Catalyst::Controller';
}
use RavLog::Form::Comment;

has 'comment' => ( is => 'rw' );
has 'article' => ( is => 'rw' );

sub base : Chained PathPart('') CaptureArgs(1)
{
   my ( $self, $c, $article_title ) = @_;

   my $article =
      $c->model('DB::Article')
      ->search( { 'subject' => { like => $c->ravlog_url_to_query($article_title) } } )->first();
   $self->article($article);

}

sub view : Chained('base') PathPart('view') Args(0)
{
   my ( $self, $c, $id ) = @_;

   $c->stash->{articles} = $self->article;
   $c->stash->{title}    = $self->article->subject();
   $c->stash->{comments} = [ $self->article->comments->all() ];

   $c->stash->{template} = 'index.tt';
   return unless $self->comment_form($c); 

   $c->stash->{comments} = [ $self->article->comments->all ];
   $c->stash->{form} = RavLog::Form::Comment->new(ctx => $c);
}

sub comment_form
{
   my ( $self, $c ) = @_;
   
   my $comment = $c->model('DB::Comment')->new_result({ article_id => $self->article->id});
   my $form = RavLog::Form::Comment->new(ctx => $c);
   $c->stash( form => $form );
   return $form->process( item => $comment, params => $c->req->params );
}


1;
