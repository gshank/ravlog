# SBC.pm
# Copyright (c) 2006 Florian Ragwitz <rafl@debian.org>

package RavLog::Format::SBC;
use strict;
use warnings;
use HTML::SBC;
use RavLog::Format::HTML;

=head1 RavLog::Format::SBC

Format Simple Blog Code into HTML.

=head1 METHODS

Standard methods implemented

=head2 new

=head2 can_format

Can format *.sbc

=head2 types

Handles 'sbc', which is Simple Blog Code.

=head2 format

=head2 format_text

=cut

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

__END__

