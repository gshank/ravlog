package RavLog::Schema::Result::User;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "Core" );
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
   "user_id",
   {
      data_type         => 'integer',
      is_auto_increment => 1,
      default_value     => undef,
      is_nullable       => 0,
   },
   "username",
   {
      data_type     => "character varying",
      default_value => undef,
      is_nullable   => 1,
      size          => 255,
   },
   "password",
   {
      data_type     => "character varying",
      default_value => undef,
      is_nullable   => 1,
      size          => 255,
   },
   "website",
   {
      data_type     => "character varying",
      default_value => undef,
      is_nullable   => 1,
      size          => 255,
   },
   "email",
   {
      data_type     => "character varying",
      default_value => undef,
      is_nullable   => 1,
      size          => 255,
   },
   "created_at",
   {
      data_type     => "datetime",
      default_value => "now()",
      is_nullable   => 1,
      size          => undef,
   },
);

__PACKAGE__->set_primary_key("user_id");

__PACKAGE__->has_many(
   'articles' => 'RavLog::Schema::Result::Article',
   'user_id'
);


sub insert
{
   my $self = shift;
   $self->created_at( DateTime->now() );
   $self->next::method(@_);
}

1;

