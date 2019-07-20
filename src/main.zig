const std = @import("std");
const io = std.io;
const parser = @import("parser.zig");
const log = @import("logger.zig").log;
const TCPSocket = @import("tcp_socket.zig").TCPSocket;

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

    var socket = try TCPSocket.init("127.0.0.1", 8000);
    log("fd: {}\n", socket.fd);
    log("port: {}\n", socket.address.port());
    log("ip: {}\n", socket.address.os_addr.in.addr);
    log("len: {}\n", socket.address.os_addr.in.len);
    log("state: {}\n", socket.state);
    log("addr: {}\n", socket.address.os_addr);
    log("addr_in: {}\n", socket.address.os_addr.in);
    log("os: {}\n", @intCast(u8, @sizeOf(std.os.sockaddr)));
    log("sa: {}\n", @intCast(u8, @sizeOf(std.os.sockaddr_in)));

    _ = try socket.connect();
    log("state: {}\n", socket.state);

    _ = try socket.write("hi richard!\n");

    var buf = [_]u8{0} ** 32;
    var read = try socket.read(&buf);
    log("read {}\n", buf);
    log("bytes: {}\n", read);
}
