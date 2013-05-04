#!perl -T

use strict;
use warnings;

use Test::More tests => 11;
use Test::NoWarnings;

BEGIN {
    use_ok Bool => {
        bool  => 'boolean',
        true  => [ qw( TRUE  $TRUE  YES $YES ) ],
        false => [ qw( FALSE $FALSE NO  $NO ) ],
    };
}

# constants
is 0 + TRUE,   1, 'TRUE';
is 0 + FALSE,  0, 'FALSE';
is 0 + $TRUE,  1, "\$TRUE";
is 0 + $FALSE, 0, "\$FALSE";
is 0 + YES,    1, 'YES';
is 0 + NO,     0, 'NO';
is 0 + $YES,   1, "\$YES";
is 0 + $NO,    0, "\$NO";

is
    0 + boolean,
    0,
    'numeric = boolean';
