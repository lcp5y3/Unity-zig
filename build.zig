const std = @import("std");

pub fn build(b: *std.Build) void {
    const unity_dep = b.dependency("Unity", .{});
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const fixture = b.option(bool, "fixture", "build fixture addon") orelse true;
    const memory = b.option(bool, "memory", "build memory addon") orelse fixture;

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

    if (memory) {
        unity.addCSourceFile(.{
            .file = unity_dep.path("extras/memory/src/unity_memory.c"),
            .flags = &FLAGS,
        });
        unity.addIncludePath(unity_dep.path("extras/memory/src"));
        unity.installHeader(unity_dep.path("extras/memory/src/unity_memory.h"), "unity_memory.h");
    }
    if (fixture) {
        unity.addCSourceFile(.{
            .file = unity_dep.path("extras/fixture/src/unity_fixture.c"),
            .flags = &FLAGS,
        });
        unity.addIncludePath(unity_dep.path("extras/fixture/src"));
        unity.installHeader(unity_dep.path("extras/fixture/src/unity_fixture.h"), "unity_fixture.h");
        unity.installHeader(unity_dep.path("extras/fixture/src/unity_fixture_internals.h"), "unity_fixture_internals.h");
    }
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
