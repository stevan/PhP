# PhP

### Pronounced "Ffffff-Pee"

PhP is a toy progroamming language written for the simple reason that 
I had no idea what to talk about at a recent AmsterdamX Perl Mongers 
meeting. I had originally wanted to call the language "FP", but that 
name is already taken (thanks a LOT John Backus!!), so it was suggested
that I use PhP instead, and I liked it, it has a nice ring to it ;)

## Programming in PhP

PhP can be programmed in pure AST (LISP style) form, where 
our S-expressions are simply ARRAY refs in which the first element 
is a "tag" to mark the type of AST node it is. See the `t/as-ast`
directory for examples.

PhP can also be programmed in the syntax (Caml(ish) style) form, 
where you simply call Perl functions named after the AST nodes and 
they  will emit AST nodes. Because we heavily abuse Perl's function 
prototypes this allows for a number of interesting variations in 
syntax. See the `t/with-syntax` directory for examples.

## TODO

* Add `mysql` functions to the language
* Add HTML templating 
* Add even more `mysql` functions to the language

