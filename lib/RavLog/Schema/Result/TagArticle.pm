package RavLog::Schema::Result::TagArticle;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "Core" );
__PACKAGE__->table("tags_articles");
__PACKAGE__->add_columns(
   "tag_article_id",
   {
      data_type         => 'integer',
      is_auto_increment => 1,
      default_value     => undef,
      is_nullable       => 0,
   },
   "tag_id",
   { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
   "article_id",
   { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
);
__PACKAGE__->set_primary_key("tag_article_id");

__PACKAGE__->belongs_to( 'tag', 'RavLog::Schema::Result::Tag', 'tag_id' );
__PACKAGE__->belongs_to( 'article',  'RavLog::Schema::Result::Article',    'article_id' );

1;

