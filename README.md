DOUBLE-U

Language Specification, version 1

=================================

Double-U is a command-based language. Code is interpreted rather than compiled,
meaning that an error will not cause the code preceding it to fail.

Unlike most programming language, most Double-u functions are non-deterministic.
For example, `select` will return a random element from the given array.

The main data structure of Double-U is the array, which can be specified as for
example, `[ 1 2 4 ]`. The various built-in functions are able to manipulate 
arrays to produce interesting results.

Built-in functions:
`let [name] = [value]` - assigns value to name, where value can be an array or int
`print [name]` - outputs the value of name to standard out
`merge [name1] [name1]` - combines the values of name1 and name2 into a new array
`[fn]! [arr]` - calls the list function fn with arr as the parameter (see below)

See test.doubleu for concrete examples of these functions and their uses.

Special note on Numerical figures:
It is important to note that Double-U only supports integers in the range [0,inf).
As a consequence, list operations that return a number will round to the nearest integer.

Explanations of some special list functions:
`remove! [arr]` - removes an element, chosen at random, from the array
`select! [arr]` - chooses a random element of the array
`average! [arr]` - randomly returns either the mean, median, or mode of the array
`gemiddelde! [arr]` - returns the mean of a random number of applications of "average!"