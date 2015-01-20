#!perl

use v5.20;
use warnings;

use Test::More;
use Test::PhP;

use PhP;

Test::PhP::run_tests(
    {
        message => '... test list',
        result  => [ cons => 
                       [ const => \0 ], 
                       [ cons => 
                           [ const => \1 ], 
                           [ cons => 
                               [ const => \2 ], 
                               [ cons => 
                                   [ const => \3 ], 
                                   [ cons => 
                                       [ const => \4 ], 
                                       [ cons => 
                                           [ const => \5 ], 
                                           []
                                       ]
                                   ]
                               ]
                           ]
                       ]
                   ],
        source  => 
        [ let => 'x', [ apply => 'list', (map { my $x = $_; [ const => \$x ] } 0 .. 5) ],
            [ var => 'x' ]
        ],
    },
    {
        message => '... test head on list',
        result  => [ const => \0 ],
        source  => 
        [ let => 'x', [ apply => 'list', (map { my $x = $_; [ const => \$x ] } 0 .. 5) ],
            [ apply => 'head' => [ var => 'x' ] ]
        ],
    },
        {
        message => '... test tail on list',
        result  => [ cons => 
                       [ const => \1 ], 
                       [ cons => 
                           [ const => \2 ], 
                           [ cons => 
                               [ const => \3 ], 
                               [ cons => 
                                   [ const => \4 ], 
                                   [ cons => 
                                       [ const => \5 ], 
                                       []
                                   ]
                               ]
                           ]
                       ]
                   ],
        source  => 
        [ let => 'x', [ apply => 'list', (map { my $x = $_; [ const => \$x ] } 0 .. 5) ],
            [ apply => 'tail' => [ var => 'x' ] ]
        ],
    },
);


done_testing;



