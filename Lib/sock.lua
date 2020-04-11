socket = require "socket"

Sock = {}; Sock.__index = Sock
function Sock:new(raw) --> object
  local public = {}
  public.__private = {
    host = "127.0.0.1",
    port = 80,
    sock = raw,
    isserver = false,
  }

  local function onConnect(self, host, port, sock, isserver) --> nil
    self:disconnect()
    self.__private = { host = host; port = port; sock = sock; isserver = isserver }
    sock:settimeout(1.0)
  --sock:setoption("tcp-nodelay", true)
  end

  function Sock:init(host, port) --> nil
    host = host or self.__private.host
    port = port or self.__private.port
    self.__private.host = host
    self.__private.port = port
  end

  function Sock:bind(host, port) --> boolean
    host = host or self.__private.host
    port = port or self.__private.port
    local sock = socket.bind(host, port)
    host, port = sock:getsockname()
    if sock then onConnect(self, host, port, sock, true) end
    return sock ~= nil;
  end

  function Sock:accept() --> Sock
    local sock = self.__private.sock:accept()
    return sock and Sock:new(sock)
  end

  function Sock:connect(host, port) --> boolean
    host = host or self.__private.host
    port = port or self.__private.port
    local sock = socket.connect(host, port)
    if sock then onConnect(self, host, port, sock, false) end
    return sock ~= nil;
  end

  function public:addr() --> string, number
    return self.__private.host, self.__private.port
  end

  function public:connected() --> boolean
    return self.__private.sock ~= nil
  end

  function isserver() --> boolean
    return __private.isserver
  end

  function Sock:disconnect() --> nil
    if self.__private.sock then self.__private.sock:close() end
    self.__private.sock = nil
  end

  function Sock:receive(mode) --> data/string/table
    mode = mode or 't'
    local sock = self.__private.sock
    if not sock then return nil, "no connection" end
    local data, err
    if mode == 'a' then
      data, err = sock:receive("*a")
    elseif mode == 's' then
      data, err = sock:receive("*l")
    elseif mode == 't' then
      local d = {}
      repeat
        table.insert(d, data)
        data, err = sock:receive("*l")
      until err
      data = d
    elseif type(mode) == "number" then
      data, err = sock:receive(mode)
    end
    return data, err
  end

  function Sock:send(data) --> number
    if self.__private.sock then
      return self.__private.sock:send(data)
    end
  end

  function Sock:sendln(data) --> number
    return self:send(data..'\x0D\x0A')
  end

  setmetatable(public, self)
  return public
end

function Sock:extend() --> class
  local t = {}; t.__index = t
  return setmetatable(t, self)
end