package RavLog::Schema::Result::Link;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "Core" );
__PACKAGE__->table("links");
__PACKAGE__->add_columns(
   "link_id",
   {
      data_type         => 'integer',
      is_auto_increment => 1,
      default_value     => undef,
      is_nullable       => 0,
   },
   "url",
   {
      data_type     => "character varying",
      default_value => undef,
      is_nullable   => 1,
      size          => 255,
   },
   "name",
   {
      data_type     => "character varying",
      default_value => undef,
      is_nullable   => 1,
      size          => 255,
   },
   "description",
   {
      data_type     => "character varying",
      default_value => undef,
      is_nullable   => 1,
      size          => 255,
   },
);

__PACKAGE__->set_primary_key("link_id");

1;

