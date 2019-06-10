const std = @import("std");
const mem = std.mem;
const c = @cImport({
    @cInclude("picohttpparser.h");
});
const HashMap = std.HashMap;

pub fn parse(buf: [*]const u8) Request {
    var req_len = mem.len(u8, buf);

    var method: ?[*]const u8 = undefined;
    var method_len: usize = undefined;

    var path: ?[*]const u8 = undefined;
    var path_len: usize = undefined;

    // todo: make the number of headers configurable
    var headers: [10]c.phr_header = undefined;
    var num_headers: usize = undefined;

    var minor_version: c_int = 0;

    var parse_ret = c.phr_parse_request(buf, req_len, &method, &method_len, &path, &path_len, &minor_version, @ptrCast([*c]c.phr_header, &headers), &num_headers, 0);
    std.debug.warn("req len: {}\n", req_len);
    std.debug.warn("parsed bytes: {}\n", parse_ret);
    std.debug.warn("method: {} mlen: {} path: {} path_len {} version: {} headers: {}\n", method.?[0..method_len], method_len, path.?[0..path_len], path_len, minor_version, num_headers);

    for (headers[0..num_headers]) |h| {
        printHeader(h);
    }

    return Request{
        .path = path.?[0..path_len],
        .method = method.?[0..method_len],
        .version = @intCast(u8, minor_version),
    };
}

fn printHeader(h: c.phr_header) void {
    std.debug.warn("{}: {}\n", h.name[0..h.name_len], h.value[0..h.value_len]);
}

const Request = struct {
    path: []const u8,
    method: []const u8,
    version: u8,
    //headers: HeadersHashMap,

    //const HeadersHashMap = HashMap([]const u8, []const u8, mem.hash_slice_u8, mem.eql_slice_u8);
};
