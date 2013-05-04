#!perl -T

use strict;
use warnings;

use Test::More tests => 15;
use Test::NoWarnings;
use Test::Differences;

BEGIN {
    use_ok 'Bool';
}

# the constants
is 0   + $TRUE,  1,    'numeric true';
is 0   + $FALSE, 0,    'numeric false';
is q{} . $TRUE,  q{1}, 'string true';
is q{} . $FALSE, q{},  'string false';

# boolean return
ok ! bool,       'empty';
ok ! bool undef, 'undef';
ok ! bool 0,     'false';
ok   bool 1,     'true';
ok   bool [],    'ref';

# dual return value
ok
    ! bool,
    'boolean = bool';
is
    0 + bool,
    0,
    'numeric = bool';
is
    q{} . bool,
    q{},
    'string = bool';

# prototype
eq_or_diff
    [ bool 0, 1 ],
    [ q{}, 1 ],
    'string = bool numeric, numeric';
