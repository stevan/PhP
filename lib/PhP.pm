package PhP;

use v5.20;
use warnings;

use experimental 'signatures', 'postderef';

use constant DEBUG => 0;

use Data::Dumper;

my $TRUE  = \'TRUE';
my $FALSE = \'FALSE';

my $ROOT_ENV = {
    '#true'  => $TRUE,
    '#false' => $FALSE,

    'OP:<+>' => sub ( $l, $r ) { \($l->$* + $r->$*) },
    'OP:<->' => sub ( $l, $r ) { \($l->$* - $r->$*) },
    'OP:<*>' => sub ( $l, $r ) { \($l->$* * $r->$*) },
    'OP:</>' => sub ( $l, $r ) { \($l->$* / $r->$*) },

    'OP:<==>' => sub ( $l, $r ) { ($l->$* == $r->$*) ? $TRUE : $FALSE },
    'OP:<!=>' => sub ( $l, $r ) { ($l->$* != $r->$*) ? $TRUE : $FALSE },
    'OP:<<>'  => sub ( $l, $r ) { ($l->$* <  $r->$*) ? $TRUE : $FALSE },
    'OP:<<=>' => sub ( $l, $r ) { ($l->$* <= $r->$*) ? $TRUE : $FALSE },
    'OP:<>>'  => sub ( $l, $r ) { ($l->$* >  $r->$*) ? $TRUE : $FALSE },
    'OP:<>=>' => sub ( $l, $r ) { ($l->$* >= $r->$*) ? $TRUE : $FALSE },
};

my $KEYWORDS = {
    'let'     => \&_let, 
    'let_rec' => \&_let_rec,  
    'var'     => \&_var,  
    'const'   => \&_const,
    'apply'   => \&_apply,
    'fun'     => \&_fun,  
    'cond'    => \&_cond, 
};

sub run ( $exp ) { _eval( $exp, $ROOT_ENV ) }

sub _DUMP { warn Dumper \@_ }

sub _eval ( $exp, $env ) {

    _DUMP( 'EVAL!!!!', $exp, $env ) if DEBUG;

    my ($keyword) = $exp->@*;

    die "Keyword $keyword not found"
        unless exists $KEYWORDS->{ $keyword };
    
    return $KEYWORDS->{ $keyword }->( $exp, $env );
}

sub _cond ( $exp, $env ) {
    my (undef, $cond, $if_true, $if_false) = $exp->@*;

    _DUMP( ':cond' =>  $cond, $if_true, $if_false ) if DEBUG;

    _eval( $cond, $env ) == $ROOT_ENV->{'#true'} 
        ? _eval( $if_true, $env ) 
        : _eval( $if_false, $env ) 
}

sub _fun ( $exp, $env ) {
    my (undef, $params, $body) = $exp->@*;

    _DUMP( ':fun' => $params, $body ) if DEBUG;

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

    _DUMP( ':let' => $var, $value, $body ) if DEBUG;

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

    my @defs = @$defs;

    while ( @defs ) {
        my ($var, $value) = (shift(@defs), shift(@defs));
        # evaluate the args ...
        my $_exp = _eval( $value, $env );
        # stuff it in the local 
        $env->{ $var } = $_exp;
    }

    return _eval( 
        $body, 
        { %$env } 
    )
}

sub _var ( $exp, $env ) {
    my (undef, $var) = $exp->@*;

    _DUMP( ':var' => $var ) if DEBUG;

    die "Could not find variable $var : " . Dumper [ $exp, $env ] 
        if not exists $env->{ $var };

    return $env->{ $var };
}

sub _const ( $exp, $env ) {
    my (undef, $value) = $exp->@*;

    _DUMP( ':const' => $value ) if DEBUG;

    die "You must have a const value and it must be a SCALAR ref : " . Dumper [ $exp, $env ]
        unless ref $value eq 'SCALAR';

    return $value;
}

sub _apply ( $exp, $env ) {
    my (undef, $f, @args) = $exp->@*;

    _DUMP( ':apply' => $f, \@args ) if DEBUG;

    return 0 if !$f;
    return 0 if !@args; 

    die "Could not find function ($f) : " . Dumper [ $exp, $env ]
        if (not exists $env->{ $f }) && (not exists $env->{ 'OP:<' . $f . '>' });

    my $code = $env->{ $f } || $env->{ 'OP:<' . $f . '>' };

    die "Could not understand the function $code : " . Dumper [ $code, $exp, $env ]
        if ref $code ne 'CODE';

    my %new_env     = $env->%*;
    my @evaled_args = map { _eval( $_, \%new_env ) } @args;

    return $code->( @evaled_args );
}

1;

__END__