use 5.010;
use Test::Roo;

sub _build_options { return { name => 'foo' } }

with 'Dancer2::Plugin::Queue::Role::Test';

run_me( { backend => 'Array' } );

done_testing;
# COPYRIGHT
