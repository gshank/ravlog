package RavLog::Format::Markdown;
use strict;
use warnings;
use Text::Markdown;
use RavLog::Format::HTML;

# Format Markdown formatted text into HTML.

sub new {
    my $class = shift;

    my $self = \Text::Markdown->new;
    bless $self, $class;
}

sub can_format {
    my $self    = shift;
    my $request = shift;

    return 100 if defined $request && $request eq 'markdown';
}

sub types {
    my $self = shift;
    return (
        {
            type        => 'markdown',
            description => 'Markdown formatted text'
        }
    );
}

sub format {
    my $self = shift;
    my $text = shift;
    my $type = shift;

    my $html_format      = RavLog::Format::HTML->new;
    my $markdown_as_html = $$self->markdown($text);
    return $html_format->format( $markdown_as_html, 'html' );
}

sub format_text {
    my $self = shift;
    my $text = shift;
    my $type = shift;

    my $html_format      = RavLog::Format::HTML->new;
    my $markdown_as_html = $$self->markdown($text);
    return $html_format->format_text( $markdown_as_html, 'html' );
}

1;
