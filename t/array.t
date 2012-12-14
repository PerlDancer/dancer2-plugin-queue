use 5.010;
use strict;
use warnings;
use Test::More 0.96 import => ['!pass'];

{

  use Dancer;
  use Dancer::Plugin::Queue;

  set show_errors => 1;

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
}

use Dancer::Test;

route_exists [ GET => '/add' ], 'GET /add handled';

response_content_like [ GET => '/add?msg=Hello%20World' ], qr/Hello World/i,
  "sent and received message";

done_testing;
# COPYRIGHT
