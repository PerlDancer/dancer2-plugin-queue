use 5.008001;
use strict;
use warnings;

package Dancer2::Plugin::Queue::Role::Test;
# ABSTRACT: A Test::Roo::Role for testing Queue backends
# VERSION

use Test::Roo::Role;
use MooX::Types::MooseLike::Base qw/Str HashRef CodeRef/;

use Dancer2 ':syntax';
use Dancer2::Plugin::Queue;
use HTTP::Tiny;
use Test::TCP;

has backend => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has options => (
    is      => 'ro',
    isa     => HashRef,
    default => sub { {} },
);

has server => (
    is  => 'lazy',
    isa => CodeRef,
);

sub _build_server {
    my ($self) = @_;
    return sub {
        my $port = shift;

        set confdir      => '.';
        set startup_info => 0;
        set print_banner => 0;
        set show_errors  => 1;
        set plugins      => {
            Queue => {
                default => {
                    class   => $self->backend,
                    options => $self->options,
                },
            }
        };

        set plugins => {
            Queue => {
                default => {
                    class   => 'Array',
                    options => { name => 'Foo' },
                },
            }
        };

        get '/add' => sub {
            queue->add_msg( params->{msg} );
            my ( $msg, $body ) = queue->get_msg;
            queue->remove_msg($msg);
            return $body;
        };

        Dancer2->runner->server->port($port);
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
        server => $self->server,
    );
};

1;

=for Pod::Coverage method_names_here

=head1 SYNOPSIS

In your backend test file:

    use Test::Roo;

    with 'Dancer2::Plugin::Queue::Role::Test';

=head1 DESCRIPTION

This module might be cool, but you'd never know it from the lack
of documentation.

=head1 SEE ALSO

=for :list
* L<Test::Roo>

=cut

# vim: ts=4 sts=4 sw=4 et:
