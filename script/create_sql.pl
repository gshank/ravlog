#!/usr/local/bin/perl
use lib './lib';
use RavLog::Schema::DB;
use Data::Dumper;
use Config::Any::YAML;

my $cfg = Config::Any::YAML->load('ravlog.yml');

my $db = RavLog::Schema::DB->connect($cfg->{RavLog}->{connect_info});

#$db->deploy();
$db->create_ddl_dir();

