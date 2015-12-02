use v6;
use Test;


nok run('perl6', 'cpptest.p6'), 'regular cpptest fails';

ok run('perl6', 'cpptest-mangled.p6'), 'mangled cpptest runs';

ok run('perl6', 'cpptest-extern-c.p6'), 'extern "C" cpptest runs';


done-testing
