#!perl -T ## no critic (TidyCode)

use strict;
use warnings;

use Bool qw(bool $TRUE $FALSE); # list import

our $VERSION = 0;

# The dual values $TRUE or $FALSE you can be used as boolean, string and numeric
my $true_as_numeric  = 0 + $TRUE;
my $false_as_numeric = 0 + $FALSE;
my $true_as_string   = q{} . $TRUE;
my $false_as_string  = q{} . $FALSE;

() = print <<"EOT";
as numeric
 true:$true_as_numeric
 false:$false_as_numeric
as string
 true:$true_as_string
 false:$false_as_string
EOT

# Subroutine bool returns a dual value
# that you can use as boolean, string and numeric.
# Subroutine bool expects 0 or 1 scalar argument.
my @empty;
my @one_false  = qw( 0 );
my @two_falses = qw( 0 0 );
my %empty_hash;
my %filled_hash = qw( 0 0 );
sub _empty           { return @empty       }
sub _one_false       { return @one_false   }
sub _two_falses      { return @two_falses  }
sub _two_falses_list { return qw( 0 0 )    }
sub _empty_hash      { return %empty_hash  }
sub _filled_hash     { return %filled_hash }
my $count = '00';
() = print map { $_ eq '----' ? "$_\n" : ++$count . ":$_\n" }
    bool,            # 01: false
    bool undef,      # 02: false
    bool 0,          # 03: false
    bool q{},        # 04: false
    bool q{A}, q{B}, # 05 + 06: bool gets A. B passed to print map.
    bool qw( A B ),  # 07: bool gets the last element in list the B. Warns because of A.
    '----',
    bool @empty,      # 08: false
    bool @one_false,  # 09: true
    bool @two_falses, # 10: true
    '----',
    bool _empty,           # 11: false
    bool _one_false,       # 12: true
    bool _two_falses,      # 13: true
    bool _two_falses_list, # 14: false
    '----',
    bool %empty_hash,  # 15: false
    bool %filled_hash, # 16: true
    '----',
    bool _empty_hash,  # 17: false
    bool _filled_hash; # 18: true

# $Id$

__END__

output:
as numeric
 true:1
 false:0
as string
 true:1
 false:
01:
02:
03:
04:
05:1
06:B
07:1
----
08:
09:1
10:1
----
11:
12:1
13:1
14:
----
15:
16:1
----
17:
18:1
