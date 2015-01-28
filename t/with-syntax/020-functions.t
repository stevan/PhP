#!perl

use v5.20;
use warnings;

use Test::More;
use Test::PhP;

use PhP;
use PhP::Syntax;

Test::PhP::run_tests(
    {
        message => '... test simple user-defined function (normal function call)',
        result  => [ const => \2 ],
        source  => 
            let('add' => fun( 'x', 'y', apply('+', var('x'), var('y') ) ),
                apply('add', const(1), const(1))
            ),
    },
    {
        message => '... test simple user-defined function (parens around)',
        result  => [ const => \2 ],
        source  => do {
            (let 'add' => (fun 'x', 'y', (apply '+', (var 'x'), (var 'y'))),
                (apply 'add', (const 1), (const 1))
            )
        }
    },
    {
        message => '... test simple user-defined function (function calls abusing prototypes)',
        result  => [ const => \2 ],
        source  => do {
            let 'add' => (fun 'x', 'y' => (apply '+' => var 'x', var 'y' )) => do {
                (apply 'add' => const 1, const 1)
            };
        }
    },
);

done_testing;



