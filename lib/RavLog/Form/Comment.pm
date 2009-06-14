package RavLog::Form::Comment;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'RavLog::Form::Render';
with 'HTML::FormHandler::Role::Captcha';

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

has_field 'verification' => (
      label    => 'Verification',
      size     => 25,
      required => 1
);

has_field 'submit' => ( 
      type => 'Submit',
      value => 'Save' 
);

no HTML::FormHandler::Moose;
1;
