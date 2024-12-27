const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_step = b.step("lib", "Install library");
    const unity_dep = b.dependency("Unity", .{});

    // create static library
    const lib = b.addStaticLibrary(.{
        .name = "unity",
        .target = target,
        .optimize = optimize,
    });
    lib.addCSourceFile(.{
        .file = unity_dep.path("src/unity.c"),
        .flags = &FLAGS,
    });
    lib.installHeader(unity_dep.path("src/unity.h"), "");
    lib.addIncludePath(unity_dep.path("src"));
    lib.linkLibC();

    const lib_install = b.addInstallArtifact(lib, .{});
    lib_step.dependOn(&lib_install.step);
    b.default_step.dependOn(lib_step);

    // declare module
    const unity_mod = b.addModule("Unity", .{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .root_source_file = b.path("src/lib.zig"),
    });
    unity_mod.linkLibrary(lib);
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
