#!/usr/bin/env perl6
use lib $?FILE.IO.dirname;
use Expat;

my $depth = 0;
my $text  = '';

my Expat $parser .= new(
    :on-open(-> $tag, %attrs
    {
        print "<$tag".indent($depth * 4);
        for %attrs.kv -> $k, $v { print qq/ $k="$v"/ }
        say '>';
        ++$depth;
    }),

    # this might be called multiple times for each chunk of text, so
    # we just collect all text and print it in the on-close handler
    :on-text({ $text ~= $_ }),

    :on-close(-> $tag {
        $text = $text.trim;
        if ($text)
        {
            say $text.indent($depth * 4);
            $text = '';
        }
        --$depth;
        say "</$tag>".indent($depth * 4);
    }),
);

$parser.parse(slurp "{$?FILE.IO.dirname}/ugly.xml");
