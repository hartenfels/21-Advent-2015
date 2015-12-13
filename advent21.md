# Day 21

TODO: Introduction


## Callbacks

TODO yadda yadda introduction function pointers etc.

Let's take [the Expat XML library](http://expat.sourceforge.net/) as an
example, which we want to use to parse this riveting XML document:

```XML
<calendar>
    <advent day="21">
        <topic title="NativeCall Bits and Pieces"/>
    </advent>
</calendar>
```

The Expat XML parser takes callbacks that are called whenever it finds and
opening or closing XML tag. You tell it which callbacks to use with the
following function:

```c
XML_SetElementHandler(XML_Parser parser,
                      void (*start)(void *userdata, char *name, char **attrs),
                      void (*end)(void* userdata, char *name));
```

It associates the given parser with two function pointers to the start and end
tag handlers. Turning this into a Perl 6 NativeCall subroutine is
straight-forward:

```Perl6
use NativeCall;

sub XML_SetElementHandler(OpaquePointer $parser,
                          &start (OpaquePointer, Str, CArray[Str]),
                          &end   (OpaquePointer, Str))
    is native('libexpat') { ... }
```

As you can see, the function pointers turn into arguments with the `&` sigil,
followed by their signature. The space between the name and the signature is
required, but you'll get an awesome error message if you forget.

Now we'll just define the callbacks to use, they'll just print an indented tree
of opening and closing tag names. We aren't required to put types and names in
the signature, just like in most of Perl 6, so we'll just leave them out where
we can:

```Perl6
my $depth = 0;

sub start-element($, $elem, $)
{
    say "open $elem".indent($depth * 4);
    ++$depth;
}

sub end-element($, $elem)
{
    --$depth;
    say "close $elem".indent($depth * 4);
}
```

Just wire it up with some regular NativeCallery:

```Perl6
sub XML_ParserCreate(Str --> OpaquePointer)     is native('libexpat') { ... }
sub XML_ParserFree(OpaquePointer)               is native('libexpat') { ... }
sub XML_Parse(OpaquePointer, Buf, int32, int32) is native('libexpat') { ... }

my $xml = q:to/XML/;
    <calendar>
        <advent day="21">
            <topic title="NativeCall Bits and Pieces"/>
        </advent>
    </calendar>
    XML

my $parser = XML_ParserCreate('UTF-8');
XML_SetElementHandler($parser, &start-element, &end-element);

my $buf = $xml.encode('UTF-8');
XML_Parse($parser, $buf, $buf.elems, 1);

XML_ParserFree($parser);
```

And magically, Expat will call our Perl 6 subroutines that will print the
expected output:

```
open calendar
    open advent
        open topic
        close topic
    close advent
close calendar
```


## LibraryMake

TODO


## C++

Trying to call into a C++ library isn't as straight-forward as using C, even if
you aren't dealing with objects or anything fancy. Take this simple library
we'll call `cpptest`, which can holler a string to stdout:

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

Well, C++ allows you to create multiple functions with the same name, but
different parameters, kinda like `multi` in Perl 6. You can't actually have
identical names in a native library though, so the compiler instead mangles the
function names into something that includes the argument and return types.
Since I compiled the library with `g++ -g`, I can get the symbols back out of
it:

```bash
$ nm cpptest.so | grep holler
0000000000000890 T _Z6hollerPKc
```

So somehow `_Z6hollerPKc` stands for “a function called holler that takes a
`const char*` and returns `void`. Alright, so if we now tell NativeCall to use
that weird gobbledegook as the function name instead:

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


## Conclusion

TODO
