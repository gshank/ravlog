use Test::More;
use ok 'RavLog::Format::HTML';
use RavLog::Test::Tidy;
use Test::HTML::Tidy;
use Test::XML::Valid;
use strict;
use warnings;

my $html = RavLog::Format::HTML->new;
ok( $html, 'created parser OK' );

# to plain text
my $input = do { local $/; <DATA> };
my $output = $html->format_text($input);
like( $output, qr/THIS IS SOME TEXT/m,         'h1 works' );
like( $output, qr/THIS IS A LEVEL 2 HEADING/m, 'h2 works' );
unlike(
    $output,
qr/This is a document.  Isn't that wonderful?  This line is getting pretty long, I hope someone cuts me off./m,
    'text is cut'
);
like( $output, qr/[\d]/m,        'number link refs exist' );
like( $output, qr/[\d].*http:/m, 'the links themselves exist' );
unlike( $output, qr/<b>/, 'no bold' );
unlike( $output, qr/<i>/, 'no italic' );
unlike( $output, qr/<p>/, 'no p tags' );

my $old;
for ( 1 .. 3 ) {
    $old = $output;
    my $output = $html->format_text($input);
    is( $old, $output, 'same output each time' );
}

# to HTML

$output = $html->format($input);

# make output tidier for tidy:
$output = <<"END";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
                      "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"
      xml:lang="en">
<head><title>test</title></head><body>$output</body></html>
END
if (0) {
    my @pretty;
    $output =~ s{</(\w+)>}{</$1>\n}g;
    @pretty = split /$/m, $output;
    my $i = 0;
    @pretty = map { $i++; "$i: $_\n" } @pretty;
    print @pretty;
}

my $tidy = RavLog::Test::Tidy->tidy();
html_tidy_ok( $tidy, $output, 'html is tidy' );
xml_string_ok( $output, 'html is valid xml' );

done_testing;

__DATA__
<h1>This is some <b>text</b></h1>
<p>This is a document.  Isn't that wonderful?  This line is getting pretty long, I hope someone cuts me off.
Yay.  This is a new line, but in the same paragraph.  What will happen?</p>
<h2>This is a level 2 heading</h2>
<p>This is a paragraph.  Yay.</p>
<h3>This is h3</h3>
<p>This is a paragraph.  Also yay.</p>
<p>This <i>is italic</i>.</p>
<img src="http://www.example.com/images/image.png"
     alt="An example image"/>
<p>This is a link <a href="http://www.google.com/">to Google</a>.</p>
<p>Here is a link to <a href="http://blog.jrock.us/">Jon's Blog</a>.  It's good for you.</p>
<h2>New section 2</h2>
<p>Text, text, text, text.  Blah blah blah blah.
Blah.  Blah.  Text, some stuff.  Lorem ipsum.  Paragraph text.</p>
<h1>XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</h1>

<blockquote> This is <i>completely</i> invalid.  </blockquote> <ul>
<li>Hello</li> </ul> <ol> <li>Hi there</li> <li>And again</li> </ol>
<!-- random junk --> <ol>Hi <img src="<>"> >< foo <b>bold</b>.
<br />
<h1>Using perl</h1> 

Lorem ipsum dollar ($) sit amit.  Lorem ipsum
dollar ($) sit amit.  Lorem ipsum dollar ($) sit amit.  Lorem ipsum
dollar ($) sit amit.  Lorem ipsum dollar ($) sit amit.  Lorem ipsum
dollar ($) sit amit.  Lorem ipsum dollar ($) sit amit.  Lorem ipsum
dollar ($) sit amit.  Lorem ipsum dollar ($) sit amit.  Lorem ipsum
dollar ($) sit amit.  Lorem ipsum dollar ($) sit amit.  Lorem ipsum
dollar ($) sit amit.  Lorem ipsum dollar ($) sit amit.  Lorem ipsum
dollar ($) sit amit.  Lorem ipsum dollar ($) sit amit.  Lorem ipsum
dollar ($) sit amit.  Lorem ipsum dollar ($) sit amit.  Lorem ipsum
dollar ($) sit amit.  Lorem ipsum dollar ($) sit amit.  Lorem ipsum
dollar ($) sit amit.  Lorem ipsum dollar ($) sit amit.  Lorem ipsum
dollar ($) sit amit.  Lorem ipsum dollar ($) sit amit.  Lorem ipsum
dollar ($) sit amit.


