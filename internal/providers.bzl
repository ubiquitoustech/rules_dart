DartLibraryInfo = provider(
    doc = "Contains information about a Dart library",
    fields = {
        "info": """A struct containing information about this library.
        Has the following fields:
            importpath: Name by which the library may be imported.
            archive: The .a file compiled from the library's sources.
        """,
        "deps": "A depset of info structs for this library's dependencies",
    },
)




# DartToolchainInfo is a dummy provider that serves as documentation for the
# public interface of the ToolchainInfo provide returned by dart_toolchain.
# Toolchains compatible with @rules_dart//:toolchain_type must
# satisfy this interface. However, no DartToolchainInfo object is actually created.
DartToolchainInfo = provider(
    doc = "Contains information about a Dart toolchain",
    fields = {
        "compile": """Function that compiles a Dart package from sources.
        Args:
            ctx: analysis context.
            srcs: list of source Files to be compiled.
            out: output file.
            importpath: the path other libraries may use to import this package.
            deps: list of DartLibraryInfo objects for direct dependencies.
        """,
        "build_test": """Function that compiles a test executable.
        Args:
            ctx: analysis context.
            srcs: list of source Files to be compiled.
            deps: list of DartLibraryInfo objects for direct dependencies.
            out: output executable file.
            importpath: import path of the internal test archive.
            rundir: directory the test should change to before executing.
        """,
    },
)