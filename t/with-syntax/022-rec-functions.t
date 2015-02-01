#!perl

use v5.20;
use warnings;

use Test::More;
use Test::PhP;

use PhP;
use PhP::Syntax;

=pod

sub mul {
    my ($x, $y) = @_;
    return $x if $y == 1;   
    return $x + mul( $x, $y - 1 );
}    

sub factorial {
    my ($n) = @_;
    return 1 if $n == 0;
    return $n * factorial( $n - 1 );
}

sub is_even {
    my ($n) = @_;
    return 'TRUE' if $n == 0;
    return is_odd( $n - 1 );
}

sub is_odd {
    my ($n) = @_;
    return 'FALSE' if $n == 0;
    return is_even( $n - 1 );
}

=cut


Test::PhP::run_tests(
    {
        message => '... test recursive multiply',
        result  => [ const => \25 ],
        source  => 
        let_rec(
            'mul' => 
                fun( 'x', 'y',
                    cond( 
                        apply('==', var('y'), const(1)),
                        var('x'),
                        apply('+',
                            var('x'),
                            apply('mul', var('x'), apply('-', var('y'), const(1)))
                        )
                    )
                )
            ,

            apply('mul', const(5), const(5)), 
        ),
    },
    {
        message => '... test recursive factorial',
        result  => [ const => \120 ],
        source  => 
        let_rec(
            'factorial' =>
                fun( 'n', 
                    cond( 
                        apply('==', var('n'), const(0)),
                        const(1),
                        apply('*',
                            var('n'),
                            apply('factorial',
                                apply('-', var('n'), const(1))
                            )
                        )
                    )
                )
            ,

            apply('factorial', const(5))
        ),
    },
    {
        message => '... test recursive even/odd predicate',
        result  => [ var => '#true' ],
        source  => 
        let_rec(
            'is_even' =>
                fun('n' => 
                    (cond
                        apply('==' => (var 'n'), (const 0)),
                        (var '#true'),
                        (apply 'is_odd' =>
                            apply( '-' => (var 'n'), (const 1))
                        )
                    )
                ),
            'is_odd' =>
                fun('n' =>
                    (cond
                        apply('==' => (var 'n'), (const 0)),
                        (var '#false'),
                        (apply 'is_even' =>
                            (apply '-' => (var 'n'), (const 1))
                        )
                    )
                )
            ,

            apply('is_even' => (const 2))
        ),
    },
);

done_testing;



