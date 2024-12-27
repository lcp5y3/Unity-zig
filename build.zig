const std = @import("std");

pub fn build(b: *std.Build) void {
    const unity_dep = b.dependency("Unity", .{});
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // create static library
    const unity = b.addStaticLibrary(.{
        .name = "unity",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    unity.addCSourceFile(.{
        .file = unity_dep.path("src/unity.c"),
        .flags = &FLAGS,
    });
    unity.installHeader(unity_dep.path("src/unity.h"), "unity.h");
    unity.installHeader(unity_dep.path("src/unity_internals.h"), "unity_internals.h");
    unity.addIncludePath(unity_dep.path("src"));

    b.installArtifact(unity);
}

const FLAGS = [_][]const u8{
    "-std=c11",
    "-Wcast-align",
    "-Wcast-qual",
    "-Wconversion",
    "-Wexit-time-destructors",
    "-Wglobal-constructors",
    "-Wmissing-noreturn",
    "-Wmissing-prototypes",
    "-Wno-missing-braces",
    "-Wold-style-cast",
    "-Wshadow",
    "-Wweak-vtables",
    "-Werror",
    "-Wall",
};
