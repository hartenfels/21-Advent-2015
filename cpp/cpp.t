use v6;
use Test;
use IntVec;


nok run('perl6', 'cpptest.p6'), 'regular cpptest fails';

ok run('perl6', 'cpptest-mangled.p6'), 'mangled cpptest runs';

ok run('perl6', 'cpptest-extern-c.p6'), 'extern "C" cpptest runs';


my IntVec $vec .= new;
ok $vec.defined, 'intvec created upon construction';

$vec.push(1);
$vec.push(2);
$vec.push(3);

cmp-ok $vec[0], '==', 1, 'first element is 1';
cmp-ok $vec[1], '==', 2, 'second element is 2';
cmp-ok $vec[2], '==', 3, 'third element is 3';


done-testing
