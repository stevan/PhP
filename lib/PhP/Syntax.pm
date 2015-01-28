package PhP::Syntax;

use v5.20;
use warnings;

use experimental 'signatures', 'postderef';

my @EXPORTS = qw[
    let
    let_rec
    const
    var
    apply
    fun
    cond
];

sub import {
    no strict 'refs';
    my $pkg = caller;
    foreach my $export ( @EXPORTS ) {
        *{ $pkg . '::' . $export } = \&{ __PACKAGE__ . '::' . $export };
    }
}

sub let  :prototype($$$) ($var, $value, $body) {
    [ let => $var, $value, $body ]
}

sub let_rec ( @args ) {
    my $body = pop @args;
    [ let_rec => [ @args ], $body ]
}

sub const :prototype($) ($value) {
    [ const => \$value ]
}

sub var :prototype($) ($var) {
    [ var => $var ]
}

sub apply :prototype($@) ($fun, @args) {
    [ apply => $fun, @args ]
}

sub fun ( @args ) {
    my $body = pop @args;
    [ fun => [ @args ], $body ]
}

sub cond :prototype($$$) ($cond, $if_true, $if_false) {
    [ cond => $cond, $if_true, $if_false ]
}

1;

__END__