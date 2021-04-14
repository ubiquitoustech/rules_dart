def _dart_download_impl(ctx):
    # Download the Dart distribution.
    ctx.report_progress("downloading")
    ctx.download_and_extract(
        ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        stripPrefix = "dart-sdk",
    )

    # Add a build file to the repository root directory.
    # We need to fill in some template parameters, based on the platform.
    ctx.report_progress("generating build file")
    if ctx.attr.dartos == "darwin":
        os_constraint = "@platforms//os:osx"
    elif ctx.attr.dartos == "linux":
        os_constraint = "@platforms//os:linux"
    elif ctx.attr.dartos == "windows":
        os_constraint = "@platforms//os:windows"
    else:
        fail("unsupported dartos: " + ctx.attr.dartos)
    if ctx.attr.dartarch == "amd64":
        arch_constraint = "@platforms//cpu:x86_64"
    else:
        fail("unsupported arch: " + ctx.attr.dartarch)
    constraints = [os_constraint, arch_constraint]
    constraint_str = ",\n        ".join(['"%s"' % c for c in constraints])

    substitutions = {
        "{dartos}": ctx.attr.dartos,
        "{dartarch}": ctx.attr.dartarch,
        "{exe}": ".exe" if ctx.attr.dartos == "windows" else "",
        "{exec_constraints}": constraint_str,
        "{target_constraints}": constraint_str,
    }
    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
        substitutions = substitutions,
    )

dart_download = repository_rule(
    implementation = _dart_download_impl,
    attrs = {
        "urls": attr.string_list(
            mandatory = True,
            doc = "List of mirror URLs where a Dart distribution archive can be downloaded",
        ),
        "sha256": attr.string(
            # mandatory = True,
            doc = "Expected SHA-256 sum of the downloaded archive",
        ),
        "dartos": attr.string(
            mandatory = True,
            values = ["darwin", "linux", "windows"],
            doc = "Host operating system for the Dart distribution",
        ),
        "dartarch": attr.string(
            mandatory = True,
            values = ["amd64"],
            doc = "Host architecture for the Dart distribution",
        ),
        "_build_tpl": attr.label(
            default = "@rules_dart//internal:BUILD.dist.bazel.tpl",
        ),
    },
    doc = "Downloads a standard Dart distribution and installs a build file",
)
