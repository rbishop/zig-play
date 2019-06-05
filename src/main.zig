const std = @import("std");
const mem = std.mem;
const c = @cImport({
    @cInclude("picohttpparser.h");
});

//extern fn phr_parse_request(buf: ?[*]const u8, len: usize, method: ?[*](?[*]const u8), method_len: ?[*]usize, path: ?[*](?[*]const u8), path_len: ?[*]usize, minor_version: ?[*]c_int, headers: ?[*]struct_phr_header, num_headers: ?[*]usize, last_len: usize) c_int;

pub fn main() u8 {
    var req: ?[*]const u8 = c"GET /posts HTTP/1.1\r\nHost: bitsandhops.com\r\nAccept: text/html\r\nUser-Agent: zig\r\n\r\n";
    //var req: ?[*]const u8 = c"GET /hoge HTTP/1.1\r\nHost: example.com\r\nUser-Agent: zig\r\n\r\n";
    var req_len: usize = 0;

    if (req) |r| {
        req_len = mem.len(u8, r);
    }

    var method: ?[*]const u8 = null;
    var method_len: usize = 0;

    var path: ?[*]const u8 = null;
    var path_len: usize = 0;

    var headers: [10]c.phr_header = undefined;
    var num_headers: usize = 10;

    var minor_version: c_int = 0;

    var parse_ret = c.phr_parse_request(req, req_len, &method, &method_len, &path, &path_len, &minor_version, @ptrCast([*c]c.phr_header, &headers), &num_headers, 0);
    std.debug.warn("req len: {}\n", req_len);
    std.debug.warn("parsed bytes: {}\n", parse_ret);
    std.debug.warn("method: {} mlen: {} path: {} path_len {} version: {} headers: {}\n", method.?[0..method_len], method_len, path.?[0..path_len], path_len, minor_version, num_headers);

    for (headers[0..num_headers]) |h| {
        _ = printHeader(h);
    }

    return 0;
}

fn printHeader(h: c.phr_header) void {
    std.debug.warn("{}: {}\n", h.name[0..h.name_len], h.value[0..h.value_len]);
}
