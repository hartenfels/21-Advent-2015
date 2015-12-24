#!/usr/bin/env perl6
use NativeCall;

sub XML_ParserCreate(Str --> OpaquePointer)               is native('expat') { ... }
sub XML_ParserFree(OpaquePointer)                         is native('expat') { ... }
sub XML_Parse(OpaquePointer, Buf, int32, int32 --> int32) is native('expat') { ... }

sub XML_SetElementHandler(OpaquePointer $parser,
                          &start (OpaquePointer, Str, CArray[Str]),
                          &end   (OpaquePointer, Str))
    is native('expat') { ... }


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
