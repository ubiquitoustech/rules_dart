This is a small demo of how things curretly work



the two commands that currently build are: 

This is a single file with no dependencies 
bazel build //tests:hello
bazel run //tests:hello

and 

This has dependencies on another library also defined in the repo
still need to run from tests/package_simple:
dart pub get
before you run bazel to generate the files


bazel build //tests/package_simple:example_exe
bazel build //tests/package_simple:example_js
bazel build //tests/package_simple:example_aot
bazel build //tests/package_simple:example_kernel



bazel run //tests/package_simple:example