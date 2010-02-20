package RavLog::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
   schema_class => 'RavLog::Schema',
   connect_info => [
     'DBI:mysql:dbname=ravlog',
     'ravlog_user',
     'ravlog_pw',
   ],
);

=head1 NAME

RavLog::Model::DB - Catalyst DBIC Schema Model

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
