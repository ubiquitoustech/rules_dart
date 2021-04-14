workspace(name = "rules_dart")

load(
    "@rules_dart//:deps.bzl",
    "dart_download",
    "dart_rules_dependencies",
)

dart_rules_dependencies()

DART_VERSION = "2.12.2"
DART_CHANNEL = "stable"
linux_x64_sha = "5ffcdedd1f5c4d0f44bc9df7244a638111d6ecb43f8599e81a2e7ae21e08e2bd"
macos_x64_sha = "cdc34e811188000090d4ac411d5ae014352b57f76e14f0e01604313781bfd540"
windows_x64_sha = "b147d65335e8afb16b0383b2604db7796fdd8534583027950ac3e221597c3e4f"

sdk_base_url = ("https://storage.googleapis.com/dart-archive/channels/" + DART_CHANNEL + "/release/" + DART_VERSION + "/sdk/")


dart_download(
    name = "dart_darwin_amd64",
    dartarch = "amd64",
    dartos = "darwin",
    sha256 = macos_x64_sha,
    urls = [(sdk_base_url + "dartsdk-macos-x64-release.zip")],
)

dart_download(
    name = "dart_linux_amd64",
    dartarch = "amd64",
    dartos = "linux",
    sha256 = linux_x64_sha,
    urls = [(sdk_base_url + "dartsdk-linux-x64-release.zip")],
)


dart_download(
    name = "dart_windows_amd64",
    dartarch = "amd64",
    dartos = "windows",
    sha256 = windows_x64_sha,
    urls = [(sdk_base_url + "dartsdk-windows-x64-release.zip")],
)

# register_toolchains makes one or more toolchain rules available for Bazel's
# automatic toolchain selection. Bazel will pick whichever toolchain is
# compatible with the execution and target platforms.
register_toolchains(
    "@dart_darwin_amd64//:toolchain",
    "@dart_linux_amd64//:toolchain",
    "@dart_windows_amd64//:toolchain",
)
