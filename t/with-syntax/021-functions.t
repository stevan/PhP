#!perl

use v5.20;
use warnings;

use Test::More;
use Test::PhP;

use PhP;
use PhP::Syntax;

Test::PhP::run_tests(
    {
        message => '... test simple user-defined function calling another',
        result  => [ const => \12 ],
        source  => 
        let('add',   fun( 'x', 'y', apply('+',   var('x'), var('y'))),
        let('add_2', fun( 'x',      apply('add', var('x'), const(2))),
            apply('add_2', const(10))
        )),
    },
    {
        message => '... test simple user-defined function calling another',
        result  => [ const => \12 ],
        source  => do {
            let 'add'   => (fun 'x', 'y' => (apply '+'   => var 'x', var 'y')),
            let 'add_2' => (fun 'x'      => (apply 'add' => var 'x', const 2)),
                (apply 'add_2' => const 10 )
            ;
        }
    },
);

done_testing;



