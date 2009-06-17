# Pod.pm
# Copyright (c) 2006 Jonathan Rockway <jrockway@cpan.org>
package RavLog::Format::Pod;
use strict;
use warnings;
use IO::String;
use base qw(Pod::Xhtml Class::Accessor);
use Pod::Simple::Text;
use RavLog::Format::HTML;
use List::Util qw(min);
use Syntax::Highlight::Engine::Kate;
use Syntax::Highlight::Engine::Kate::All;

# lang = language code is in
# spaces = spaces that the textblock is indented by
__PACKAGE__->mk_accessors(qw/lang spaces/);

=head1 RavLog::Format::Pod

Fomat POD documentation as XHTML.  Syntax-highlight code blocks.

=head1 METHODS

Standard methods implemented

=head2 new

=head2 can_format

Can format *.pod.

=head2 types

Handles 'pod' which is perl's Plain Old Documenation.  See L<perlpod>.

=head2 format

=head2 format_text

=head2 verbatim

Overrides Pod::Xhtml to provide syntax-highlighting of code blocks.

To specify a language for a code block, and all remaining code blocks,
make the first line C<lang:LanguageName>, like C<lang:Perl> or
C<lang:Haskell>.  To turn off syntax highlighting until
the next C<lang:> directive, do C<lang:0> or C<lang:undef>.

=head2 textblock

C<pod--> (long story)

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(
        TopLinks     => 0,
        MakeIndex    => 0,
        FragmentOnly => 1,
        TopHeading   => 3,
                                  );
    $self->spaces(-1);
    return $self;
}

sub can_format {
    my $self    = shift;
    my $request = shift;

    return 100 if ( $request =~ /pod/ );
    return 0;
}

sub types {
    my $self = shift;
    return (
        {
            type        => 'pod',
            description => 'Perl POD (Plain Old Documentation)'
        }
    );
}

sub format {
    my $self = shift;
    my $text = shift;
    my $type = shift;    # TODO: copy this into lang?

    $text = "=pod\n\n$text" unless $text =~ /\n=[a-z]+\s/;

    my $input  = IO::String->new($text);
    my $result = IO::String->new;

    $self->parse_from_filehandle( $input, $result );
    
    my $output = ${ $result->string_ref };
    $output =~ s{\n</pre>}{</pre>}g; # fixup some weird formatting
    return $output;
}

sub format_text {
    my $self = shift;
    my $text = shift;
    my $type = shift;

    my $pod_format = Pod::Simple::Text->new;

    my $output;
    $pod_format->output_string( \$output );
    $text = "=pod\n\n$text" unless $text =~ /\n=[a-z]+\s/;
    $pod_format->parse_string_document($text);
    my $text_format = RavLog::Format::PlainText->new;
    return $text_format->format_text( $output, 'text' );
}

# HACK!
sub _handleSequence {
    my $self = shift;
    my $seq  = shift;

    if ( ref $seq eq 'SCALAR' ) {
        return $$seq;    # skip escaping step, since this is already HTML
    }
    else {
        return $self->SUPER::_handleSequence($seq);
    }
}

sub textblock {
    my $parser = shift;
    $parser->spaces(-1);
    $parser->SUPER::textblock(@_);
}

sub verbatim {
    my $parser    = shift;
    my $paragraph = shift;
    my $line_num  = shift;
    my $pod_para  = shift;
    my $text      = $pod_para->text;

    my @lines = split /\n/, $text;

    if ( $lines[0] && $lines[0] =~ m{\s*lang:([^.]+)\s*$} ) {

        if ( !defined $1 || !$1 || $1 eq 'undef' ) {
            $parser->lang(0);
        }
        else {
            $parser->lang( ucfirst $1 );
        }

        shift @lines;
    }
    # strip unnecessary leading spaces
    my ($res, $spaces) = _strip_leading_spaces([@lines],$parser->spaces);
    $text = join "\n", @{$res};
    $parser->spaces($spaces);
    
    # syntax highlight if necessary
    if ( $parser->lang ) {
        eval {
            no warnings 'redefine';
            local *Syntax::Highlight::Engine::Kate::Template::logwarning
              = sub { die @_ }; # i really don't care
            my $hl = Syntax::Highlight::Engine::Kate->new(
                language      => $parser->lang,
                substitutions => {
                    "<"  => "&lt;",
                    ">"  => "&gt;",
                    "&"  => "&amp;",
                    q{'} => "&apos;",
                    q{"} => "&quot;",
                },
                format_table => {
                    # convert Kate's internal representation into
                    # <span class="<internal name>"> value </span>
                    map {
                        $_ => [ qq{<span class="$_">}, '</span>' ]
                    }
                      qw/Alert BaseN BString Char Comment DataType
                         DecVal Error Float Function IString Keyword
                         Normal Operator Others RegionMarker Reserved
                         String Variable Warning/,
                },
            );

            my $html = $hl->highlightText($text);
            $text = \$html;
        };
        # too verbose and too irrelevant
        # if ($@) {
        #    warn "Error syntax highlighting: $@";
        #}
    }

    # if highlighting didn't work, just show the regular text
    $pod_para->text($text);
    $parser->parse_tree->append($pod_para);
}

sub _strip_leading_spaces {
    my @lines = @{shift()};
    my $spaces = shift || -1;
    
    # figure out how many that is
    for my $line (@lines) {
        next if $line =~ /^\s*$/;    # skip lines that are all spaces
        if ($line =~ /^(\s+)/){
            if ( $spaces == -1 ) {
                $spaces = length $1;
            }
            else {
                $spaces = min( $spaces, length $1 );
            }
        }
        else {
            $spaces = 0;
        }
    }
    
    for my $line (@lines) {
        next if $line =~ /^\s*$/;
        $line =  substr $line, $spaces;
    }
    
    return ([@lines],$spaces);
}

1;
