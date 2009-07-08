package RavLog::Controller::Admin::Article;

use Moose;
BEGIN {
   extends 'Catalyst::Controller';
}

has 'article' => ( is => 'rw' );
use RavLog::Form::Article;

sub base : Chained('/admin/base')  PathPart('article') CaptureArgs(0) {}

sub list : Chained('base') PathPart('list') Args(0)
{
   my ( $self, $c ) = @_;
   my $articles = $c->model('DB::Article');
   $c->stash( articles => $articles, template => 'admin/article/list.tt',
              tabnavid => 'tabnav2' );
}

sub create : Chained('base') PathPart('create') Args(0)
{
   my ( $self, $c ) = @_;
   my $article = $c->model('DB::Article')->new_result({ });
   $self->article($article);
   return $self->form($c);
}

sub item : Chained('base') PathPart('') CaptureArgs(1)
{
   my ( $self, $c, $article_id ) =  @_;

   my $article = $c->model('DB::Article')->find($article_id);
   $self->article($article);
}

sub view : Chained('item') PathPart('') Args(0)
{
   my ( $self, $c ) = @_;

   $c->stash( article => $self->article, template => 'admin/article/view.tt' );
}

sub edit :  Chained('item') PathPart('edit') Args(0)
{
   my ( $self, $c ) = @_;
   return $self->form($c);
}

sub form
{
   my ( $self, $c ) = @_;
   my $form = RavLog::Form::Article->new( $self->article );
   $c->stash( template => 'admin/article/edit.tt', 
      tabnavid => 'tabnav1', form => $form,
      action => $c->uri_for_action( $c->action, $c->req->captures) );
   return unless $form->process( params => $c->req->params );
   $form->item->update({user_id => $c->user->user_id }) 
         unless( $form->item->user_id );
   $c->res->redirect( $c->uri_for_action( '/admin/article/view', [$form->item->id]) );
}

sub delete : Chained('item') PathPart('delete') Args(0)
{
   my ( $self, $c ) = @_;
   $self->article->delete;
   $c->res->redirect( $c->uri_for_action( '/admin/article/list') );
}

sub clear : Chained('item') PathPart('clear') Args(0)
{

   my ( $self, $c ) = @_;
   $c->cache->remove('front_page_articles');
   $c->clear_cached_page('/');
   $c->clear_cached_page( '/view/' . $c->nifty_txt_to_url( $self->article->subject ) );
}
1;
