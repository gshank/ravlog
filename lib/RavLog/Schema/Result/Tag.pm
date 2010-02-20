package RavLog::Schema::Result::Tag;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "Core" );
__PACKAGE__->table("tags");
__PACKAGE__->add_columns(
   "tag_id",
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
);
__PACKAGE__->set_primary_key("tag_id");

__PACKAGE__->has_many(
   'tags_articles' => 'RavLog::Schema::Result::TagArticle',
   'tag_id'
);
__PACKAGE__->many_to_many( 'articles' => 'tags_articles', 'article' );

1;

