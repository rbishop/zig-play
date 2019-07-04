const std = @import("std");
const io = std.io;

pub fn log(comptime format: []const u8, args: ...) !void {
    const std_out = try io.getStdOut();
    var out = std_out.outStream();
    const stream = &out.stream;
    try stream.print(format, args);
}
