#!perl

use v5.20;
use warnings;

use Test::More;
use Test::PhP;

use PhP;

Test::PhP::run_tests(
    {
        message => '... test let',
        result  => [ const => \10 ],
        source  => [ let => 'x', [ const => \10 ], [ var => 'x' ]],
    },
);

done_testing;



