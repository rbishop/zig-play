const std = @import("std");
const parser = @import("parser.zig");

pub fn main() u8 {
    var data: [*]const u8 = c"GET /posts HTTP/1.1\r\nHost: bitsandhops.com\r\nAccept: text/html\r\nUser-Agent: zig\r\n\r\n";
    const req = parser.parse(data);
    return 0;
}
