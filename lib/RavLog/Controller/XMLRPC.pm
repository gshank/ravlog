package RavLog::Controller::XMLRPC;

use Moose;
BEGIN {
   extends 'Catalyst::Controller';
}

sub getBlogPosts : XMLRPCPath('/xmlrpc/getRecentPosts')
{
   my ( $self, $c, $blogid, $username, $password, $number_of_posts ) = @_;

   if ( $c->authenticate( { username => $username, password => $password } ) )
   {

      my @articles = $c->model('DB::Article')->get_latest_articles($number_of_posts);

      my @returnXML;
      for ( my $i = 0; $i < scalar(@articles); $i++ )
      {
         my $url = $c->ravlog_txt_to_url( $articles[$i]->subject() );
         $url = $c->uri_for( 'view', $url );

         my @tags = ();
         foreach my $tag ( $articles[$i]->tags )
         {
            push @tags, $tag->name;
         }

         my %post = (
            title       => $articles[$i]->subject,
            description => $articles[$i]->body,
            userid      => $articles[$i]->user->username,
            'link'      => $url,
            tags        => [@tags],
            postid      => $articles[$i]->id,
            dateCreated => $articles[$i]->created_at->datetime,
         );

         push @returnXML, \%post;
      }
      $c->stash->{xmlrpc} = [@returnXML];
   }

   $c->res->body('stub');
}

sub getBlogTags : XMLRPCPath('/xmlrpc/getTags')
{
   my ( $self, $c, $blogid, $username, $password ) = @_;

   my @returnXML;
   if ( $c->authenticate( { username => $username, password => $password } ) )
   {
      my @tags = $c->model('DB::Tag')->search( undef, {} )->all();
      for ( my $i = 0; $i < scalar(@tags); $i++ )
      {
         my $url = $tags[$i]->name();
         $url = $c->ravlog_txt_to_url($url);

         # FIXME: $url = $c->uri_for( 'view', $url ); clean it up
         $url = $c->uri_for( "tag/" . $url );

         my %tag = (
            tagId        => $tags[$i]->id,
            tagName      => $tags[$i]->name,
            description  => $tags[$i]->name,
            htmlUrl      => $url,
         );
         push @returnXML, \%tag;
      }

      $c->stash->{xmlrpc} = [@returnXML];
   }

   $c->res->body('stub');
}

sub getUsersBlogs : XMLRPCPath('/blogger/getUsersBlogs')
{
   my ( $self, $c, $hash, $username, $password ) = @_;

   $c->stash->{xmlrpc} = [
      {
         url      => $c->uri_for('/'),
         blogid   => 1,
         blogName => $c->uri_for('/'),
         isAdmin  => 1
      }
   ];

   $c->res->body('stub');
}

sub deletePost : XMLRPCPath('/blogger/deletePost')
{
   my ( $self, $c, $hash, $post_to_delete, $username, $password, $blogid ) = @_;
   if ( $c->authenticate( { username => $username, password => $password } ) )
   {
      $c->log->info( 'post to delete: ' . $post_to_delete );
      $c->model('DB::Article')->find($post_to_delete)->delete();
      $c->forward( 'submit', 'cache_refresh' );    # send it off to clear cache
   }
   $c->res->body('stub');
}

sub newPost : XMLRPCPath('/xmlrpc/newPost')
{
   my ( $self, $c, $blogid, $username, $password, $post ) = @_;

   if ( $c->authenticate( { username => $username, password => $password } ) )
   {
      $c->log->info('Posting...');
      my $article = $c->forward(
         'admin',
         'save_article',
         [
            {
               subject    => $post->{title},
               body       => $post->{description},
               tags       => $post->{tags},
            }
         ]
      );
      $c->stash->{xmlrpc} = $article->id();
   }

   $c->res->body('stub');
}

sub getPost : XMLRPCPath('/xmlrpc/getPost')
{
   my ( $self, $c, $postid, $username, $password ) = @_;

   if ( $c->authenticate( { username => $username, password => $password } ) )
   {
      my $article = $c->model('DB::Article')->find($postid);

      my $url = $c->ravlog_txt_to_url( $article->subject() );
      $url = $c->uri_for( 'view', $url );
      $c->stash->{xmlrpc} = {
         title       => $article->subject,
         description => $article->body,
         userid      => $article->user->username,
         'link'      => $url,
         postid      => $article->id,
         dateCreated => $article->created_at->datetime
      };
   }
   $c->res->body('stub');
}

sub getUserInfo : XMLRPCPath('/blogger/getUserInfo')
{
   my ( $self, $c, $appkey, $username, $password ) = @_;

   if ( $c->authenticate( { username => $username, password => $password } ) )
   {
      $c->stash->{xmlrpc} = {
         nickname  => $c->user->username,
         userid    => $c->user->id,
         email     => $c->user->email,
         url       => $c->uri_for( $c->user->username ),
         lastname  => $c->user->username,
         firstname => $c->user->username,
      };
   }
   $c->res->body('stub');
}

sub editPost : XMLRPCPath('/xmlrpc/editPost')
{
   my ( $self, $c, $postid, $username, $password, $post ) = @_;

   if ( $c->authenticate( { username => $username, password => $password } ) )
   {
      my $article = $c->forward(
         'admin',
         'save_article',
         [
            {
               article_id => $postid,
               subject    => $post->{title},
               body       => $post->{description},
               tags       => $post->{tags},
            }
         ]
      );
      $c->stash->{xmlrpc} = $article->id();
   }

   $c->res->body('stub');
}

1;
