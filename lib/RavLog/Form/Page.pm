package RavLog::Form::Page;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'RavLog::Form::Render';


has_field 'name' => (
      required => 1,
      label    => 'Page Name',
      size     => 40,
   );

has_field 'display_sidebar' => (
      required => 1,
      label    => 'Display the sidebar?',
      type     => 'Select',
      widget   => 'radio_group',
   );

has_field 'display_in_drawer' => (
      required => 1,
      label    => 'Display in the drawer?',
      type     => 'Select',
      widget   => 'radio_group',
      options  => [ { value => 1, label => 'Yes'}, { value => 0, label => 'No'}],
   );

has_field 'body' => (
      required => 1,
      label    => 'Page Content',
      type     => 'TextArea',
      cols     => 60,
      rows     => 20,
   );

has_field 'submit' => ( 
      type => 'Submit',
      value => 'Save' 
);

sub options_display_in_drawer
{
   ( 1 => 'Yes', 0, 'No' )
}
sub options_display_sidebar
{
   ( 1 => 'Yes', 0, 'No' )
}

no HTML::FormHandler::Moose;
1;
