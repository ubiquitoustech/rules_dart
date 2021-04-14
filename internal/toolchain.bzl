"""Toolchains for Dart rules.
dart_toolchain creates a provider as described in DartToolchainInfo in
providers.bzl. toolchains and dart_toolchains are declared in the build file
generated in dart_download in repo.bzl.
"""

load(
    "@bazel_skylib//lib:paths.bzl",
    "paths",
)
load(
    "@rules_dart//internal:actions.bzl",
    # "dart_build_test",
    "dart_compile",
)

def _dart_toolchain_impl(ctx):
    # Find important files and paths.
    dart_cmd = None
    for f in ctx.files.tools:
        if f.path.endswith("/bin/dart") or f.path.endswith("/bin/dart.exe"):
            dart_cmd = f
            break
    if not dart_cmd:
        fail("could not locate Dart command")

    # this should be used to set the dart environment variables later
    env = {"DARTROOT": paths.dirname(paths.dirname(dart_cmd.path))}

    # Return a TooclhainInfo provider. This is the object that rules get
    # when they ask for the toolchain.
    return [platform_common.ToolchainInfo(
        # Functions that generate actions. Rules may call these.
        # This is the public interface of the toolchain.
        compile = dart_compile,
        # build_test = dart_build_test,

        # Internal data. Contents may change without notice.
        # Think of these like private fields in a class. Actions may use these
        # (they are methods of the class) but rules may not (they are clients).
        internal = struct(
            dart_cmd = dart_cmd,
            env = env,
            builder = ctx.executable.builder,
            tools = ctx.files.tools,
            std_pkgs = ctx.files.std_pkgs,
        ),
    )]

dart_toolchain = rule(
    implementation = _dart_toolchain_impl,
    attrs = {
        "builder": attr.label(
            mandatory = True,
            executable = True,
            cfg = "host",
            doc = "Executable that performs most actions",
        ),
        "tools": attr.label_list(
            mandatory = True,
            doc = "Compiler, and other executables from the Dart distribution",
        ),
        "std_pkgs": attr.label_list(
            mandatory = True,
            doc = "Standard library packages from the Dart distribution",
        ),
    },
    doc = "Gathers functions and file lists needed for a Dart toolchain",
)