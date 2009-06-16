package RavLog::Form::Link;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has_field 'name' => (
   required => 1,
   label    => 'Displayed Name',
   size     => 40,
);

has_field 'url' => (
   required => 1,
   label    => 'Url',
   size     => 40,
);

has_field 'description' => (
   required => 1,
   label    => 'Description',
   size     => 40,
);

has_field 'submit' => ( 
      type => 'Submit',
      value => 'Save' 
);

no HTML::FormHandler::Moose;
1;
