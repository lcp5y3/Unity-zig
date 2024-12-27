# Unity Zig

Using zig build system to build [Unity](https://github.com/ThrowTheSwitch/Unity) unit test library.

## Adding It to your project

First update your *build.zig.zon* with:

```bash
zig fetch --save git+https://github.com/lcp5y3/Unity-zig.git#v2.6.0
```

After that you can link `Unity` with your project by adding the following
lines to your `build.zig`

```zig
const unity_dep = b.dependency("Unity_zig", .{
  .target = target,
  .optimize = optimize,
});

exe.linkLibrary(unity_dep.artifact("unity"));
```

## Building the lib

If you only want to build Unity to get .a and header, run:

```bash
zig build
```

You will find the Statically lib *libunity.a* in zig-out folder.


