package RavLog::Schema::Result::Page;

use strict;
use warnings;

use base 'DBIx::Class';
use Text::Textile 'textile';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("pages");
__PACKAGE__->add_columns(
  "page_id",
  {
    data_type => 'integer', 
	is_auto_increment => 1,
    default_value => undef,
	is_nullable => 0,
  },
  "name",
  {
    data_type => "character varying",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "body",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
  },
   "format",
   {
      data_type     => 'varchar',
      is_nullable   => 1,
      size          => 12,
   },
  "display_sidebar",
  {
	data_type => 'smallint',
	default_value => 1,
	is_nullable => 0,
   },
  "display_in_drawer",
  {
	data_type => 'smallint',
	default_value => 1,
	is_nullable => 0,
  }
);
__PACKAGE__->set_primary_key("page_id");

sub formatted_body {
    my $self = shift;
    my $format = $self->format || 'text';
    return RavLog::Format::format_html( $self->body, $format );
}

1;
