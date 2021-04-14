
load("@rules_dart//:def.bzl", "dart_toolchain")
load("@rules_dart//internal:rules.bzl", "dart_tool_binary")

# tools contains executable files that are part of the toolchain.
filegroup(
    name = "tools",
    srcs = ["bin/dart{exe}"] + glob(["pkg/tool/{dartos}_{dartarch}/**"]),
    visibility = ["//visibility:public"],
)

# std_pkgs contains packages in the standard library.
filegroup(
    name = "std_pkgs",
    srcs = glob(
        ["pkg/{dartos}_{dartarch}/**"],
        exclude = ["pkg/{dartos}_{dartarch}/cmd/**"],
    ),
    visibility = ["//visibility:public"],
)

# builder is an executable used by rules_dart to perform most actions.
# builder mostly acts as a wrapper around the compiler and linker.
dart_tool_binary(
    name = "builder",
    srcs = ["@rules_dart//internal/builder:builder"],
    # these should be added back in for dart?
    std_pkgs = [":std_pkgs"],
    tools = [":tools"],
)

# toolchain_impl gathers information about the Dart toolchain.
# See the DartToolchain provider.
dart_toolchain(
    name = "toolchain_impl",
    builder = ":builder",
    std_pkgs = [":std_pkgs"],
    tools = [":tools"],
)

# toolchain is a Bazel toolchain that expresses execution and target
# constraints for toolchain_impl. This target should be registered by
# calling register_toolchains in a WORKSPACE file.
toolchain(
    name = "toolchain",
    exec_compatible_with = [
        {exec_constraints},
    ],
    target_compatible_with = [
        {target_constraints},
    ],
    toolchain = ":toolchain_impl",
    toolchain_type = "@rules_dart//:toolchain_type",
)