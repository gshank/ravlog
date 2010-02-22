package RavLog::Form::Formats;
use HTML::FormHandler::Moose::Role;

use RavLog::Format;

has_field 'format' => (
      type => 'Select', required => 1,
);
sub options_format {
    my $self = shift;
    my @types = RavLog::Format::types;
    my @options;
    foreach my $type (@types) {
        push @options, { value => $type->{type}, label => $type->{description} };
    }
    return \@options;
}
1;
