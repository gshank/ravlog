package RavLog::Format::Textile;
use strict;
use warnings;
use Text::Textile;
use RavLog::Format::HTML;

# Format Textile formatted text into HTML.

sub new {
    my $class = shift;

    my $textile = Text::Textile->new;
    $textile->charset('utf-8');

    my $self = \$textile;
    bless $self, $class;
}

sub can_format {
    my $self    = shift;
    my $request = shift;

    return 100 if defined $request && $request eq 'textile';
}

sub types {
    my $self = shift;
    return (
        {
            type        => 'textile',
            description => 'Textile formatted text'
        }
    );
}

sub format {
    my $self = shift;
    my $text = shift;
    my $type = shift;

    my $html_format     = RavLog::Format::HTML->new;
    my $textile_as_html = $$self->process($text);
    return $html_format->format( $textile_as_html, 'html' );
}

sub format_text {
    my $self = shift;
    my $text = shift;
    my $type = shift;

    my $html_format     = RavLog::Format::HTML->new;
    my $textile_as_html = $$self->process($text);
    return $html_format->format_text( $textile_as_html, 'html' );
}

1;
