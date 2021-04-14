load(
    "@rules_dart//internal:rules.bzl",
    _dart_binary = "dart_binary",
    # _dart_library = "dart_library",
    # _dart_test = "dart_test",
)
load(
    "@rules_dart//internal:providers.bzl",
    _DartLibraryInfo = "DartLibraryInfo",
)
load(
    "@rules_dart//internal:toolchain.bzl",
    _dart_toolchain = "dart_toolchain",
)
load("@rules_dart//internal:repo.bzl", 
    _dart_download = "dart_download")

dart_binary = _dart_binary
# dart_library = _dart_library
# dart_test = _dart_test
dart_toolchain = _dart_toolchain
dart_download = _dart_download
DartLibraryInfo = _DartLibraryInfo