package Dancer::Plugin::Fake::Response;

use warnings;
use strict;

use Dancer ':syntax';
use Dancer::Plugin;

=head1 NAME

Dancer::Plugin::Fake::Response - The great new Dancer::Plugin::Fake::Response!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

in your Dancer project, use this plugin and register  :

    package MyDancer::Server;

    use Dancer::Plugin::Fake::Response;

    catch_fake_exception();

In your config file :

    plugins:
      Fake::Reponse:
        GET:
          /rewrite_fake_route/:id.:format:
            response:
              id: 1
              test: "get test"
            code: 123
          /rewrite_fake_route2/:id.:format:
            response:
              id: 2
              test: "get test 2"
            code: 123
        PUT:
          /rewrite_fake_route/:id.:format:
            response:
              id: 3
              test: "put test"
            code: 234
        POST:
          /rewrite_fake_route/:format:
            response:
              id: 4
              test: "post test"
            code: 456
        DELETE:
          /rewrite_fake_route/:id.:format:
            response:
              id: 5
              test: "delete test"
            code: 456

For each defined route in Dancer plugin config are catched and return data and code configured.

For example for : GET http://localhost/rewrite_fake_route/1.json
return code : 123
return body : {"id":1,"test":"get test"}

new step :
* add possibility to return params set like id : :id
* add possibility to request data store in a file like response_file: file/get_answer.json


=head1 SUBROUTINES/METHODS

=head2 catch_fake_exception

Before filter for dancer

Catch if route match with configured route to answer fake data.

=cut

use Data::Dumper 'Dumper';
register 'catch_fake_exception' => sub {
    before sub {
        my $req = request;
        my %req_params = params;
        return if !defined plugin_setting->{$req->method()};
        foreach my $route (keys %{plugin_setting->{$req->method()}})
        {
          if ($route eq $req->{_route_pattern})
          {
            set serializer => uc($req_params{format}) || 'JSON';
            my $response = plugin_setting->{$req->method()}->{$route}->{response};
            my $code     = plugin_setting->{$req->method()}->{$route}->{code};
            status($code);
            return halt(plugin_setting->{$req->method()}->{$route}->{response});
          }
        }
    };
};

register_plugin;

=head1 AUTHOR

Nicolas Oudard, C<< <noudard at weborama.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-dancer-plugin-fake-response at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dancer-Plugin-Fake-Response>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Dancer::Plugin::Fake::Response


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dancer-Plugin-Fake-Response>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Dancer-Plugin-Fake-Response>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Dancer-Plugin-Fake-Response>

=item * Search CPAN

L<http://search.cpan.org/dist/Dancer-Plugin-Fake-Response/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Nicolas Oudard.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Dancer::Plugin::Fake::Response
