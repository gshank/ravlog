package RavLog::Format::SBC;
use strict;
use warnings;
use HTML::SBC;
use RavLog::Format::HTML;

# Format Simple Blog Code into HTML.

sub new {
    my $class = shift;

    my $self = \HTML::SBC->new;
    bless $self, $class;
}

sub can_format {
    my $self    = shift;
    my $request = shift;

    return 100 if defined $request && $request eq 'sbc';
}

sub types {
    my $self = shift;
    return (
        {
            type        => 'sbc',
            description => 'Simple Blog Code'
        }
    );
}

sub format {
    my $self = shift;
    my $text = shift;
    my $type = shift;

    my $html_format = RavLog::Format::HTML->new;
    my $sbc_as_html = $$self->sbc($text);
    return $html_format->format( $sbc_as_html, 'html' );
}

sub format_text {
    my $self = shift;
    my $text = shift;
    my $type = shift;

    my $html_format = RavLog::Format::HTML->new;
    my $sbc_as_html = $$self->sbc($text);
    return $html_format->format_text( $sbc_as_html, 'html' );
}

1;
