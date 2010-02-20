use strict;
use warnings;
use Test::More;
use lib 't/lib';


use_ok( 'RavLog::Schema');
use_ok( 'RavLog::Schema::Result::User');

my $schema = RavLog::Schema->connect('dbi:mysql:dbname=ravlog;user=ravlog_admin;password=rlpw');

ok($schema, 'get db schema');


my $user = $schema->resultset('User')->find(1);
unless( $user )
{
   $user = $schema->resultset('User')->create({ username => 'test', password => 'testpw'} );
}
ok( $user,  'get user' );

my @articles = $schema->resultset('Article')->get_latest_articles;

foreach my $article (@articles)
{
   print $article->subject, "\n";
   print $article->user->username, "\n";
}

my $article = $schema->resultset('Article')->new_result({});
ok( $article, 'new result for Article worked' );

done_testing;
