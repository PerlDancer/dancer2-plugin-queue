use 5.008001;
use strict;
use warnings;

package Dancer2::Plugin::Queue::Role::Test;
# ABSTRACT: A Test::Roo::Role for testing Queue backends

our $VERSION = '0.007';

use Test::Roo::Role;
use MooX::Types::MooseLike::Base qw/Str HashRef CodeRef/;

use HTTP::Tiny;
use Test::TCP;

=attr backend

The short name for a Dancer2::Plugin::Queue implementation to test.

=cut

has backend => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

=attr options

A hash reference of options to configure the backend.

=cut

has options => (
    is      => 'lazy',
    isa     => HashRef,
);

sub _build_options { }

has _server => (
    is  => 'lazy',
    isa => CodeRef,
);

sub _build__server {
    my ($self) = @_;
    return sub {
        package
            MyServer;
        use Dancer2 ':syntax';
        use Dancer2::Plugin::Queue;
        my $port = shift;

        set confdir      => '.';
        set startup_info => 0;
        set show_errors  => 1;
        set plugins      => {
            Queue => {
                default => {
                    class   => $self->backend,
                    options => $self->options,
                },
            }
        };

        get '/add' => sub {
            queue->add_msg( params->{msg} );
            my ( $msg, $body ) = queue->get_msg;
            queue->remove_msg($msg);
            return $body;
        };

        Dancer2->runner->server->{ port } = $port;
        start;
    };
}

test 'queue and dequeue' => sub {
    my $self = shift;
    test_tcp(
        client => sub {
            my $port = shift;
            my $url  = "http://localhost:$port/";

            my $ua = HTTP::Tiny->new;

            my $res = $ua->get( $url . "add?msg=Hello%20World" );
            like $res->{content}, qr/Hello World/i, "sent and receieved message";
        },
        server => $self->_server,
    );
};

1;

=for Pod::Coverage method_names_here

=head1 SYNOPSIS

In your backend test file:

    use Test::Roo;

    with 'Dancer2::Plugin::Queue::Role::Test';

    run_me({ backend => 'Array', options => { name => "foo" } });

    done_testing;

=head1 DESCRIPTION

This module is a L<Test::Roo> role used for testing L<Dancer2::Plugin::Queue>
implementations.

Implementations using this test role must ensure that the following modules are
included as test requirements:

=for :list
* L<HTTP::Tiny>
* L<Test::Roo>
* L<Test::TCP>

=cut

# vim: ts=4 sts=4 sw=4 et:
