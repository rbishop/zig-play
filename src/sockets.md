# Sockets

## Why and Tenets

Zig doesn't offer any socket APIs and I need sockets. I'm going to build this
with an eye towards turning it into something useful so that I never have to
directly use the awful BSD socket APIs ever again. Here are the goals of my
sockets library:

1. Configurability: many socket libraries hide away the socket life cycle or
   file descriptor. This limits your ability to set specific socket options at
   the precise time they need to be set. A classic example of this are
   abstractions like TCPListener where you can't set `SO_REUSEPORT` before
   listening.

2. Concurrency Oblivious: many socket libraries couple sockets to a concurrency
   runtime such as an event loop or threads. This limits your control and often
   a given application needs both threads and events.

3. Ease of use: the library should be easy to use without needing to drown in
   BSD sockets API details. I'll be exploring how I can use Zig's type system
   to guide users at compile-time as much as possible.

## What

Ways to represent networking:
1. Direct use of the sockets API (C)
2. Abstract types representing Sockets that hide the horrible atrocities of the
   sockets API (Ruby)
3. Buffers (Java, Node, and Go mostly do this)

Side note: it's weird but sockets are actually an abstraction over NIC buffers.
So then people make buffers that are an abstraction around sockets. We can't
avoid the socket APIs unfortunately and you can't hide them because developers
need to be able to configure the socket file descriptors.

### What even is networking anyway?

- Medium view point: beams of light being shot down glass
- NIC-centric view point: Receive and Transmit Buffers/Queues
- OS-centric viewpoint: Sockets and file descriptors
- Application Developer viewpoint: I'm just trying to send some shit somewhere

Whose opinion matters anyway: Application Developers.
