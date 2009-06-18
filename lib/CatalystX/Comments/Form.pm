package CatalystX::Comments::Form;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';
#with 'HTML::FormHandler::Role::Captcha';

has '+item_class' => ( default => 'Comment' );

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

has_field 'comment' => (
      type     => 'TextArea',
      required => 1,
      label    => 'Body',
      cols     => 30,
      rows     => 10
);

has_field article_id => ( widget => 'no_render' );

has_field 'submit' => ( 
      type => 'Submit',
      value => 'Save' 
);

no HTML::FormHandler::Moose;
1;
