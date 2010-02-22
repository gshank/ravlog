package RavLog::Schema::Result::Comment;

use strict;
use warnings;

use base 'DBIx::Class';
use RavLog::Format;
use namespace::autoclean;

__PACKAGE__->load_components( "InflateColumn::DateTime", "Core" );
__PACKAGE__->table("comments");
__PACKAGE__->add_columns(
   "comment_id",
   {
      data_type         => 'integer',
      is_auto_increment => 1,
      default_value     => undef,
      is_nullable       => 0,
   },
   "name",
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
   "url",
   {
      data_type     => "character varying",
      default_value => undef,
      is_nullable   => 1,
      size          => 255,
   },
   "body",
   {
      data_type     => "text",
      default_value => undef,
      is_nullable   => 1,
      size          => undef,
   },
   "format",
   {
      data_type     => "varchar",
      default_value => undef,
      is_nullable   => 1,
      size          => 12,
   },
   "remote_ip",
   {
      data_type     => "character varying",
      default_value => undef,
      is_nullable   => 1,
      size          => 32,
   },
   "created_at",
   {
      data_type     => "datetime",
      default_value => "now()",
      is_nullable   => 1,
      size          => undef,
   },
   article_id => { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
   user_id => { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
);

__PACKAGE__->set_primary_key("comment_id");

__PACKAGE__->belongs_to( 'article', 'RavLog::Schema::Result::Article', 'article_id' );
__PACKAGE__->belongs_to( 'user', 'RavLog::Schema::Result::User', 'user_id' );

sub formatted_body {
    my $self = shift;
    my $format = $self->format || 'text';
    return RavLog::Format::format_html( $self->body, $format );
}

1;

