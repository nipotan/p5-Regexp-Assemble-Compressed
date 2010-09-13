use strict;
use Test::More tests => 4;

use_ok 'Regexp::Assemble::Compressed';

my $ra = Regexp::Assemble::Compressed->new;
for my $i (0 .. 9) {
    $ra->add($i)
}
ok($ra->as_string, '[0-9]');

$ra->reset;
for my $i ('a' .. 'z') {
    $ra->add($i);
}
ok($ra->as_string, '[a-z]');

$ra->reset;
for my $i ('a' .. 'z', '0' .. '9', 'A' .. 'Z') {
    $ra->add($i);
}
ok($ra->as_string, '[0-9A-Za-z]');
