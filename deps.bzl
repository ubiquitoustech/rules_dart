load("@bazel_tools//tools/build_defs/repo:utils.bzl", _maybe = "maybe")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_dart//internal:repo.bzl", _dart_download = "dart_download")

dart_download = _dart_download

def dart_rules_dependencies():
    """Declares external repositories that rules_dart depends on. This
    function should be loaded and called from WORKSPACE files."""

    # bazel_skylib is a set of libraries that are useful for writing
    # Bazel rules. We use it to handle quoting arguments in shell commands.

    _maybe(
        http_archive,
        "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        ],
        sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
    )
