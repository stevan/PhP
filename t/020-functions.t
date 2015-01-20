#!perl

use v5.20;
use warnings;

use Test::More;
use Test::PhP;

use PhP;

Test::PhP::run_tests(
    {
        message => '... test simple user-defined function',
        result  => [ const => \2 ],
        source  => 
        [ let => 'add', [ fun => [ 'x', 'y' ], [ apply => '+', [ var => 'x' ], [ var => 'y' ] ] ],
            [ apply => 'add', 
                [ const => \1 ], 
                [ const => \1 ], 
            ]
        ],
    },
);

done_testing;



