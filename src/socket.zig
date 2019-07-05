const std = @import("std");
const net = std.net;
const os = std.os;
const posix = os.posix;

// Need to decide whether I want this to support blocking and non-blocking
// sockets or factor those out into separate modules
pub const Socket = struct {
    fd: usize,
    addr: net.Address,
    const Self = @This();

    pub fn init(ip: []const u8, port: u16) Self {
        const ipInt = net.parseIp4(ip) catch |err| 0;
        const _addr = net.Address.initIp4(ipInt, port);
        const _fd = os.posixSocket(posix.PF_INET, posix.SOCK_STREAM, posix.IPPROTO_TCP);

        return Socket{
            .fd = _fd,
            .addr = _addr,
        };
    }

    // a whole bunch of fnctl(2) going to happen down here ugh
    //pub fn bind() {};
    //pub fn listen() {};
    //pub fn accept() {};
};
