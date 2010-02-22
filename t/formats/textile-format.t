use Test::More;
use ok 'RavLog::Format::Textile';
use Test::HTML::Tidy;
use Test::XML::Valid;
use RavLog::Test::Tidy;
use strict;
use warnings;

my $textile = RavLog::Format::Textile->new;
isa_ok( $textile, 'RavLog::Format::Textile', 'created parser' );

my $input = do { local $/; <DATA> };
my $output = $textile->format($input);

# make output tidier for tidy:
$output = <<"END";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
                      "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"
      xml:lang="en">
<head><title>test</title></head><body>$output</body></html>
END

my $tidy = RavLog::Test::Tidy->tidy();
html_tidy_ok( $tidy, $output, 'html is tidy' );
xml_string_ok( $output, 'html is valid xml' );

done_testing;

__DATA__
h1. This is some *text*

This is a document.  Isn't that wonderful?  This line is getting pretty long, I hope someone cuts me off.
Yay.  This is a new line, but in the same paragraph.  What will happen?

h2. This is a level 2 heading

This is a paragraph.  Yay.

h3. This is h3

This is a paragraph.  Also yay.

h1. Using perl

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
