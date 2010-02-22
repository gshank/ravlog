package RavLog::Format::PlainText;
use strict;
use warnings;
use Text::Autoformat ('autoformat', 'break_TeX');
use URI::Find;

# Format plain text files as pretty HTML (and nicely-formated plain
# text via Text::AutoFormat)

sub new {
    my $class = shift;
    my $self  = \my $scalar;
    bless $self, $class;
}

sub can_format {
    my $self    = shift;
    my $request = shift;

    return 100 if ( $request =~ /te?xt/ );
    return 1;    # everything is text, so let this match a little
}

sub types {
    my $self = shift;
    return (
        {
            type        => 'text',
            description => 'Plain text'
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
    $text =~ s/'/&apos;/g;
    $text =~ s/"/&quot;/g;

    # find URIs
    my $finder = URI::Find->new(
                                sub {
                                    my($uri, $orig_uri) = @_;
                                    return qq|<a href="$uri">$orig_uri</a>|;
                                });
    $finder->find(\$text);
    
    # fix paragraphs
    my @paragraphs = split /\n+/m, $text;
    @paragraphs = grep { $_ !~ /^\s*$/ } @paragraphs;
    return join( ' ', map { "<p>$_</p>" } @paragraphs );
}

sub format_text {
    my $self = shift;
    my $text = shift;
    my $type = shift;

    return autoformat( $text, { break => break_TeX, all => 1 } );
}

1;

__END__

