#!perl -T ## no critic (TidyCode)

use strict;
use warnings;

# import configuration with hash reference
use Bool {
    bool  => 'boolean',
    true  => [ qw( $MY_TRUE  MY_TRUE  ) ],
    false => [ qw( $MY_FALSE MY_FALSE ) ],
};

our $VERSION = 0;

# The dual values $MY_TRUE, MY_TRUE, $MY_FALSE or MY_FALSE you can be used as boolean, string and numeric
my $true_as_2numerics  = $MY_TRUE  + MY_TRUE;
my $false_as_2numerics = $MY_FALSE + MY_FALSE;
my $true_as_2strings   = $MY_TRUE  . MY_TRUE;
my $false_as_2strings  = $MY_FALSE . MY_FALSE;

() = print <<"EOT";
as numeric
 true:$true_as_2numerics
 false:$false_as_2numerics
as string
 true:$true_as_2strings
 false:$false_as_2strings
EOT

# Subroutine boolean returns a dual value
# that you can use as boolean, string and numeric.
# Subroutine boolean expects 0 or 1 scalar argument.
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
    boolean,            # 01: false
    boolean undef,      # 02: false
    boolean 0,          # 03: false
    boolean q{},        # 04: false
    boolean q{A}, q{B}, # 05 + 06: boolean gets A. B passed to print map.
    boolean qw( A B ),  # 07: boolean gets the last element in list the B. Warns because of A.
    '----',
    boolean @empty,      # 08: false
    boolean @one_false,  # 09: true
    boolean @two_falses, # 10: true
    '----',
    boolean _empty,           # 11: false
    boolean _one_false,       # 12: true
    boolean _two_falses,      # 13: true
    boolean _two_falses_list, # 14: false
    '----',
    boolean %empty_hash,  # 15: false
    boolean %filled_hash, # 16: true
    '----',
    boolean _empty_hash,  # 17: false
    boolean _filled_hash; # 18: true

# $Id$

__END__

output:
as numeric
 true:2
 false:0
as string
 true:11
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
