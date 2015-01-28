#!perl

use v5.20;
use warnings;

use Test::More;
use Test::PhP;

use PhP;
use PhP::Syntax;

Test::PhP::run_tests(
    {
        message => '... test cond with true result',
        result  => const('X IS TRUE'),
        source  => let('x', const(10), 
            cond( 
                apply('==', var('x'), const(10)),
                const('X IS TRUE'),
                const('X IS FALSE'),
            )
        ),
    },
    {
        message => '... test cond with false result',
        result  => const('X IS FALSE'),
        source  => let('x', const(10), 
            cond( 
                apply('==', var('x'), const(12)),
                const('X IS TRUE'),
                const('X IS FALSE'),
            )
        ),
    }
);

done_testing;



