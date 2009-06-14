package RavLog::Form::User;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('Email');

extends 'HTML::FormHandler::Model::DBIC';
with 'RavLog::Form::Render';


has_field 'username' => (
   required => 1,
   label    => 'User Name',
   size     => 25,
);

has_field 'password' => (
   required => 1,
   type     => 'Password',
   label    => 'Password',
   size     => 25,
);

has_field 'website' => (
   required => 1,
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
