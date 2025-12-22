#!/usr/bin/env dub
/+ dub.sdl:
name "tcp-echo-single"
description "Single-file TCP echo demo"
targetType "executable"
+/

import std.stdio;
import std.socket;
import std.string;
import std.conv;

enum ushort PORT = 4000;

void runServer() {
    auto listener = new TcpSocket(AddressFamily.INET);
    // Делаем сервер устойчивым к быстрому перезапуску (TIME_WAIT).
    listener.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
    listener.bind(new InternetAddress("127.0.0.1", PORT));
    listener.listen(1);
    writeln("server listening on 127.0.0.1:", PORT);

    auto client = listener.accept();
    scope(exit) client.close();

    ubyte[4096] buf;
    auto n = client.receive(buf[]);
    auto msg = cast(string) buf[0 .. n].idup;

    // Уберём возможный перевод строки для красоты.
    msg = msg.stripRight("\r\n");
    writeln("server got: ", msg);

    client.send((msg ~ "\n").representation);
    writeln("server sent echo and exits");
}

void runClient(string msg) {
    auto sock = new TcpSocket(AddressFamily.INET);
    scope(exit) sock.close();
    sock.connect(new InternetAddress("127.0.0.1", PORT));
    sock.send((msg ~ "\n").representation);

    ubyte[4096] buf;
    auto n = sock.receive(buf[]);
    auto resp = cast(string) buf[0 .. n].idup;
    resp = resp.stripRight("\r\n");
    writeln("client got: ", resp);
}

int main(string[] args) {
    if (args.length < 2) {
        writeln("usage:");
        writeln("  server");
        writeln("  client <message>");
        return 1;
    }

    auto mode = args[1];
    if (mode == "server") {
        runServer();
        return 0;
    }
    if (mode == "client") {
        auto msg = args.length >= 3 ? args[2] : "hello";
        runClient(msg);
        return 0;
    }

    writeln("unknown mode: ", mode);
    return 1;
}


