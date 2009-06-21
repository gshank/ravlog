package CatalystX::Comments::BaseForm;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';
#with 'HTML::FormHandler::Role::Captcha';

has '+name' => ( default => 'comment_form' );
has '+item_class' => ( default => 'Comment' );
has '+html_prefix' => ( default => 1 );

has_field 'body' => (
      type     => 'TextArea',
      required => 1,
      label    => 'Body',
      cols     => 30,
      rows     => 10
);

has_field 'submit' => ( 
      type => 'Submit',
      value => 'Save' 
);

no HTML::FormHandler::Moose;
1;
