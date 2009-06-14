package RavLog::Controller::Feed;

use strict;
use warnings;
use base 'Catalyst::Controller';
use XML::Feed;
use Text::Textile qw(textile);

sub comments : Local
{
   my ( $self, $c, $subject ) = @_;

   my $feed = XML::Feed->new('RSS');
   $feed->title( $c->config->{name} . ' RSS' );
   $feed->link( $c->uri_for('/') );
   $feed->description( $c->config->{name} . ' RSS Feed' );

   my @comments;
   if ( !defined $subject )
   {
      @comments = $c->model('DB::Comment')->all();
   }
   else
   {
      @comments =
         $c->model('DB::Article')
         ->search( { subject => { like => $c->ravlog_url_to_query($subject) } } )->first()
         ->comments();
   }

   for ( my $i = 0; $i < scalar(@comments); $i++ )
   {
      my $feed_entry = XML::Feed::Entry->new('RSS');
      $feed_entry->title(
         $comments[$i]->name() . "'s comment " . $comments[$i]->created_at->ymd() );
      my $url = $c->ravlog_txt_to_url( $comments[$i]->article()->subject() );
      $feed_entry->link( $c->uri_for( '/view/' . $url . '#comments' ) );
      $feed_entry->summary( textile( $comments[$i]->comment() ) );
      $feed_entry->issued( $comments[$i]->created_at() );
      $feed->add_entry($feed_entry);
   }

   $c->res->content_type('application/rss+xml');
   $c->res->body( $feed->as_xml );
}

sub articles : Local
{
   my ( $self, $c, $tag ) = @_;

   my $feed = XML::Feed->new('RSS');
   $feed->title( $c->config->{name} . ' RSS' );
   $feed->link( $c->uri_for('/') );
   $feed->description( $c->config->{name} . ' RSS Feed' );

   my @articles;
   if ( !defined $tag )
   {
      @articles = $c->model('DB::Article')->get_latest_articles();
   }
   else
   {
      @articles =
         $c->model('DB::Tag')
         ->search( { name => { like => $c->ravlog_url_to_query($tag) } } )->first()->articles();
   }

   for ( my $i = 0; $i < scalar(@articles); $i++ )
   {
      my $feed_entry = XML::Feed::Entry->new('RSS');
      $feed_entry->title( $articles[$i]->subject() );
      my $url = $c->ravlog_txt_to_url( $articles[$i]->subject() );
      $feed_entry->link( $c->uri_for( '/view', $url ) );
      $feed_entry->summary( textile( $articles[$i]->body() ) );
      $feed_entry->issued( $articles[$i]->created_at() );
      $feed->add_entry($feed_entry);
   }

   $c->res->content_type('application/rss+xml');
   $c->res->body( $feed->as_xml );
}

1;
