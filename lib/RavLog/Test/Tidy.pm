package RavLog::Test::Tidy;
use strict;
use warnings;
use HTML::Tidy;

=head1 NAME

RavLog::Test::Tidy - setup a tidy for use with Angerwhale tests

=head1 SYNOPSIS

   use RavLog::Test::Tidy;
   my $tidy = RavLog::Test::Tidy->new;

=head1 METHODS

=head2 tidy

Return a new tidy object with the settings we desire

=cut

sub tidy {
    my $class = shift;
    return HTML::Tidy->new({'char-encoding' => 'utf8'});
}

1;
