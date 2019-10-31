socket = require "socket"

Sock = {}; Sock.__index = Sock
function Sock:new(raw) --> class
  --local
  private = {
    host = "127.0.0.1",
    port = 80,
    sock = raw,
    isserver = false,
  }; local public = {}

  local function onConnect(self, host, port, sock, isserver)
    self:disconnect()
    private = {
      host = host; port = tonumber(port);
      sock = sock; isserver = isserver
    }
    sock:settimeout(1.0)
  --sock:setoption("tcp-nodelay", true)
  end

  function Sock:bind(host, port) --> boolean
    host = host or private.host
    port = port or private.port
    local sock = socket.bind(host, port)
    host, port = sock:getsockname()
    if sock then onConnect(self, host, port, sock, true) end
    return sock ~= nil;
  end

  function Sock:accept() --> Sock
    local sock = private.sock:accept()
    return sock and Sock:new(sock)
  end

  function Sock:connect(host, port) --> boolean
    host = host or private.host
    port = port or private.port
    local sock = socket.connect(host, port)
    if sock then onConnect(self, host, port, sock, false) end
    return sock ~= nil;
  end

  function public:addr() --> string, number
    return private.host, private.port
  end

  function public:connected() --> boolean
    return private.sock ~= nil
  end

  function isserver() --> boolean
    return private.isserver
  end

  function Sock:disconnect() --> nil
    if private.sock then private.sock:close() end
    private.sock = nil
  end

  function Sock:receive(mode) --> data/string/table
    mode = mode or 't'
    local sock = private.sock
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
    if private.sock then
      return private.sock:send(data)
    end
  end

  setmetatable(public, Sock)
  return public
end

function Sock:extend() --> class
  return setmetatable({}, Sock)
end