const std = @import("std");
const io = std.io;
const parser = @import("parser.zig");

pub fn main() !void {
    var data: [*]const u8 = c"GET /posts HTTP/1.1\r\nHost: bitsandhops.com\r\nAccept: text/html\r\nUser-Agent: zig\r\n\r\n";
    var req = try parser.parse(data);

    const out_file: std.os.File = try io.getStdOut();
    const out = out_file.outStream();
    var stream = out.stream;

    try stream.print("Method: {}\n", req.method);
    try stream.print("Path: {}\n", req.path);
    try stream.print("Version: {}\n", req.version.toString());

    var iter = req.headers.iterator();

    // for some reason I need to re-initialize stdOut after req is referenced...?
    var new_outfile = try io.getStdOut();
    var new_out = new_outfile.outStream();
    var new_stream = out.stream;

    while (iter.next()) |h| {
        try new_stream.print("{}: {}\n", h.key, h.value);
    }
    //try stream.print("Accept: {}\n", req.headers.get("Accept").?.value);
}
