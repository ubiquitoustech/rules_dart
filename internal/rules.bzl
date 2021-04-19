load(
    "@rules_dart//internal:actions.bzl",
    "dart_compile",
    "dart_build_test",
)
load("@rules_dart//internal:providers.bzl", "DartLibraryInfo")

load("@bazel_skylib//lib:shell.bzl", "shell")

def _dart_binary_impl(ctx):
    # this should probably be broken into multiple rules
    # making the rules more correct for the actions 
    # if the require a config file 
    # if they are executable or not

    dart_toolchain = ctx.toolchains["@rules_dart//:toolchain_type"]

    # Declare an output file for the main package and compile it from srcs. All
    # our output files will start with a prefix to avoid conflicting with
    # other rules.
    prefix = ctx.label.name

    # these were also changed
    executable_path = "{name}_/{name}".format(name = ctx.label.name)

    # will need to change the ending depending on the command that was run
    ending = ""
    if ctx.attr.cmd == "exe":
        ending = ".exe"
    if ctx.attr.cmd == "aot-snapshot":
        ending = ".aot"
    if ctx.attr.cmd == "js":
        ending = ".js"
    if ctx.attr.cmd == "kernel":
        ending = ".dill"
    if ctx.attr.cmd == "jit-snapshot":
        ending = ".jit"
    executable = ctx.actions.declare_file(executable_path + ending)

    dart_toolchain.compile(
        ctx,
        srcs = ctx.files.srcs,
        # not sure how dart packages will work and if it's similar to go deps leaving this
        # deps = [dep[DartLibraryInfo] for dep in ctx.attr.deps],
        out = executable,
        package_config = ctx.files.package_config,
        lib = ctx.files.lib,
        cmd = ctx.attr.cmd,
    )

    # Return the DefaultInfo provider. This tells Bazel what files should be
    # built when someone asks to build a dart_binary rules. It also says which
    # one is executable (in this case, there's only one).

    return [DefaultInfo(
        files = depset([executable]),
        runfiles = ctx.runfiles(collect_data = True),
        executable = executable,


    )]




dart_binary = rule(
    _dart_binary_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".dart"],
            doc = "Source files to compile for the main package of this binary",
        ),
        "package_config": attr.label_list(
            allow_files = [".json"],
            doc = "Source files to compile for the main package of this binary",
        ),
        "lib": attr.label_list(
            allow_files = [".dart", ".yaml"], #, ".snapshot"],
            doc = "Source files to compile for the lib package of this binary",
        ),
        "cmd": attr.string(
            mandatory = True,
            doc = "Which dart command to compile with, get list with dart compile --help ex. aot-snapshot   Compile Dart to an AOT snapshot. exe            Compile Dart to a self-contained executable. jit-snapshot   Compile Dart to a JIT snapshot. js             Compile Dart to JavaScript. kernel         Compile Dart to a kernel snapshot.",
        ),
    },
    doc = "Builds an executable program from Dart source code",
    executable = True,
    toolchains = ["@rules_dart//:toolchain_type"],
)

# this has not been implemented yet just pulled outline from go as a starting point
def _dart_library_impl(ctx):
    # Load the toolchain.
    toolchain = ctx.toolchains["@rules_dart//:toolchain_type"]

    # Declare an output file for the library package and compile it from srcs.
    archive = ctx.actions.declare_file("{name}_/pkg.a".format(name = ctx.label.name))
    toolchain.compile(
        ctx,
        srcs = ctx.files.srcs,
        importpath = ctx.attr.importpath,
        deps = [dep[DartLibraryInfo] for dep in ctx.attr.deps],
        out = archive,
    )

    # Return the output file and metadata about the library.
    return [
        DefaultInfo(
            files = depset([archive]),
            runfiles = ctx.runfiles(collect_data = True),
        ),
        DartLibraryInfo(
            info = struct(
                importpath = ctx.attr.importpath,
                archive = archive,
            ),
            deps = depset(
                direct = [dep[DartLibraryInfo].info for dep in ctx.attr.deps],
                transitive = [dep[DartLibraryInfo].deps for dep in ctx.attr.deps],
            ),
        ),
    ]

