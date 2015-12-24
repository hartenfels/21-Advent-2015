unit class Expat;
use NativeCall;


class XML is repr('CPointer') {}

sub XML_ParserCreate(Str --> XML)   is native('expat') { ... }
sub XML_ParserFree(XML)             is native('expat') { ... }
sub XML_GetErrorCode(XML --> int32) is native('expat') { ... }
sub XML_ErrorString(int32 --> Str)  is native('expat') { ... }

sub XML_Parse(XML, Buf, int32, int32 --> int32)
    is native('expat') { ... }

sub XML_SetElementHandler(XML, & (OpaquePointer, Str, CArray[Str]),
                               & (OpaquePointer, Str))
    is native('expat') { ... }

sub XML_SetCharacterDataHandler(XML, & (OpaquePointer, CArray[int8], int32))
    is native('expat') { ... }


sub start($parser, $, $elem, $attrs)
{
    return unless defined $parser.on-open;

    my %map;
    loop (my $i = 0; defined $attrs[$i]; $i += 2)
    {
        %map{$attrs[$i]} = $attrs[$i + 1];
    }

    try $parser.on-open.($elem, %map);
    warn $! if $!;
}

sub end($parser, $, $elem)
{
    return unless defined $parser.on-close;
    try $parser.on-close.($elem);
    warn $! if $!;
}

sub text($parser, $, $s, $len)
{
    return unless defined $parser.on-text;
    my Buf $buf .= new($s[0 ..^ $len]);
    try $parser.on-text.($buf.decode('UTF-8'));
    warn $! if $!;
}


has $!parser;
has $.on-open  is rw;
has $.on-close is rw;
has $.on-text  is rw;

submethod BUILD(:$!on-open, :$!on-close, :$!on-text, Str :$enc = 'UTF-8')
{
    $!parser = XML_ParserCreate($enc);
    XML_SetElementHandler($!parser, &start.assuming(self),
                                      &end.assuming(self));
    XML_SetCharacterDataHandler($!parser, &text.assuming(self));
}

method parse(Expat:D: Str $xml, Cool :$done = True)
{
    my $buf = $xml.encode('UTF-8');
    XML_Parse($!parser, $buf, $buf.elems, +$done)
        or fail XML_ErrorString(XML_GetErrorCode($!parser));
}

method DESTROY
{
    XML_ParserFree($!parser);
}
