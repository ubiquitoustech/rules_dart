 These rules are an initial attempt to get dart rules working again:

Currently the rules have dart_binary which just compiles small dart programs but doesn't handle packages yet.

The next things we would like to add are:
* handling packages, libraries and dependencies
* add testing
* creating protobuf rules to work with this
* platform rules and remote execution
* Use stardoc to make the docs for the rules as needed: https://github.com/bazelbuild/stardoc

It is being made open now so that feedback and sugestions from anyone who would want to use these rules can be taken in.

See the test folder readme for how to use these rules.

need to install MSYS2 x86_64 in C:\tools\msys64 before running on windows

you still need dart installed to create .dart_tool/package_config.json in tests/package_simple example