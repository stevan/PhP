#!perl

use v5.20;
use warnings;

use Test::More;
use Test::PhP;

use PhP;

Test::PhP::run_tests(
    {
        message => '... test let',
        result  => [ const => \20 ],
        source  => 
        [ let => 'x', [ const => \10 ], 
        [ let => 'y', [ const => \10 ], 
            [ apply => '+', [ var => 'x' ], [ var => 'y' ]]
        ]],
    },
);

done_testing;



