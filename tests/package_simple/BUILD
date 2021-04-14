load("@rules_dart//:def.bzl", "dart_binary")

dart_binary(
    name = "example",
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