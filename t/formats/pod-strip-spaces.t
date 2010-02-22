use strict;
use warnings;
use Test::More;
use RavLog::Format::Pod;

my @tests = ( [[" this", " is", " a", " test"] => [qw/this is a test/]],
              [["this", "is", "a", "test"] => [qw/this is a test/]],
              [["  this", "is", "a", "test"] => ["  this", "is", "a", "test"]],
            );

my $data = do { local $/; <DATA> };
my @cases = split/XXXXX/,$data;
foreach my $case (@cases) {
    my ($in,$exp) = split/-----/,$case;
    $in  =~ s/^\n//;
    $exp =~ s/^\n//;
    
    push @tests, [[split/\n/,$in],[split/\n/,$exp]];
}
              
foreach my $pair (@tests) {
    my $input = $pair->[0];
    my ($got) = RavLog::Format::Pod::_strip_leading_spaces($input);
    my $exp   = $pair->[1];
    
    is_deeply($got, $exp);
}

done_testing;

__DATA__
 $c->stash->{human_readable} = sub {
     my $nr = shift;

     my $i = 0;
     my @units = qw/B KB MB GB TB/;
     while ( $nr > 1024 ) {
         $nr /= 1024 ;
         $i++ ;
     }

     #show one decimal for small numbers
     $nr = Number::Format::round($nr, $nr>=10?0:1);

     $nr .= $units[$i] ;
     return $nr;
     };
 };
-----
$c->stash->{human_readable} = sub {
    my $nr = shift;

    my $i = 0;
    my @units = qw/B KB MB GB TB/;
    while ( $nr > 1024 ) {
        $nr /= 1024 ;
        $i++ ;
    }

    #show one decimal for small numbers
    $nr = Number::Format::round($nr, $nr>=10?0:1);

    $nr .= $units[$i] ;
    return $nr;
    };
};
XXXXX
   this
   is
    a
     test
-----
this
is
 a
  test
