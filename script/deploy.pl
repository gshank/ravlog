use lib './lib';
use RavLog::Schema::DB;
use Data::Dumper;
use Config::Any::YAML;

my $db = RavLog::Schema::DB->connect('dbi:SQLite:./mydb.db');

if(!defined $db) {
	print "Can't connect to database!\n";
	exit(0);
}

eval { $db->deploy({add_drop_table => 1}); };

if($@) {
    print "\n\nOk failed to re-deploy, trying fresh deployment!\n\n";
    $db->deploy();
}
