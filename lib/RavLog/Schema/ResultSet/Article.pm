package RavLog::Schema::ResultSet::Article;
use base 'DBIx::Class::ResultSet';

sub get_latest_articles
{
   my ( $self, $number_of_posts ) = @_;
   my $rows = 10;
   $rows = $number_of_posts if defined $number_of_posts;
   return $self->search( undef, { rows => $rows, order_by => 'article_id desc' } )->all;
}

sub archived
{
   my ( $self, $year, $month, $day ) = @_;

   my $dt   = DateTime->now();
   my $hour = $dt->hour();

   if ( defined $day && $day != $dt->day )
   {
      $hour = '24';
   }

   if ( defined $day )
   {
      return $self->search(
         {
            created_at => {
               -between => [ "$year-$month-$day 00:00:00", "$year-$month-$day $hour:00:00" ]
            }
         },
         { order_by => 'article_id desc' }
      )->all();
   }
   else
   {
      my $lastday = DateTime->last_day_of_month( year => $year, month => $month )->day;

      return $self->search(
         { created_at => { -between => [ "$year-$month-1", "$year-$month-$lastday" ] } },
         { order_by => 'article_id desc' } )->all();
   }
}

sub from_month
{
   my ( $self, $month, $year ) = @_;

   $year = DateTime->now()->year() unless defined $year;

   my $dt      = DateTime->now();
   my $lastday = DateTime->last_day_of_month( year => $year, month => $month )->day;
   my $hour    = $dt->hour();

   return $self->search(
      { created_at => { -between => [ "$year-$month-1", "$year-$month-$lastday" ] } },
      { order_by   => 'article_id desc' } )->all();
}

1;
