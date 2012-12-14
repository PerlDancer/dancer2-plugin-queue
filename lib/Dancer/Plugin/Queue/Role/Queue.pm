use 5.008001;
use strict;
use warnings;

package Dancer::Plugin::Queue::Role::Queue;
# ABSTRACT: Dancer::Plugin::Queue implementation API
# VERSION

use Moo::Role;

requires 'add_msg';

requires 'get_msg';

requires 'remove_msg';

1;

=for Pod::Coverage method_names_here

=head1 SYNOPSIS

  use Dancer::Plugin::Queue::Role::Queue;

=head1 DESCRIPTION

This module might be cool, but you'd never know it from the lack
of documentation.

=head1 USAGE

Good luck!

=head1 SEE ALSO

Maybe other modules do related things.

=cut

# vim: ts=2 sts=2 sw=2 et:
