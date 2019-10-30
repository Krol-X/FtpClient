socket = require "socket"
require "conio"
require "tools"

-- Состояние программы
local conn
stat = {
  sock = nil,
  datasock = nil,
  host = nil,
  port = nil,
  quit = false,
  type = "I",
}


-- Вывод ошибок
function Error(s) setattr_(clerr) print("Error: "..s) end
function Error_cmd(s) Error('Unknown Command "'..s..'"') end
function Error_con()  Error('Client is not connected!') end


answer = {
  unpack = function(s) --> number, s
    local i, j = s:find("([^%s-]+)")
    code = assert(tonumber(s:sub(i, j)))
    return code, s:sub(j)
  end;
  colorof = function(code)
    if code >= 100 and code < 200 then
      return clpre
    elseif code >= 200 and code < 300 then
      return clok
    elseif code >= 300 and code < 400 then
      return clinter
    else
      return clerr
    end
  end;
  print = function(t) --> number
    local r
    table.foreach(t, function(i, s)
      local c, ss = answer.unpack(s)
      setattr_(answer.colorof(c))
      print(s)
      r = c
    end)
    return r
  end;
}


function connect(host, port) --> boolean
  local sock = socket.connect(host, port)
  stat.sock = sock
  if sock then
    --sock:setoption("tcp-nodelay", true)
    sock:settimeout(1.0)
  end
  stat.host = sock and host
  stat.port = sock and port
  return sock ~= nil
end


function receive() --> table
  local sock = stat.sock; local r = {}
  if not sock then Error_con() end
  local s, err = sock:receive("*l")
  if not err then
    r[#r+1] = s
    while not err and s:find("-") do
      s, err = sock:receive("*l")
      r[#r+1] = s
    end
  else
    setattr_(clerr)
    print("Receive error: "..err)
  end
  return r;
end


function send(s)
  if stat.sock then
    stat.sock:send(s..'\x0D\x0A')
  else
    Error_con()
  end
end


function data_connect(s)

end


function topath(s)
  return s and s:trimspaces():gsub("\\", "/") or "";
end