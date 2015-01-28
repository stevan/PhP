package Test::PhP;

use v5.20;
use warnings;

use Test::More ();

use experimental 'signatures', 'postderef';

sub run_tests (@tests) {
    foreach my $test ( @tests ) {
        Test::More::is_deeply(
            PhP::run( $test->{source} ),
            PhP::run( $test->{result} ),
            $test->{message} // '... testing PhP',
        );
    }
}

1;

__END__