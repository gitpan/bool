#!perl -T

use strict;
use warnings;

use Test::More tests => 5;
use Test::NoWarnings;

BEGIN {
    use_ok 'bool', qw( bool $TRUE $FALSE );
}

is
    0 + bool,
    0,
    'numeric = bool';
is
    0 + $TRUE,
    1,
    'numeric = $TRUE';
is
    0 + $FALSE,
    0,
    'numeric = $FALSE';
