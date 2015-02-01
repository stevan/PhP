#!perl

use v5.20;
use warnings;

use Test::More;
use Test::PhP;

use PhP;
use PhP::Syntax;

Test::PhP::run_tests(
    {
        message => '... test head',
        result  => [ const => \1 ],
        source  => (
            let 'x' => cons((const 1), (const 2)),
               apply('head' => (var 'x'))
        ),
    },
    {
        message => '... test tail',
        result  => [ const => \2 ],
        source  => (
            let 'x' => cons((const 1), (const 2)),
                apply('tail' => (var 'x'))
        ),
    },
);


done_testing;



