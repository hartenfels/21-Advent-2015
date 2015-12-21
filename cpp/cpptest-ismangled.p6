#!/usr/bin/env perl6
use NativeCall;

sub holler(Str) is native('cpptest') is mangled { ... }
holler('Hello World');
