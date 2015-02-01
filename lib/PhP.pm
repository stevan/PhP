package PhP;

use v5.20;
use warnings;

use experimental 'signatures', 'postderef';

my $TRUE  = \'TRUE';
my $FALSE = \'FALSE';
my $NIL   = [];

my $ROOT_ENV = {
    '#true'  => $TRUE,
    '#false' => $FALSE,
    '#nil'   => $NIL,

    'OP:<+>' => sub ( $l, $r ) { [ const => \($l->[1]->$* + $r->[1]->$*) ] },
    'OP:<->' => sub ( $l, $r ) { [ const => \($l->[1]->$* - $r->[1]->$*) ] },
    'OP:<*>' => sub ( $l, $r ) { [ const => \($l->[1]->$* * $r->[1]->$*) ] },
    'OP:</>' => sub ( $l, $r ) { [ const => \($l->[1]->$* / $r->[1]->$*) ] },

    'OP:<==>' => sub ( $l, $r ) { ($l->[1]->$* == $r->[1]->$*) ? $TRUE : $FALSE },
    'OP:<!=>' => sub ( $l, $r ) { ($l->[1]->$* != $r->[1]->$*) ? $TRUE : $FALSE },
    'OP:<<>'  => sub ( $l, $r ) { ($l->[1]->$* <  $r->[1]->$*) ? $TRUE : $FALSE },
    'OP:<<=>' => sub ( $l, $r ) { ($l->[1]->$* <= $r->[1]->$*) ? $TRUE : $FALSE },
    'OP:<>>'  => sub ( $l, $r ) { ($l->[1]->$* >  $r->[1]->$*) ? $TRUE : $FALSE },
    'OP:<>=>' => sub ( $l, $r ) { ($l->[1]->$* >= $r->[1]->$*) ? $TRUE : $FALSE },

    'OP:<head>' => sub ( $cell ) { $cell->[1] },
    'OP:<tail>' => sub ( $cell ) { $cell->[2] },
    
    'OP:<list>' => sub ( @values ) {
        my $cell = [ cons => pop( @values ), $NIL ];
        $cell = [ cons => pop( @values ), $cell ]
            while @values;
        return $cell;
    },
};

my $KEYWORDS = {
    'let'     => \&_let, 
    'let_rec' => \&_let_rec,  
    'var'     => \&_var,  
    'const'   => \&_const,
    'apply'   => \&_apply,
    'fun'     => \&_fun,  
    'cond'    => \&_cond, 
    'cons'    => \&_cons, 
};

sub run ( $exp ) { _eval( $exp, $ROOT_ENV ) }

sub _eval ( $exp, $env ) {
    my ($keyword) = $exp->@*;

    die "Keyword $keyword not found" unless exists $KEYWORDS->{ $keyword };
    
    return $KEYWORDS->{ $keyword }->( $exp, $env );
}

sub _cons ( $exp, $env ) {
    my (undef, $head, $tail) = $exp->@*;

    return [ cons => $head, $tail ];
}

sub _cond ( $exp, $env ) {
    my (undef, $cond, $if_true, $if_false) = $exp->@*;

    _eval( $cond, $env ) == $ROOT_ENV->{'#true'} 
        ? _eval( $if_true, $env ) 
        : _eval( $if_false, $env ) 
}

sub _fun ( $exp, $env ) {
    my (undef, $params, $body) = $exp->@*;

    return sub {
        my @args = @_;

        my %new_env = $env->%*;
        foreach my $i ( 0 .. $#{ $params } ) {
            $new_env{ $params->[ $i ] } = $args[ $i ];       
        }

        return _eval( $body, \%new_env );
    };
}

sub _let ( $exp, $env ) {
    my (undef, $var, $value, $body) = $exp->@*;

    return _eval( 
        $body, 
        {
            %$env,
            $var => _eval( $value, $env ) 
        } 
    )
}

sub _let_rec ( $exp, $env ) {
    my (undef, $defs, $body) = $exp->@*;

    my %env  = %$env; # make a copy first ...
    my @defs = @$defs;
    while ( @defs ) {
        my ($var, $value) = (shift(@defs), shift(@defs));
        my $_exp = _eval( $value, \%env );
        $env{ $var } = $_exp;
    }

    return _eval( $body, \%env );
}

sub _var ( $exp, $env ) {
    my (undef, $var) = $exp->@*;

    die "Could not find variable $var" unless exists $env->{ $var };
    return $env->{ $var };
}

sub _const ( $exp, $env ) {
    my (undef, $value) = $exp->@*;

    return [ const => $value ];
}

sub _apply ( $exp, $env ) {
    my (undef, $f, @args) = $exp->@*;

    die "Could not find function ($f)"
        if (not exists $env->{ $f }) && (not exists $env->{ 'OP:<' . $f . '>' });

    my $code        = $env->{ $f } || $env->{ 'OP:<' . $f . '>' };
    my %new_env     = $env->%*;
    my @evaled_args = map { _eval( $_, \%new_env ) } @args;

    return $code->( @evaled_args );
}

1;

__END__