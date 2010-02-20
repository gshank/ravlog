#!/usr/bin/env perl

use lib './lib';
use RavLog::Schema;
use Data::Dumper;
use Config::Any::Perl;

my $cfg = Config::Any::Perl->load('ravlog_local.pl');

my $db = RavLog::Schema->connect($cfg->{'Model::DB'}->{connect_info}->[0]);

if(!defined $db) {
	print "Can't connect to database!\n";
	exit(0);
}

$username = question('user name');
$password = question('password');

my $user = $db->resultset('User')->new({});
$user->username($username);
$user->password($password);
$user->insert();

print "Ready now.\n";

sub question {
	my ($what)=@_;
	while(1) {
		print "What $what do you want? ";
		$input = <STDIN>;
		chomp($input);
		if ($login =~ / /) {
			print "\n\nNo spaces in $what\n\n";
		}
		else {
			last;
		}
	}	
	
	return $input;
}


