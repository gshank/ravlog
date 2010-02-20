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

sub textilize {
    my $self = shift;
    my $what = shift;
    
    my $temp = $self->$what;
    $temp =~ s/\[code (.*?)\]/==<pre>\[code $1\]/g;
    $temp =~ s/\[\/code\]/\[\/code\]<\/pre>==/g;
    return textile($temp);
}

1;

