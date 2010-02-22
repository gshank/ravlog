package RavLog::Format;
use strict;
use warnings;
use Carp;
use namespace::autoclean;

# this formatting code is from Angerwhale, and is copyright
# Jonathan Rockway and Florian Ragwitz

use Module::Pluggable (
    search_path => ['RavLog::Format'],
    instantiate => 'new',
);

sub _format {
    my ( $text, $type, $what ) = @_;

    croak 'invalid arguments to _format' if !defined $text || !$type;

    my @choices;
    foreach my $plugin ( plugins() ) {
        if ( $plugin->can('can_format') && $plugin->can($what) ) {
            my $possibility = $plugin->can_format($type);
            push @choices, [ $plugin, $possibility ];
        }
    }

    # now sort the choices, and choose the highest
    @choices = sort { $b->[1] <=> $a->[1] } @choices;
    my $choice = $choices[0]->[0];

    return $choice->$what( $text, $type );
}

sub format_html {
    return _format( @_, 'format' );
}

sub format_text {
    return _format( @_, 'format_text' );
}

sub types {
    my @types;
    foreach my $plugin ( plugins() ) {
        push @types, $plugin->types() if $plugin->can('types');
    }
    return @types;
}

1;

__END__

=head1 NAME

RavLog::Format - Dispatches formatting of articles/comments

=head1 SYNOPSIS

  my @types = (
    {
       'description' => 'Text::WikiFormat formatted text',
       'type' => 'wiki',
    },
    {
       'description' => 'Perl POD (Plain Old Documentation)',
       'type' => 'pod',
    },
    {
       'description' => 'Markdown formatted text',
       'type' => 'markdown',
    },
    {
       'description' => 'HTML',
       'type' => 'html',
    },
    {
       'description' => 'Textile formatted text',
       'type' => 'textile',
    },
    {
       'description' => 'Plain text',
       'type' => 'text',
    },
    {
       'description' => 'Simple Blog Code',
       'type' => 'sbc',
    }
  );

=cut
