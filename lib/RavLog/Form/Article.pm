package RavLog::Form::Article;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'RavLog::Form::Render';

has_field 'subject' => (
      label    => 'Subject',
      size     => 40,
      required => 1,
);

has_field 'tags' => (
      type     => 'Select',
      label    => 'Tags',
      multiple => 1,
);

has_field 'body' => (
      required => 1,
      type     => 'TextArea',
      label    => 'Body',
      rows     => 20,
      cols     => 40,
);
has_field '_submit' => ( 
      type => 'Submit',
      id => '_submit',
      value => 'Save' 
);


no HTML::FormHandler::Moose;
1;
