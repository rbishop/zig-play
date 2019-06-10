# Summary

Zig seems like a lightweight and fun language to do systems programming in. I
want to see how enjoyable it is to write Zig code that parses a protocol, calls
and links against C libraries, writes to files, and handles sockets. To do this
I'll write a database-like server that receives HTTP (or my own little
protocol) and appends data to files.

# Milestones

- [x] Statically link and call a C library
- [x] Use a C HTTP parser such as picohttpparser
- [x] Use Zig's translate-c capability
- [ ] Listen on a TCP socket
- [ ] Play with coroutines
- [ ] Write a basic coroutine scheduler
- [ ] Dynamically link a shared C library
- [ ] Use an Allocator
- [ ] Use threads and blocking I/O
- [ ] Use io_uring and coroutines for async I/O
