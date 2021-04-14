This is a small demo of how things curretly work



the two commands that currently build are: 

This is a single file with no dependencies 
bazel build //tests:hello
bazel run //tests:hello

and 

This has dependencies on another library also defined in the repo
bazel build //tests/package_simple:example
bazel run //tests/package_simple:example