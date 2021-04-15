Test building it on mac and windows to verify it works and what dart commands you need to run to create the .dart_tool directory and the pubspec.lock files. 

These rules are an initial attempt to get dart rules working again:

Currently the rules have dart_binary which just compiles small dart programs but doesn't handle packages yet.

The next things we would like to add are:
    1. handling packages, libraries and dependencies
    2. add testing
    3. creating protobuf rules to work with this
    4. platform rules and remote execution

It is being made open now so that feedback and sugestions from anyone who would want to use these rules can be taken in.

See the test folder readme for how to use these rules.

Use stardoc to make the docs for the rules as needed:
https://github.com/bazelbuild/stardoc

need to install MSYS2 x86_64 in C:\tools\msys64 before running on windows

you still need dart installed to create .dart_tool/package_config.json in tests/package_simple example