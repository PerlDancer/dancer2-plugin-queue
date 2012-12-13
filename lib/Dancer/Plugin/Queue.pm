use 5.008001;
use strict;
use warnings;

package Dancer::Plugin::Queue;
# ABSTRACT: Dancer plugin for message queue abstractions
# VERSION

use Dancer::Plugin;
use Class::Load qw/try_load_class/;

my %queues;
my $conf;

register queue => sub {
  my ( $dsl, $name ) = @_;
  $conf ||= plugin_setting();

  # if name not specified, DWIM or use 'default'
  if ( not defined $name ) {
    if ( keys %$conf == 1 ) {
      ($name) = keys %$conf;
    }
    elsif ( exists $conf->{default} ) {
      $name = "default";
    }
    else {
      die "Can't determine a default queue name";
    }
  }

  # return cached object if already created
  return $queues{$name} if defined $queues{$name};

  # otherwise, instantiate the object from config settings
  my $queue_conf = $conf->{$name}
    or die "No configuration for queue '$name'";

  my $class = $queue_conf->{class}
    or die "No class specified for queue '$name'";

  try_load_class($class)
    or die "Queue class '$class' could not be loaded";

  $class->can('DOES') && $class->DOES("Dancer::Plugin::Queue::Role::Queue")
    or die "Queue class '$class' does not implment the expected role";

  my $object = eval { $class->new( $queue_conf->{options} || {} ) }
    or die "Could not create $class object: $@";

  return $queues{$name} = $object;
};

register_plugin for_versions => [ 1, 2 ];
1;

=for Pod::Coverage method_names_here

=head1 SYNOPSIS

  use Dancer::Plugin::Queue;

=head1 DESCRIPTION

This module might be cool, but you'd never know it from the lack
of documentation.

=head1 USAGE

Good luck!

=head1 SEE ALSO

Maybe other modules do related things.

=cut

