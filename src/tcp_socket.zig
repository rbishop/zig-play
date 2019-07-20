const std = @import("std");
const net = std.net;
const os = std.os;

pub const TCPSocket = struct {
    fd: i32,
    ip: u32,
    port: u16,
    address: net.Address,
    state: State,
    const Self = @This();

    pub const State = enum {
        Init,
        Connected,
        Disconnected,
        Closed,
    };

    pub fn init(ip: []const u8, port: u16) os.SocketError!Self {
        var ipInt = net.parseIp4(ip) catch |err| 0;
        var _addr = net.Address.initIp4(ipInt, port);
        var _fd = try os.socket(os.PF_INET, os.SOCK_STREAM, os.IPPROTO_TCP);

        return TCPSocket{
            .fd = _fd,
            .ip = ipInt,
            .port = port,
            .address = _addr,
            .state = .Init,
        };
    }

    // Functions for client sockets
    pub fn connect(self: *TCPSocket) os.ConnectError!void {
        try os.connect(self.fd, @ptrCast(*os.sockaddr, &self.address.os_addr.in), @sizeOf(os.sockaddr));
        self.state = .Connected;
    }

    pub fn read(self: *TCPSocket, buf: []u8) os.ReadError!usize {
        var bytes_read = try os.read(self.fd, buf);
        return bytes_read;
    }

    pub fn write(self: *TCPSocket, buf: []const u8) os.WriteError!void {
        try os.write(self.fd, buf);
    }
    //pub fn disconnect() {};
    //pub fn close() {};

    // Functions for listener sockets
    //pub fn bind() {};
    //pub fn listen() {};
    //pub fn accept() {};

    // Functions for socket configuration
    // pub fn getOption() {};
    // pub fn setOption() {};
    // pub fn nonBlocking() {};
};
