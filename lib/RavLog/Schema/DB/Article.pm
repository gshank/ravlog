package RavLog::Schema::DB::Article;

use strict;
use warnings;
use base 'DBIx::Class';
use Text::Textile 'textile';

__PACKAGE__->load_components( 'TimeStamp', 'InflateColumn::DateTime', 'Core' );
__PACKAGE__->table('articles');
__PACKAGE__->resultset_class('RavLog::Schema::ResultSet::Article');
__PACKAGE__->add_columns(
   "article_id",
   {
      data_type         => 'integer',
      is_auto_increment => 1,
      default_value     => undef,
      is_nullable       => 0,
   },
   "subject",
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
   "created_at",
   {
      data_type     => "datetime",
      set_on_create => 1,
      is_nullable   => 1,
      size          => undef,
   },
   "updated_at",
   {
      data_type     => "datetime",
      set_on_create => 1,
      set_on_update => 1,
      is_nullable   => 1,
      size          => undef,
   },

   "user_id",
   {
      data_type     => "integer",
      default_value => undef,
      is_nullable   => 1,
      size          => 4,
   },
);

__PACKAGE__->set_primary_key("article_id");
__PACKAGE__->has_many(
   'comments' => 'RavLog::Schema::DB::Comment',
   'article_id'
);

__PACKAGE__->belongs_to(
   'user' => 'RavLog::Schema::DB::User',
   'user_id'
);

__PACKAGE__->has_many(
   'tags_articles' => 'RavLog::Schema::DB::TagArticle',
   'article_id'
);
__PACKAGE__->many_to_many( 'tags' => 'tags_articles', 'tag' );

sub textilize
{
   my $self = shift;
   my $what = shift;

   my $temp = $self->$what;
   $temp =~ s/<textarea/==<textarea/g;
   $temp =~ s/<\/textarea>/<\/textarea>==/g;
   # $temp =~ s/\[code (.*?)\]/==\[code $1\]/g;
   # $temp =~ s/\[\/code\]/\[\/code\]==/g;
   return textile($temp);
}

sub insert
{
   my $self = shift;
   $self->created_at( DateTime->now() );
   $self->next::method(@_);
}



1;

