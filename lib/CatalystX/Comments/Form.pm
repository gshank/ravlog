package CatalystX::Comments::Form;

use HTML::FormHandler::Moose;

extends 'CatalystX::Comments::BaseForm';

has_field 'name' => (
      required => 1,
      label    => 'Name',
      size     => 25
);

has_field 'email' => ( 
     label => 'Email',   
     size => 25 );

has_field 'url' => ( 
     label => 'Website', 
     size => 25 );

no HTML::FormHandler::Moose;
1;
