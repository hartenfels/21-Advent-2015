#!/usr/bin/env perl6
use NativeCall;

sub holler(Str) is native('cpptest-extern-c') { ... }
holler('Hello World');
