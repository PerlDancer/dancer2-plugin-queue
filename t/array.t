use 5.010;
use Test::Roo;

with 'Dancer2::Plugin::Queue::Role::Test';

main->new( backend => 'Array', options => { name => "foo" } )->run_me;

done_testing;
# COPYRIGHT
