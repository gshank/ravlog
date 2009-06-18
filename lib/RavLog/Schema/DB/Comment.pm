package RavLog::Schema::DB::Comment;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "PK::Auto", "InflateColumn::DateTime", "Core" );
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
   "comment",
   {
      data_type     => "text",
      default_value => undef,
      is_nullable   => 1,
      size          => undef,
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
   "article_id",
   { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
);

use Text::Textile qw(textile);

sub textilize
{
   my $self = shift;
   my $what = shift;

   my $temp = $self->$what;
   $temp =~ s/\[code (.*?)\]/==<pre>\[code $1\]/g;
   $temp =~ s/\[\/code\]/\[\/code\]<\/pre>==/g;
   return textile($temp);
}

sub insert
{
   my $self = shift;
   $self->created_at( DateTime->now() );
   $self->next::method(@_);
}

__PACKAGE__->set_primary_key("comment_id");

__PACKAGE__->belongs_to( 'article', 'RavLog::Schema::DB::Article', 'article_id' );

1;

