package RavLog::Controller::Root;

use Moose;
BEGIN {
   extends 'Catalyst::Controller';
}
use HTML::CalendarMonthSimple;

__PACKAGE__->config->{namespace} = '';

sub begin : Private
{
   my ( $self, $c ) = @_;

   if( $c->model('DB::Config')->find('front page')->value ne 'blog' ) {
        $c->stash('blog_page' => 1 );
    }
   $c->stash->{pages} =
      [ $c->model('DB::Page')->search( display_in_drawer => 1 )->all() ];
   $c->stash->{activelink} = { home => 'activelink' };    # set it to home unless overridden.
   $c->stash->{sidebar} = 1;
   $c->stash->{xmlrpc} = undef;
}

sub base : Chained PathPart('') CaptureArgs(0) {}

sub tag : Local
{
   my ( $self, $c, $tag ) = @_;

   my $db_tag =
      $c->model('DB::Tag')
      ->search( { name => { like => $c->ravlog_url_to_query($tag) } } )->first();
   $c->stash->{articles} = $db_tag->articles;
   $c->stash->{template} = 'blog_index.tt';
   $c->stash->{rss}      = $db_tag->name;
}

sub page : Local
{
   my ( $self, $c, $what ) = @_;

   my $page =
      $c->model('DB::Page')
      ->search( { name => { like => $c->ravlog_url_to_query($what) } } )->first();

   $c->stash->{sidebar} = undef unless $page->display_sidebar();
   $c->stash->{page}    = $page;
   $c->stash->{title}   = $page->name;
   my $name = $c->ravlog_txt_to_url( $page->name );
   $c->stash->{activelink} = { $name => 'activelink' };
   $c->stash->{template} = 'page.tt';
}

sub archived : Local
{
   my ( $self, $c, $year, $month, $day ) = @_;

   my $articles = $c->model('DB::Article')->archived( $year, $month, $day );
   $c->stash->{articles} = $articles; 
   $c->stash->{template} = 'blog_index.tt';
}

sub default : Local
{
   my ( $self, $c ) = @_;

   $self->blog_index($c);
}

sub front_page : Path Args(0) {
    my ( $self, $c ) = @_;

    my $front_page = $c->model('DB::Config')->find('front page');
    $c->stash( activelink => { 'home' => 'activelink' } );
    if( $front_page->value eq 'blog' ) {
        $self->blog_index($c);
    }
    else {
        my $page = $c->model('DB::Page')
          ->search( { name => { like => $c->ravlog_url_to_query($front_page->value) } } )->first();
        $c->stash->{page}    = $page;
        $c->stash( template => 'page.tt' );
    }
}

sub blog_index {
   my ( $self, $c ) = @_;

   my $articles = $c->model('DB::Article')->get_latest_articles();
   $c->stash->{articles} = $articles; 
   $c->stash->{template} = 'blog_index.tt';
}

sub blog : Path('/blog') Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( activelink => { 'blog' => 'activelink' } );
    $self->blog_index($c);
}

sub tags 
{
   my ( $self, $c ) = @_;

   my @tags = $c->model('DB::Tag')->all();
   $c->stash->{tags} = [@tags];
}

sub links
{
   my ( $self, $c ) = @_;
   my @links = $c->model('DB::Link')->search( undef, { order_by => 'link_id desc' } )->all();
   $c->stash->{links} = [@links];
}

sub calendar : Local
{
   my ( $self, $c ) = @_;

   my $dt  = DateTime->now();
   my $cal = new HTML::CalendarMonthSimple(
      'year'  => $dt->year,
      'month' => $dt->month
   );
   $cal->border(0);
   $cal->width(50);
   $cal->headerclass('month_date');
   $cal->showweekdayheaders(0);

   my @articles = $c->model('DB::Article')->from_month( $dt->month );

   foreach my $article (@articles)
   {
      my $location =
           '/archived/'
         . $article->created_at->year() . '/'
         . $article->created_at->month() . '/'
         . $article->created_at->mday();
      $cal->setdatehref( $article->created_at->mday(), $location );
   }

   $c->stash->{calendar} = $cal->as_HTML;
}

sub archives
{
   my ( $self, $c ) = @_;

   my @articles = $c->model('DB::Article')->all();

   unless (@articles)
   {
      $c->stash->{archives} = "<p>No Articles in Archive!</p>";
      return;
   }

   my $months;
   foreach my $article (@articles)
   {
      my $month = $article->created_at()->month_name();
      my $year  = $article->created_at()->year();
      my $key   = "$year $month";
      if ( ( defined $months->{$key}->{count} ) && ( $months->{$key}->{count} > 0 ) )
      {
         $months->{$key}->{count} += 1;
      }
      else
      {
         $months->{$key}->{count} = 1;
         $months->{$key}->{year}  = $year;
         $months->{$key}->{month} = $article->created_at()->month();
      }
   }

   my @out;
   while ( my ( $key, $value ) = each( %{$months} ) )
   {
      push @out,
         "<li><a href='/archived/$value->{year}/$value->{month}'>$key</a> <span class='special_text'>($value->{count})</span></li>";
   }
   $c->stash->{archives} = join( ' ', @out );
}

sub enable_sidebar : Local
{
   my ( $self, $c ) = @_;

   $self->tags($c);
   $self->archives($c);
   $self->links($c);
   $self->calendar($c);
}

sub auto : Private
{
   my ( $self, $c ) = @_;

   $c->set_ravlog_params( [ [ 'ul#error_content h3', 'top' ] ] );

   return 1;
}

sub cache_refresh
{
   my ( $self, $c, $item ) = @_;

   return;
   $c->cache->remove('front_page_articles');
   $c->clear_cached_page('/');
   if ( ref($item) eq "RavLog::Model::DB::Article" )
   {
      $c->clear_cached_page( '/view/' . $c->ravlog_txt_to_url( $item->subject ) );
   }
   if ( ref($item) eq "RavLog::Model::DB::Page" )
   {
      $c->clear_cached_page( '/page/' . $c->ravlog_txt_to_url( $item->name ) );
   }
}

sub end : Private
{
   my ( $self, $c ) = @_;

   return 1 if $c->req->method eq 'HEAD';
   return 1 if length( $c->response->body );
   return 1 if scalar @{ $c->error } && !$c->stash->{template};
   return 1 if $c->response->status =~ /^(?:204|3\d\d)$/;

   $self->enable_sidebar($c) if $c->stash->{sidebar};
   $c->forward('TT');
}

1;
