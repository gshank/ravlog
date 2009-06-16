package RavLog::Form::User;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('Email');

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';


has_field 'username' => (
   required => 1,
   label    => 'User Name',
   size     => 25,
);

has_field 'password' => (
   type     => 'Password',
   label    => 'Password',
   size     => 25,
);

has_field 'website' => (
   label    => 'Website',
   size     => 25,
);

has_field 'email' => (
      required => 1,
      label    => 'E-Mail',
      apply => [ Email ],
      size     => 25,
);

has_field 'submit' => (
   type => 'Submit',
   value => 'Save'
);



no HTML::FormHandler::Moose;
1;
