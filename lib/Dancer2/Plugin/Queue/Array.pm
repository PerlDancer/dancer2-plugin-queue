use 5.008001;
use strict;
use warnings;

package Dancer2::Plugin::Queue::Array;
# ABSTRACT: Single-process, in-memory queue

our $VERSION = '0.006';

# Dependencies
use Moo;
use MooX::Types::MooseLike::Base qw/Str ArrayRef/;
with 'Dancer2::Plugin::Queue::Role::Queue';

=attr name

The C<name> attribute does nothing useful, but it's required
in order to test how options are passed to queue implementations

=cut

has name => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has _messages => (
    is      => 'ro',
    isa     => ArrayRef,
    default => sub { [] },
);

=method add_msg

  $queue->add_msg( $data );

Enqueues $data as a message.

=cut

sub add_msg {
    my ( $self, $msg ) = @_;
    push @{ $self->_messages }, $msg;
}

=method get_msg

  my ($msg, $data) = $queue->get_msg;

Dequeues a message.

=cut

sub get_msg {
    my ($self) = @_;
    my $msg = shift @{ $self->_messages };
    return wantarray ? ( $msg, $msg ) : $msg;
}

=method remove_msg

  $queue->remove_msg( $msg );

Usually would remove a message from the queue as deleted, but
for this demo class, does nothing, since C<get_msg> already removed it.

=cut

sub remove_msg {
    my ( $self, $msg ) = @_;
    # XXX NOOP since 'get_msg' already removes it
}

1;

=for Pod::Coverage method_names_here

=head1 SYNOPSIS

  # in dancer config.yml
  
  queue:
    default:
      class: Array
      options:
        name: test

=head1 DESCRIPTION

This module provides a trivial, single-process, in-memory queue
for testing.

=cut

# vim: ts=4 sts=4 sw=4 et:
