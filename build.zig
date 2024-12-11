const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const flags = [_][]const u8 {
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

    const unity_dep = b.dependency("Unity", .{});
    const unity_lib= b.addStaticLibrary(.{
        .name = "unity",
        .target = target,
        .optimize = optimize,
    });

    unity_lib.addIncludePath(unity_dep.path("src"));
    unity_lib.addCSourceFile(.{
        .file = unity_dep.path("src/unity.c"),
        .flags = &flags,
    });
    unity_lib.linkLibC();

    b.installArtifact(unity_lib);

}


