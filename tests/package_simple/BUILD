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