const std = @import("std");
const io = std.io;
const parser = @import("parser.zig");
const log = @import("logger.zig").log;
const Socket = @import("socket.zig").Socket;

pub fn main() !void {
    var data: [*]const u8 = c"GET /posts HTTP/1.1\r\nHost: bitsandhops.com\r\nAccept: text/html\r\nUser-Agent: zig\r\n\r\n";
    var req = try parser.parse(data);

    log("Method: {}\n", req.method);
    log("Path: {}\n", req.path);
    log("Version: {}\n", req.version.toString());

    var iter = req.headers.iterator();

    while (iter.next()) |h| {
        log("{}: {}\n", h.key, h.value);
    }
    //log("Accept: {}\n", req.headers.get("Accept").?.value);

    var sock = Socket.init("127.0.0.1", 8000);
    log("fd: {}", sock.fd);
}
