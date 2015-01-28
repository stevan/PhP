#!perl

use v5.20;
use warnings;

use Test::More;
use Test::PhP;

use PhP;

Test::PhP::run_tests(
    {
        message => '... test user-defined functions',
        result  => [ const => \60 ],
        source  => 
            [ let => 'add', [ fun => [ 'x', 'y' ], [ apply => '+', [ var => 'x' ], [ var => 'y' ] ] ],
            [ let => 'sub', [ fun => [ 'x', 'y' ], [ apply => '-', [ var => 'x' ], [ var => 'y' ] ] ],
            [ let => 'mul', [ fun => [ 'x', 'y' ], [ apply => '*', [ var => 'x' ], [ var => 'y' ] ] ],

            [ apply => 'add', 
                [ const => \10 ], 
                [ apply => 'mul', 
                    [ const => \10 ], 
                    [ apply => 'sub', 
                        [ const => \10 ], 
                        [ const => \5 ] 
                    ]
                ]
            ]

        ]]],
    },
);

done_testing;



