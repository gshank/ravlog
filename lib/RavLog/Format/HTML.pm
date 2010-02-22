package RavLog::Format::HTML;
use HTML::TreeBuilder;
use Quantum::Superpositions;
use Scalar::Util qw(blessed);
use URI;
use base 'Class::Accessor';
use Text::Autoformat qw(autoformat break_TeX);

use strict;
use warnings;
__PACKAGE__->mk_accessors(qw/_links/);

# Format valid or invalid HTML into valid XHTML or plain text.

sub new {
    my $class = shift;
    my $self  = {};
    bless $self, $class;
}

sub can_format {
    my $self    = shift;
    my $request = shift;

    return 100 if ( $request =~ /html?/ );
    return 0;
}

sub types {
    my $self = shift;
    return (
        {
            type        => 'html',
            description => 'HTML'
        }
    );
}

sub format {
    my $self = shift;
    my $text = shift;
    my $type = shift;

    my $html = HTML::TreeBuilder->new;

    $html->parse($text);
    $html->eof;

    my $result = $self->_parse( $html->guts );
    $html->delete;

    return "$result";
}

sub format_text {
    my $self = shift;
    my $text = shift;
    my $type = shift;

    my $html = HTML::TreeBuilder->new;

    $html->parse($text);
    $html->eof;

    $self->_clear_links();
    my $result = $self->_parse_text( $html->guts );
    my @links = @{ $self->_links || [] };
    $self->_clear_links();

    $html->delete;

    if (@links) {
        @links = map { autoformat($_) } @links;
        chomp @links;
        chomp @links;
        my $links = join "\n", @links;

        $result = autoformat( $result, { break => break_TeX, all => 1 } );
        $result .= "\n-- \n$links\n";
    }
    return $result;
}

sub _clear_links {
    my $self = shift;
    $self->_links( [] );
}

sub _push_link {
    my $self  = shift;
    my $link  = shift;
    my $links = $self->_links();
    my $count = scalar @$links + 1;
    chomp $link;
    push @$links, " [$count] $link";
    return $count;
}

sub _parse_text {
    my $self     = shift;
    my @elements = @_;
    my $result   = q{};     # stores body of text
    foreach my $element (@elements) {
        my $type;
        if ( blessed $element && $element->isa('HTML::Element') ) {
            my @kids = $element->content_list;
            my $type = $element->tag;
            if ( $type eq 'a' ) {
                my $location = $element->attr('href');
                my $uri      = URI->new($location);

                # push link data
                my $count = $self->_push_link($uri);
                $result .= $self->_parse_text(@kids) . " [$count]";
            }
            elsif ( $type eq 'img' ) {
                my $alt = $element->attr('alt');
                $result .= "[$alt]" if $alt;
            }
            elsif ( $type =~ /^h(\d)/ ) {
                my $level = $1;
                my $heading .= $self->_parse_text(@kids);

                if ( $level < 3 ) {
                    $heading = uc $heading;
                }

                if ( $level < 2 ) {
                    my $len = length $heading;
                    $len = 72 if $len > 72;

                    $heading .= "\n";
                    $heading .= "-" x $len;
                }

                $result .= "\n$heading\n";
            }
            elsif ( $type eq 'br' ) {
                $result .= "\n";
            }
            elsif ( $type eq 'hr' ) {
                $result .= "\n\n";
            }
            elsif ( $type eq 'p' ) {
                $result .= "\n" . $self->_parse_text(@kids) . "\n";
            }
            else {
                $result .= $self->_parse_text(@kids);
            }
        }
        else {
            $result .= $element;
        }
    }
    return $result;
}

sub _parse {
    my $self = shift;

    my @elements = @_;
    my $result   = q{};
    foreach my $element (@elements) {
        my $type;
        if ( blessed $element && $element->isa('HTML::Element') ) {
            my @kids = $element->content_list;
            my $type = $element->tag;

            # if it's a link
            if ( $type eq 'a' ) {
                my $location = $element->attr('href');
                my $uri      = URI->new($location);

                my $scheme = $uri->scheme;
                if ( !$scheme ) {
                    $uri->scheme('http');
                    $scheme = 'http';
                }

                if ( $scheme !~ /^(http|ftp|mailto)$/ ||
                    $uri->as_string =~ /#/ )
                {
                    $result .= $self->_parse(@kids);    # not a link.
                }

                else {
                    $location = _escape( $uri->as_string );
                    $result .= qq{<a href="$location">};
                    $result .= $self->_parse(@kids);
                    $result .= '</a>';
                }
            }

            elsif ( $type eq 'cite' ) {

                # save cite for the next blockquote
                delete $self->{cite};
                foreach my $kid (@kids) {
                    $self->{cite} = $self->_parse($kid);
                }
            }
            elsif ( $type eq 'blockquote' ) {
                my $quote;

                foreach my $kid (@kids) {
                    if ( blessed $kid &&
                        $kid->tag eq any(qw|p blockquote ul|) )
                    {
                        $quote .= $self->_parse($kid);
                    }
                    elsif ( blessed $kid && $kid->tag eq 'cite' ) {
                        $self->{cite} = $self->_parse($kid);
                    }
                    else {
                        $quote .= "<p>" . $self->_parse($kid) . "</p>";
                    }
                }
                my $cite = $self->{cite};
                $result .= $cite ? qq{<blockquote cite="$cite">} :
                                   q{<blockquote>};

                $result .= qq{$quote</blockquote>};
            }

            # lists need items
            elsif ( $type eq any(qw(ul ol)) ) {
                $result .= "<$type>";
                foreach my $kid (@kids) {
                    if ( blessed $kid &&
                        $kid->tag eq 'li' )
                    {
                        $result .= $self->_parse($kid);
                    }
                    else {
                        my $content = $self->_parse($kid);
                        next unless $content;
                        $result .= "<li>$content</li>";
                    }
                }
                $result .= "</$type>";
            }

            # one of these tags
            elsif (
                $type eq any(
                    qw(i strong b u pre samp code
                        kbd p q ol ul li dt dl dd
                        tt big small sub sup)
                )
                )
            {
                $result .= qq{<$type>};
                $result .= $self->_parse(@kids);
                $result .= qq{</$type>};
            }

            # image
            elsif ( $type eq 'img' ) {
                my $alt = $element->attr('alt');
                if ($alt) {
                    $result .= "<p>[$alt]</p>";
                }
            }

            # heading
            elsif ( $type =~ /h(\d+)/ ) {
                my $heading = $1;
                $heading += 2;
                $heading = 6 if ( $heading > 6 );
                $result .= qq{<h$heading>};
                $result .= $self->_parse(@kids);
                $result .= qq{</h$heading>};
            }

            # break
            elsif ( $type eq 'br' ) {
                $result .= '<br />';
            }

            # ignore the header completely
            elsif ( $type eq 'head' ) { }

            # also ignore script, just in case
            elsif ( $type eq 'script' ) { }

            # something else
            else {
                $result .= $self->_parse(@kids);
            }
        }

        # plain text
        else {
            $result .= _escape($element);
        }
    }

    return $result;
}

sub _escape {
    my $text = shift;
    $text =~ s/&/&amp;/g;
    $text =~ s/</&lt;/g;
    $text =~ s/>/&gt;/g;
    $text =~ s/"/&quot;/g;
    $text =~ s/'/&apos;/g;
    return $text;
}

1;
