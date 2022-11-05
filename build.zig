const std = @import("std");
const mach = @import("libs/mach/build.zig");

pub fn build(b: *std.build.Builder) !void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const app = try mach.App.init(b, .{
        .name = "iso-cubes",
        .src = "src/main.zig",
        .target = target,
        .deps = &[_]std.build.Pkg{},
    });
    app.setBuildMode(mode);
    try app.link(.{});
    app.install();

    const run_cmd = try app.run();
    run_cmd.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(run_cmd);

    const app_tests = b.addTest("src/main.zig");
    app_tests.setTarget(target);
    app_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&app_tests.step);
}
