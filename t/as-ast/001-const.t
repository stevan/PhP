#!perl

use v5.20;
use warnings;

use Test::More;
use Test::PhP;

use PhP;

Test::PhP::run_tests(
    {
        message => '... test const',
        result  => [ const => \10 ],
        source  => [ const => \10 ],
    },
);

done_testing;



