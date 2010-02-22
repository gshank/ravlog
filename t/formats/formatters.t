use Test::More;
use ok 'RavLog::Format';
use strict;
use warnings;

my @types = RavLog::Format::types;
ok( @types > 0, 'do we have some formatters?' );

my $txt = "This is some plain old text.\n\nThis is a new paragraph\n";
my $pod = <<'ENDPOD';

=head1 PLAIN OLD DOCUMENTATION

Plain old documentation is not just for documenting Perl
programs.  It can also be used to post to your blog.

=head1 ANOTHER HEADING

This test is good for POD processors, too.  This section of the test
looks like POD, but it's actually a heredoc.  Confusing!

ENDPOD
my $html = 'This <i>is</i> HTML. Hopefully this passes thru.';

# not a complete test, just want to see if things show up

my $formatted_html = RavLog::Format::format_html( $html, 'html' );
my $text_html      = RavLog::Format::format_text( $html, 'html' );
chomp $html;
chomp $text_html;
chomp $formatted_html;

is( $formatted_html, $html, 'html passed through' );
is( $text_html, 'This is HTML. Hopefully this passes thru.' );

my $formatted_txt = RavLog::Format::format_html( $txt, 'txt' );
my $text_txt      = RavLog::Format::format_text( $txt, 'txt' );
chomp $txt;
chomp $text_txt;
chomp $formatted_txt;

ok($formatted_txt);
is( $text_txt, $txt );

my $formatted_pod = RavLog::Format::format_html( $pod, 'pod' );
my $text_pod      = RavLog::Format::format_text( $pod, 'pod' );
ok($formatted_pod);
like( $text_pod, qr/Confusing!$/ );

done_testing;
