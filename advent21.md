# Day 21


## Callbacks


## LibraryMake


## C++

Trying to call into a C++ library isn't as straight-forward as using C, even if
you aren't dealing with objects or anything fancy. Take this simple library
we'll call `cpptest`:

```cpp
#include <iostream>

void holler(const char* str)
{
    std::cout << str << "!\n";
}
```

When you try to unsuspectingly call this function with NativeCall:

```Perl6
sub holler(Str) is native('cpptest') { ... }
holler('Hello World');
```

You get a nasty error message like `Cannot locate symbol 'holler' in native
library 'cpptest.so'`! Why can't Perl see the function right in front of its
face?

Well, in C++, all functions are like `multi sub`s in Perl 6, and the compiler
figures out which one to call by mangling their name into something that has
the argument types encoded into it. Since I compiled the library with `g++ -g`,
I can get the symbols back out of it:

```bash
$ nm cpptest.so | grep holler
0000000000000890 T _Z6hollerPKc
```

Alright, so if we now tell NativeCall to use that weird gobbledegook as the
function name instead:

```Perl6
sub holler(Str) is native('cpptest') is symbol('_Z6hollerPKc') { ... }
```

It works, and we get C++ hollering out `Hello World!`, as expected... if the
libary was compiled with g++. The name mangling isn't standardized in any way,
and different compilers do produce different names. In Visual C++ for example,
the name would be something like `?holler@@ZAX?BPDXZ` instead.

The proper solution is to wrap your function like so:

```cpp
extern "C"
{
    void holler(const char* str)
    {
        std::cout << str << "!\n";
    }
}
```

This will export the function name like C would as a non-`multi` function,
which is standardized for all compilers. Now the original Perl 6 program above
works correctly and hollers without needing strange symbol names.

You still can't directly call into classes or objects like this, which you
probably would want to do when you're thinking about NativeCalling into C++,
but wrapping the methods works just fine:

```cpp
#include <vector>

extern "C"
{
    std::vector<int>* intvec_new() { return new std::vector<int>(); }
    void intvec_free(std::vector<int>* vec) { delete v; }
    // etc. pp.
}
```

See also
[FFI::Platypus::Lang::CPP](https://metacpan.org/pod/FFI::Platypus::Lang::CPP),
which lets you do calls to C++ directly.
