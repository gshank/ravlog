use inc::Module::Install;

name 'RavLog';
all_from 'lib/RavLog.pm';

requires 'Catalyst' => '5.800050';
requires 'DBIx::Class';
requires 'DBIx::Class::TimeStamp';
requires 'SQL::Translator';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Plugin::Cache';
requires 'Catalyst::Plugin::Cache::FileCache';
requires 'Catalyst::Plugin::PageCache';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Authentication' => '0.10008';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Authentication::Credential::Password';
requires 'Catalyst::View::TT';
requires 'Catalyst::View::JSON';
requires 'Text::Highlight';
requires 'Text::Textile';
requires 'JSON::Syck';
requires 'DateTime::Format::MySQL';
requires 'Catalyst::Plugin::Server';
requires 'Catalyst::Plugin::Server::XMLRPC';
requires 'Config::Any::Perl';
requires 'XML::Feed';
requires 'HTML::CalendarMonthSimple';
requires 'DateTime';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
