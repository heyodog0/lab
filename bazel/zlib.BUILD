package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # BSD/MIT-like license (for zlib)

cc_library(
    name = "zlib",
    srcs = [
        "adler32.c",
        "compress.c",
        "crc32.c",
        "crc32.h",
        "deflate.c",
        "deflate.h",
        "gzclose.c",
        "gzguts.h",
        "gzlib.c",
        "gzread.c",
        "gzwrite.c",
        "infback.c",
        "inffast.c",
        "inffast.h",
        "inffixed.h",
        "inflate.c",
        "inflate.h",
        "inftrees.c",
        "inftrees.h",
        "trees.c",
        "trees.h",
        "uncompr.c",
        "zconf.h",
        "zutil.c",
        "zutil.h",
    ],
    hdrs = ["zlib.h"],
    # On modern macOS, TARGET_OS_MAC is always defined, which makes zutil.h
    # macro-define fdopen to NULL and clash with the system <stdio.h>
    # declaration. Predefining the macro to itself keeps the real fdopen and
    # skips zlib's "No fdopen()" fallback.
    copts = [
        "-Wno-implicit-function-declaration",
        "-Dfdopen=fdopen",
    ],
    includes = ["."],
)
