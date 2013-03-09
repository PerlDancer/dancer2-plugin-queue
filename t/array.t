use 5.010;
use Test::Roo;

with 'Dancer2::Plugin::Queue::Role::Test';

run_me({ backend => 'Array', options => { name => "foo" } });

done_testing;
# COPYRIGHT
