# Wiki.pm
# Copyright (c) 2006 Jonathan Rockway <jrockway@cpan.org>

package RavLog::Format::Wiki;
use strict;
use warnings;
use Text::WikiFormat;

=head1 RavLog::Format::Wiki

Format WikiText into HTML and plain text.

=head1 METHODS

Standard methods implemented

=head2 new

=head2 can_format

Can format *.wiki.

=head2 types

Handles 'wiki', which is L<Text::WikiFormat|Text::WikiFormat>'s wiki
format.

=head2 format

=head2 format_text

=cut

sub new {
    my $class = shift;
    my $self  = \my $scalar;
    bless $self, $class;
}

sub can_format {
    my $self    = shift;
    my $request = shift;

    return 100 if defined $request && $request eq 'wiki';
}

sub types {
    my $self = shift;
    return (
        {
            type        => 'wiki',
            description => 'Text::WikiFormat formatted text'
        }
    );
}

sub format {
    my $self = shift;
    my $text = shift;
    my $type = shift;

    $text =~ s/&/&amp;/g;
    $text =~ s/>/&gt;/g;
    $text =~ s/</&lt;/g;

    return Text::WikiFormat::format($text);
}

1;

__END__

