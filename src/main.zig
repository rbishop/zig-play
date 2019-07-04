const std = @import("std");
const io = std.io;
const parser = @import("parser.zig");
const log = @import("logger.zig").log;

pub fn main() !void {
    var data: [*]const u8 = c"GET /posts HTTP/1.1\r\nHost: bitsandhops.com\r\nAccept: text/html\r\nUser-Agent: zig\r\n\r\n";
    var req = try parser.parse(data);

    try log("Method: {}\n", req.method);
    try log("Path: {}\n", req.path);
    try log("Version: {}\n", req.version.toString());

    var iter = req.headers.iterator();

    while (iter.next()) |h| {
        try log("{}: {}\n", h.key, h.value);
    }
    //try logger.log("Accept: {}\n", req.headers.get("Accept").?.value);
}