# this has not been implemented yet just pulled outline from go as a starting point
dart_library = rule(
    _dart_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".dart"],
            doc = "Source files to compile",
        ),
        "deps": attr.label_list(
            providers = [DartLibraryInfo],
            doc = "Direct dependencies of the library",
        ),
        "data": attr.label_list(
            allow_files = True,
            doc = "Data files available to binaries using this library",
        ),
        "importpath": attr.string(
            mandatory = True,
            doc = "Name by which the library may be imported",
        ),
    },
    doc = "Compiles a Dart archive from Dart sources and dependencies",
    toolchains = ["@rules_dart//:toolchain_type"],
)



def _dart_tool_binary_impl(ctx):
    # Locate the dart command. We use it to invoke the compiler.
    dart_cmd = None
    for f in ctx.files.tools:
        if f.path.endswith("/bin/dart") or f.path.endswith("/bin/dart.exe"):
            dart_cmd = f
            break
    if not dart_cmd:
        fail("could not locate Dart command")

    # Declare the output executable file.
    executable_path = "{name}_/{name}".format(name = ctx.label.name)
    executable = ctx.actions.declare_file(executable_path + ".exe")

    # Create a shell command that compiles the binary.
    cmd_tpl = ("{dart} compile exe {srcs} -o {out}")
    cmd = cmd_tpl.format(
        dart = shell.quote(dart_cmd.path),
        out = shell.quote(executable.path),
        srcs = " ".join([shell.quote(src.path) for src in ctx.files.srcs]),
    )
    inputs = ctx.files.srcs + ctx.files.tools + ctx.files.std_pkgs
    ctx.actions.run_shell(
        outputs = [executable],
        inputs = inputs,
        command = cmd,
        mnemonic = "DartToolBuild",
    )

    return [DefaultInfo(
        files = depset([executable]),
        executable = executable,
    )]

dart_tool_binary = rule(
    implementation = _dart_tool_binary_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".dart"],
            doc = "Source files to compile for the main package of this binary",
        ),
        "tools": attr.label_list(
            allow_files = True,
            mandatory = True,
            doc = "Executable files that are part of a Go distribution",
        ),
        "std_pkgs": attr.label_list(
            allow_files = True,
            mandatory = True,
            doc = "Pre-compiled standard library packages that are part of a Go distribution",
        ),
    },
    doc = """Builds an executable program for the Dart toolchain.
go_tool_binary is a simple version of go_binary. It is separate from go_binary
because go_binary relies on a program produced by this rule.
This rule does not support dependencies or build constraints. All source files
will be compiled, and they may only depend on the standard library.
""",
    executable = True,
)




def dart_build_tool(ctx, srcs, out):
    cmd_tpl = ("dart compile exe {srcs} -o {out}")
    cmd = cmd_tpl.format(
        out = shell.quote(out.path),
        srcs = " ".join([shell.quote(src.path) for src in srcs]),
    )
    ctx.actions.run_shell(
        outputs = [out],
        inputs = srcs,
        command = cmd,
        mnemonic = "DartToolBuild",
        use_default_shell_env = True,
    )


# this has not been implemented yet just pulled outline from go as a starting point
def _dart_test_impl(ctx):
    toolchain = ctx.toolchains["@rules_dart//:toolchain_type"]

    executable_path = "{name}_/{name}".format(name = ctx.label.name)
    executable = ctx.actions.declare_file(executable_path)
    toolchain.build_test(
        ctx,
        srcs = ctx.files.srcs,
        deps = [dep[DartLibraryInfo] for dep in ctx.attr.deps],
        out = executable,
        importpath = ctx.attr.importpath,
        rundir = ctx.label.package,
    )

    return [DefaultInfo(
        files = depset([executable]),
        runfiles = ctx.runfiles(collect_data = True),
        executable = executable,
    )]

# this has not been implemented yet just pulled outline from go as a starting point
dart_test = rule(
    implementation = _dart_test_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".dart"],
            doc = ("Source files to compile for this test. " +
                   "May be a mix of internal and external tests."),
        ),
        "deps": attr.label_list(
            providers = [DartLibraryInfo],
            doc = "Direct dependencies of the test",
        ),
        "data": attr.label_list(
            allow_files = True,
            doc = "Data files available to this test",
        ),
        "importpath": attr.string(
            default = "",
            doc = "Name by which test archives may be imported (optional)",
        ),
    },
    doc = """Compiles and links a Dart test executable. Functions with names
starting with "Test" in files with names ending in "_test.dart" will be called
using the dart "testing" framework.""",
    test = True,
    toolchains = ["@rules_dart//:toolchain_type"],
)