const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const exe = b.addCExecutable("main");//, "src/main.zig");
    b.addCIncludePath("deps/");

    exe.setBuildMode(mode);
    exe.addCompileFlags([][]const u8 {
        "-std=c99"
    });
    exe.addSourceFile("deps/picohttpparser.c");
    const zig_main = b.addObject("main", "src/main.zig");
    exe.addObject(zig_main);
    exe.setVerboseLink(true);

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addCommand(".", b.env_map, [][]const u8{exe.getOutputPath()});
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(&exe.step);

    exe.setOutputPath("./main");
    b.default_step.dependOn(&exe.step);
    b.installArtifact(exe);
}
