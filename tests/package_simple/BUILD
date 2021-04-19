load("@rules_dart//:def.bzl", "dart_binary")

dart_binary(
    name = "example_exe",
    srcs = [
        "example/package_simple_example.dart",
    ],
    package_config = [".dart_tool/package_config.json",],
    lib = [
        "lib/package_simple.dart", 
        "lib/src/package_simple_base.dart",
    ],
    cmd = "exe",
)

dart_binary(
    name = "example_aot",
    srcs = [
        "example/package_simple_example.dart",
    ],
    package_config = [".dart_tool/package_config.json",],
    lib = [
        "lib/package_simple.dart", 
        "lib/src/package_simple_base.dart",
    ],
    cmd = "aot-snapshot",
)

dart_binary(
    name = "example_js",
    srcs = [
        "example/package_simple_example.dart",
    ],
    # package_config = [".dart_tool/package_config.json",],
    lib = [
        "lib/package_simple.dart", 
        "lib/src/package_simple_base.dart",
    ],
    cmd = "js",
)

dart_binary(
    name = "example_kernel",
    srcs = [
        "example/package_simple_example.dart",
    ],
    # package_config = [".dart_tool/package_config.json",],
    lib = [
        "lib/package_simple.dart", 
        "lib/src/package_simple_base.dart",
    ],
    cmd = "kernel",
)

dart_binary(
    name = "example_jit",
    srcs = [
        "example/package_simple_example.dart",
    ],
    # package_config = [".dart_tool/package_config.json",],
    lib = [
        "lib/package_simple.dart", 
        "lib/src/package_simple_base.dart",
    ],
    cmd = "jit-snapshot",
)
















# testing attempt using a package
# what if we just tested this by still compiling everything normally but then also running the tests 
# from the builder .dart file
# the lib could also just point to the dart snapshot or dart pub get --precompile could be run
# in the same file system as the build and test as well 
# this could be a good starting point to see how well things will work

# okay start with a normal dart_bianry
# then in the lib folder add the pubspec.yaml 

# steps:
# this will take the pubspec file as input and create a .dart_tool/package_config.json that will point to all the packages
# You will also need to pass in the packages eventually as well
# this should happen in the correct workspace for the package or project you are working on with the builder process run workspace
# 1. dart put get --precompile
# Then this will take in the .dart_tool/package_config.json and the packages and build and run the tests
# this should happen in the correct workspace for the package or project you are working on with the builder process run workspace ??
# 2. dart test test/package_simple_test.dart
# this will take in nothing if it uses no packages or lib but will eventually need to
# 3. dart compile exe ...

dart_binary(
    name = "example_exe_test",
    srcs = [
        "example/package_simple_example.dart",
    ],
    package_config = [".dart_tool/package_config.json",],
    lib = [
        "lib/package_simple.dart", 
        "lib/src/package_simple_base.dart",
        "test/package_simple_test.dart",
        # ".dart_tool/pub/bin/test/test.dart-2.12.3.snapshot",
        "pubspec.yaml",
    ],
    # + glob(
    #     ["hosted/**",
    #     ".dart/**",
    #     ".dart_tool/**"],
    # ),
    cmd = "exe",
    # need to add optional pubspec.yaml file
)