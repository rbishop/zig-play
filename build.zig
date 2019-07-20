const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("play", "src/main.zig");

    exe.addCSourceFile("deps/picohttpparser.c", [_][]const u8{"-std=c99"});
    exe.setBuildMode(mode);
    exe.addIncludeDir("deps/");

    b.default_step.dependOn(&exe.step);
    b.installArtifact(exe);

    const run = b.step("run", "run the client");
    run.dependOn(&exe.run().step);
}
