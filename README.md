# DOUBLE-U

## Language Specification, version 1

Double-U is a command-based language. Code is interpreted rather than compiled,
meaning that an error will not cause the code preceding it to fail.

Unlike most programming language, most Double-u functions are non-deterministic.
For example, `select!` will return a random element from the given array.

The main data structure of Double-U is the array, which can be specified as for
example, `[ 1 2 4 ]`. The various built-in functions are able to manipulate 
arrays to produce interesting results.

Built-in functions:
`let <name> = <value>` - assigns value to name, where value can be an array or int.
`print <name>` - outputs the value of name to standard out.
`merge! <name1> <name1>` - combines the values of name1 and name2 into a new array.
`<fn>! <arr>` - calls the list function fn with arr as the parameter (see below)

See example.doubleu for concrete examples of these functions and their uses.

### Explanations of selected list functions:

`remove! <arr>` - removes an element, chosen at random, from the array

`select! <arr>` - chooses a random element of the array

`mode! <arr>` - chooses one of the most frequently occuring elements of the array

`average! <arr>` - randomly returns either the mean, median, or mode of the array

`std! <arr>` - calculates the standard deviation of the array

`trim! <arr>` - calls `remove! [arr]` a number of times proportional to `std! [arr]`

`normalize! <arr>` - calculates and returns the [standard score](https://en.wikipedia.org/wiki/Standard_score) of each element in the array

### Explanations of selected numerical functions:

`wrap! <n>` - creates an array of *n* elements, each chosen at random from the range [0,1000]

`twist! <n>` - returns a number in the range [*n*, 1000] or if *n* > 1000, the range [0, *n*]

`chain! <n>` - chains together a random selection of *n* commands

### How to use the REPL:

Run the REPL using `ruby doubleu.rb` from the command line. Type the command `help!` to see the full list of available commands. You can use `_` in an expression to substitute the value of the previous command executed. `^C` will clear the current line and stop any commands currently running. `^D` will exit the REPL.

### Options:

Using the `-s` or `--string` option will replace string occurences by an array of ints everywhere in the program. For example, `"doubleu"` would become `[100, 111, 117, 98, 108, 101, 117]`. This option also works in the REPL.

Using the `-p` or `--print` option will output all arrays as strings. `-s` and `-p` can be combined to allow string manipulation in Double-U.
