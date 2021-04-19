load("@bazel_skylib//lib:shell.bzl", "shell")


def dart_compile(ctx, srcs, out, package_config, lib, cmd):
    """Compiles a single Dart package from sources.

    Args:
        ctx: analysis context.
        srcs: list of source Files to be compiled.
        out: output .a file. Should have the importpath as a suffix,
            for example, library "example.com/foo" should have the path
            "somedir/example.com/foo.a".
        deps: list of DartLibraryInfo objects for direct dependencies.
    """
    toolchain = ctx.toolchains["@rules_dart//:toolchain_type"]
    args = ctx.actions.args()
    args.add("compile")
    # args.add("test")
    args.add(cmd)
    # if someone does not declare a package_config don't add it into the command
    # some of the compile options don't have a package_config option
    if ((package_config != []) and  (cmd != "js") and (cmd != "kernel") and (cmd != "jit-snapshot")):
        args.add("-p")
        args.add_all(package_config)
    args.add_all(srcs)


    # turned off for trial of testing
    args.add("-o", out)

    # turn on --minified for js compile
    # might add another optional arg to turn minified on and off
    if (cmd == "js"):
        args.add("-m")
        # this should declare multiple files
        # .js .js.deps .js.map
        # not really sure what the best way to handle multiple outputs is
        # right now it will fail if they aren't generated but it just passes
        # the main .js file as output
        executable_path = "{name}_/{name}".format(name = ctx.label.name)
        out2 = ctx.actions.declare_file(executable_path + ".js.deps")
        out3 = ctx.actions.declare_file(executable_path + ".js.map")
        out = [out, out2, out3]
    else:
        out = [out]


    inputs = (srcs
              + 
              toolchain.internal.tools +
              toolchain.internal.std_pkgs)
    ctx.actions.run(
        outputs = out,
        inputs = inputs + package_config + lib,
        executable = toolchain.internal.builder,
        arguments = [args],
        env = toolchain.internal.env,
        mnemonic = "DartCompile",
    )

# this should be updated to use toolchains and also this is just from go and needs to be updated to work with dart
def dart_build_test(ctx, srcs, deps, out, rundir = "", importpath = ""):
    direct_dep_infos = [d.info for d in deps]
    transitive_dep_infos = depset(transitive = [d.deps for d in deps]).to_list()
    inputs = (srcs +
              [ctx.file._stdimportcfg] +
              [d.archive for d in direct_dep_infos] +
              [d.archive for d in transitive_dep_infos])

    args = ctx.actions.args()
    args.add("test")
    args.add("-stdimportcfg", ctx.file._stdimportcfg)
    args.add_all(
        direct_dep_infos,
        before_each = "-direct",
        map_each = _format_arc,
    )
    args.add_all(
        transitive_dep_infos,
        before_each = "-transitive",
        map_each = _format_arc,
    )
    if rundir != "":
        args.add("-dir", rundir)
    if importpath != "":
        args.add("-p", importpath)
    args.add("-o", out)
    args.add_all(srcs)
    
    ctx.actions.run(
        outputs = [out],
        inputs = inputs,
        executable = ctx.executable._builder,
        arguments = [args],
        mnemonic = "DartTest",
        use_default_shell_env = True,
    )


def _format_arc(lib):
    """Formats a DartLibraryInfo.info object as an -arc argument"""
    return "{}={}".format(lib.importpath, lib.archive.path)