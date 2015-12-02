#!/usr/bin/env perl6
use NativeCall;

sub holler(Str) is native('cpptest') is symbol('_Z6hollerPKc') { ... }
holler('Hello World');
