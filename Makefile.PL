use inc::Module::Install;

name 'RavLog';
all_from 'lib/RavLog.pm';

requires 'Catalyst' => '5.800050';
requires 'DBIx::Class';
requires 'DBIx::Class::TimeStamp';
requires 'SQL::Translator';
requires 'Catalyst::Plugin::ConfigLoader' => '0.23';
requires 'Catalyst::Plugin::Static::Simple' => '0.21' ;
requires 'Catalyst::Action::RenderView' => '0.09';
requires 'Catalyst::Plugin::Cache' => '0.08';
requires 'Catalyst::Plugin::Cache::FileCache' => '0.5';
requires 'Catalyst::Plugin::PageCache' => '0.21';
requires 'Catalyst::Plugin::Session' => '0.22';
requires 'Catalyst::Plugin::Session::Store::FastMmap' => '0.11';
requires 'Catalyst::Plugin::Session::State::Cookie' => '0.11';
requires 'Catalyst::Plugin::Authentication' => '0.10012';
requires 'Catalyst::Authentication::Store::DBIx::Class' => '0.1082';
requires 'Catalyst::Authentication::Credential::Password';
requires 'Catalyst::View::TT' => '0.29';
requires 'Catalyst::View::JSON' => '0.25';
requires 'Text::Highlight';
requires 'Text::Textile';
requires 'JSON::XS';
requires 'DateTime::Format::MySQL';
requires 'Config::Any::Perl';
requires 'XML::Feed';
requires 'HTML::CalendarMonthSimple';
requires 'DateTime';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
