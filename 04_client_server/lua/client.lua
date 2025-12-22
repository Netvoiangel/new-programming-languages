-- Требуется LuaSocket: luarocks install luasocket
local socket = require("socket")

local host, port = "127.0.0.1", 4000
local msg = arg[1] or "hello"

local c = assert(socket.tcp())
assert(c:connect(host, port))
c:send(msg .. "\n")

local line = c:receive("*l")
print("client got:", line)

c:close()


