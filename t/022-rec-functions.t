#!perl

use v5.20;
use warnings;

use Test::More;
use Test::PhP;

use PhP;

=pod

sub mul {
    my ($x, $y, $acc) = @_;
    return $acc if $y <= 0;   
    return mul( $x, $y - 1, $acc + $x );
}

=cut

Test::PhP::run_tests(
    {
        message => '... test simple user-defined function',
        result  => [ const => \25 ],
        source  => 
        [ let_rec => 'mul', 
            [ fun => [ 'x', 'y', 'acc' ], 
                [ cond => 
                    [ apply => '<=', [ var => 'y' ], [ const => \0 ]],
                    [ var => 'acc' ],
                    [ apply => 'mul',
                        [ var => 'x' ],
                        [ apply => '-', [ var => 'y' ], [ const => \1 ]],
                        [ apply => '+', [ var => 'acc'], [ var => 'x' ]],
                    ]
                ]
            ],

            [ apply => 'mul', 
                [ const => \5 ], 
                [ const => \5 ], 
                [ const => \0 ], 
            ]
        ],
    },
);

done_testing;



