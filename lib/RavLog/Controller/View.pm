package RavLog::Controller::View;

use Moose;
BEGIN {
   extends 'Catalyst::Controller';
   with 'CatalystX::Comments';
}

has 'comment' => ( is => 'rw' );
has 'article' => ( is => 'rw' );
has model_name => ( is => 'ro', isa => 'Str', default => 'DB' );

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

   $c->stash->{comments} = [ $self->article->comments->all ];
   $self->stash_comment_form( $c, $self->article->id );
}


1;
