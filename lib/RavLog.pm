package RavLog;

use strict;
use warnings;
use DateTime;
use Text::Highlight;
use Config::Any::Perl;

our $VERSION = '0.01';

use Catalyst ( 
   '-Debug',
   'Static::Simple',
   'ConfigLoader',
   'Cache::FileCache',
   'PageCache',
   'Session', 
   'Session::Store::FastMmap', 
   'Session::State::Cookie', 
   'Server',
   'Server::XMLRPC',
   'Authentication', 
);


__PACKAGE__->config( static => {dirs => ['static'] } );

__PACKAGE__->config( 'View::JSON' => { json_driver => 'JSON::Syck' } );

__PACKAGE__->config( 'Plugin::Cache' => 
  { backend => { store => 'FastMmap' } } );
                
__PACKAGE__->config( 'Plugin::Authentication' => {
    default_realm => 'dbic',
        dbic => {
            credential => {
                class => 'Password',
                password_field => 'password',
                password_type => 'clear',
            },
            store => {
                class => 'DBIx::Class',
                user_class => 'DB::User',
                user_field => 'username',
            },
	},
});

__PACKAGE__->config( 'Plugin::PageCache'  => {
    set_http_headers => 1,
    expires => 20,
    auto_check_user => 1,
    auto_cache => [
        '/view/.*',
        '/',
        '/category/.*',
        '/archived/.*',
        '/page/.*',
    ],
    debug => 0,
});

# session not yet using Plugin::Session config
__PACKAGE__->config( session => {
    expires => 3600,
    storage => '/tmp/sessions',
});


# Start the application
__PACKAGE__->setup;


#===================================================
# this should be a role 

sub render_ravlog_date {
    my $self = shift;
    my $date = shift;
    
    return "<span class=\"ravlog_date\" title=\""
      . $self->datetime_to_ravlog_time($date)
      . "\"></span>";
}

sub set_ravlog_params {
    my $self = shift;
    if (@_) { $self->{ravlog_args} = shift; }
    else {
        return $self->{ravlog_args};
    }
}

sub render_ravlog_headers {
    my $self = shift;
	return $self->render_ravlog_edges_and_dates;
}

sub ravlog_txt_to_url {
    my $self = shift;

    my ( $txt, $id ) = @_;

    $txt =~ s/(\'|\!|\`|\?)//g;
    $txt =~ s/ /\_/g;

    return $txt;
}

sub ravlog_url_to_query {
    my $self = shift;

    my ($txt) = shift;

    $txt =~ s/\_/ /g;
    $txt =~ s/s /\%/g;
    return ( "%" . $txt . "%" );
}

sub datetime_to_ravlog_time {
    my $self = shift;

    my ($d) = shift;
    my $ext =
        $d->day_abbr() . ", "
      . $d->day() . " "
      . $d->month_abbr() . " "
      . $d->year() . " "
      . $d->hour . ":"
      . $d->minute . ":"
      . $d->second();
    return $ext;
}

sub ravlog_highlight_code {
	my $self = shift;
	my $html = shift;

	$html =~ s/\[code syntax\=[\'|\"](.*?)[\'|\"]\](.*?)\[\/code\]/$self->process_code($1,$2)/egs;
	return $html;
}


sub process_code {
	my ($self,$lang,$code)=@_;
	
    my $high = new Text::Highlight(wrapper=>"<div class='code'>%s</div>\n");
    my $final=$high->highlight($lang,$code);
    $final =~ s/  /&nbsp;&nbsp;/g;
    $final =~ s/\n/<br\/>/g;
    
    return $final;
}

sub render_ravlog_edges_and_dates {
    my $self = shift;

    my ($tags) = $self->{ravlog_args};
    my $ravlog_tags = "<script type=\"text/javascript\">\n";
    $ravlog_tags = $ravlog_tags . "window.onload=function(){ \n";
    $ravlog_tags = $ravlog_tags . "show_dates_as_local_time(); \n";
    for my $tag ( @{$tags} ) {
        $ravlog_tags = $ravlog_tags . "Nifty(";
        for my $element ( @{$tag} ) {
            $ravlog_tags = $ravlog_tags . "'$element',";
        }
        chop($ravlog_tags);
        $ravlog_tags = $ravlog_tags . ");\n";
    }

    $ravlog_tags = $ravlog_tags . "} \n </script> \n";

    return $ravlog_tags;
}

sub push_into_ravlog_params {
    my $self = shift;
    my ( $current_list, $tags_to_add ) = @_;
    push @$current_list, $tags_to_add;
    return $current_list;
}

1;

=head1 NAME

RavLog - Blog application using Catalyst

=head1 SYNOPSIS

Install. Execute with 'script/ravlog_server.pl'.

=head1 AUTHOR

Gerda Shank

Partly based on previous efforts by Victor Igumnov and Jonathan Rockway.

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

