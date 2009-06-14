use strict;
use warnings;
use Test::More tests => 3;
use lib 't/lib';


use_ok( 'RavLog::Schema::DB');

my $schema = RavLog::Schema::DB->connect('dbi:mysql:dbname=ravlog;user=ravlog_admin;host=mysql.odshank.com;password=bgn8agn');

ok($schema, 'get db schema');

my $user = $schema->resultset('User')->find(1);
ok( $user,  'get user' );

my @articles = $schema->resultset('Article')->get_latest_articles;

foreach my $article (@articles)
{
   print $article->subject, "\n";
}
