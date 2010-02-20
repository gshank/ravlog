package RavLog::Schema::Result::Config;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "Core" );
__PACKAGE__->table("config");
__PACKAGE__->add_columns(
   "name",
   {
      data_type         => 'varchar',
      is_nullable       => 1,
   },
   "value",
   {
      data_type     => "varchar",
      is_nullable   => 1,
      size          => 255,
   },
   "description",
   {
      data_type     => "varchar",
      default_value => undef,
      is_nullable   => 1,
      size          => 255,
   },
);

__PACKAGE__->set_primary_key("name");

1;

