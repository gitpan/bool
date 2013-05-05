package bool; ## no critic (Capitalization TidyCode)

use strict;
use warnings;
use Carp qw(confess);
use Const::Fast;

our $VERSION = '0.002';

const my $TRUE  => ! 0;
const my $FALSE => ! 1;

sub import {
    my (undef, @import) = @_;

    if ( ! @import ) {
        @import = qw( bool $TRUE $FALSE );
    }
    my %map_of = (
        bool          => [ ( 'bool' ) x 2 ],
        '$TRUE'       => [ true  => '$TRUE'  ], ## no critic (InterpolationOfMetachars)
        '$FALSE'      => [ false => '$FALSE' ], ## no critic (InterpolationOfMetachars)
    );
    my %import_of = map {
        ref eq 'HASH'
        ? %{$_}
        : exists $map_of{$_}
        ? @{ $map_of{$_} }
        : confess "$_ is not exported";
    } @import;

    my $caller = caller;
    for my $key ( qw( bool ) ) {
        if ( $import_of{$key} ) {
            no strict qw(refs); ## no critic (NoStrict)
            no warnings qw(redefine prototype); ## no critic (NoWarnings)
            *{ "$caller\::$import_of{$key}" } = \&{$key};
        }
    }
    for my $key ( qw( true false ) ) {
        my @values = grep { defined }
            ref $import_of{$key} eq 'ARRAY'
            ? @{ $import_of{$key} }
            : $import_of{$key};
        for my $value (@values) {
            no strict qw(refs); ## no critic (NoStrict)
            my ( $reftype, $name )
                = $value =~ m{ \A ( [\$\@%&*]? ) ( .* ) \z }xms;
            *{ "${caller}::$name" }
                = $reftype eq q{$}
                ? ( $key eq 'true' ? \$TRUE : \$FALSE )
                : $reftype eq q{} || $reftype eq q{&}
                ? ( $key eq 'true' ? sub { $TRUE } : sub {$FALSE } )
                : confess "Unexpected value $value in $key";
        }
    }

    return;
}

sub bool (;$) { ## no critic (SubroutinePrototypes)
    return !! shift;
}

# $Id$

1;

__END__

=head1 NAME

bool - Boolean constants and modifier

=head1 VERSION

0.002

=head1 SYNOPSIS

    use bool; # default import

    use bool qw(bool $TRUE $FALSE); # default import full written as list

    use bool { # default import written in hash notation
        bool  => 'bool',
        true  => '$TRUE',
        false => '$FALSE',
    };

    use bool {
        bool  => 'boolean',              # bool  imported as boolean
        true  => [ qw( $TRUE  TRUE  ) ], # true  imported as $TRUE  and TRUE
        false => [ qw( $FALSE FALSE ) ], # false imported as $FALSE and FALSE
    };

    # e.g.
    call_anything({
        ok     => $TRUE,
        not_ok => $FALSE,
        is_any => bool my_sub, # my_sub should return nothing or a scalar
        other  => 'other',
    });

=head1 EXAMPLE

Inside of this Distribution is a directory named example.
Run this *.pl files.

=head1 DESCRIPTION

=head2 Why

Perl implements booleans as dual values.
The numeric part is 1 as true and 0 as false.
The string part is q{1} as true and q{} as false.
See L<Scalar::Util|Scalar::Util>#dualvar for customer combined values.

You can use a boolean in numeric context

    $numeric = ( 5 == 5 ) + ( 'aa' eq 'bb' ); # 1 + 0 = 1

or in string context

    $string = ( 5 == 5 ) . ( 'aa' eq 'bb' ); # q{1} . q{} = q{1}

The typical writing to force the numeric context only is

    $numeric = 0 + $boolean;

and to force the string context is

    $string = q{} . $boolean;

And that works perfectly if the booleans are dual values
like Perl internal does.
That works also perfect if we use 1 as true.
It works different if we use 0 as false.

=head2 Constants

This module exports 2 constants, named $TRUE and $FALSE as dual values.
The readability of your code is more clear if you write $TRUE ($FALSE).
That implements by the reader that you mean boolean and not numeric.

=head2 Modifier

This module also implements the keyword bool.
That converts all stuff to a real boolean (dual value).

=head1 SUBROUTINES/METHODS

=head2 subroutine bool

Returns a real boolean als dual value.
The prototype of bool is C<(;$)>.
So you can write bool without subroutine brackets.

    $bool = bool;
    $bool = bool $scalar;
    $bool = bool qw(); # empty element list
    $bool = bool qw( single_element_list );
    $bool = bool @array;
    $bool = bool %hash;

Examples

    $false = bool;
    $false = bool undef;
    $false = bool 0;
    $true  = bool 1;
    $false = bool q{};
    $true  = bool q{ };
    $false = bool @empty;
    $true  = bool @filled;
    $false = bool %empty;
    $true  = bool %filled;
    $true  = bool $any_reference_or_object;

    # If my_sub returns nothing is_any is false.
    # If my_sub returns undef is_any is false.
    # If my_sub returns 1 false value is_any is false.
    # If my_sub returns 1 true value is_any is true.
    # If my_sub returns more than 1 element Perl warns
    # and takes the last one only.
    %hash = (
        is_any => bool my_sub,
        other  => 'other',
    );

C<qw> returns a list and not an array.

    $true = bool qw( A B );

and

    sub qw_return { return qw( A B ) }
    $true = bool qw_return;

will throw a warning because A is ignored.
The result is true because of B, the last element in list.

=head1 DIAGNOSTICS

=head2 During list import

"... is not exported"
means that the value you wrote is not known.

=head2 During all import variants

"Unexpected value ... in ..."
means that you try to import anything else than a scalar or subroutine
as true or false.

=head1 CONFIGURATION AND ENVIRONMENT

nothing

=head1 DEPENDENCIES

L<Carp|Carp>

L<Const::Fast|Const::Fast>

=head1 INCOMPATIBILITIES

not known

=head1 BUGS AND LIMITATIONS

none

=head1 SEE ALSO

L<boolean|boolean>
Handling with string 'true' and 'false'.

L<Scalar::Boolean|Scalar::Boolean>
A real boolean is a dual value and not numeric 0 and 1.

L<constant::boolean|constant::boolean>
Subroutine constants returns real dual value booleans.
Has no lexical constants and no modifier subroutine.

L<Boolean::String|Boolean::String>
Implements numeric combined with an error message.

L<Scalar::Util|Scalar::Util>#dualvar
Shows how to write custom defined dual values.

=head1 AUTHOR

Steffen Winkler

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013,
Steffen Winkler
C<< <steffenw at cpan.org> >>.
All rights reserved.

This module is free software;
you can redistribute it and/or modify it
under the same terms as Perl itself.
