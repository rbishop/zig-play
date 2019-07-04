const std = @import("std");
const io = std.io;

// Being lazy and letting this no-op if we are unable to get
// or write to std out
// TODO: Pass stdout in as an argument and return a struct
// TODO: Make the logger buffered
pub fn log(comptime format: []const u8, args: ...) void {
    const std_out = io.getStdOut() catch |err| return;
    var out = std_out.outStream();
    const stream = &out.stream;
    stream.print(format, args) catch |err| return;
}
