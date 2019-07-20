const std = @import("std");
const mem = std.mem;
const c = @cImport({
    @cInclude("picohttpparser.h");
});
const HashMap = std.HashMap;
const heap = std.heap;

const ParseError = error{
    InvalidVersion,
    InvalidMethod,
    PartialRequest,
    InvalidRequest,
};

pub fn parse(buf: [*]const u8) !Request {
    var req_len = mem.len(u8, buf);

    var method: ?[*]const u8 = undefined;
    var method_len: usize = undefined;

    var path: ?[*]const u8 = undefined;
    var path_len: usize = undefined;

    // todo: make the number of headers configurable
    var headers: [10]c.phr_header = undefined;
    var num_headers: usize = undefined;

    var minor_version: c_int = 0;

    const bytes_parsed: c_int = c.phr_parse_request(buf, req_len, &method, &method_len, &path, &path_len, &minor_version, @ptrCast([*c]c.phr_header, &headers), &num_headers, 0);

    if (bytes_parsed == -1) {
        return ParseError.InvalidRequest;
    } else if (bytes_parsed == -2) {
        return ParseError.PartialRequest;
    }

    var alloc = heap.direct_allocator;
    var headers_map = HeadersMap.init(alloc);

    for (headers[0..num_headers]) |h| {
        _ = try headers_map.put(h.name[0..h.name_len], h.value[0..h.value_len]);
    }

    const version = switch (@intCast(u1, minor_version)) {
        0 => HTTPVersion.OneDotZero,
        1 => HTTPVersion.OneDotOne,
    };

    return Request{
        .path = path.?[0..path_len],
        .method = method.?[0..method_len],
        .version = version,
        .headers = headers_map,
    };
}

pub const Request = struct {
    path: []const u8,
    method: []const u8,
    version: HTTPVersion,
    headers: HeadersMap,
};

const HeadersMap = HashMap([]const u8, []const u8, mem.hash_slice_u8, mem.eql_slice_u8);

pub const Header = struct {
    name: []const u8,
    value: []const u8,
};

pub const HTTPVersion = enum(u8) {
    OneDotZero,
    OneDotOne,

    pub fn toString(self: HTTPVersion) []const u8 {
        return switch (self) {
            HTTPVersion.OneDotZero => "1.0",
            HTTPVersion.OneDotOne => "1.1",
        };
    }
};
