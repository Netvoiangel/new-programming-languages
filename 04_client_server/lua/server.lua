-- Требуется LuaSocket: luarocks install luasocket
local socket = require("socket")

local host, port = "127.0.0.1", 4000
local srv = assert(socket.bind(host, port))
print(("server listening on %s:%d"):format(host, port))

local client = srv:accept()
client:settimeout(5)

local line = client:receive("*l")
print("server got:", line)

client:send(line .. "\n")
client:close()
srv:close()
print("server sent echo and exits")


