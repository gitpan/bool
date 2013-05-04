#!perl

use strict;
use warnings;

use Test::More;
use Test::NoWarnings;
use Test::Differences;
use Cwd qw(getcwd chdir);

$ENV{AUTHOR_TESTING} or plan(
    skip_all => 'Set $ENV{AUTHOR_TESTING} to run this test.'
);

plan(tests => 4);

my @data = (
    {
        test   => '01_default',
        path   => 'example',
        script => '01_default.pl',
        params => '-I../lib -T',
        result => <<'EOT',
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
EOT
    },
    {
        test   => '02_bool',
        path   => 'example',
        script => '02_bool.pl',
        params => '-I../lib -T',
        result => <<'EOT',
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
EOT
    },
    {
        test   => '03_hash',
        path   => 'example',
        script => '03_hash.pl',
        params => '-I../lib -T',
        result => <<'EOT',
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
EOT
    },
);

for my $data (@data) {
    my $dir = getcwd();
    chdir("$dir/$data->{path}");
    my $result = qx{perl $data->{params} $data->{script} 2>&3};
    chdir($dir);
    eq_or_diff(
        $result,
        $data->{result},
        $data->{test},
    );
}
